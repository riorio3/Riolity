import Foundation

struct ExportSpecs: Codable {
    let suggestedMaterials: [MaterialRecommendation]
    let scaleRecommendation: ScaleRecommendation
    let useCaseDescription: String

    static func generate(
        for category: ProblemCategory,
        solution: NatureSolution,
        properties: StructuralProperties
    ) -> ExportSpecs {
        let materials = generateMaterialRecommendations(for: category, properties: properties)
        let scale = generateScaleRecommendation(for: category, properties: properties)
        let useCase = generateUseCaseDescription(for: category, solution: solution, properties: properties)

        return ExportSpecs(
            suggestedMaterials: materials,
            scaleRecommendation: scale,
            useCaseDescription: useCase
        )
    }

    private static func generateMaterialRecommendations(
        for category: ProblemCategory,
        properties: StructuralProperties
    ) -> [MaterialRecommendation] {
        switch category {
        case .structural:
            return [
                MaterialRecommendation(
                    material: "PETG",
                    suitability: 0.92,
                    reason: "Excellent layer adhesion and impact resistance for structural parts"
                ),
                MaterialRecommendation(
                    material: "PLA+",
                    suitability: 0.78,
                    reason: "Easy to print with good rigidity, but lower heat resistance"
                ),
                MaterialRecommendation(
                    material: "Nylon",
                    suitability: 0.85,
                    reason: "High strength and flexibility, ideal for load-bearing applications"
                )
            ]
        case .fluidFlow:
            return [
                MaterialRecommendation(
                    material: "PETG",
                    suitability: 0.88,
                    reason: "Water-resistant and food-safe options available"
                ),
                MaterialRecommendation(
                    material: "Resin (Standard)",
                    suitability: 0.82,
                    reason: "Smooth internal surfaces for better flow characteristics"
                ),
                MaterialRecommendation(
                    material: "ABS",
                    suitability: 0.75,
                    reason: "Heat resistant, suitable for thermal management applications"
                )
            ]
        case .surfaceProperties:
            return [
                MaterialRecommendation(
                    material: "Resin (High Detail)",
                    suitability: 0.95,
                    reason: "Captures fine surface details essential for texture effects"
                ),
                MaterialRecommendation(
                    material: "TPU",
                    suitability: 0.85,
                    reason: "Flexible material great for grip and adhesion applications"
                ),
                MaterialRecommendation(
                    material: "PLA",
                    suitability: 0.70,
                    reason: "Good for prototyping surface patterns before final production"
                )
            ]
        case .acousticVibration:
            return [
                MaterialRecommendation(
                    material: "TPU",
                    suitability: 0.90,
                    reason: "Flexible structure absorbs vibrations effectively"
                ),
                MaterialRecommendation(
                    material: "PLA (Low Infill)",
                    suitability: 0.78,
                    reason: "Porous structure aids sound absorption"
                ),
                MaterialRecommendation(
                    material: "Resin (Flexible)",
                    suitability: 0.82,
                    reason: "Dampens vibrations while maintaining structural integrity"
                )
            ]
        }
    }

    private static func generateScaleRecommendation(
        for category: ProblemCategory,
        properties: StructuralProperties
    ) -> ScaleRecommendation {
        switch category {
        case .structural:
            return ScaleRecommendation(
                minScale: 30,
                maxScale: 200,
                optimalScale: 80,
                reason: "At 80mm scale, wall thickness provides optimal strength-to-weight ratio"
            )
        case .fluidFlow:
            return ScaleRecommendation(
                minScale: 40,
                maxScale: 150,
                optimalScale: 70,
                reason: "Channel dimensions at this scale allow effective flow while remaining printable"
            )
        case .surfaceProperties:
            return ScaleRecommendation(
                minScale: 20,
                maxScale: 100,
                optimalScale: 50,
                reason: "Surface features are well-defined at this scale with most printers"
            )
        case .acousticVibration:
            return ScaleRecommendation(
                minScale: 50,
                maxScale: 250,
                optimalScale: 120,
                reason: "Larger scale improves acoustic performance, smaller pores at this size"
            )
        }
    }

    private static func generateUseCaseDescription(
        for category: ProblemCategory,
        solution: NatureSolution,
        properties: StructuralProperties
    ) -> String {
        let porosityDesc = properties.porosity > 0.5 ? "high porosity" : "moderate density"
        let complexityDesc = properties.complexity > 0.6 ? "intricate geometry" : "efficient structure"

        return "This \(solution.name.lowercased())-inspired design provides optimal \(category.rawValue.lowercased()) properties. The \(complexityDesc) with \(porosityDesc) (\(properties.porosityPercent)) makes it suitable for \(solution.realWorldApplications.prefix(2).joined(separator: " and "))."
    }
}

struct MaterialRecommendation: Codable, Identifiable {
    let material: String
    let suitability: Double
    let reason: String

    var id: String { material }

    var suitabilityPercent: String {
        String(format: "%.0f%%", suitability * 100)
    }
}

struct ScaleRecommendation: Codable {
    let minScale: Float
    let maxScale: Float
    let optimalScale: Float
    let reason: String

    var formattedRange: String {
        "\(Int(minScale))mm - \(Int(maxScale))mm"
    }

    var formattedOptimal: String {
        "\(Int(optimalScale))mm"
    }
}
