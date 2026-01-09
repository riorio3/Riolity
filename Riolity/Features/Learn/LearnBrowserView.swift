import SwiftUI

struct LearnBrowserView: View {
    @EnvironmentObject var flowState: DesignFlowState
    @State private var selectedCategory: ProblemCategory?
    @State private var selectedSolution: NatureSolution?
    @State private var showingSolutionDetail = false

    private var filteredSolutions: [NatureSolution] {
        if let category = selectedCategory {
            return NatureSolutionsDatabase.shared.getSolutions(for: category)
        }
        return NatureSolutionsDatabase.shared.getAllSolutions()
    }

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    RetroHeader(text: "LEARN FROM NATURE", size: 18)
                    TerminalText(text: "Explore how nature solves engineering problems", size: 12, color: RetroTheme.dimGreen)
                }
                .padding(.top, 12)
                .padding(.bottom, 8)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        categoryFilterButton(nil, title: "ALL")

                        ForEach(ProblemCategory.allCases) { category in
                            categoryFilterButton(category, title: category.rawValue.uppercased())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Solutions list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSolutions) { solution in
                            LearnSolutionCard(solution: solution) {
                                selectedSolution = solution
                                showingSolutionDetail = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }

            ScanlineOverlay()
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingSolutionDetail) {
            if let solution = selectedSolution {
                SolutionDetailView(solution: solution) {
                    // Use this solution action
                    showingSolutionDetail = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        flowState.startWithSolution(solution)
                    }
                }
            }
        }
    }

    private func categoryFilterButton(_ category: ProblemCategory?, title: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        }) {
            TerminalText(
                text: title,
                size: 11,
                color: selectedCategory == category ? RetroTheme.background : RetroTheme.primaryGreen
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(selectedCategory == category ? RetroTheme.primaryGreen : Color.clear)
            )
            .retroBorder(color: selectedCategory == category ? RetroTheme.primaryGreen : RetroTheme.dimGreen)
        }
    }
}

struct LearnSolutionCard: View {
    let solution: NatureSolution
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        TerminalText(text: solution.name.uppercased(), size: 14)
                        TerminalText(text: solution.organism, size: 11, color: RetroTheme.dimGreen)
                    }

                    Spacer()

                    // Category badge
                    TerminalText(text: solution.category.rawValue, size: 9, color: RetroTheme.dimGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .retroBorder(color: RetroTheme.darkGreen)
                }

                TerminalText(text: solution.shortPrinciple, size: 12, color: RetroTheme.dimGreen)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        TerminalText(text: "STR", size: 9, color: RetroTheme.darkGreen)
                        RetroMiniProgressBar(progress: solution.strengthRating)
                    }

                    HStack(spacing: 4) {
                        TerminalText(text: "EFF", size: 9, color: RetroTheme.darkGreen)
                        RetroMiniProgressBar(progress: solution.efficiencyRating)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        TerminalText(text: "TAP TO LEARN", size: 10, color: RetroTheme.dimGreen)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(RetroTheme.dimGreen)
                    }
                }
            }
            .padding(14)
            .background(RetroTheme.darkGreen.opacity(0.2))
            .retroBorder(color: RetroTheme.dimGreen)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RetroMiniProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(RetroTheme.darkGreen)

                Rectangle()
                    .fill(RetroTheme.primaryGreen)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(width: 40, height: 4)
        .cornerRadius(2)
    }
}
