import SwiftUI

struct ProjectDetailView: View {
    let project: DesignProject
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var shareURL: URL?
    @State private var showingDeleteConfirm = false

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.down")
                                TerminalText(text: "CLOSE", size: 12)
                            }
                        }

                        Spacer()

                        Button(action: { showingDeleteConfirm = true }) {
                            Image(systemName: "trash")
                                .foregroundColor(RetroTheme.dimGreen)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Project name and date
                    VStack(alignment: .leading, spacing: 6) {
                        RetroHeader(text: project.displayName, size: 18)
                        TerminalText(text: "Created: \(project.dateString)", size: 12, color: RetroTheme.dimGreen)
                    }
                    .padding(.horizontal)

                    // 3D Preview placeholder
                    ZStack {
                        RetroTheme.darkGreen.opacity(0.3)

                        VStack(spacing: 12) {
                            Image(systemName: "cube.fill")
                                .font(.system(size: 50))
                                .foregroundColor(RetroTheme.dimGreen)

                            TerminalText(text: "3D PREVIEW", size: 12, color: RetroTheme.dimGreen)
                        }
                    }
                    .frame(height: 200)
                    .retroBorder()
                    .padding(.horizontal)

                    // Purpose description
                    RetroInfoCard(
                        title: "Design Purpose",
                        content: project.purposeDescription,
                        icon: "lightbulb"
                    )
                    .padding(.horizontal)

                    // Problem context
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            TerminalText(text: "PROBLEM", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: project.categoryName, size: 12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 4) {
                            TerminalText(text: "ALGORITHM", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: project.design.algorithmName, size: 12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Properties
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText(text: "DESIGN PROPERTIES", size: 12, color: RetroTheme.dimGreen)

                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                TerminalText(text: "POROSITY", size: 10, color: RetroTheme.darkGreen)
                                TerminalText(text: project.design.properties.porosityPercent, size: 14)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 4) {
                                TerminalText(text: "S/V RATIO", size: 10, color: RetroTheme.darkGreen)
                                TerminalText(text: project.design.properties.surfaceToVolumeFormatted, size: 14)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 4) {
                                TerminalText(text: "COMPLEXITY", size: 10, color: RetroTheme.darkGreen)
                                TerminalText(text: project.design.properties.complexityLevel, size: 14)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        TerminalText(text: project.design.properties.meshStats, size: 11, color: RetroTheme.dimGreen)
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Export specs
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText(text: "EXPORT RECOMMENDATIONS", size: 12, color: RetroTheme.dimGreen)

                        ForEach(project.exportSpecs.suggestedMaterials.prefix(2)) { material in
                            HStack {
                                TerminalText(text: material.material, size: 12)
                                Spacer()
                                TerminalText(text: material.suitabilityPercent, size: 12, color: RetroTheme.primaryGreen)
                            }
                        }

                        HStack {
                            TerminalText(text: "Optimal Scale:", size: 11, color: RetroTheme.dimGreen)
                            TerminalText(text: project.exportSpecs.scaleRecommendation.formattedOptimal, size: 12)
                        }
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Generation parameters
                    VStack(alignment: .leading, spacing: 8) {
                        TerminalText(text: "GENERATION PARAMETERS", size: 12, color: RetroTheme.dimGreen)

                        HStack {
                            TerminalText(text: "Seed: \(project.design.seedString)", size: 11)
                            Spacer()
                            TerminalText(text: String(format: "C:%.0f%% D:%.0f%% O:%.0f%%",
                                                     project.design.complexity * 100,
                                                     project.design.density * 100,
                                                     project.design.organicBias * 100), size: 11, color: RetroTheme.dimGreen)
                        }
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.2))
                    .retroBorder(color: RetroTheme.darkGreen)
                    .padding(.horizontal)

                    // Action buttons
                    VStack(spacing: 12) {
                        RetroButton(title: "EXPORT STL FILE", action: exportSTL)

                        HStack(spacing: 12) {
                            RetroSecondaryButton(
                                title: "COPY DETAILS",
                                icon: "doc.on.doc",
                                action: copyDetails
                            )

                            RetroSecondaryButton(
                                title: "SHARE",
                                icon: "square.and.arrow.up",
                                action: exportSTL
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer(minLength: 60)
                }
            }

            ScanlineOverlay()
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = shareURL {
                ShareSheet(items: [url])
            }
        }
        .alert("Delete Project?", isPresented: $showingDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private func exportSTL() {
        let mesh = project.design.regenerateMesh()

        if let url = STLExporter.shared.exportSTL(mesh: mesh, name: project.name) {
            shareURL = url
            showingShareSheet = true
        }
    }

    private func copyDetails() {
        let details = """
        RIOLITY DESIGN: \(project.displayName)
        Created: \(project.dateString)

        Problem: \(project.categoryName)
        Algorithm: \(project.design.algorithmName)
        Seed: \(project.design.seedString)

        Properties:
        - Porosity: \(project.design.properties.porosityPercent)
        - S/V Ratio: \(project.design.properties.surfaceToVolumeFormatted)
        - Complexity: \(project.design.properties.complexityLevel)
        - Mesh: \(project.design.properties.meshStats)

        Purpose: \(project.purposeDescription)
        """

        UIPasteboard.general.string = details
    }
}
