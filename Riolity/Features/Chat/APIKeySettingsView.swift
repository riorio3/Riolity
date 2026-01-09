import SwiftUI

/// Settings view for API key configuration
struct APIKeySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var apiKey: String = ""
    @State private var isValidating: Bool = false
    @State private var validationResult: ValidationResult?
    @State private var showKey: Bool = false

    enum ValidationResult {
        case valid
        case invalid(String)
    }

    private var hasExistingKey: Bool {
        KeychainService.shared.hasAPIKey(type: .claudeAPI)
    }

    var body: some View {
        NavigationView {
            ZStack {
                RetroTheme.background.ignoresSafeArea()

                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 40))
                            .foregroundColor(RetroTheme.primaryGreen)
                            .retroGlow(radius: 10)

                        TerminalText(text: "API CONFIGURATION", size: 18, color: RetroTheme.primaryGreen)

                        TerminalText(
                            text: "Enter your Claude API key to enable AI-powered design generation",
                            size: 12,
                            color: RetroTheme.dimGreen
                        )
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    // Status indicator
                    statusIndicator

                    // API Key input
                    VStack(alignment: .leading, spacing: 8) {
                        TerminalText(text: "CLAUDE API KEY", size: 11, color: RetroTheme.dimGreen)

                        HStack {
                            Group {
                                if showKey {
                                    TextField("sk-ant-...", text: $apiKey)
                                } else {
                                    SecureField("sk-ant-...", text: $apiKey)
                                }
                            }
                            .font(.custom("Menlo", size: 14))
                            .foregroundColor(RetroTheme.primaryGreen)
                            .tint(RetroTheme.primaryGreen)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()

                            Button(action: { showKey.toggle() }) {
                                Image(systemName: showKey ? "eye.slash" : "eye")
                                    .foregroundColor(RetroTheme.dimGreen)
                            }
                        }
                        .padding(12)
                        .background(RetroTheme.background)
                        .retroBorder()

                        // Format hint
                        TerminalText(
                            text: "Keys start with 'sk-ant-' from console.anthropic.com",
                            size: 10,
                            color: RetroTheme.darkGreen
                        )
                    }
                    .padding(.horizontal)

                    // Validation result
                    if let result = validationResult {
                        validationResultView(result)
                    }

                    Spacer()

                    // Action buttons
                    VStack(spacing: 12) {
                        // Save button
                        RetroButton(
                            title: hasExistingKey ? "UPDATE KEY" : "SAVE KEY",
                            action: { saveAPIKey() },
                            isLoading: isValidating
                        )
                        .disabled(apiKey.isEmpty || isValidating)
                        .padding(.horizontal)

                        // Delete button (if key exists)
                        if hasExistingKey {
                            Button(action: { deleteAPIKey() }) {
                                Text("DELETE SAVED KEY")
                                    .font(.custom("Menlo", size: 12))
                                    .foregroundColor(.red.opacity(0.8))
                            }
                        }

                        // Help link
                        Link(destination: URL(string: "https://console.anthropic.com/settings/keys")!) {
                            HStack {
                                Text("Get an API key")
                                    .font(.custom("Menlo", size: 11))
                                Image(systemName: "arrow.up.right.square")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(RetroTheme.dimGreen)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(RetroTheme.primaryGreen)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Status Indicator

    private var statusIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(hasExistingKey ? Color.green : Color.orange)
                .frame(width: 8, height: 8)

            TerminalText(
                text: hasExistingKey ? "API KEY CONFIGURED" : "NO API KEY",
                size: 11,
                color: hasExistingKey ? .green : .orange
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            (hasExistingKey ? Color.green : Color.orange).opacity(0.1)
        )
        .cornerRadius(20)
    }

    // MARK: - Validation Result View

    private func validationResultView(_ result: ValidationResult) -> some View {
        HStack(spacing: 8) {
            switch result {
            case .valid:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("API key validated successfully")
                    .font(.custom("Menlo", size: 12))
                    .foregroundColor(.green)
            case .invalid(let message):
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text(message)
                    .font(.custom("Menlo", size: 12))
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    // MARK: - Actions

    private func saveAPIKey() {
        let key = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)

        // Basic format check
        guard KeychainService.shared.isValidAPIKeyFormat(key, type: .claudeAPI) else {
            validationResult = .invalid("Invalid key format. Keys start with 'sk-ant-'")
            return
        }

        isValidating = true
        validationResult = nil

        // Save to keychain
        let saved = KeychainService.shared.saveAPIKey(key, type: .claudeAPI)

        if saved {
            // Validate with API
            Task {
                let isValid = await AIService.shared.validateAPIKey()

                await MainActor.run {
                    isValidating = false

                    if isValid {
                        validationResult = .valid
                        apiKey = ""

                        // Auto-dismiss after success
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } else {
                        validationResult = .invalid("Key saved but validation failed. Check your key.")
                    }
                }
            }
        } else {
            isValidating = false
            validationResult = .invalid("Failed to save key to secure storage")
        }
    }

    private func deleteAPIKey() {
        KeychainService.shared.deleteAPIKey(type: .claudeAPI)
        validationResult = nil
        apiKey = ""
    }
}
