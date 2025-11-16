import SwiftUI

// Reusable gradient background used across views
struct AppBackgroundGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                AppTheme.palette.darkBase,
                AppTheme.palette.darkElevated
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay(
            RadialGradient(
                colors: [
                    AppTheme.palette.cyan.opacity(0.35),
                    AppTheme.palette.blue.opacity(0.25),
                    Color.clear
                ],
                center: .center,
                startRadius: 10,
                endRadius: 500
            )
            .blendMode(.plusLighter)
            .ignoresSafeArea()
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview("App Background Gradient") {
    AppBackgroundGradient()
}
