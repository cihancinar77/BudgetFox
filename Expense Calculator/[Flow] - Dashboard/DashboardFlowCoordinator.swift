//
//  DashboardFlowCoordinator.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 10.05.2024.
//

import UIKit

class DashboardFlowCoordinator: NSObject, FlowCoordination {
  
    private let window: UIWindow
    private let tabBarController = UITabBarController()
    private let coordinator: ApplicationFlowCoordinator
    private var childFlowCoordinators: [FlowCoordination] = []
    
    init(window: UIWindow, coordinator: ApplicationFlowCoordinator) {
        self.window = window
        self.coordinator = coordinator
    }
    
    func start() {
        let expenseListFlowCoordinator = ExpenseListFlowCoordinator()
        childFlowCoordinators.append(expenseListFlowCoordinator)
        
        let settingsFlowCoordinator = SettingsFlowCoordinator()
        childFlowCoordinators.append(settingsFlowCoordinator)
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .gray
        tabBarController.delegate = self
        
        tabBarController.viewControllers = [
            expenseListFlowCoordinator.navigationController,
            settingsFlowCoordinator.navigationController
        ]
        
        //Customizing TabBarView
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.backgroundColor = UIColor.clear
        tabBarController.tabBar.isTranslucent = true
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBarController.tabBar.bounds
        blurEffectView.alpha = 1.0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBarController.tabBar.insertSubview(blurEffectView, at: 0)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(named: "Accent1"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ], for: .normal)
        
        self.window.rootViewController = tabBarController
        
        for coordinator in childFlowCoordinators {
            coordinator.start()
        }
    }
}

extension DashboardFlowCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
