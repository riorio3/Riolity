import SwiftUI

@main
struct RiolityApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    // Shared state for design flow
    @StateObject private var designFlowState = DesignFlowState()

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                // Main AI Chat interface
                ChatView()
                    .environmentObject(designFlowState)
                    .tabItem {
                        Label("Create", systemImage: "wand.and.stars")
                    }
                    .tag(0)

                // Design studio (for refinement)
                DesignFlowView()
                    .environmentObject(designFlowState)
                    .tabItem {
                        Label("Studio", systemImage: "cube.fill")
                    }
                    .tag(1)

                LearnBrowserView()
                    .environmentObject(designFlowState)
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }
                    .tag(2)

                ProjectsGalleryView()
                    .tabItem {
                        Label("Projects", systemImage: "folder.fill")
                    }
                    .tag(3)
            }
            .accentColor(RetroTheme.primaryGreen)
            .onAppear {
                customizeTabBar()
            }
            .onChange(of: designFlowState.shouldSwitchToStudio) { shouldSwitch in
                if shouldSwitch {
                    selectedTab = 1
                    designFlowState.shouldSwitchToStudio = false
                }
            }
        }
    }

    private func customizeTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1)

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0, green: 0.6, blue: 0.25, alpha: 1)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0, green: 0.6, blue: 0.25, alpha: 1)
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0, green: 1, blue: 0.4, alpha: 1)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0, green: 1, blue: 0.4, alpha: 1)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// Design flow steps
enum DesignFlowStep: Int {
    case problemSelection = 0
    case solutionPicker = 1
    case designStudio = 2
    case export = 3
}

// Shared state for the design wizard flow
@MainActor
class DesignFlowState: ObservableObject {
    @Published var selectedCategory: ProblemCategory?
    @Published var selectedSolution: NatureSolution?
    @Published var currentStep: DesignFlowStep = .problemSelection

    // Generation state
    @Published var complexity: Double = 0.5
    @Published var density: Double = 0.5
    @Published var organicBias: Double = 0.5

    @Published var currentMesh: MeshData?
    @Published var currentProperties: StructuralProperties?
    @Published var currentAlgorithm: GenerationAlgorithm?
    @Published var currentSeed: Int = 0

    @Published var isGenerating: Bool = false

    // AI-generated design state
    @Published var aiDesignSpec: DesignSpecification?
    @Published var aiDesignName: String = ""
    @Published var aiDesignPurpose: String = ""
    @Published var shouldSwitchToStudio: Bool = false

    func reset() {
        selectedCategory = nil
        selectedSolution = nil
        currentStep = .problemSelection
        complexity = 0.5
        density = 0.5
        organicBias = 0.5
        currentMesh = nil
        currentProperties = nil
        currentAlgorithm = nil
        currentSeed = 0
        aiDesignSpec = nil
        aiDesignName = ""
        aiDesignPurpose = ""
    }

    func startWithSolution(_ solution: NatureSolution) {
        selectedCategory = solution.category
        selectedSolution = solution
        complexity = solution.defaultComplexity
        density = solution.defaultDensity
        organicBias = solution.defaultOrganicBias
        currentStep = .designStudio
    }

    func selectCategory(_ category: ProblemCategory) {
        selectedCategory = category
        currentStep = .solutionPicker
    }

    func selectSolution(_ solution: NatureSolution) {
        selectedSolution = solution
        complexity = solution.defaultComplexity
        density = solution.defaultDensity
        organicBias = solution.defaultOrganicBias
        currentStep = .designStudio
    }

    /// Apply an AI-generated design specification
    func applyAIDesign(_ spec: DesignSpecification) {
        aiDesignSpec = spec
        aiDesignName = spec.name
        aiDesignPurpose = spec.purpose

        // Set parameters from AI
        complexity = spec.complexity
        density = spec.density
        organicBias = spec.organicBias
        currentAlgorithm = spec.algorithm

        // Find matching category and create synthetic solution
        selectedCategory = mapProblemType(spec.problemType)

        // Create a synthetic solution based on AI spec
        let syntheticSolution = NatureSolution(
            id: "ai-\(UUID().uuidString)",
            name: spec.bioInspiration,
            organism: spec.bioInspiration,
            category: selectedCategory ?? .structural,
            principle: spec.principle,
            scientificBacking: "AI-generated design based on biomimicry principles",
            realWorldApplications: [spec.purpose],
            recommendedAlgorithm: spec.algorithm,
            defaultComplexity: spec.complexity,
            defaultDensity: spec.density,
            defaultOrganicBias: spec.organicBias,
            strengthRating: 0.8,
            efficiencyRating: 0.8
        )
        selectedSolution = syntheticSolution

        // Move to design studio and trigger tab switch
        currentStep = .designStudio
        shouldSwitchToStudio = true

        // Auto-generate
        generate()
    }

    private func mapProblemType(_ type: String) -> ProblemCategory {
        switch type.lowercased() {
        case "structural": return .structural
        case "fluid_flow", "fluidflow", "fluid": return .fluidFlow
        case "surface", "surface_properties": return .surfaceProperties
        case "acoustic", "vibration", "acoustic_vibration": return .acousticVibration
        default: return .structural
        }
    }

    func generate() {
        let algorithm = currentAlgorithm ?? selectedSolution?.recommendedAlgorithm ?? .voronoiMutation

        isGenerating = true
        currentSeed = Int.random(in: 0...999999)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let result = NovelGenerator.shared.generate(
                seed: self.currentSeed,
                complexity: self.complexity,
                density: self.density,
                organicBias: self.organicBias,
                algorithm: algorithm
            )

            DispatchQueue.main.async {
                self.currentMesh = result.mesh
                self.currentProperties = result.properties
                self.currentAlgorithm = result.algorithm
                self.isGenerating = false
            }
        }
    }

    func regenerate() {
        generate()
    }

    func proceedToExport() {
        currentStep = .export
    }

    func createProject() -> DesignProject? {
        guard let category = selectedCategory,
              let solution = selectedSolution,
              let properties = currentProperties,
              let algorithm = currentAlgorithm else {
            return nil
        }

        let design = GeneratedDesign(
            seed: currentSeed,
            algorithm: algorithm,
            complexity: complexity,
            density: density,
            organicBias: organicBias,
            properties: properties
        )

        let specs = ExportSpecs.generate(
            for: category,
            solution: solution,
            properties: properties
        )

        // Use AI purpose if available, otherwise generated
        let purposeDescription = aiDesignPurpose.isEmpty ? specs.useCaseDescription : aiDesignPurpose

        return DesignProject(
            problemCategory: category,
            selectedSolutionId: solution.id,
            design: design,
            exportSpecs: specs,
            purposeDescription: purposeDescription
        )
    }
}
