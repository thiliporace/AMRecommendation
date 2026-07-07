//
//  LoginViewController.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
