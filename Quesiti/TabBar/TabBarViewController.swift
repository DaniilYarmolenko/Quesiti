//
//  TabBarViewController.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(configureTabBarItems), name: Notification.Name("configureTabBarItems"), object: nil)
        if Auth.auth().currentUser == nil {
            presentLoginController()
            NotificationCenter.default.post(name: Notification.Name("configureTabBarItems"), object: nil)
            setValue(AppTabBar(frame: tabBar.frame), forKey: "tabBar")
                    view.backgroundColor = .white
        } else {
            setValue(AppTabBar(frame: tabBar.frame), forKey: "tabBar")
                    view.backgroundColor = .white
            NotificationCenter.default.post(name: Notification.Name("configureTabBarItems"), object: nil)
        }
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .white
//            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setValue(AppTabBar(frame: tabBar.frame), forKey: "tabBar")
                view.backgroundColor = .white
//        configureTabBarItems()
    }
    @objc func configureTabBarItems(notification: NSNotification) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //print(uid, "123")
        self.selectedIndex = 0
        
        let homePageVC = HomePageViewController()
        let homePagePresenter = HomePagePresenter(view: homePageVC)
        homePageVC.presenter = homePagePresenter
        homePageVC.tabBarItem = UITabBarItem(title: "Home Page", image: UIImage(systemName: "house.fill"), tag: 0)

        
        let searchVC = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchVC)
        searchVC.presenter = searchPresenter
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), tag: 1)
        
        
        let addQuestionVC = AddQuestionViewController()
        let addQuestionPresenter = AddQuestionPresenter(view: addQuestionVC)
        addQuestionVC.presenter = addQuestionPresenter
    
        let mapVC = MapViewController()
        let mapPresenter = MapPresenter(view: mapVC)
        mapVC.presenter = mapPresenter
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        let profileVC = ProfileViewController()
        profileVC.delegate = self
        let profilePresenter = ProfilePresenter(view: profileVC)
        profileVC.presenter = profilePresenter
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 3)
        
        Database.database().fetchUser(withUID: uid) { (user) in
            homePageVC.user = user
            profileVC.user = user
            
        }
        
        let homePageNavigationVC = UINavigationController(rootViewController: homePageVC)
        
        
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        
        let mapNavigationVC = UINavigationController(rootViewController: mapVC)
        
        let profileNavigationVC = UINavigationController(rootViewController: profileVC)
        setViewControllers([homePageNavigationVC,searchNavigationVC, mapNavigationVC, profileNavigationVC], animated: true)
        
    }
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let loginController = WelcomeViewController()
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: true, completion: nil)
        }
    }
    
    @available(iOS 15.0, *)
        private func updateTabBarAppearance() {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            
            let barTintColor: UIColor = .white
            tabBarAppearance.backgroundColor = barTintColor
            
            self.tabBar.standardAppearance = tabBarAppearance
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        @available(iOS 15.0, *)
        private func updateNavBarAppearance(navController: UINavigationController) {
            let navBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            
            let navTintColor: UIColor = .white
            navBarAppearance.backgroundColor = navTintColor
            
            navController.navigationBar.standardAppearance = navBarAppearance
            navController.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
}

extension TabBarViewController: LogOutDelegate{
    func logOut() {
        presentLoginController()
    }
}
