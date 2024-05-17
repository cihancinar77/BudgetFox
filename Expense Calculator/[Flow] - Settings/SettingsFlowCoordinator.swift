//
//  SettingsFlowCoordinator.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import UIKit

class SettingsFlowCoordinator: FlowCoordination {
    
    private(set) var navigationController = UINavigationController()
    private var viewController: UIViewController?
    
    func start() {
        let viewController = SettingsViewController()
        viewController.view.backgroundColor = .gray
        self.viewController = viewController
        navigationController.viewControllers = [viewController]
        
        navigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape")?.withTintColor(.gray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "gearshape.fill")?.withTintColor(UIColor(named: "Accent1") ?? .yellow, renderingMode: .alwaysOriginal)
        )
    }
}
