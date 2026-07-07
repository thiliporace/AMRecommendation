//
//  LoginCoordinator.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

@MainActor
final class LoginCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel(loginCoordinator: self)
        
        let viewController = LoginViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func navigateToMainApp(){
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        
        mainTabCoordinator.start()
    }
}
