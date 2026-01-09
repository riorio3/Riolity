# Riolity

**AI-Powered Biomimicry Design Engine**

> *"Nature has already solved the problems we're trying to solve."* — Janine Benyus

Riolity bridges the gap between human imagination and physical creation. Describe what you need in plain language, and Riolity leverages AI combined with billions of years of nature's R&D to generate functional, 3D-printable designs.

---

## Vision

The stealth bomber wasn't designed to *look* like a bird—engineers understood *why* certain biological geometries minimize radar signatures and applied those principles to functional aircraft. Riolity brings this same approach to everyone.

**Before Riolity:**
```
Idea → Requires CAD expertise → Requires engineering knowledge → Requires biomimicry research → Maybe a design
```

**With Riolity:**
```
"I need a lightweight wall hook that holds 5kg" → Functional, bio-optimized STL ready to print
```

---

## Core Principles

### 1. Natural Language First
No CAD experience needed. Describe your problem:
- *"Design a phone stand with minimal material"*
- *"Create a vent cover that maximizes airflow"*
- *"I need a grip texture for a tool handle"*

### 2. Nature's Intelligence
Access to comprehensive biomimicry knowledge:
- 3.8 billion years of evolutionary optimization
- Patterns from organisms across all domains of life
- Scientific principles, not surface aesthetics

### 3. Functional Output
Every design is manufacturable:
- Real dimensions and tolerances
- 3D printing constraints considered
- Material recommendations included
- Purpose-built, not procedurally random

### 4. Democratized Creation
Remove barriers between wanting to create and creating:
- No engineering degree required
- No expensive software licenses
- From imagination to physical object

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INPUT                              │
│  "I need a lightweight bracket for my drone's camera mount"    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    AI REASONING ENGINE                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  Intent     │  │  Constraint │  │  Biomimicry Pattern     │ │
│  │  Parser     │  │  Extractor  │  │  Matcher                │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
│                                                                 │
│  Understands: structural load, mounting points, weight limits, │
│  environmental factors, aesthetic preferences                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 BIOMIMICRY KNOWLEDGE BASE                       │
│                                                                 │
│  Structural: Honeycomb, Trabecular Bone, Bird Skulls, Diatoms  │
│  Flow: Murray's Law, Termite Mounds, Lung Bronchi, Leaf Veins  │
│  Surface: Gecko Adhesion, Lotus Effect, Shark Denticles        │
│  Thermal: Penguin Huddles, Termite Ventilation, Desert Beetles │
│  Acoustic: Owl Feathers, Moth Scales, Spider Webs              │
│  + Hundreds more patterns from nature's library                 │
│                                                                 │
│  Each pattern includes:                                         │
│  - Scientific principle (WHY it works)                          │
│  - Mathematical model (HOW to apply it)                         │
│  - Constraints (WHEN to use it)                                 │
│  - Real-world validations (WHERE it's proven)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                PARAMETRIC DESIGN ENGINE                         │
│                                                                 │
│  Base Geometries:          Bio-Pattern Application:            │
│  ├── Brackets              ├── Internal lattice structures     │
│  ├── Mounts                ├── Topology optimization           │
│  ├── Enclosures            ├── Surface texturing               │
│  ├── Channels              ├── Flow path optimization          │
│  ├── Grips                 ├── Load path alignment             │
│  ├── Stands                └── Material distribution           │
│  ├── Hooks                                                      │
│  ├── Covers                                                     │
│  └── Custom forms                                               │
│                                                                 │
│  Real CAD operations:                                           │
│  - Boolean operations (union, subtract, intersect)              │
│  - Filleting and chamfering                                     │
│  - Shell and offset                                             │
│  - Pattern and array                                            │
│  - Loft and sweep                                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                MANUFACTURING OPTIMIZER                          │
│                                                                 │
│  3D Printing Constraints:                                       │
│  - Minimum wall thickness (material-specific)                   │
│  - Maximum overhang angles (45° default)                        │
│  - Support structure requirements                               │
│  - Bridge distances                                             │
│  - Layer adhesion considerations                                │
│                                                                 │
│  Material Recommendations:                                      │
│  - PLA: Easy printing, moderate strength                        │
│  - PETG: Chemical resistance, flexibility                       │
│  - ABS: Heat resistance, post-processing                        │
│  - TPU: Flexibility, impact absorption                          │
│  - Nylon: Strength, wear resistance                             │
│  - Resin: Fine detail, smooth finish                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      OUTPUT                                     │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  3D Preview  │  │  STL Export  │  │  Design Documentation│  │
│  │  (SceneKit)  │  │  (Printable) │  │  (Purpose & Specs)   │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
│                                                                 │
│  "This bone-structure-inspired camera mount uses trabecular    │
│   lattice patterns to achieve 60% weight reduction while       │
│   maintaining structural integrity for loads up to 500g.       │
│   Recommended: PETG at 0.2mm layer height, 30% infill."        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| UI | SwiftUI | Native iOS interface |
| 3D Rendering | SceneKit | Real-time preview |
| AI Reasoning | Claude API | Natural language understanding & design reasoning |
| Knowledge Base | Local JSON + API | Biomimicry patterns & principles |
| Geometry Engine | Custom Swift | Parametric CAD operations |
| Export | STL/OBJ/STEP | Manufacturing-ready output |
| Security | iOS Keychain | Secure API key storage |
| Storage | SwiftData | Local project persistence |

---

## Security

- API keys stored in iOS Keychain (never in code or UserDefaults)
- No sensitive data transmitted without encryption
- Local-first architecture (designs stay on device)
- Optional cloud sync with end-to-end encryption

---

## Project Structure

```
Riolity/
├── App/
│   └── RiolityApp.swift
├── Core/
│   ├── Theme/
│   ├── Components/
│   └── Extensions/
├── Features/
│   ├── Chat/                    # Natural language interface
│   ├── Design/                  # Design generation flow
│   ├── Preview/                 # 3D visualization
│   ├── Export/                  # Manufacturing output
│   └── Projects/                # Saved designs
├── Services/
│   ├── AI/                      # LLM integration
│   │   ├── AIService.swift
│   │   ├── PromptEngine.swift
│   │   └── ResponseParser.swift
│   ├── Biomimicry/              # Knowledge base
│   │   ├── PatternDatabase.swift
│   │   ├── PrincipleEngine.swift
│   │   └── PatternMatcher.swift
│   ├── Geometry/                # CAD operations
│   │   ├── ParametricEngine.swift
│   │   ├── BooleanOps.swift
│   │   ├── MeshGenerator.swift
│   │   └── Templates/
│   ├── Manufacturing/           # Print optimization
│   │   ├── PrintabilityAnalyzer.swift
│   │   ├── SupportGenerator.swift
│   │   └── MaterialRecommender.swift
│   ├── Export/
│   │   ├── STLExporter.swift
│   │   ├── OBJExporter.swift
│   │   └── DocumentGenerator.swift
│   └── Security/
│       ├── KeychainService.swift
│       └── SecureStorage.swift
├── Models/
│   ├── Design/
│   ├── Biomimicry/
│   ├── Geometry/
│   └── Manufacturing/
└── Resources/
    ├── Assets.xcassets
    └── BiomimicryData/
        ├── patterns.json
        ├── principles.json
        └── organisms.json
```

---

## Roadmap

### Phase 1: Foundation ✓
- [x] Project structure
- [x] UI framework (retro terminal aesthetic)
- [x] Basic 3D rendering
- [x] STL export

### Phase 2: AI Integration ✓
- [x] Claude API integration
- [x] Natural language input
- [x] Intent parsing
- [x] Constraint extraction

### Phase 3: Knowledge Base
- [ ] Comprehensive biomimicry database (500+ patterns)
- [ ] Scientific principle modeling
- [ ] Pattern-to-geometry mapping
- [ ] Real-world validation data

### Phase 4: Parametric Engine
- [ ] Base geometry templates
- [ ] Boolean operations
- [ ] Bio-pattern application algorithms
- [ ] Topology optimization

### Phase 5: Manufacturing Intelligence
- [ ] Printability analysis
- [ ] Automatic support detection
- [ ] Material-specific optimization
- [ ] Slicer profile generation

### Phase 6: Advanced Features
- [ ] AR preview (place design in real world)
- [ ] Collaborative design
- [ ] Community pattern library
- [ ] Direct printer integration

---

## Contributing

This project aims to democratize design and manufacturing. Contributions welcome:

- **Biomimicry researchers**: Add patterns and principles
- **Engineers**: Improve geometry algorithms
- **Designers**: Enhance UI/UX
- **Makers**: Test and validate printability

---

## License

MIT License - Build freely, create boldly.

---

## Philosophy

> *"You never change things by fighting the existing reality. To change something, build a new model that makes the existing model obsolete."* — Buckminster Fuller

Riolity doesn't compete with CAD software. It creates a new paradigm where the barrier between imagination and creation dissolves. Where a child can design a functional prosthetic. Where a farmer can create optimized irrigation. Where anyone with an idea can hold it in their hands.

Nature figured this out. We're just translating.

---

**Built with purpose. Designed by nature. Created by you.**
