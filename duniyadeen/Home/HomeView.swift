//
//  HomeView.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 17/11/25.
//

import SwiftUI
//#if canImport(UIKit)
//import UIKit
//#endif

struct HomeView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HeaderView(topInset: geo.safeAreaInsets.top)
                    .frame(height: 260 + geo.safeAreaInsets.top)
                    .clipShape(
                        UnevenRoundedRectangle(
                            cornerRadii: .init(
                                topLeading: 0,
                                bottomLeading: 28, bottomTrailing: 28, topTrailing: 0
                            )
                        )
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 6)
                    .ignoresSafeArea(edges: .top)
                // Breathing space for future controls that sit on the header edge
//                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 16))
                
                // Placeholder content; we'll build the rest next
                Spacer()
            }
        }
    }
}

private struct HeaderView: View {
    var topInset: CGFloat
    
    var body: some View {
        ZStack {
            HeaderBackground()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NEXT PRAYER")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundStyle(.white.opacity(0.95))
                        
                        Text("Asr")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text("4:41")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                            Text("PM")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .opacity(0.95)
                        }
                        .foregroundStyle(.white)
                        
                        Text("Starts in 1h 10m")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.95))
                        
                        Text("Location · Dubai, UAE")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    
                    Spacer(minLength: 16)
                    
                    HeaderSun(size: 70)
                }
                
                Spacer(minLength: 12)
                
                // Bottom row of pills: Location left, Alerts + Methods right
                HStack(spacing: 16) {
                    HeaderPill(systemImage: "location.fill", title: "Auto location")
                    Spacer(minLength: 0)
                    HeaderPill(systemImage: "bell.fill", title: "Alerts")
                    HeaderPill(systemImage: "link", title: "Methods")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, topInset + 16)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

private struct HeaderSun: View {
    var size: CGFloat = 110
    
    var body: some View {
        Group {
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white.opacity(0.95))
        }
        .frame(width: size, height: size)
        .opacity(0.95)
        .shadow(color: .white.opacity(0.15), radius: 8)
        .accessibilityHidden(true)
    }
}

private struct HeaderPill: View {
    let systemImage: String
    let title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .imageScale(.medium)
                Text(title)
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white.opacity(0.95))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
        }
        .glassEffect(.regular.tint(.white.opacity(0.18)).interactive(), in: .capsule)
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }
}

private struct HeaderBackground: View {
    var body: some View {
        ZStack {
            // Warm orange -> golden gradient (softer tone, no glow)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.00, green: 0.62, blue: 0.28), location: 0.0), // soft orange
                    .init(color: Color(red: 1.00, green: 0.73, blue: 0.36), location: 0.55), // amber
                    .init(color: Color(red: 1.00, green: 0.83, blue: 0.54), location: 1.0)   // pale golden
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle Liquid Glass scrim for better text readability (iOS 26+)
            Rectangle()
                .fill(.clear)
                .glassEffect(
                    .regular.tint(.white.opacity(0.5)).interactive(),
                    in: .rect(cornerRadius: 0)
                )
                .allowsHitTesting(false)
        }
        .compositingGroup()
    }
}

#Preview {
    HomeView()
}
