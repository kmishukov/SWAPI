//
//  AppDelegate.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController()
        let navigation = UINavigationController(rootViewController: mainVC)
        configureColorTheme()
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataController.save()
    }

    // MARK: - CoreData stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SWAPI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func configureColorTheme(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.swapiTitleBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.swapiYellow]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.swapiYellow
    }
}

extension UIColor {
    static let swapiGreen = UIColor(red: 3/255.0, green: 210/255.0, blue: 119/255.0, alpha: 1)
    static let swapiYellow = UIColor(red: 255/255.0, green: 228/255.0, blue: 1/255.0, alpha: 1)
    static let swapiTitleBackground = UIColor(red: 28/255.0, green: 30/255.0, blue: 34/255.0, alpha: 1)
    static let swapiBackground = UIColor(red: 38/255.0, green: 43/255.0, blue: 48/255.0, alpha: 1)
}

extension UITableViewController {
    func configureColorTheme(){
        tableView.rowHeight = 44
        tableView.backgroundColor = UIColor.swapiBackground
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.swapiYellow
    }
}

extension UITableView {
    func configureColorTheme(){
        self.rowHeight = 44
        self.backgroundColor = UIColor.swapiBackground
        self.tableFooterView = UIView()
        self.separatorStyle = .singleLine
        self.separatorInset = .zero
        self.separatorColor = UIColor.swapiYellow
    }
}

extension UINavigationController {

}





