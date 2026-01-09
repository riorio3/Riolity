import Foundation

struct DesignProject: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var name: String

    // Problem context
    let problemCategory: ProblemCategory
    let selectedSolutionId: String

    // Design data
    let design: GeneratedDesign

    // Export specs
    var exportSpecs: ExportSpecs

    // Purpose explanation
    var purposeDescription: String

    init(
        problemCategory: ProblemCategory,
        selectedSolutionId: String,
        design: GeneratedDesign,
        exportSpecs: ExportSpecs,
        purposeDescription: String
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.name = "PROJECT_\(Self.generateShortId())"
        self.problemCategory = problemCategory
        self.selectedSolutionId = selectedSolutionId
        self.design = design
        self.exportSpecs = exportSpecs
        self.purposeDescription = purposeDescription
    }

    static func generateShortId() -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in chars.randomElement()! })
    }

    var displayName: String {
        name.uppercased()
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: createdAt)
    }

    var categoryName: String {
        problemCategory.rawValue
    }
}

extension DesignProject: Equatable {
    static func == (lhs: DesignProject, rhs: DesignProject) -> Bool {
        lhs.id == rhs.id
    }
}
