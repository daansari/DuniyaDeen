import SwiftUI

struct CapsuleOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white.opacity(configuration.isPressed ? 0.06 : 0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 10, y: 6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview("Capsule Outline Button") {
    ZStack {
        LinearGradient(
            colors: [AppTheme.palette.darkBase, AppTheme.palette.darkElevated],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Button("Preview") {}
            .buttonStyle(CapsuleOutlineButtonStyle())
            .padding(24)
            .frame(maxWidth: 360)
    }
}
