import Foundation

/// Represents a message in the design conversation
struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    var designSpec: DesignSpecification?
    var isLoading: Bool

    enum MessageRole: String, Codable {
        case user
        case assistant
        case system
    }

    init(
        id: UUID = UUID(),
        role: MessageRole,
        content: String,
        timestamp: Date = Date(),
        designSpec: DesignSpecification? = nil,
        isLoading: Bool = false
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.designSpec = designSpec
        self.isLoading = isLoading
    }

    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}

/// Design specification extracted from AI response
struct DesignSpecification: Codable, Equatable {
    let name: String
    let problemType: String
    let bioInspiration: String
    let principle: String
    let algorithm: GenerationAlgorithm
    let complexity: Double
    let density: Double
    let organicBias: Double
    let material: String
    let purpose: String
    let dimensions: Dimensions?

    struct Dimensions: Codable, Equatable {
        let width: Double
        let height: Double
        let depth: Double

        var formatted: String {
            "\(Int(width))×\(Int(height))×\(Int(depth))mm"
        }
    }
}
