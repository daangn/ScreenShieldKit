//
//  ViewController.swift
//  Sample
//
//  Created by Ray on 5/12/25.
//

import UIKit

import ScreenShieldKit

final class ViewController: UIViewController {

  private let screenShieldSwitch: UISwitch = {
    let view = UISwitch()
    return view
  }()

  private let redView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemRed
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    setupUI()
    addTargets()
  }

  private func setupUI() {
    view.addSubview(screenShieldSwitch)
    view.addSubview(redView)

    screenShieldSwitch.translatesAutoresizingMaskIntoConstraints = false
    redView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      screenShieldSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
      screenShieldSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      redView.topAnchor.constraint(equalTo: screenShieldSwitch.bottomAnchor, constant: 20),
      redView.widthAnchor.constraint(equalToConstant: 200),
      redView.heightAnchor.constraint(equalToConstant: 200),
      redView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])

  }

  private func addTargets() {
    screenShieldSwitch.addTarget(
      self,
      action: #selector(screenShieldSwitchValueChanged(_:)),
      for: .valueChanged
    )
  }

  @objc
  private func screenShieldSwitchValueChanged(_ sender: UISwitch) {
    redView.setScreenShield(enabled: sender.isOn)
  }
}
