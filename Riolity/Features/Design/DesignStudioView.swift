import SwiftUI
import SceneKit

struct DesignStudioView: View {
    @EnvironmentObject var flowState: DesignFlowState
    @State private var isRotating = true

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 4) {
                TerminalText(text: "> STEP 3: DESIGN STUDIO", size: 14, color: RetroTheme.dimGreen)

                if let solution = flowState.selectedSolution {
                    TerminalText(text: "Inspired by: \(solution.name)", size: 12)
                }
            }
            .padding(.top, 8)

            // 3D View
            sceneSection
                .padding(.horizontal)
                .padding(.top, 8)

            // Properties display
            if let props = flowState.currentProperties {
                propertiesSection(props)
            }

            // Parameter controls
            parameterControls
                .padding(.horizontal)

            // Action buttons
            actionButtons
                .padding()

            Spacer(minLength: 0)
        }
    }

    private var sceneSection: some View {
        ZStack {
            if flowState.currentMesh != nil {
                SceneKitPreview(flowState: flowState, isRotating: $isRotating)
            } else {
                emptySceneView
            }

            // Overlay controls
            VStack {
                HStack {
                    Spacer()

                    Button(action: { isRotating.toggle() }) {
                        Image(systemName: isRotating ? "pause.circle" : "play.circle")
                            .font(.system(size: 24))
                            .foregroundColor(RetroTheme.primaryGreen)
                            .retroGlow(radius: 5)
                    }
                    .padding(8)
                }

                Spacer()

                if flowState.currentMesh != nil {
                    HStack {
                        if let solution = flowState.selectedSolution {
                            TerminalText(text: solution.recommendedAlgorithm.rawValue.uppercased(), size: 10, color: RetroTheme.dimGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(RetroTheme.background.opacity(0.8))
                                .retroBorder(color: RetroTheme.darkGreen)
                        }

                        Spacer()

                        TerminalText(text: "SEED: \(String(format: "%06d", flowState.currentSeed % 1000000))", size: 10, color: RetroTheme.dimGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(RetroTheme.background.opacity(0.8))
                            .retroBorder(color: RetroTheme.darkGreen)
                    }
                    .padding(8)
                }
            }
        }
        .frame(height: 280)
        .retroBorder()
    }

    private var emptySceneView: some View {
        ZStack {
            RetroTheme.background

            VStack(spacing: 16) {
                Image(systemName: "cube.transparent")
                    .font(.system(size: 50))
                    .foregroundColor(RetroTheme.dimGreen)

                TerminalText(text: "TAP GENERATE TO CREATE", size: 14, color: RetroTheme.dimGreen)
            }
        }
    }

    private func propertiesSection(_ props: StructuralProperties) -> some View {
        HStack(spacing: 12) {
            propertyItem(label: "POROSITY", value: props.porosityPercent)
            propertyItem(label: "S/V RATIO", value: props.surfaceToVolumeFormatted)
            propertyItem(label: "COMPLEXITY", value: props.complexityLevel)
            propertyItem(label: "SYMMETRY", value: String(props.symmetryType.prefix(8)))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func propertyItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            TerminalText(text: label, size: 9, color: RetroTheme.darkGreen)
            TerminalText(text: value, size: 11, color: RetroTheme.primaryGreen)
        }
        .frame(maxWidth: .infinity)
    }

    private var parameterControls: some View {
        VStack(spacing: 8) {
            let labels = flowState.selectedCategory?.parameterLabels ?? (p1: "COMPLEXITY", p2: "DENSITY", p3: "ORGANIC BIAS")

            // Parameter 1
            HStack {
                TerminalText(text: labels.p1, size: 10, color: RetroTheme.dimGreen)
                    .frame(width: 100, alignment: .leading)

                Slider(value: $flowState.complexity, in: 0.1...1.0)
                    .accentColor(RetroTheme.primaryGreen)

                TerminalText(text: String(format: "%.0f%%", flowState.complexity * 100), size: 10)
                    .frame(width: 35, alignment: .trailing)
            }

            // Parameter 2
            HStack {
                TerminalText(text: labels.p2, size: 10, color: RetroTheme.dimGreen)
                    .frame(width: 100, alignment: .leading)

                Slider(value: $flowState.density, in: 0.2...1.0)
                    .accentColor(RetroTheme.primaryGreen)

                TerminalText(text: String(format: "%.0f%%", flowState.density * 100), size: 10)
                    .frame(width: 35, alignment: .trailing)
            }

            // Parameter 3
            HStack {
                TerminalText(text: labels.p3, size: 10, color: RetroTheme.dimGreen)
                    .frame(width: 100, alignment: .leading)

                Slider(value: $flowState.organicBias, in: 0.0...1.0)
                    .accentColor(RetroTheme.primaryGreen)

                TerminalText(text: String(format: "%.0f%%", flowState.organicBias * 100), size: 10)
                    .frame(width: 35, alignment: .trailing)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Regenerate
            RetroSecondaryButton(
                title: "REGENERATE",
                icon: "arrow.clockwise",
                isDisabled: flowState.isGenerating,
                action: { flowState.regenerate() }
            )

            // Main generate button
            RetroButton(
                title: flowState.currentMesh == nil ? "GENERATE" : "NEW SEED",
                action: { flowState.generate() },
                isLoading: flowState.isGenerating
            )

            // Continue to export
            RetroSecondaryButton(
                title: "EXPORT",
                icon: "arrow.right",
                isDisabled: flowState.currentMesh == nil,
                action: { flowState.proceedToExport() }
            )
        }
    }
}

// SceneKit view for 3D preview
struct SceneKitPreview: UIViewRepresentable {
    @ObservedObject var flowState: DesignFlowState
    @Binding var isRotating: Bool

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1)
        scnView.autoenablesDefaultLighting = false
        scnView.allowsCameraControl = true
        scnView.showsStatistics = false

        let scene = SCNScene()
        scnView.scene = scene

        setupCamera(in: scene)
        setupLighting(in: scene)
        addGridFloor(to: scene)

        context.coordinator.scnView = scnView

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(doubleTap)

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        guard let scene = scnView.scene else { return }

        scene.rootNode.childNode(withName: "model", recursively: false)?.removeFromParentNode()

        if let mesh = flowState.currentMesh {
            let geometry = NovelGenerator.shared.generateGeometry(mesh: mesh)
            let modelNode = SCNNode(geometry: geometry)
            modelNode.name = "model"

            if isRotating {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 20)
                let repeatRotation = SCNAction.repeatForever(rotation)
                modelNode.runAction(repeatRotation, forKey: "rotation")
            } else {
                modelNode.removeAction(forKey: "rotation")
            }

            scene.rootNode.addChildNode(modelNode)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func setupCamera(in scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 0.1
        cameraNode.camera?.zFar = 100
        cameraNode.position = SCNVector3(x: 1.5, y: 1.2, z: 1.5)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(cameraNode)
    }

    private func setupLighting(in scene: SCNScene) {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(red: 0, green: 0.3, blue: 0.1, alpha: 1)
        ambientLight.light?.intensity = 500
        scene.rootNode.addChildNode(ambientLight)

        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.color = UIColor(red: 0, green: 1, blue: 0.4, alpha: 1)
        directionalLight.light?.intensity = 800
        directionalLight.position = SCNVector3(5, 10, 5)
        directionalLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(directionalLight)
    }

    private func addGridFloor(to scene: SCNScene) {
        let gridSize: Float = 3.0
        let gridSpacing: Float = 0.2
        let gridColor = UIColor(red: 0, green: 0.3, blue: 0.12, alpha: 0.5)

        for i in stride(from: -gridSize, through: gridSize, by: gridSpacing) {
            let xLine = createLine(
                from: SCNVector3(-gridSize, -0.5, i),
                to: SCNVector3(gridSize, -0.5, i),
                color: gridColor
            )
            scene.rootNode.addChildNode(xLine)

            let zLine = createLine(
                from: SCNVector3(i, -0.5, -gridSize),
                to: SCNVector3(i, -0.5, gridSize),
                color: gridColor
            )
            scene.rootNode.addChildNode(zLine)
        }
    }

    private func createLine(from start: SCNVector3, to end: SCNVector3, color: UIColor) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [start, end])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        let geometry = SCNGeometry(sources: [source], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = color
        geometry.materials = [material]

        return SCNNode(geometry: geometry)
    }

    class Coordinator: NSObject {
        var scnView: SCNView?

        @objc func handleDoubleTap() {
            guard let scnView = scnView else { return }

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5

            scnView.pointOfView?.position = SCNVector3(x: 1.5, y: 1.2, z: 1.5)
            scnView.pointOfView?.look(at: SCNVector3(0, 0, 0))

            SCNTransaction.commit()
        }
    }
}
