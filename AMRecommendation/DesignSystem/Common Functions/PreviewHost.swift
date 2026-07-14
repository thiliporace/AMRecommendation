//
//  PreviewHost.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 13/07/26.
//

import Foundation
import UIKit

/// This function will be used by all Previews in order to change the ViewController's User Interface Style
@MainActor
func previewHost(_ style: UIUserInterfaceStyle, _ make: () -> UIView) -> UIViewController {
    let viewController = UIViewController()
    viewController.overrideUserInterfaceStyle = style
    viewController.view.backgroundColor = .systemBackground
    let view = make()
    view.translatesAutoresizingMaskIntoConstraints = false
    viewController.view.addSubview(view)
    NSLayoutConstraint.activate([
        view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
        view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
    ])
    return viewController
}

