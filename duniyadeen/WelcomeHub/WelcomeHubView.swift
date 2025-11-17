//
//  WelcomeHub.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import SwiftUI
import Combine
import CoreMotion

// MARK: - WelcomeHub
struct WelcomeHubView: View {
    @StateObject private var store = WelcomeHubStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                    AppBackgroundGradient()
                        .frame(width: geo.size.width, height: geo.size.height * 1.14, alignment: .center)
                        .offset(y: -geo.size.height * 0.07)
                    
                    ConcentricRings()
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
    #if canImport(CoreMotion)
                        // Subtle parallax based on device motion
//                        .offset(x: CGFloat(store.state.roll) * 20, y: -geo.size.height * 0.15 + CGFloat(store.state.pitch) * 20)
                        .rotation3DEffect(.degrees(store.state.pitch * 8), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
                        .rotation3DEffect(.degrees(-store.state.roll * 8), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                        .animation(.smooth(duration: 0.18), value: store.state.pitch)
                        .animation(.smooth(duration: 0.18), value: store.state.roll)
                        .offset(y: -geo.size.height * 0.07)
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
//                                .shadow(color: Color.black.opacity(0.25), radius: 14, y: 6)
//                                .offset(x: CGFloat(store.state.roll) * 20, y: CGFloat(store.state.pitch) * 20)
                                .rotation3DEffect(.degrees(store.state.pitch * 8), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
                                .rotation3DEffect(.degrees(-store.state.roll * 8), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                                .animation(.smooth(duration: 0.18), value: store.state.pitch)
                                .animation(.smooth(duration: 0.18), value: store.state.roll)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .offset(y: -geo.size.height * 0.07)
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
                                    startPoint: UnitPoint(x: max(0, min(1, 0.2 + CGFloat(store.state.roll) * 0.25)), y: 0.5),
                                    endPoint: UnitPoint(x: max(0, min(1, 0.8 + CGFloat(store.state.roll) * 0.25)), y: 0.5)
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: AppTheme.palette.accentSecondary.opacity(0.35), radius: 16, y: 8)
                        }

                        NavigationLink(destination: PermissionView()) {
                            Text("Continue as Guest")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                                        startPoint: UnitPoint(x: max(0, min(1, 0.3 + CGFloat(store.state.roll) * 0.25)), y: 0.5),
                                        endPoint: UnitPoint(x: max(0, min(1, 0.7 + CGFloat(store.state.roll) * 0.25)), y: 0.5)
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
                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 16))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            store.send(.scenePhaseChanged(newPhase))
        }
        .onAppear { store.send(.onAppear) }
        .onDisappear { store.send(.onDisappear) }
    }
}

#Preview {
    WelcomeHubView()
}
