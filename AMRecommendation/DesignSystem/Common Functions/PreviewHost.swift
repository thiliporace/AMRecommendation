//
//  PreviewHost.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 13/07/26.
//

import Foundation
import UIKit

#if DEBUG
/// This function will be used by all Previews in order to change the ViewController's User Interface Style
enum PreviewHost {
    @MainActor
    static func previewHost(_ style: UIUserInterfaceStyle,
                            contentSizeCategory: UIContentSizeCategory = .unspecified,
                            fillWidth: Bool = false,
                            _ make: () -> UIView) -> UIViewController {
        let viewController = UIViewController()
        viewController.overrideUserInterfaceStyle = style
        viewController.view.backgroundColor = .systemBackground

        /// Force a Dynamic Type size so previews can exercise the largest text without changing device settings
        if contentSizeCategory != .unspecified, #available(iOS 17.0, *) {
            viewController.traitOverrides.preferredContentSizeCategory = contentSizeCategory
        }
        let view = make()
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)

        let safeArea = viewController.view.safeAreaLayoutGuide
        if fillWidth {
            /// Full-width components (e.g. the tab bar) let the container own their width:
            /// pin them edge to edge so they stretch to the screen instead of hugging content.
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                view.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            ])
        } else {
            /// Hug-content components (buttons, segmented control) size to their intrinsic width and centre.
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            ])
        }
        return viewController
    }
}
#endif
