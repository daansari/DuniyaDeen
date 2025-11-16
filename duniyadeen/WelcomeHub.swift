//
//  WelcomeHub.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import SwiftUI
import Combine
#if canImport(CoreMotion)
import CoreMotion
#endif

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

#if canImport(CoreMotion)
final class MotionManager: ObservableObject {
    private let manager = CMMotionManager()
    @Published var roll: Double = 0
    @Published var pitch: Double = 0
    
    private var filteredRoll: Double = 0
    private var filteredPitch: Double = 0
    private let smoothingFactor: Double = 0.12 // lower = smoother

    init() {
        start()
    }

    private func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let m = motion else { return }
            // Low-pass filter to smooth jitter
            let newRoll = m.attitude.roll
            let newPitch = m.attitude.pitch
            self.filteredRoll = self.filteredRoll + self.smoothingFactor * (newRoll - self.filteredRoll)
            self.filteredPitch = self.filteredPitch + self.smoothingFactor * (newPitch - self.filteredPitch)
            self.roll = self.filteredRoll
            self.pitch = self.filteredPitch
        }
    }

    deinit {
        manager.stopDeviceMotionUpdates()
    }
}
#endif

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
            .shadow(color: Color.white.opacity(opacity * 0.5), radius: 20)
    }
}

// MARK: - Themed Button Styles
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

// MARK: - Background
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

// MARK: - WelcomeHub
struct WelcomeHub: View {
#if canImport(CoreMotion)
    @StateObject private var motion = MotionManager()
#endif

    fileprivate func linearGradientView() -> some View {
        return LinearGradient(
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
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                linearGradientView()
                    .frame(width: geo.size.width, height: geo.size.height * 1.25, alignment: .center)
                    .offset(y: -geo.size.height * 0.25)
                
                PastelBackground()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
#if canImport(CoreMotion)
                    // Subtle parallax based on device motion
                    .offset(x: CGFloat(motion.roll) * 20, y: -geo.size.height * 0.15 + CGFloat(motion.pitch) * 20)
                    .rotation3DEffect(.degrees(motion.pitch * 8), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
                    .rotation3DEffect(.degrees(-motion.roll * 8), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                    .animation(.smooth(duration: 0.18), value: motion.pitch)
                    .animation(.smooth(duration: 0.18), value: motion.roll)
#else
                    .offset(y: -geo.size.height * 0.15)
#endif
                    .edgesIgnoringSafeArea(.all)
                
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
                                    endRadius: 100
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
                            .offset(x: CGFloat(motion.roll) * 20, y: CGFloat(motion.pitch) * 20)
                            .rotation3DEffect(.degrees(motion.pitch * 8), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
                            .rotation3DEffect(.degrees(-motion.roll * 8), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                            .animation(.smooth(duration: 0.18), value: motion.pitch)
                            .animation(.smooth(duration: 0.18), value: motion.roll)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .offset(y: -geo.size.height * 0.15)
                .edgesIgnoringSafeArea(.all)
                
                // Bottom actions
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button("Login") {
                            // TODO: handle login
                        }
                        .buttonStyle(CapsuleOutlineButtonStyle())

                        Button(action: {
                            // TODO: handle register
                        }) {
                            Text("Register")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .contentShape(Capsule())
                        }
                        .background(
                            LinearGradient(
                                colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                                startPoint: UnitPoint(x: max(0, min(1, 0.2 + CGFloat(motion.roll) * 0.25)), y: 0.5),
                                endPoint: UnitPoint(x: max(0, min(1, 0.8 + CGFloat(motion.roll) * 0.25)), y: 0.5)
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: AppTheme.palette.accentSecondary.opacity(0.35), radius: 16, y: 8)
                    }

                    Button(action: {
                        // TODO: handle guest flow
                    }) {
                        Text("Continue as Guest")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                                    startPoint: UnitPoint(x: max(0, min(1, 0.3 + CGFloat(motion.roll) * 0.25)), y: 0.5),
                                    endPoint: UnitPoint(x: max(0, min(1, 0.7 + CGFloat(motion.roll) * 0.25)), y: 0.5)
                                )
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, max(geo.safeAreaInsets.bottom, 16) + 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

#Preview {
    WelcomeHub()
}

