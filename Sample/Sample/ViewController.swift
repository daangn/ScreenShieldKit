//
//  ViewController.swift
//  Sample
//
//  Created by Kanghoon Oh on 5/12/25.
//

import ScreenShieldKit
import UIKit

/// Demonstrates ScreenShieldKit's UIKit surface via `UIView.setScreenShield(enabled:)`, driving
/// protection from a switch. Mirrors the SwiftUI demo so both tabs read consistently.
final class ViewController: UIViewController {
  private let protectSwitch = UISwitch()

  private let balanceCard = GradientCardView()

  private let balanceTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Account balance"
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = UIColor.white.withAlphaComponent(0.8)
    return label
  }()

  private let balanceValueLabel: UILabel = {
    let label = UILabel()
    label.text = "$ 128,400.00"
    label.font = .systemFont(ofSize: 34, weight: .bold)
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.6
    return label
  }()

  private let cardNumberContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .secondarySystemBackground
    view.layer.cornerRadius = 12
    view.layer.cornerCurve = .continuous
    return view
  }()

  private let cardNumberLabel: UILabel = {
    let label = UILabel()
    label.text = "1234 5678 9012 3456"
    label.font = .monospacedSystemFont(ofSize: 22, weight: .regular)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "UIKit"
    view.backgroundColor = .systemBackground

    setupUI()
    protectSwitch.isOn = true
    protectSwitch.addTarget(self, action: #selector(protectSwitchChanged(_:)), for: .valueChanged)
    applyProtection(protectSwitch.isOn)
  }

  private func setupUI() {
    let protectLabel = UILabel()
    protectLabel.text = "Protect content"
    protectLabel.font = .preferredFont(forTextStyle: .body)
    protectLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    let protectRow = UIStackView(arrangedSubviews: [protectLabel, protectSwitch])
    protectRow.axis = .horizontal
    protectRow.alignment = .center

    let cardStack = UIStackView(arrangedSubviews: [balanceTitleLabel, balanceValueLabel])
    cardStack.axis = .vertical
    cardStack.spacing = 6
    cardStack.translatesAutoresizingMaskIntoConstraints = false
    balanceCard.addSubview(cardStack)
    NSLayoutConstraint.activate([
      cardStack.topAnchor.constraint(equalTo: balanceCard.topAnchor, constant: 20),
      cardStack.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 20),
      cardStack.trailingAnchor.constraint(equalTo: balanceCard.trailingAnchor, constant: -20),
      cardStack.bottomAnchor.constraint(equalTo: balanceCard.bottomAnchor, constant: -20),
    ])

    cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    cardNumberContainer.addSubview(cardNumberLabel)
    NSLayoutConstraint.activate([
      cardNumberLabel.topAnchor.constraint(equalTo: cardNumberContainer.topAnchor, constant: 18),
      cardNumberLabel.leadingAnchor.constraint(equalTo: cardNumberContainer.leadingAnchor, constant: 16),
      cardNumberLabel.trailingAnchor.constraint(equalTo: cardNumberContainer.trailingAnchor, constant: -16),
      cardNumberLabel.bottomAnchor.constraint(equalTo: cardNumberContainer.bottomAnchor, constant: -18),
    ])

    let footnote = UILabel()
    footnote.text = "Take a screenshot or start a screen recording. The shielded content is hidden from the capture but stays visible here."
    footnote.font = .preferredFont(forTextStyle: .footnote)
    footnote.textColor = .secondaryLabel
    footnote.numberOfLines = 0

    let mainStack = UIStackView(arrangedSubviews: [
      protectRow,
      makeSection(title: "Balance card (setScreenShield)", content: balanceCard),
      makeSection(title: "Card number (setScreenShield)", content: cardNumberContainer),
      footnote,
    ])
    mainStack.axis = .vertical
    mainStack.spacing = 28
    mainStack.translatesAutoresizingMaskIntoConstraints = false

    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.alwaysBounceVertical = true
    view.addSubview(scrollView)
    scrollView.addSubview(mainStack)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      mainStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
      mainStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
      mainStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
      mainStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
    ])
  }

  private func makeSection(title: String, content: UIView) -> UIStackView {
    let label = UILabel()
    label.text = title
    label.font = .preferredFont(forTextStyle: .subheadline)
    label.textColor = .secondaryLabel

    let stack = UIStackView(arrangedSubviews: [label, content])
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }

  private func applyProtection(_ enabled: Bool) {
    balanceCard.setScreenShield(enabled: enabled)
    cardNumberContainer.setScreenShield(enabled: enabled)
  }

  @objc
  private func protectSwitchChanged(_ sender: UISwitch) {
    applyProtection(sender.isOn)
  }
}

/// A rounded card whose backing layer is a blue → purple gradient.
private final class GradientCardView: UIView {
  override class var layerClass: AnyClass { CAGradientLayer.self }

  private var gradientLayer: CAGradientLayer {
    layer as! CAGradientLayer
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.cornerRadius = 16
    gradientLayer.cornerCurve = .continuous
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
