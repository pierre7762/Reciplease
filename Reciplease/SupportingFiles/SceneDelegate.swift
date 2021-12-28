//
//  SceneDelegate.swift
//  Reciplease
//
//  Created by Pierre on 29/10/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "Reciplease")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataStack.saveContext()
    }
}

