import SwiftUI

struct CapsuleFillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .clipShape(Capsule())
            .shadow(color: AppTheme.palette.accentSecondary.opacity(0.35), radius: 16, y: 8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview("Capsule Fill Button") {
    ZStack {
        LinearGradient(
            colors: [AppTheme.palette.darkBase, AppTheme.palette.darkElevated],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Button("Preview") {}
            .buttonStyle(CapsuleFillButtonStyle())
            .padding(24)
            .frame(maxWidth: 360)
    }
}
