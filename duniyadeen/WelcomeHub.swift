//
//  WelcomeHub.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import SwiftUI

// MARK: - Theme & Palette
struct Palette {
    // Dark base inspired by the logo backdrop
    let darkBase = Color(red: 0.10, green: 0.10, blue: 0.11) // near-black charcoal
    let darkElevated = Color(red: 0.14, green: 0.14, blue: 0.16)

    // Cyan -> Blue gradient inspired by the logo "D"
    let cyan = Color(red: 0.13, green: 0.93, blue: 0.86)     // bright cyan/teal edge
    let teal = Color(red: 0.00, green: 0.73, blue: 0.75)
    let blue = Color(red: 0.06, green: 0.45, blue: 0.86)
    let deepBlue = Color(red: 0.03, green: 0.25, blue: 0.53)

    // Accents for foreground
    let accentPrimary = Color(red: 0.00, green: 0.78, blue: 0.82) // teal
    let accentSecondary = Color(red: 0.06, green: 0.45, blue: 0.86) // blue
}

struct Theme {
    let palette = Palette()
}

// Shared app theme instance (can be moved to an Environment later)
private let AppTheme = Theme()

// MARK: - Shared UI
struct ConcentricRings: View {
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
            .frame(width: radius * 2, height: radius * 2.5)
            .foregroundStyle(Color.white.opacity(opacity))
            .shadow(color: Color.white.opacity(opacity * 0.8), radius: 20)
    }
}

// MARK: - Background
struct PastelBackground: View {
    var body: some View {
        ZStack {
            ConcentricRings(radii: [120, 200, 280, 360, 440, 520], baseOpacity: 0.08, lineWidth: 70)
                .foregroundStyle(.white)
                .blendMode(.plusLighter)
                .overlay(
                    ConcentricRings(radii: [120, 200, 280, 360, 440, 520], baseOpacity: 0.13, lineWidth: 2)
                        .foregroundStyle(
                            LinearGradient(colors: [AppTheme.palette.cyan.opacity(0.15), AppTheme.palette.blue.opacity(0.10)], startPoint: .leading, endPoint: .trailing)
                        )
                        .blendMode(.screen)
                )
        }
    }
}

// MARK: - WelcomeHub
struct WelcomeHub: View {
    var body: some View {
        ZStack {
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
            
            PastelBackground()

            // Placeholder foreground content – replace with your hub UI
            VStack(spacing: 16) {
                ZStack {
                    // Soft glow behind the logo for contrast on dark background
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppTheme.palette.accentPrimary.opacity(0.25), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 120, height: 120)
                        .blur(radius:25)
                        .offset(y: 0)

                    // Logo image
                    Image("AppLogo") // Ensure this asset exists in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .shadow(color: Color.black.opacity(0.25), radius: 14, y: 6)
                }
            }
        }
    }
}

#Preview {
    WelcomeHub()
}

