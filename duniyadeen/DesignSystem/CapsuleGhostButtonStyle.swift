import SwiftUI

struct CapsuleGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundStyle(Color.white.opacity(0.9))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white.opacity(configuration.isPressed ? 0.05 : 0.04))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 6, y: 3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview("Capsule Ghost Button") {
    ZStack {
        LinearGradient(
            colors: [AppTheme.palette.darkBase, AppTheme.palette.darkElevated],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Button("Preview") {}
            .buttonStyle(CapsuleGhostButtonStyle())
            .padding(24)
            .frame(maxWidth: 360)
    }
}
