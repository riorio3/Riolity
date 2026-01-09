import Foundation

/// AI Service for Claude API integration
/// Handles natural language understanding and design reasoning
@MainActor
final class AIService: ObservableObject {
    static let shared = AIService()

    @Published var isProcessing = false
    @Published var lastError: AIError?

    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-20250514"
    private let maxTokens = 4096

    private init() {}

    // MARK: - Types

    enum AIError: LocalizedError {
        case noAPIKey
        case invalidAPIKey
        case networkError(String)
        case invalidResponse
        case rateLimited
        case serverError(Int)

        var errorDescription: String? {
            switch self {
            case .noAPIKey:
                return "No API key configured. Add your Claude API key in Settings."
            case .invalidAPIKey:
                return "Invalid API key. Please check your Claude API key."
            case .networkError(let message):
                return "Network error: \(message)"
            case .invalidResponse:
                return "Invalid response from AI service."
            case .rateLimited:
                return "Rate limited. Please wait a moment and try again."
            case .serverError(let code):
                return "Server error (code: \(code)). Please try again."
            }
        }
    }

    struct Message: Codable {
        let role: String
        let content: String
    }

    struct APIRequest: Codable {
        let model: String
        let max_tokens: Int
        let system: String
        let messages: [Message]
    }

    struct APIResponse: Codable {
        struct Content: Codable {
            let type: String
            let text: String?
        }
        let content: [Content]
        let stop_reason: String?
    }

    struct ErrorResponse: Codable {
        struct ErrorDetail: Codable {
            let type: String
            let message: String
        }
        let error: ErrorDetail
    }

    // MARK: - Design Request

    struct DesignRequest {
        let userPrompt: String
        let conversationHistory: [Message]

        init(userPrompt: String, conversationHistory: [Message] = []) {
            self.userPrompt = userPrompt
            self.conversationHistory = conversationHistory
        }
    }

    struct DesignResponse {
        let message: String
        let designIntent: DesignIntent?
        let biomimicryPatterns: [BiomimicryPattern]
        let suggestedParameters: DesignParameters?
        let isComplete: Bool
    }

    struct DesignIntent {
        let problemType: String
        let functionalRequirements: [String]
        let constraints: [String]
        let suggestedScale: String?
    }

    struct BiomimicryPattern {
        let name: String
        let organism: String
        let principle: String
        let applicationReason: String
    }

    struct DesignParameters {
        let baseGeometry: String
        let complexity: Double
        let density: Double
        let organicBias: Double
        let suggestedAlgorithm: String
        let materialRecommendation: String
    }

    // MARK: - API Calls

    /// Process a design request through Claude
    func processDesignRequest(_ request: DesignRequest) async throws -> DesignResponse {
        guard let apiKey = KeychainService.shared.getAPIKey(type: .claudeAPI) else {
            throw AIError.noAPIKey
        }

        isProcessing = true
        defer { isProcessing = false }

        let systemPrompt = PromptEngine.shared.buildSystemPrompt()

        var messages = request.conversationHistory
        messages.append(Message(role: "user", content: request.userPrompt))

        let apiRequest = APIRequest(
            model: model,
            max_tokens: maxTokens,
            system: systemPrompt,
            messages: messages
        )

        let response = try await makeAPICall(apiRequest, apiKey: apiKey)
        return try ResponseParser.shared.parseDesignResponse(response)
    }

    /// Simple chat message (for general conversation)
    func sendMessage(_ message: String, history: [Message] = []) async throws -> String {
        guard let apiKey = KeychainService.shared.getAPIKey(type: .claudeAPI) else {
            throw AIError.noAPIKey
        }

        isProcessing = true
        defer { isProcessing = false }

        let systemPrompt = PromptEngine.shared.buildSystemPrompt()

        var messages = history
        messages.append(Message(role: "user", content: message))

        let apiRequest = APIRequest(
            model: model,
            max_tokens: maxTokens,
            system: systemPrompt,
            messages: messages
        )

        return try await makeAPICall(apiRequest, apiKey: apiKey)
    }

    // MARK: - Private

    private func makeAPICall(_ request: APIRequest, apiKey: String) async throws -> String {
        guard let url = URL(string: baseURL) else {
            throw AIError.networkError("Invalid URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse.self, from: data)

            guard let textContent = apiResponse.content.first(where: { $0.type == "text" }),
                  let text = textContent.text else {
                throw AIError.invalidResponse
            }

            return text

        case 401:
            throw AIError.invalidAPIKey

        case 429:
            throw AIError.rateLimited

        case 400...499:
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw AIError.networkError(errorResponse.error.message)
            }
            throw AIError.serverError(httpResponse.statusCode)

        default:
            throw AIError.serverError(httpResponse.statusCode)
        }
    }

    // MARK: - API Key Validation

    /// Test if the API key is valid by making a minimal request
    func validateAPIKey() async -> Bool {
        guard let apiKey = KeychainService.shared.getAPIKey(type: .claudeAPI) else {
            return false
        }

        let request = APIRequest(
            model: model,
            max_tokens: 10,
            system: "Respond with OK",
            messages: [Message(role: "user", content: "Test")]
        )

        do {
            _ = try await makeAPICall(request, apiKey: apiKey)
            return true
        } catch AIError.invalidAPIKey {
            return false
        } catch {
            // Other errors don't necessarily mean invalid key
            return true
        }
    }
}
