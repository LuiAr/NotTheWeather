//
//  GlassCard.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.6),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }
}

struct GlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.6, blue: 1.0),
                    Color(red: 0.6, green: 0.8, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Animated orbs for depth
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 50)
                .offset(x: -100, y: -200)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.2), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(width: 250, height: 250)
                .blur(radius: 40)
                .offset(x: 150, y: 300)
        }
    }
}

#Preview {
    ZStack {
        GlassBackground()

        GlassCard {
            VStack {
                Text("Glass Card")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Beautiful liquid glass effect")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
