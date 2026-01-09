import Foundation

class NatureSolutionsDatabase {
    static let shared = NatureSolutionsDatabase()

    private(set) var solutions: [NatureSolution] = []

    private init() {
        loadSolutions()
    }

    func getSolutions(for category: ProblemCategory) -> [NatureSolution] {
        solutions.filter { $0.category == category }
    }

    func getSolution(byId id: String) -> NatureSolution? {
        solutions.first { $0.id == id }
    }

    func getAllSolutions() -> [NatureSolution] {
        solutions
    }

    private func loadSolutions() {
        solutions = [
            // STRUCTURAL SOLUTIONS
            NatureSolution(
                id: "honeycomb",
                name: "Honeycomb Structure",
                organism: "Honeybee (Apis mellifera)",
                category: .structural,
                principle: "Hexagonal tessellation maximizes structural strength while minimizing material usage. Each cell shares walls with neighbors, distributing load efficiently across the entire structure.",
                scientificBacking: "Studies show honeycomb structures achieve up to 90% weight reduction compared to solid materials while maintaining comparable strength. The 120-degree angles create optimal stress distribution.",
                realWorldApplications: [
                    "Aircraft fuselage panels",
                    "Satellite structures",
                    "Packaging materials",
                    "Architectural facades"
                ],
                recommendedAlgorithm: .voronoiMutation,
                defaultComplexity: 0.6,
                defaultDensity: 0.7,
                defaultOrganicBias: 0.3,
                strengthRating: 0.95,
                efficiencyRating: 0.92
            ),

            NatureSolution(
                id: "trabecular-bone",
                name: "Trabecular Bone",
                organism: "Mammalian skeletal system",
                category: .structural,
                principle: "Spongy bone tissue forms an adaptive lattice that responds to mechanical stress. Trabeculae align along principal stress directions, creating load paths where needed most.",
                scientificBacking: "Wolff's Law describes how bone remodels in response to mechanical loading. This principle has inspired topology optimization algorithms used in modern engineering.",
                realWorldApplications: [
                    "3D-printed implants",
                    "Lightweight aerospace brackets",
                    "Topology-optimized components",
                    "Building structures"
                ],
                recommendedAlgorithm: .noiseField,
                defaultComplexity: 0.5,
                defaultDensity: 0.6,
                defaultOrganicBias: 0.6,
                strengthRating: 0.88,
                efficiencyRating: 0.85
            ),

            NatureSolution(
                id: "venus-basket",
                name: "Venus Flower Basket",
                organism: "Euplectella aspergillum (glass sponge)",
                category: .structural,
                principle: "Hierarchical silica lattice with diagonal bracing at multiple scales. The structure resists buckling through geometric reinforcement rather than material strength alone.",
                scientificBacking: "Research shows the sponge's lattice design is twice as strong as similar synthetic structures. The diagonal struts prevent localized failure from propagating.",
                realWorldApplications: [
                    "Bridge support structures",
                    "Tower frameworks",
                    "Seismic-resistant buildings",
                    "Lightweight scaffolding"
                ],
                recommendedAlgorithm: .voronoiMutation,
                defaultComplexity: 0.7,
                defaultDensity: 0.5,
                defaultOrganicBias: 0.4,
                strengthRating: 0.92,
                efficiencyRating: 0.88
            ),

            // FLUID FLOW SOLUTIONS
            NatureSolution(
                id: "vascular-network",
                name: "Vascular Network",
                organism: "Trees and plants",
                category: .fluidFlow,
                principle: "Murray's Law describes optimal branching where parent vessel radius cubed equals sum of child radii cubed. This minimizes pumping energy while maintaining flow rates.",
                scientificBacking: "Biological vascular systems evolved over millions of years to optimize fluid transport. Murray's Law has been validated across species from trees to mammals.",
                realWorldApplications: [
                    "Microfluidic chips",
                    "Cooling system design",
                    "Water distribution networks",
                    "Blood vessel scaffolds"
                ],
                recommendedAlgorithm: .randomLSystem,
                defaultComplexity: 0.6,
                defaultDensity: 0.5,
                defaultOrganicBias: 0.8,
                strengthRating: 0.70,
                efficiencyRating: 0.95
            ),

            NatureSolution(
                id: "termite-mound",
                name: "Termite Mound Ventilation",
                organism: "Macrotermes termites",
                category: .fluidFlow,
                principle: "Complex internal channels create passive ventilation through convection. Daily temperature cycles drive air circulation without any mechanical components.",
                scientificBacking: "Termite mounds maintain 30-32°C internally despite 40°C external swings. The Eastgate Centre in Zimbabwe uses this principle to reduce AC energy by 90%.",
                realWorldApplications: [
                    "Passive building ventilation",
                    "Data center cooling",
                    "Underground shelters",
                    "Greenhouse climate control"
                ],
                recommendedAlgorithm: .reactionDiffusion,
                defaultComplexity: 0.7,
                defaultDensity: 0.6,
                defaultOrganicBias: 0.7,
                strengthRating: 0.65,
                efficiencyRating: 0.90
            ),

            NatureSolution(
                id: "lung-bronchi",
                name: "Lung Bronchi",
                organism: "Mammalian respiratory system",
                category: .fluidFlow,
                principle: "Fractal branching pattern increases surface area exponentially while minimizing dead space. Each generation of branches reduces diameter systematically.",
                scientificBacking: "Human lungs pack 70-100 square meters of surface area into 6 liters of volume. The fractal dimension of approximately 2.97 maximizes gas exchange efficiency.",
                realWorldApplications: [
                    "Heat exchangers",
                    "Air filtration systems",
                    "Chemical reactors",
                    "Respiratory devices"
                ],
                recommendedAlgorithm: .randomLSystem,
                defaultComplexity: 0.8,
                defaultDensity: 0.4,
                defaultOrganicBias: 0.9,
                strengthRating: 0.60,
                efficiencyRating: 0.98
            ),

            // SURFACE PROPERTY SOLUTIONS
            NatureSolution(
                id: "gecko-feet",
                name: "Gecko Adhesion",
                organism: "Gecko (Gekkonidae family)",
                category: .surfaceProperties,
                principle: "Millions of microscopic hair-like setae create Van der Waals adhesion. No sticky residue is needed—pure geometry creates the bond that can be released at will.",
                scientificBacking: "Each gecko foot can support 20+ times body weight. The hierarchical structure from setae to spatulae creates self-cleaning, reusable adhesion.",
                realWorldApplications: [
                    "Climbing robots",
                    "Surgical grippers",
                    "Reusable adhesives",
                    "Clean room handling"
                ],
                recommendedAlgorithm: .voronoiMutation,
                defaultComplexity: 0.9,
                defaultDensity: 0.4,
                defaultOrganicBias: 0.5,
                strengthRating: 0.85,
                efficiencyRating: 0.90
            ),

            NatureSolution(
                id: "lotus-leaf",
                name: "Lotus Leaf Surface",
                organism: "Nelumbo nucifera (Sacred Lotus)",
                category: .surfaceProperties,
                principle: "Microscale bumps covered with waxy nanocrystals create superhydrophobicity. Water beads up and rolls off, carrying dirt particles with it.",
                scientificBacking: "Contact angles exceed 150 degrees, causing water to form nearly spherical droplets. The self-cleaning effect requires zero energy input.",
                realWorldApplications: [
                    "Self-cleaning facades",
                    "Anti-fouling coatings",
                    "Waterproof textiles",
                    "Solar panel coatings"
                ],
                recommendedAlgorithm: .noiseField,
                defaultComplexity: 0.8,
                defaultDensity: 0.3,
                defaultOrganicBias: 0.6,
                strengthRating: 0.70,
                efficiencyRating: 0.95
            ),

            NatureSolution(
                id: "shark-skin",
                name: "Shark Skin Denticles",
                organism: "Sharks (Selachimorpha)",
                category: .surfaceProperties,
                principle: "Tiny tooth-like scales called denticles create micro-vortices that reduce drag. The riblet pattern also inhibits bacterial attachment.",
                scientificBacking: "Shark skin can reduce drag by 8-10%. The pattern has been adapted for swimsuits (later banned from competition) and aircraft surfaces.",
                realWorldApplications: [
                    "Aircraft fuselage coatings",
                    "Ship hull treatments",
                    "Hospital surfaces",
                    "Swimming performance gear"
                ],
                recommendedAlgorithm: .noiseField,
                defaultComplexity: 0.7,
                defaultDensity: 0.5,
                defaultOrganicBias: 0.5,
                strengthRating: 0.75,
                efficiencyRating: 0.88
            ),

            // ACOUSTIC/VIBRATION SOLUTIONS
            NatureSolution(
                id: "owl-feathers",
                name: "Owl Silent Flight",
                organism: "Barn Owl (Tyto alba)",
                category: .acousticVibration,
                principle: "Leading edge serrations break up airflow into micro-turbulence, suppressing the sound-producing vortices. Trailing edge fringes further dampen noise.",
                scientificBacking: "Owl flight is nearly silent above 2kHz, the hearing range of prey. The comb-like serrations delay flow separation and reduce aeroacoustic noise.",
                realWorldApplications: [
                    "Wind turbine blade edges",
                    "Quiet fan designs",
                    "Aircraft noise reduction",
                    "HVAC systems"
                ],
                recommendedAlgorithm: .noiseField,
                defaultComplexity: 0.7,
                defaultDensity: 0.5,
                defaultOrganicBias: 0.6,
                strengthRating: 0.65,
                efficiencyRating: 0.92
            ),

            NatureSolution(
                id: "woodpecker-skull",
                name: "Woodpecker Impact Absorption",
                organism: "Woodpecker (Picidae family)",
                category: .acousticVibration,
                principle: "Spongy bone, a unique hyoid bone structure, and asymmetric brain positioning absorb and redirect impact forces. Each peck generates 1000+ g of deceleration.",
                scientificBacking: "Woodpeckers strike at 6-7 m/s, 20 times per second, with no brain damage. The skull's layered structure dissipates energy through multiple mechanisms.",
                realWorldApplications: [
                    "Protective helmets",
                    "Shock absorbers",
                    "Electronics packaging",
                    "Vehicle crumple zones"
                ],
                recommendedAlgorithm: .noiseField,
                defaultComplexity: 0.6,
                defaultDensity: 0.6,
                defaultOrganicBias: 0.5,
                strengthRating: 0.90,
                efficiencyRating: 0.85
            ),

            NatureSolution(
                id: "cicada-wings",
                name: "Cicada Wing Acoustics",
                organism: "Cicada (Cicadoidea)",
                category: .acousticVibration,
                principle: "Microscopic pillars on wing membranes create acoustic interference patterns that dampen specific frequencies. The pillar spacing tunes the absorption spectrum.",
                scientificBacking: "Cicada wing nanopillars are approximately 200nm tall and spaced 170nm apart. This geometry creates broadband sound absorption through destructive interference.",
                realWorldApplications: [
                    "Acoustic panels",
                    "Soundproofing materials",
                    "Speaker enclosures",
                    "Recording studio treatment"
                ],
                recommendedAlgorithm: .reactionDiffusion,
                defaultComplexity: 0.8,
                defaultDensity: 0.5,
                defaultOrganicBias: 0.7,
                strengthRating: 0.60,
                efficiencyRating: 0.88
            )
        ]
    }
}
