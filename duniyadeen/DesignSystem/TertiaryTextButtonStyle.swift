import SwiftUI

struct TertiaryTextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

#Preview("Tertiary Text Button") {
    ZStack {
        LinearGradient(
            colors: [AppTheme.palette.darkBase, AppTheme.palette.darkElevated],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Button("Preview") {}
            .buttonStyle(TertiaryTextButtonStyle())
            .padding(24)
            .frame(maxWidth: 360)
    }
}
