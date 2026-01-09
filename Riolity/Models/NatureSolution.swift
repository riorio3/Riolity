import Foundation

struct NatureSolution: Identifiable, Codable {
    let id: String
    let name: String
    let organism: String
    let category: ProblemCategory

    // Educational content
    let principle: String
    let scientificBacking: String
    let realWorldApplications: [String]

    // Generation mapping
    let recommendedAlgorithm: GenerationAlgorithm
    let defaultComplexity: Double
    let defaultDensity: Double
    let defaultOrganicBias: Double

    // Ratings for display
    let strengthRating: Double
    let efficiencyRating: Double

    var displayName: String {
        name.uppercased()
    }

    var shortPrinciple: String {
        String(principle.prefix(100)) + (principle.count > 100 ? "..." : "")
    }
}

// Parameter preset for a solution
struct ParameterPreset: Codable {
    let complexity: Double
    let density: Double
    let organicBias: Double

    static let `default` = ParameterPreset(complexity: 0.5, density: 0.5, organicBias: 0.5)
}
