import SwiftUI

struct ExportView: View {
    @EnvironmentObject var flowState: DesignFlowState
    @State private var showingShareSheet = false
    @State private var shareURL: URL?
    @State private var projectSaved = false

    private var exportSpecs: ExportSpecs? {
        guard let category = flowState.selectedCategory,
              let solution = flowState.selectedSolution,
              let properties = flowState.currentProperties else {
            return nil
        }

        return ExportSpecs.generate(for: category, solution: solution, properties: properties)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    TerminalText(text: "> STEP 4: EXPORT & SAVE", size: 14, color: RetroTheme.dimGreen)
                    TypewriterText(text: "Your design is ready for the real world")
                }
                .padding(.top)

                // Purpose description
                if let specs = exportSpecs {
                    RetroInfoCard(
                        title: "Design Purpose",
                        content: specs.useCaseDescription,
                        icon: "lightbulb"
                    )
                    .padding(.horizontal)
                }

                // Problem context
                if let category = flowState.selectedCategory, let solution = flowState.selectedSolution {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            TerminalText(text: "PROBLEM", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: category.rawValue, size: 12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 4) {
                            TerminalText(text: "INSPIRED BY", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: solution.name, size: 12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)
                }

                // Material recommendations
                if let specs = exportSpecs {
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText(text: "RECOMMENDED MATERIALS", size: 12, color: RetroTheme.dimGreen)

                        ForEach(specs.suggestedMaterials) { material in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        TerminalText(text: material.material, size: 14)
                                        Spacer()
                                        TerminalText(text: material.suitabilityPercent, size: 12, color: RetroTheme.primaryGreen)
                                    }
                                    TerminalText(text: material.reason, size: 11, color: RetroTheme.dimGreen)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding(10)
                            .background(RetroTheme.darkGreen.opacity(0.2))
                            .retroBorder(color: RetroTheme.darkGreen)
                        }
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)
                }

                // Scale recommendations
                if let specs = exportSpecs {
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText(text: "SCALE RECOMMENDATIONS", size: 12, color: RetroTheme.dimGreen)

                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                TerminalText(text: "RANGE", size: 10, color: RetroTheme.dimGreen)
                                TerminalText(text: specs.scaleRecommendation.formattedRange, size: 14)
                            }

                            VStack(spacing: 4) {
                                TerminalText(text: "OPTIMAL", size: 10, color: RetroTheme.dimGreen)
                                TerminalText(text: specs.scaleRecommendation.formattedOptimal, size: 14)
                                    .retroGlow(radius: 5)
                            }
                        }

                        TerminalText(text: specs.scaleRecommendation.reason, size: 11, color: RetroTheme.dimGreen)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)
                }

                // Design properties summary
                if let props = flowState.currentProperties {
                    VStack(alignment: .leading, spacing: 8) {
                        TerminalText(text: "DESIGN PROPERTIES", size: 12, color: RetroTheme.dimGreen)

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                TerminalText(text: "Porosity: \(props.porosityPercent)", size: 12)
                                TerminalText(text: "S/V Ratio: \(props.surfaceToVolumeFormatted)", size: 12)
                            }

                            Spacer()

                            VStack(alignment: .leading, spacing: 4) {
                                TerminalText(text: "Complexity: \(props.complexityLevel)", size: 12)
                                TerminalText(text: "Mesh: \(props.meshStats)", size: 12)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)
                }

                // Action buttons
                VStack(spacing: 12) {
                    // Export STL
                    RetroButton(title: "EXPORT STL FILE", action: exportSTL)

                    // Save project
                    HStack(spacing: 12) {
                        RetroSecondaryButton(
                            title: projectSaved ? "SAVED" : "SAVE PROJECT",
                            icon: projectSaved ? "checkmark.circle" : "square.and.arrow.down",
                            isDisabled: projectSaved,
                            action: saveProject
                        )

                        RetroSecondaryButton(
                            title: "NEW DESIGN",
                            icon: "plus",
                            action: startNewDesign
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer(minLength: 60)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = shareURL {
                ShareSheet(items: [url])
            }
        }
    }

    private func exportSTL() {
        guard let mesh = flowState.currentMesh else { return }

        let name = "Riolity_\(flowState.selectedSolution?.name.replacingOccurrences(of: " ", with: "_") ?? "Design")"

        if let url = STLExporter.shared.exportSTL(mesh: mesh, name: name) {
            shareURL = url
            showingShareSheet = true
        }
    }

    private func saveProject() {
        if let project = flowState.createProject() {
            ProjectStorageService.shared.saveProject(project)
            withAnimation {
                projectSaved = true
            }
        }
    }

    private func startNewDesign() {
        withAnimation {
            flowState.reset()
        }
    }
}
