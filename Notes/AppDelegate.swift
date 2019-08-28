//
//  AppDelegate.swift
//  Notes
//
//  Created by Мишаня on 26/06/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var container: NSPersistentContainer!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createContainer()
        // Override point for customization after application launch.
        let tabBarController = UITabBarController()
        
        let notesViewController = NotesViewController()
        let notesPresenter = NotesPresenter(view: notesViewController)
        notesViewController.presenter = notesPresenter
        
        notesViewController.title = "Заметки"
        notesViewController.tabBarItem.image = createImage(drawPathMode: .stroke)
        notesViewController.tabBarItem.selectedImage = createImage(drawPathMode: .fill)
        let navigationController = UINavigationController(rootViewController: notesViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        
        let photosVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "PhotosVC") as! PhotosViewController
        photosVC.tabBarItem.image = createImage(drawPathMode: .stroke)
        photosVC.tabBarItem.selectedImage = createImage(drawPathMode: .fill)
        let photosNavController = UINavigationController(rootViewController: photosVC)
        photosVC.title = "Галерея"
        
        let photosPresenter = PhotosPresenter(view: photosVC)
        photosVC.presenter = photosPresenter
        
        tabBarController.viewControllers = [navigationController, photosNavController]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }

    func createImage(drawPathMode: CGPathDrawingMode) -> UIImage{
        let size = CGSize(width: 20, height: 20)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (contex) in
            let rect = CGRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2)
            contex.cgContext.addEllipse(in: rect)
            contex.cgContext.drawPath(using: drawPathMode)
        }
        return image
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func createContainer(){
        container = NSPersistentContainer(name: "ManagedNote")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {fatalError("Unable to load persistance store!")}
            
        }
    }


}

