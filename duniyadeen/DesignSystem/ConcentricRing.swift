import SwiftUI

// MARK: - ConcentricRings
struct ConcentricRing: View {
    var radii: [CGFloat] = []
    var baseOpacity: Double = 0.10
    var lineWidth: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(Array(radii.enumerated()), id: \.offset) { index, radius in
                ring(radius: radius, opacity: opacity(for: index))
            }
        }
        .allowsHitTesting(false)
    }

    private func opacity(for index: Int) -> Double {
        // Fade each subsequent ring slightly
        max(baseOpacity - Double(index) * 0.05, 0.01)
    }

    private func ring(radius: CGFloat, opacity: Double) -> some View {
        Circle()
            .strokeBorder(
                LinearGradient(
                    colors: [Color.white.opacity(opacity), Color.clear],
                    startPoint: .center,
                    endPoint: .bottom
                ),
                lineWidth: lineWidth
            )
            .frame(width: radius * 2, height: radius * 2)
            .foregroundStyle(Color.white.opacity(opacity))
            .shadow(color: Color.white.opacity(opacity * 0.5), radius: 20)
    }
}

#Preview("Concentric Rings") {
    ZStack {
        AppBackgroundGradient()
        ConcentricRing(
            radii: [120],
            baseOpacity: 0.08,
            lineWidth: 70
        )
    }
}
