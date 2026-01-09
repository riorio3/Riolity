import SwiftUI

struct DesignFlowView: View {
    @EnvironmentObject var flowState: DesignFlowState

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerSection

                // Step indicator
                StepIndicator(
                    currentStep: flowState.currentStep.rawValue,
                    totalSteps: 4,
                    stepTitles: ["PROBLEM", "NATURE", "DESIGN", "EXPORT"]
                )
                .padding(.vertical, 12)

                // Content based on current step
                contentForStep

                Spacer(minLength: 0)
            }

            // Scanline overlay
            ScanlineOverlay()
                .ignoresSafeArea()
        }
    }

    private var headerSection: some View {
        HStack {
            if flowState.currentStep.rawValue > 0 {
                Button(action: goBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        TerminalText(text: "BACK", size: 12)
                    }
                }
            }

            Spacer()

            VStack(spacing: 2) {
                RetroHeader(text: "DESIGN STUDIO", size: 16)
                if !flowState.aiDesignName.isEmpty {
                    TerminalText(text: flowState.aiDesignName, size: 10, color: RetroTheme.dimGreen)
                }
            }

            Spacer()

            Button(action: { flowState.reset() }) {
                TerminalText(text: "RESET", size: 12, color: RetroTheme.dimGreen)
            }
            .opacity(flowState.currentStep.rawValue > 0 ? 1 : 0)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var contentForStep: some View {
        switch flowState.currentStep {
        case .problemSelection:
            ProblemSelectionView()
                .environmentObject(flowState)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

        case .solutionPicker:
            NatureSolutionPickerView()
                .environmentObject(flowState)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

        case .designStudio:
            DesignStudioView()
                .environmentObject(flowState)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

        case .export:
            ExportView()
                .environmentObject(flowState)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
    }

    private func goBack() {
        withAnimation(.easeInOut(duration: 0.3)) {
            let currentRaw = flowState.currentStep.rawValue
            if currentRaw > 0, let previousStep = DesignFlowStep(rawValue: currentRaw - 1) {
                flowState.currentStep = previousStep
            }
        }
    }
}
