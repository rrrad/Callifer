//
//  AppDelegate.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 06.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let callManager = CallManager()
    var providerDelegate: ProviderDelegate!
    var contactAuth: Bool = false
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // проверить авторизацию приложения в контактах
        ContactAuthorizer().contactAuth { [weak self] (res) in
            if res {
                self?.contactAuth = true
            } 
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (_, _) in
            
        }
        
        providerDelegate = ProviderDelegate.init(callManager: callManager)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        
        let nav = UINavigationController.init(rootViewController: GroupeListViewController())
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
        return true
    }
    
    func displayIncommingCall(UUID: UUID,
                              handele: String,
                              hasVideo: Bool,
                              complition: ((Error?) -> Void)?
    ) { providerDelegate.reportIncomingCall(UUID: UUID,
                                            handele: handele,
                                            hasVideo: hasVideo,
                                            complition: complition)
    }

    // MARK: UISceneSession Lifecycle
@available(iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
@available(iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

