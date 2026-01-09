import Foundation

class AlgorithmMapper {
    static let shared = AlgorithmMapper()

    private init() {}

    func getRecommendedAlgorithms(for category: ProblemCategory) -> [GenerationAlgorithm] {
        switch category {
        case .structural:
            return [.voronoiMutation, .noiseField, .implicitBlend]
        case .fluidFlow:
            return [.randomLSystem, .reactionDiffusion]
        case .surfaceProperties:
            return [.voronoiMutation, .noiseField, .reactionDiffusion]
        case .acousticVibration:
            return [.noiseField, .voronoiMutation]
        }
    }

    func getDefaultParameters(for category: ProblemCategory, algorithm: GenerationAlgorithm) -> ParameterPreset {
        switch category {
        case .structural:
            switch algorithm {
            case .voronoiMutation:
                return ParameterPreset(complexity: 0.6, density: 0.7, organicBias: 0.3)
            case .noiseField:
                return ParameterPreset(complexity: 0.5, density: 0.6, organicBias: 0.5)
            case .implicitBlend:
                return ParameterPreset(complexity: 0.7, density: 0.5, organicBias: 0.2)
            default:
                return ParameterPreset.default
            }

        case .fluidFlow:
            switch algorithm {
            case .randomLSystem:
                return ParameterPreset(complexity: 0.6, density: 0.5, organicBias: 0.8)
            case .reactionDiffusion:
                return ParameterPreset(complexity: 0.7, density: 0.6, organicBias: 0.7)
            default:
                return ParameterPreset.default
            }

        case .surfaceProperties:
            switch algorithm {
            case .voronoiMutation:
                return ParameterPreset(complexity: 0.8, density: 0.4, organicBias: 0.4)
            case .noiseField:
                return ParameterPreset(complexity: 0.9, density: 0.3, organicBias: 0.6)
            case .reactionDiffusion:
                return ParameterPreset(complexity: 0.7, density: 0.5, organicBias: 0.7)
            default:
                return ParameterPreset.default
            }

        case .acousticVibration:
            switch algorithm {
            case .noiseField:
                return ParameterPreset(complexity: 0.7, density: 0.5, organicBias: 0.6)
            case .voronoiMutation:
                return ParameterPreset(complexity: 0.6, density: 0.6, organicBias: 0.4)
            default:
                return ParameterPreset.default
            }
        }
    }

    func getPrimaryAlgorithm(for solution: NatureSolution) -> GenerationAlgorithm {
        return solution.recommendedAlgorithm
    }
}
