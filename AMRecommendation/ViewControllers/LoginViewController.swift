//
//  LoginViewController.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel

    /// In Combine, a subscription only stays alive as long as the AnyCancellable returned by .sink exists.
    /// If you don't store it, the subscription dies the exact millisecond viewDidLoad() finishes executing.
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loginState
            /// If your ViewModel accidentally sends .loading twice in a row,
            /// .removeDuplicates() intercepts the second one and drops it.
            .removeDuplicates()
            /// This is where the values are consumed and acted upon.
            /// self?.render(state): Every time a new unique state (like .loading, .success, or .error)
            /// flows down the pipeline, this calls your render method to update the screen
            .sink { [weak self] state in
                self?.render(state)
            }
            /// This appends the subscription token into your cancellables set,
            /// keeping the pipeline active and listening.
            .store(in: &cancellables)
    }

    /// Single entry point for reflecting login state in the UI. Every branch must leave the
    /// screen in a complete state, since states do not arrive in a guaranteed order.
    private func render(_ state: LoginStateEnum) {
        switch state {
        case .idle:
            break
        case .loading:
            break
        case .success:
            break
        case .error:
            break
        }
    }
}
