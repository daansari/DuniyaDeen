import SwiftUI

// MARK: - PastelBackground
struct ConcentricRings: View {
    var body: some View {
        ZStack {
            ConcentricRing(radii: [120, 192, 295, 405], baseOpacity: 0.09, lineWidth: 70)
                .foregroundStyle(.white)
                .blendMode(.plusLighter)
                .overlay(
                    ConcentricRing(radii: [120, 192, 295, 405], baseOpacity: 0.15, lineWidth: 2)
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
        ConcentricRings()
    }
}
