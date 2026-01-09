import Foundation

/// Parses AI responses to extract design specifications and conversation elements
final class ResponseParser {
    static let shared = ResponseParser()

    private init() {}

    // MARK: - Types

    struct ParsedDesign: Codable {
        let ready_to_generate: Bool
        let design: DesignSpec?
    }

    struct DesignSpec: Codable {
        let name: String
        let problem_type: String
        let bio_inspiration: String
        let principle: String
        let algorithm: String
        let parameters: DesignParams
        let dimensions_mm: Dimensions?
        let material: String?
        let purpose: String

        struct DesignParams: Codable {
            let complexity: Double
            let density: Double
            let organic_bias: Double
        }

        struct Dimensions: Codable {
            let width: Double
            let height: Double
            let depth: Double
        }
    }

    // MARK: - Parsing

    /// Parse AI response into a DesignResponse
    func parseDesignResponse(_ text: String) throws -> AIService.DesignResponse {
        // Extract JSON block if present
        let parsedDesign = extractDesignJSON(from: text)

        // Extract the conversational message (text without JSON block)
        let message = extractMessage(from: text)

        // Build design intent from parsed data
        var designIntent: AIService.DesignIntent?
        var patterns: [AIService.BiomimicryPattern] = []
        var suggestedParams: AIService.DesignParameters?

        if let design = parsedDesign?.design {
            designIntent = AIService.DesignIntent(
                problemType: design.problem_type,
                functionalRequirements: [design.purpose],
                constraints: [],
                suggestedScale: design.dimensions_mm.map { "\(Int($0.width))×\(Int($0.height))×\(Int($0.depth))mm" }
            )

            patterns.append(AIService.BiomimicryPattern(
                name: design.bio_inspiration,
                organism: design.bio_inspiration,
                principle: design.principle,
                applicationReason: design.purpose
            ))

            suggestedParams = AIService.DesignParameters(
                baseGeometry: design.problem_type,
                complexity: design.parameters.complexity,
                density: design.parameters.density,
                organicBias: design.parameters.organic_bias,
                suggestedAlgorithm: design.algorithm,
                materialRecommendation: design.material ?? "PLA"
            )
        }

        return AIService.DesignResponse(
            message: message,
            designIntent: designIntent,
            biomimicryPatterns: patterns,
            suggestedParameters: suggestedParams,
            isComplete: parsedDesign?.ready_to_generate ?? false
        )
    }

    /// Extract JSON design block from response text
    func extractDesignJSON(from text: String) -> ParsedDesign? {
        // Look for JSON block between ```json and ```
        let jsonPattern = "```json\\s*([\\s\\S]*?)```"

        guard let regex = try? NSRegularExpression(pattern: jsonPattern, options: []),
              let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
              let jsonRange = Range(match.range(at: 1), in: text) else {
            return nil
        }

        let jsonString = String(text[jsonRange]).trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ParsedDesign.self, from: jsonData)
        } catch {
            // JSON parsing failed - response doesn't contain valid design spec
            return nil
        }
    }

    /// Extract conversational message (remove JSON blocks)
    func extractMessage(from text: String) -> String {
        // Remove JSON blocks
        let jsonPattern = "```json[\\s\\S]*?```"

        guard let regex = try? NSRegularExpression(pattern: jsonPattern, options: []) else {
            return text
        }

        let range = NSRange(text.startIndex..., in: text)
        let cleanText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")

        return cleanText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Check if response indicates readiness to generate
    func isReadyToGenerate(_ text: String) -> Bool {
        if let parsed = extractDesignJSON(from: text) {
            return parsed.ready_to_generate
        }
        return false
    }

    /// Extract algorithm type from response
    func extractAlgorithm(from text: String) -> GenerationAlgorithm? {
        guard let parsed = extractDesignJSON(from: text),
              let design = parsed.design else {
            return nil
        }

        switch design.algorithm.lowercased() {
        case "voronoi", "voronoi_mutation":
            return GenerationAlgorithm.voronoiMutation
        case "noise_field", "noisefield":
            return GenerationAlgorithm.noiseField
        case "l_system", "lsystem":
            return GenerationAlgorithm.randomLSystem
        case "reaction_diffusion", "reactiondiffusion":
            return GenerationAlgorithm.reactionDiffusion
        case "implicit_blend", "implicitblend":
            return GenerationAlgorithm.implicitBlend
        default:
            return nil
        }
    }

    /// Extract design parameters from response
    func extractParameters(from text: String) -> (complexity: Double, density: Double, organicBias: Double)? {
        guard let parsed = extractDesignJSON(from: text),
              let design = parsed.design else {
            return nil
        }

        return (
            complexity: design.parameters.complexity,
            density: design.parameters.density,
            organicBias: design.parameters.organic_bias
        )
    }
}
