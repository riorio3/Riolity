import SwiftUI

struct ProblemSelectionView: View {
    @EnvironmentObject var flowState: DesignFlowState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    TerminalText(text: "> STEP 1: DEFINE YOUR PROBLEM", size: 14, color: RetroTheme.dimGreen)
                    TypewriterText(text: "What are you trying to solve?")
                }
                .padding(.top)

                // Category cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(ProblemCategory.allCases) { category in
                        ProblemCategoryCard(
                            icon: category.icon,
                            title: category.rawValue,
                            description: category.description,
                            isSelected: flowState.selectedCategory == category,
                            action: {
                                selectCategory(category)
                            }
                        )
                    }
                }
                .padding(.horizontal)

                // Selected category detail
                if let category = flowState.selectedCategory {
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText(text: "SELECTED: \(category.rawValue.uppercased())", size: 12, color: RetroTheme.dimGreen)
                        TerminalText(text: category.detailedDescription, size: 13)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RetroTheme.darkGreen.opacity(0.3))
                    .retroBorder(color: RetroTheme.dimGreen)
                    .padding(.horizontal)
                }

                // Continue button
                if flowState.selectedCategory != nil {
                    RetroButton(title: "FIND NATURE'S SOLUTIONS", action: continueToSolutions)
                        .padding(.top, 8)
                }

                Spacer(minLength: 40)
            }
        }
    }

    private func selectCategory(_ category: ProblemCategory) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if flowState.selectedCategory == category {
                flowState.selectedCategory = nil
            } else {
                flowState.selectedCategory = category
            }
        }
    }

    private func continueToSolutions() {
        guard let category = flowState.selectedCategory else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            flowState.selectCategory(category)
        }
    }
}
