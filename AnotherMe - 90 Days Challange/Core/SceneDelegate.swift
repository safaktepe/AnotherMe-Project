//
//  SceneDelegate.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 6.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        
        if UserDefaults.standard.hasOnboarded {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController =  storyboard.instantiateViewController(withIdentifier: "ChallangeDoneViewController") as! UIViewController
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
            } else {
            let controller : UIViewController = OnboardingCollectionViewController.instantiate()
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
        }
        
        
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

