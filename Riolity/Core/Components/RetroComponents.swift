import SwiftUI

// Terminal-style text
struct TerminalText: View {
    let text: String
    var size: CGFloat = 14
    var color: Color = RetroTheme.primaryGreen

    var body: some View {
        Text(text)
            .font(RetroTheme.terminalFont(size))
            .foregroundColor(color)
    }
}

// Header text with glow
struct RetroHeader: View {
    let text: String
    var size: CGFloat = 24

    var body: some View {
        Text(text)
            .font(RetroTheme.headerFont(size))
            .foregroundColor(RetroTheme.primaryGreen)
            .retroGlow(radius: 8)
    }
}

// Retro-styled button
struct RetroButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: RetroTheme.background))
                        .scaleEffect(0.8)
                } else {
                    Text("[ \(title) ]")
                        .font(RetroTheme.terminalFont(16))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .foregroundColor(isPressed ? RetroTheme.background : RetroTheme.primaryGreen)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isPressed ? RetroTheme.primaryGreen : Color.clear)
            )
            .retroBorder()
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .retroGlow(radius: isPressed ? 15 : 5)
    }
}

// Secondary button style
struct RetroSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDisabled: Bool = false

    init(title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                TerminalText(text: title, size: 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .retroBorder(color: isDisabled ? RetroTheme.darkGreen : RetroTheme.dimGreen)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

// Progress bar
struct RetroProgressBar: View {
    let progress: Double
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TerminalText(text: label, size: 12, color: RetroTheme.dimGreen)
                Spacer()
                TerminalText(text: "\(Int(progress * 100))%", size: 12)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(RetroTheme.darkGreen)
                        .frame(height: 8)

                    Rectangle()
                        .fill(RetroTheme.primaryGreen)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .retroGlow(radius: 4)
                }
            }
            .frame(height: 8)
            .retroBorder()
        }
    }
}

// Info card for biomimicry details
struct RetroInfoCard: View {
    let title: String
    let content: String
    var icon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(RetroTheme.primaryGreen)
                        .font(.system(size: 14))
                }
                TerminalText(text: title.uppercased(), size: 12, color: RetroTheme.dimGreen)
            }

            TerminalText(text: content, size: 14)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RetroTheme.darkGreen.opacity(0.3))
        .retroBorder(color: RetroTheme.dimGreen)
    }
}

// Animated typing text effect
struct TypewriterText: View {
    let text: String
    @State private var displayedText = ""
    @State private var currentIndex = 0

    var body: some View {
        TerminalText(text: displayedText + (currentIndex < text.count ? "_" : ""))
            .onAppear {
                startTyping()
            }
    }

    private func startTyping() {
        displayedText = ""
        currentIndex = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText += String(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// Step indicator for wizard flow
struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    let stepTitles: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                HStack(spacing: 4) {
                    Circle()
                        .fill(index <= currentStep ? RetroTheme.primaryGreen : RetroTheme.darkGreen)
                        .frame(width: 8, height: 8)
                        .retroGlow(radius: index == currentStep ? 6 : 0)

                    if index < stepTitles.count {
                        TerminalText(
                            text: stepTitles[index],
                            size: 10,
                            color: index <= currentStep ? RetroTheme.primaryGreen : RetroTheme.dimGreen
                        )
                    }
                }

                if index < totalSteps - 1 {
                    Rectangle()
                        .fill(index < currentStep ? RetroTheme.primaryGreen : RetroTheme.darkGreen)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
    }
}

// Category card for problem selection
struct ProblemCategoryCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(RetroTheme.primaryGreen)
                        .retroGlow(radius: isSelected ? 10 : 5)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(RetroTheme.primaryGreen)
                            .retroGlow(radius: 5)
                    }
                }

                TerminalText(text: title.uppercased(), size: 14)
                TerminalText(text: description, size: 11, color: RetroTheme.dimGreen)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? RetroTheme.darkGreen.opacity(0.5) : Color.clear)
            .retroBorder(color: isSelected ? RetroTheme.primaryGreen : RetroTheme.dimGreen)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Nature solution card
struct NatureSolutionCard: View {
    let title: String
    let organism: String
    let principle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        TerminalText(text: title.uppercased(), size: 14)
                        TerminalText(text: "Source: \(organism)", size: 11, color: RetroTheme.dimGreen)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(RetroTheme.primaryGreen)
                            .retroGlow(radius: 5)
                    }
                }

                TerminalText(text: principle, size: 12, color: RetroTheme.dimGreen)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? RetroTheme.darkGreen.opacity(0.5) : Color.clear)
            .retroBorder(color: isSelected ? RetroTheme.primaryGreen : RetroTheme.dimGreen)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
