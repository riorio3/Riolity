import SwiftUI

/// Main chat interface for natural language design input
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject var flowState: DesignFlowState
    @FocusState private var isInputFocused: Bool
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Generate button (when design is ready)
            if viewModel.showGenerateButton {
                generateButton
            }

            // Quick prompts
            if viewModel.messages.count <= 1 {
                quickPromptsView
            }

            // Input area
            inputArea
        }
        .background(RetroTheme.background)
        .sheet(isPresented: $showSettings) {
            APIKeySettingsView()
        }
        .onAppear {
            checkAPIKey()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                TerminalText(text: "RIOLITY", size: 20, color: RetroTheme.primaryGreen)
                    .retroGlow(radius: 8)
                TerminalText(text: "BIOMIMICRY DESIGN ENGINE", size: 10, color: RetroTheme.dimGreen)
            }

            Spacer()

            // Settings button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                    .foregroundColor(RetroTheme.primaryGreen)
            }

            // Clear button
            Button(action: { viewModel.clearConversation() }) {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                    .foregroundColor(RetroTheme.dimGreen)
            }
            .padding(.leading, 12)
        }
        .padding()
        .background(RetroTheme.background)
    }

    // MARK: - Quick Prompts

    private var quickPromptsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                QuickPromptChip(text: "Wall hook for 5kg") {
                    Task { await viewModel.sendQuickPrompt("I need a wall hook that can hold 5kg") }
                }
                QuickPromptChip(text: "Phone stand") {
                    Task { await viewModel.sendQuickPrompt("Design a minimal phone stand") }
                }
                QuickPromptChip(text: "Vent cover") {
                    Task { await viewModel.sendQuickPrompt("Create a vent cover that maximizes airflow") }
                }
                QuickPromptChip(text: "Cable organizer") {
                    Task { await viewModel.sendQuickPrompt("Design a cable organizer using biomimicry") }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Generate Button

    private var generateButton: some View {
        Button(action: {
            if let design = viewModel.generateDesign() {
                // Transfer to design flow
                flowState.applyAIDesign(design)
                flowState.currentStep = .designStudio
            }
        }) {
            HStack {
                Image(systemName: "cube.fill")
                Text("GENERATE 3D DESIGN")
                    .font(.custom("Menlo", size: 14))
                    .fontWeight(.bold)
            }
            .foregroundColor(RetroTheme.background)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RetroTheme.primaryGreen)
            .retroGlow(radius: 10)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: - Input Area

    private var inputArea: some View {
        HStack(spacing: 12) {
            // Text input
            TextField("Describe what you need...", text: $viewModel.inputText, axis: .vertical)
                .font(.custom("Menlo", size: 14))
                .foregroundColor(RetroTheme.primaryGreen)
                .tint(RetroTheme.primaryGreen)
                .lineLimit(1...4)
                .focused($isInputFocused)
                .padding(12)
                .background(RetroTheme.background)
                .retroBorder()
                .onSubmit {
                    Task { await viewModel.sendMessage() }
                }

            // Send button
            Button(action: {
                Task { await viewModel.sendMessage() }
            }) {
                ZStack {
                    if viewModel.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: RetroTheme.primaryGreen))
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(viewModel.inputText.isEmpty ? RetroTheme.dimGreen : RetroTheme.primaryGreen)
                    }
                }
            }
            .disabled(viewModel.inputText.isEmpty || viewModel.isProcessing)
        }
        .padding()
        .background(RetroTheme.background)
    }

    // MARK: - Helpers

    private func checkAPIKey() {
        if !KeychainService.shared.hasAPIKey(type: .claudeAPI) {
            showSettings = true
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.role == .user {
                Spacer(minLength: 40)
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                // Role indicator
                if message.role != .user {
                    HStack(spacing: 4) {
                        Image(systemName: roleIcon)
                            .font(.system(size: 10))
                        Text(roleLabel)
                            .font(.custom("Menlo", size: 9))
                    }
                    .foregroundColor(roleColor)
                }

                // Message content
                if message.isLoading {
                    LoadingIndicator()
                } else {
                    Text(message.content)
                        .font(.custom("Menlo", size: 13))
                        .foregroundColor(contentColor)
                        .multilineTextAlignment(message.role == .user ? .trailing : .leading)
                }

                // Design specification card
                if let spec = message.designSpec {
                    DesignSpecCard(spec: spec)
                }
            }
            .padding(12)
            .background(backgroundColor)
            .cornerRadius(12)
            .retroBorder(color: borderColor)

            if message.role != .user {
                Spacer(minLength: 40)
            }
        }
    }

    private var roleIcon: String {
        switch message.role {
        case .user: return "person.fill"
        case .assistant: return "leaf.fill"
        case .system: return "exclamationmark.triangle.fill"
        }
    }

    private var roleLabel: String {
        switch message.role {
        case .user: return "YOU"
        case .assistant: return "RIOLITY"
        case .system: return "SYSTEM"
        }
    }

    private var roleColor: Color {
        switch message.role {
        case .user: return RetroTheme.dimGreen
        case .assistant: return RetroTheme.primaryGreen
        case .system: return .orange
        }
    }

    private var contentColor: Color {
        switch message.role {
        case .user: return RetroTheme.primaryGreen
        case .assistant: return RetroTheme.primaryGreen.opacity(0.9)
        case .system: return .orange
        }
    }

    private var backgroundColor: Color {
        switch message.role {
        case .user: return RetroTheme.darkGreen.opacity(0.3)
        case .assistant: return RetroTheme.background
        case .system: return Color.orange.opacity(0.1)
        }
    }

    private var borderColor: Color {
        switch message.role {
        case .user: return RetroTheme.darkGreen
        case .assistant: return RetroTheme.darkGreen
        case .system: return .orange.opacity(0.5)
        }
    }
}

// MARK: - Design Spec Card

struct DesignSpecCard: View {
    let spec: DesignSpecification

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cube.fill")
                Text("DESIGN READY")
                    .font(.custom("Menlo", size: 11))
                    .fontWeight(.bold)
            }
            .foregroundColor(RetroTheme.primaryGreen)

            Divider()
                .background(RetroTheme.darkGreen)

            specRow("Bio-inspiration", spec.bioInspiration)
            specRow("Algorithm", spec.algorithm.rawValue)
            specRow("Material", spec.material)

            if let dims = spec.dimensions {
                specRow("Size", dims.formatted)
            }
        }
        .padding(12)
        .background(RetroTheme.darkGreen.opacity(0.2))
        .retroBorder(color: RetroTheme.primaryGreen)
        .padding(.top, 8)
    }

    private func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label.uppercased())
                .font(.custom("Menlo", size: 9))
                .foregroundColor(RetroTheme.dimGreen)
            Spacer()
            Text(value)
                .font(.custom("Menlo", size: 10))
                .foregroundColor(RetroTheme.primaryGreen)
        }
    }
}

// MARK: - Quick Prompt Chip

struct QuickPromptChip: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.custom("Menlo", size: 11))
                .foregroundColor(RetroTheme.primaryGreen)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(RetroTheme.background)
                .retroBorder()
        }
    }
}

// MARK: - Loading Indicator

struct LoadingIndicator: View {
    @State private var dotCount = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            Text("Thinking")
                .font(.custom("Menlo", size: 13))
                .foregroundColor(RetroTheme.dimGreen)

            Text(String(repeating: ".", count: dotCount + 1))
                .font(.custom("Menlo", size: 13))
                .foregroundColor(RetroTheme.primaryGreen)
                .frame(width: 20, alignment: .leading)
        }
        .onReceive(timer) { _ in
            dotCount = (dotCount + 1) % 3
        }
    }
}
