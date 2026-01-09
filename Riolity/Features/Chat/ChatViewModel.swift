import Foundation
import SwiftUI

/// Manages the chat conversation state and AI interactions
@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isProcessing: Bool = false
    @Published var error: String?
    @Published var currentDesign: DesignSpecification?
    @Published var showGenerateButton: Bool = false

    private let aiService = AIService.shared

    // MARK: - Initialization

    init() {
        addWelcomeMessage()
    }

    private func addWelcomeMessage() {
        let welcome = ChatMessage(
            role: .assistant,
            content: """
            Welcome to Riolity. I'm your biomimicry design engine.

            Tell me what you need to create. For example:
            • "I need a lightweight wall hook that holds 5kg"
            • "Design a vent cover that maximizes airflow"
            • "Create a phone stand using minimal material"

            I'll analyze your problem, find how nature solved it, and generate a 3D-printable design.

            What would you like to create?
            """
        )
        messages.append(welcome)
    }

    // MARK: - Message Handling

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        // Clear input
        inputText = ""
        error = nil

        // Add user message
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        // Add loading placeholder
        let loadingMessage = ChatMessage(
            role: .assistant,
            content: "",
            isLoading: true
        )
        messages.append(loadingMessage)

        isProcessing = true

        do {
            // Build conversation history for context
            let history = buildConversationHistory()

            // Send to AI
            let request = AIService.DesignRequest(
                userPrompt: text,
                conversationHistory: history
            )

            let response = try await aiService.processDesignRequest(request)

            // Remove loading message
            messages.removeLast()

            // Parse design if ready
            var designSpec: DesignSpecification?
            if response.isComplete, let params = response.suggestedParameters {
                designSpec = DesignSpecification(
                    name: response.designIntent?.problemType ?? "Design",
                    problemType: response.designIntent?.problemType ?? "structural",
                    bioInspiration: response.biomimicryPatterns.first?.organism ?? "Nature",
                    principle: response.biomimicryPatterns.first?.principle ?? "",
                    algorithm: mapAlgorithm(params.suggestedAlgorithm),
                    complexity: params.complexity,
                    density: params.density,
                    organicBias: params.organicBias,
                    material: params.materialRecommendation,
                    purpose: response.biomimicryPatterns.first?.applicationReason ?? "",
                    dimensions: nil
                )
                currentDesign = designSpec
                showGenerateButton = true
            }

            // Add assistant response
            let assistantMessage = ChatMessage(
                role: .assistant,
                content: response.message,
                designSpec: designSpec
            )
            messages.append(assistantMessage)

        } catch let aiError as AIService.AIError {
            // Remove loading message
            messages.removeLast()
            error = aiError.localizedDescription

            let errorMessage = ChatMessage(
                role: .system,
                content: "Error: \(aiError.localizedDescription)"
            )
            messages.append(errorMessage)

        } catch {
            // Remove loading message
            messages.removeLast()
            self.error = error.localizedDescription

            let errorMessage = ChatMessage(
                role: .system,
                content: "Error: \(error.localizedDescription)"
            )
            messages.append(errorMessage)
        }

        isProcessing = false
    }

    // MARK: - Helpers

    private func buildConversationHistory() -> [AIService.Message] {
        messages.compactMap { message in
            guard !message.isLoading else { return nil }

            switch message.role {
            case .user:
                return AIService.Message(role: "user", content: message.content)
            case .assistant:
                return AIService.Message(role: "assistant", content: message.content)
            case .system:
                return nil
            }
        }
    }

    private func mapAlgorithm(_ name: String) -> GenerationAlgorithm {
        switch name.lowercased() {
        case "voronoi", "voronoi_mutation":
            return .voronoiMutation
        case "noise_field", "noisefield":
            return .noiseField
        case "l_system", "lsystem":
            return .randomLSystem
        case "reaction_diffusion", "reactiondiffusion":
            return .reactionDiffusion
        case "implicit_blend", "implicitblend":
            return .implicitBlend
        default:
            return .voronoiMutation
        }
    }

    // MARK: - Actions

    func clearConversation() {
        messages.removeAll()
        currentDesign = nil
        showGenerateButton = false
        error = nil
        addWelcomeMessage()
    }

    func generateDesign() -> DesignSpecification? {
        return currentDesign
    }

    // MARK: - Quick Actions

    func sendQuickPrompt(_ prompt: String) async {
        inputText = prompt
        await sendMessage()
    }
}
