//
//  SceneDelegate.swift
//  Sample
//
//  Created by Kanghoon Oh on 5/12/25.
//

import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo _: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = makeRootViewController()
    window.makeKeyAndVisible()
    self.window = window
  }

  private func makeRootViewController() -> UIViewController {
    let uikitTab = UINavigationController(rootViewController: ViewController())
    uikitTab.tabBarItem = UITabBarItem(
      title: "UIKit",
      image: UIImage(systemName: "square.dashed"),
      tag: 0
    )

    let swiftuiTab = UINavigationController(
      rootViewController: UIHostingController(rootView: SwiftUIDemoView())
    )
    swiftuiTab.tabBarItem = UITabBarItem(
      title: "SwiftUI",
      image: UIImage(systemName: "swift"),
      tag: 1
    )

    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [uikitTab, swiftuiTab]
    return tabBarController
  }
}
