import SwiftUI

// MARK: - PastelBackground
struct PastelBackground: View {
    var body: some View {
        ZStack {
            ConcentricRings(radii: [120, 190, 280, 360, 440, 520, 600, 680, 760, 820], baseOpacity: 0.08, lineWidth: 70)
                .foregroundStyle(.white)
                .blendMode(.plusLighter)
                .overlay(
                    ConcentricRings(radii: [120, 190, 280, 360, 440, 520, 600, 680, 760, 820], baseOpacity: 0.1, lineWidth: 2)
                        .foregroundStyle(
                            LinearGradient(colors: [AppTheme.palette.cyan.opacity(0.15), AppTheme.palette.blue.opacity(0.10)], startPoint: .leading, endPoint: .trailing)
                        )
                        .blendMode(.screen)
                )
        }
    }
}

#Preview("Pastel Background") {
    ZStack {
        AppBackgroundGradient()
        PastelBackground()
    }
}
