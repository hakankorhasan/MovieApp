//
//  ViewController.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 26.08.2022.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let upcomingVC = UINavigationController(rootViewController: UpComingVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let watchlistVC = UINavigationController(rootViewController: WhatcListVC())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.tv")
        searchVC.tabBarItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        watchlistVC.tabBarItem.image = UIImage(systemName: "heart.text.square")
        
        homeVC.title = "Movies"
        upcomingVC.title = "Coming Soon"
        searchVC.title = "Search Movie"
        watchlistVC.title = "My Favorites"
        
        
        setViewControllers([homeVC , upcomingVC , searchVC , watchlistVC], animated: true)
    }


}

