import Foundation

enum ProblemCategory: String, CaseIterable, Codable, Identifiable {
    case structural = "Structural"
    case fluidFlow = "Fluid/Air Flow"
    case surfaceProperties = "Surface Properties"
    case acousticVibration = "Acoustic/Vibration"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .structural: return "cube.fill"
        case .fluidFlow: return "wind"
        case .surfaceProperties: return "hand.point.up.fill"
        case .acousticVibration: return "waveform"
        }
    }

    var description: String {
        switch self {
        case .structural:
            return "Brackets, supports, joints, load distribution"
        case .fluidFlow:
            return "Ventilation, channels, heat dissipation"
        case .surfaceProperties:
            return "Grip, texture, self-cleaning, adhesion"
        case .acousticVibration:
            return "Sound absorption, vibration dampening"
        }
    }

    var detailedDescription: String {
        switch self {
        case .structural:
            return "Design structures that maximize strength while minimizing material. Nature excels at creating load-bearing forms that distribute stress efficiently."
        case .fluidFlow:
            return "Optimize flow of air, water, or heat through your design. Natural systems have evolved elegant solutions for fluid transport and thermal management."
        case .surfaceProperties:
            return "Engineer surface characteristics for specific functions. From gecko-inspired adhesion to lotus-leaf self-cleaning, nature offers remarkable surface solutions."
        case .acousticVibration:
            return "Control sound and vibration through structure. Nature has developed sophisticated methods for dampening, absorbing, and channeling mechanical waves."
        }
    }

    var parameterLabels: (p1: String, p2: String, p3: String) {
        switch self {
        case .structural:
            return ("CELL DENSITY", "WALL THICKNESS", "REGULARITY")
        case .fluidFlow:
            return ("CHANNEL WIDTH", "BRANCH DENSITY", "FLOW SMOOTHNESS")
        case .surfaceProperties:
            return ("FEATURE SIZE", "PATTERN DEPTH", "COVERAGE")
        case .acousticVibration:
            return ("PORE SIZE", "ABSORPTION DEPTH", "DENSITY GRADIENT")
        }
    }
}
