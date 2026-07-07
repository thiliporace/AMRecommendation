//
//  AppCoordinator.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

@MainActor
final class AppCoordinator: CoordinatorProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
}
