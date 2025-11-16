//
//  WelcomeHub.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import SwiftUI

// MARK: - Theme & Palette
struct Palette {
    // Colors sampled from the provided image: soft white -> blush pink -> warm cream
    let topWhite = Color.white
    let midBlush = Color(red: 0.97, green: 0.85, blue: 0.94)   // light pink haze
    let warmCream = Color(red: 1.00, green: 0.97, blue: 0.88)  // warm pastel near bottom

    // Accent pinks used for the central badge/rings tint if needed
    let accentPink = Color(red: 0.91, green: 0.36, blue: 0.62)
    let accentPinkDark = Color(red: 0.78, green: 0.23, blue: 0.52)
}

struct Theme {
    let palette = Palette()
}

// Shared app theme instance (can be moved to an Environment later)
private let AppTheme = Theme()

// MARK: - Shared UI
struct ConcentricRings: View {
    var radii: [CGFloat] = [40, 75, 100]
    var baseOpacity: Double = 0.10
    var lineWidth: CGFloat = 60

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
        max(baseOpacity - Double(index) * 0.03, 0.01)
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
            .shadow(color: Color.white.opacity(opacity * 0.8), radius: 20)
    }
}

// MARK: - Background
struct PastelBackground: View {
    var body: some View {
        ZStack {
            // Vertical gradient from white (top) -> blush (mid) -> warm cream (bottom)
            LinearGradient(
                colors: [
                    AppTheme.palette.topWhite,
                    AppTheme.palette.midBlush.opacity(0.85),
                    AppTheme.palette.warmCream
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Subtle concentric rings around center, very low opacity to mimic the image
            ConcentricRings()
                .blendMode(.plusLighter)
        }
    }
}

// MARK: - WelcomeHub
struct WelcomeHub: View {
    var body: some View {
        ZStack {
            PastelBackground()

            // Placeholder foreground content – replace with your hub UI
            VStack(spacing: 16) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppTheme.palette.accentPink, AppTheme.palette.accentPinkDark],
                            center: .center,
                            startRadius: 2,
                            endRadius: 60
                        )
                    )
                    .frame(width: 88, height: 88)
                    .overlay {
                        Text("c")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                    }
                    .shadow(color: AppTheme.palette.accentPink.opacity(0.25), radius: 24, y: 8)
            }
        }
    }
}

#Preview {
    WelcomeHub()
}
