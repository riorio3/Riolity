import SwiftUI

struct SolutionDetailView: View {
    let solution: NatureSolution
    let onUseThisSolution: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button(action: { dismiss() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.down")
                                    TerminalText(text: "CLOSE", size: 12)
                                }
                            }

                            Spacer()

                            TerminalText(text: solution.category.rawValue.uppercased(), size: 11, color: RetroTheme.dimGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .retroBorder(color: RetroTheme.darkGreen)
                        }

                        RetroHeader(text: solution.name.uppercased(), size: 20)

                        TerminalText(text: "Source: \(solution.organism)", size: 13, color: RetroTheme.dimGreen)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Ratings
                    HStack(spacing: 30) {
                        VStack(spacing: 6) {
                            TerminalText(text: "STRENGTH", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: String(format: "%.0f%%", solution.strengthRating * 100), size: 20)
                                .retroGlow(radius: 5)
                            RetroProgressBar(progress: solution.strengthRating, label: "")
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 6) {
                            TerminalText(text: "EFFICIENCY", size: 10, color: RetroTheme.dimGreen)
                            TerminalText(text: String(format: "%.0f%%", solution.efficiencyRating * 100), size: 20)
                                .retroGlow(radius: 5)
                            RetroProgressBar(progress: solution.efficiencyRating, label: "")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Principle - WHY IT WORKS
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .foregroundColor(RetroTheme.primaryGreen)
                            TerminalText(text: "WHY IT WORKS", size: 13, color: RetroTheme.dimGreen)
                        }

                        TerminalText(text: solution.principle, size: 14)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.primaryGreen)
                    .padding(.horizontal)

                    // Scientific backing
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "flask")
                                .foregroundColor(RetroTheme.primaryGreen)
                            TerminalText(text: "SCIENTIFIC BACKING", size: 13, color: RetroTheme.dimGreen)
                        }

                        TerminalText(text: solution.scientificBacking, size: 13, color: RetroTheme.dimGreen)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.2))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Real world applications
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(RetroTheme.primaryGreen)
                            TerminalText(text: "REAL WORLD APPLICATIONS", size: 13, color: RetroTheme.dimGreen)
                        }

                        ForEach(solution.realWorldApplications, id: \.self) { app in
                            HStack(alignment: .top, spacing: 10) {
                                Text(">")
                                    .font(RetroTheme.terminalFont(14))
                                    .foregroundColor(RetroTheme.primaryGreen)
                                TerminalText(text: app, size: 14)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Algorithm info
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundColor(RetroTheme.primaryGreen)
                            TerminalText(text: "GENERATION ALGORITHM", size: 13, color: RetroTheme.dimGreen)
                        }

                        HStack {
                            TerminalText(text: solution.recommendedAlgorithm.rawValue.uppercased(), size: 14)
                            Spacer()
                            TerminalText(text: solution.recommendedAlgorithm.description, size: 11, color: RetroTheme.dimGreen)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.2))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)

                    // Use this solution button
                    RetroButton(title: "USE THIS SOLUTION", action: onUseThisSolution)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    Spacer(minLength: 60)
                }
            }

            ScanlineOverlay()
                .ignoresSafeArea()
        }
    }
}
