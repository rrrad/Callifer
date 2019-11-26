//
//  AppDelegate.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 06.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit
import PushKit
import CallKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {
    var window: UIWindow?
    let voipPush = PKPushRegistry.init(queue: DispatchQueue.main)
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
        
        voipPush.delegate = self
        voipPush.desiredPushTypes = [.voIP]
        
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
    
    
    // MARK: PushKit metods
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // здесь передаются данные изменения состояния на сервер
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
            // берем информацию из push notification playload
            if let uuidString = payload.dictionaryPayload["UUID"] as? String,
            let handle = payload.dictionaryPayload["handle"] as? String,
            let hasVideo = payload.dictionaryPayload["hasVideo"] as? Bool,
            let uuid = UUID(uuidString: uuidString) {
                
                providerDelegate.reportIncomingCall(UUID: uuid, handele: handle, hasVideo: hasVideo) { (err) in
                    // errors??
                }
            }
        }
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

