import SwiftUI

struct NatureSolutionPickerView: View {
    @EnvironmentObject var flowState: DesignFlowState

    private var solutions: [NatureSolution] {
        guard let category = flowState.selectedCategory else { return [] }
        return NatureSolutionsDatabase.shared.getSolutions(for: category)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    TerminalText(text: "> STEP 2: LEARN FROM NATURE", size: 14, color: RetroTheme.dimGreen)

                    if let category = flowState.selectedCategory {
                        TypewriterText(text: "Nature solved \(category.rawValue.lowercased()) with...")
                    }
                }
                .padding(.top)

                // Solution cards
                VStack(spacing: 12) {
                    ForEach(solutions) { solution in
                        NatureSolutionCard(
                            title: solution.name,
                            organism: solution.organism,
                            principle: solution.shortPrinciple,
                            isSelected: flowState.selectedSolution?.id == solution.id,
                            action: {
                                selectSolution(solution)
                            }
                        )
                    }
                }
                .padding(.horizontal)

                // Selected solution detail
                if let solution = flowState.selectedSolution {
                    VStack(alignment: .leading, spacing: 16) {
                        // Principle
                        VStack(alignment: .leading, spacing: 6) {
                            TerminalText(text: "WHY IT WORKS", size: 11, color: RetroTheme.dimGreen)
                            TerminalText(text: solution.principle, size: 13)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        // Scientific backing
                        VStack(alignment: .leading, spacing: 6) {
                            TerminalText(text: "SCIENTIFIC BACKING", size: 11, color: RetroTheme.dimGreen)
                            TerminalText(text: solution.scientificBacking, size: 12, color: RetroTheme.dimGreen)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        // Real world applications
                        VStack(alignment: .leading, spacing: 6) {
                            TerminalText(text: "REAL WORLD USES", size: 11, color: RetroTheme.dimGreen)
                            ForEach(solution.realWorldApplications, id: \.self) { app in
                                HStack(spacing: 8) {
                                    Text("•")
                                        .foregroundColor(RetroTheme.primaryGreen)
                                    TerminalText(text: app, size: 12)
                                }
                            }
                        }

                        // Ratings
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                TerminalText(text: "STRENGTH", size: 10, color: RetroTheme.dimGreen)
                                RetroProgressBar(progress: solution.strengthRating, label: "")
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                TerminalText(text: "EFFICIENCY", size: 10, color: RetroTheme.dimGreen)
                                RetroProgressBar(progress: solution.efficiencyRating, label: "")
                            }
                        }
                    }
                    .padding()
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.primaryGreen)
                    .padding(.horizontal)
                }

                // Continue button
                if flowState.selectedSolution != nil {
                    RetroButton(title: "GENERATE DESIGN", action: continueToDesign)
                        .padding(.top, 8)
                }

                Spacer(minLength: 40)
            }
        }
    }

    private func selectSolution(_ solution: NatureSolution) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if flowState.selectedSolution?.id == solution.id {
                flowState.selectedSolution = nil
            } else {
                flowState.selectedSolution = solution
            }
        }
    }

    private func continueToDesign() {
        guard let solution = flowState.selectedSolution else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            flowState.selectSolution(solution)
        }
    }
}
