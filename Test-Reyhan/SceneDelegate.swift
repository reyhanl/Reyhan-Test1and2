//
//  SceneDelegate.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var windowScene: UIWindowScene?
    var launchArgument: LaunchArgument?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.windowScene = windowScene
        do{
            let _ = try UserManager.shared.fetchUser()
        }catch{
            UserManager.shared.makeNewUser()
        }
        
        let args = ProcessInfo.processInfo.arguments
        if args.contains("TestTransactionModal") {
            UserDefaults.standard.setValue("yes", forKey: "testing")
            launchArgument = .TransactionModal
            self.presentTransactionModal()
        }else if args.contains("TestPromoViewController"){
            UserDefaults.standard.setValue("yes", forKey: "testing")
            launchArgument = .promoViewController
            FirebaseApp.configure()
            setupRemoteConfig()
        }else if args.contains("TestTransactionSuccess"){
            UserDefaults.standard.setValue("yes", forKey: "testing")
            launchArgument = .promoViewController
            self.presentTransactionModalWithSuccess()
        }else{
            UserDefaults.standard.setValue(nil, forKey: "testing")
            FirebaseApp.configure()
            setupRemoteConfig()
        }
        
        //UserDetauls with key testing is used to isolate the coredata when needed (check CoreDataStack code)
    }
    
    private func setupRemoteConfig() {
        // Interval 1 day if prod. Otherwise 0.
        let prod = false
        let interval: TimeInterval = prod ? (60 * 60 * 24 * 1) : 0
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = interval
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch(withExpirationDuration: interval) { (status, error) in
            if status == .success {
                print("Config fetched!")
                remoteConfig.activate { success, error in
                    guard error == nil,
                          let value = remoteConfig.configValue(forKey: RemoteConfigModel.CodingKeys.key.rawValue).stringValue else{
                        print(error?.localizedDescription)
                        return
                    }
                    self.addToken(token: value)
                    DispatchQueue.main.async {
                        switch self.launchArgument {
                        case .TransactionModal:
                            self.presentTransactionModal()
                        case .promoViewController:
                            break
                        case nil:
                            self.presentMainVC()
                        }
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func presentMainVC(){
        guard let windowScene = windowScene else{return}
        let vc = HomeRouter.makeComponent()
        let navigationController = CustomNavigationController(rootViewController: vc)
        let homeTabBarItem = UITabBarItem(title: "QR", image: UIImage.init(systemName: "qrcode"), selectedImage: UIImage.init(systemName: "qrcode"))
        vc.tabBarItem = homeTabBarItem
        
        let promoVC = PromoRouter.makeComponent()
        let promoNavigationController = CustomNavigationController(rootViewController: promoVC)
        let promoTabBarItem = UITabBarItem(title: "Promos", image: UIImage.init(systemName: "ticket"), selectedImage: UIImage.init(systemName: "ticket.fill"))
        promoTabBarItem.accessibilityIdentifier = "promoTabBar"
        promoVC.tabBarItem = promoTabBarItem
        
        let tabBar = UITabBarController()
        tabBar.overrideUserInterfaceStyle = .dark
        tabBar.addChild(navigationController)
        tabBar.addChild(promoNavigationController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    func presentTransactionModal(){
        guard let windowScene = windowScene else{return}
        let vc = UIViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let transactionModalVC = TransactionModalVC()
        transactionModalVC.modalPresentationStyle = .overCurrentContext
        transactionModalVC.setupUI(transaction: 
                .init(bank: "FakeBank",
                      transactionID: "123456789",
                      merchant: "FakeMerchant",
                      transactionTotal: 2000,
                      date: ""), user: .init(balance: 1999))
        vc.present(transactionModalVC, animated: true)
    }
    
    func presentTransactionModalWithSuccess(){
        guard let windowScene = windowScene else{return}
        let vc = UIViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let transactionModalVC = TransactionModalVC()
        transactionModalVC.modalPresentationStyle = .overCurrentContext
        transactionModalVC.setupUI(transaction:
                .init(bank: "FakeBank",
                      transactionID: "123456789",
                      merchant: "FakeMerchant",
                      transactionTotal: 2000,
                      date: ""), user: .init(balance: 2500))
        vc.present(transactionModalVC, animated: true)
    }
    
    func addToken(token: String){
        UserDefaults.standard.setValue(token, forKey: tokenKey)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

let tokenKey = "token"

enum LaunchArgument: String{
    case TransactionModal = "TestTransactionModal"
    case promoViewController = "promoViewController"
}
