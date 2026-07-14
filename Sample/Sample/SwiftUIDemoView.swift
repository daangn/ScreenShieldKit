//
//  SwiftUIDemoView.swift
//  Sample
//
//  Created by Kanghoon Oh on 7/12/26.
//

import ScreenShieldKit
import SwiftUI

/// Demonstrates ScreenShieldKit's SwiftUI surface: the ``View/screenShield(_:)`` modifier applied to
/// both a composed card and inline text, with dynamic on/off protection driven by `@State`.
///
/// Take a screenshot or start a screen recording while `Protect content` is on: the shielded views
/// disappear from the capture while staying visible on the device.
struct SwiftUIDemoView: View {
  @State private var isProtected = true

  var body: some View {
    ScrollView {
      VStack(spacing: 28) {
        Toggle("Protect content", isOn: $isProtected)

        // 1) Modifier on a composed view.
        VStack(alignment: .leading, spacing: 8) {
          sectionTitle(".screenShield(_:) on a card")
          balanceCard
            .screenShield(isProtected)
        }

        // 2) Modifier on inline text.
        VStack(alignment: .leading, spacing: 8) {
          sectionTitle(".screenShield(_:) on inline text")
          Text("1234 5678 9012 3456")
            .font(.system(.title3, design: .monospaced))
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.12)))
            .screenShield(isProtected)
        }

        Text(
          "Take a screenshot or start a screen recording. The shielded content is hidden from the capture but stays visible here. Toggling protection keeps the views' state intact."
        )
        .font(.footnote)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
    }
    .navigationTitle("SwiftUI")
  }

  private func sectionTitle(_ text: String) -> some View {
    Text(text)
      .font(.subheadline.weight(.semibold))
      .foregroundColor(.secondary)
  }

  private var balanceCard: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("Account balance")
        .font(.caption)
        .foregroundColor(.white.opacity(0.8))
      Text("$ 128,400.00")
        .font(.largeTitle.bold())
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(LinearGradient(
          colors: [.blue, .purple],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ))
    )
  }
}

#Preview {
  NavigationView {
    SwiftUIDemoView()
  }
}
