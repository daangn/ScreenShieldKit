//
//  ScreenShieldBridge.swift
//  ScreenShieldKit
//
//  Created by Kanghoon Oh on 7/12/26.
//
//  Legacy fallback used below the OS versions that ship SwiftUI's native capture-redaction reason
//  (iOS 18 / macOS 15 / tvOS 18 / visionOS 2). It hosts the SwiftUI content inside a platform hosting
//  controller and applies the Core Animation capture flag (`CALayer.setScreenShield(enabled:)`) to
//  the backing layer.
//
//  Identity note: the hosting container is always present regardless of `isProtected`. Only the layer
//  flag is toggled in the update pass, so switching protection on/off never tears down and rebuilds
//  the hosted content (which would reset its state).
//

#if canImport(SwiftUI)
import SwiftUI

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit

/// Bridges SwiftUI content to a `UIHostingController` whose layer carries the capture flag.
///
/// SwiftUI keeps propagating the ancestor environment across this representable-managed hosting
/// controller, so `@Environment` values (including custom `EnvironmentKey`s) and `@EnvironmentObject`
/// dependencies reach the hosted content without any manual forwarding.
@available(iOS 16.0, tvOS 16.0, visionOS 1.0, *)
struct ScreenShieldBridge<Content: View>: View {
  let isProtected: Bool
  let content: Content

  init(isProtected: Bool, content: Content) {
    self.isProtected = isProtected
    self.content = content
  }

  var body: some View {
    ScreenShieldHostingController(isProtected: isProtected) {
      content
    }
  }
}

@available(iOS 16.0, tvOS 16.0, visionOS 1.0, *)
private struct ScreenShieldHostingController<Content: View>: UIViewControllerRepresentable {
  let isProtected: Bool
  let content: Content

  init(isProtected: Bool, @ViewBuilder content: () -> Content) {
    self.isProtected = isProtected
    self.content = content()
  }

  func makeUIViewController(context: Context) -> UIHostingController<Content> {
    let controller = UIHostingController(rootView: content)
    controller.view.backgroundColor = .clear
    controller.view.layer.setScreenShield(enabled: isProtected)
    return controller
  }

  func updateUIViewController(_ controller: UIHostingController<Content>, context: Context) {
    controller.rootView = content
    controller.view.layer.setScreenShield(enabled: isProtected)
  }

  /// Size the representable to the hosted SwiftUI content. Relying on `sizingOptions` alone does not
  /// reliably propagate height into the surrounding SwiftUI layout on iOS 16/17, so the size is
  /// resolved explicitly against the proposed width (letting `maxWidth: .infinity` content fill it).
  func sizeThatFits(
    _ proposal: ProposedViewSize,
    uiViewController: UIHostingController<Content>,
    context: Context
  ) -> CGSize? {
    let targetWidth = proposal.width.flatMap { $0.isFinite ? $0 : nil } ?? .greatestFiniteMagnitude
    return uiViewController.sizeThatFits(
      in: CGSize(width: targetWidth, height: .greatestFiniteMagnitude)
    )
  }
}

#elseif os(macOS)
import AppKit

/// Bridges SwiftUI content to an `NSHostingController` whose backing layer carries the capture flag.
///
/// SwiftUI keeps propagating the ancestor environment across this representable-managed hosting
/// controller, so `@Environment` values and `@EnvironmentObject` dependencies reach the hosted
/// content without any manual forwarding.
///
/// - Note: On macOS, layer-level capture hiding is best-effort and may not hide content from every
///   system capture path. Verify on the macOS versions you support.
@available(macOS 13.0, *)
struct ScreenShieldBridge<Content: View>: View {
  let isProtected: Bool
  let content: Content

  init(isProtected: Bool, content: Content) {
    self.isProtected = isProtected
    self.content = content
  }

  var body: some View {
    ScreenShieldHostingController(isProtected: isProtected) {
      content
    }
  }
}

@available(macOS 13.0, *)
private struct ScreenShieldHostingController<Content: View>: NSViewControllerRepresentable {
  let isProtected: Bool
  let content: Content

  init(isProtected: Bool, @ViewBuilder content: () -> Content) {
    self.isProtected = isProtected
    self.content = content()
  }

  func makeNSViewController(context: Context) -> NSHostingController<Content> {
    let controller = NSHostingController(rootView: content)
    controller.view.wantsLayer = true
    controller.view.setScreenShield(enabled: isProtected)
    return controller
  }

  func updateNSViewController(_ controller: NSHostingController<Content>, context: Context) {
    controller.rootView = content
    controller.view.wantsLayer = true
    controller.view.setScreenShield(enabled: isProtected)
  }

  /// Size the representable to the hosted SwiftUI content, resolving against the proposed width so
  /// that `maxWidth: .infinity` content fills it rather than shrink-wrapping.
  func sizeThatFits(
    _ proposal: ProposedViewSize,
    nsViewController: NSHostingController<Content>,
    context: Context
  ) -> CGSize? {
    let targetWidth = proposal.width.flatMap { $0.isFinite ? $0 : nil } ?? .greatestFiniteMagnitude
    return nsViewController.sizeThatFits(
      in: CGSize(width: targetWidth, height: .greatestFiniteMagnitude)
    )
  }
}
#endif
#endif
