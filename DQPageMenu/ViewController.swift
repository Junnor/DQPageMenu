//
//  ViewController.swift
//  DQPageMenu
//
//  Created by Ju on 2017/7/6.
//  Copyright © 2017年Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initializerMenuViewController()
    }
    
    private var addedPageViewController = false
    private func initializerMenuViewController() {
        if !addedPageViewController {
            addedPageViewController = true
            
            let scrollContainerVC = MenuContainerViewController(menus: pageItems(),
                                                                viewControllers: pageViewContorllers())
            self.addChildViewController(scrollContainerVC)
            scrollContainerVC.view.frame = view.bounds
            view.addSubview(scrollContainerVC.view)
            scrollContainerVC.didMove(toParentViewController: self)
        }
    }
    
    // MRAK: Test data
    private func pageItems() -> [UIButton] {
        
        var items = [UIButton]()
        
        let red = UIButton()
        let gray = UIButton()
        let purple = UIButton()
        
        red.setTitle("One", for: .normal)
        gray.setTitle("Two", for: .normal)
        purple.setTitle("Three", for: .normal)
        
        items.append(red)
        items.append(gray)
        items.append(purple)

        return items
    }
    
    private func pageViewContorllers() -> [UIViewController] {
        
        var vcs = [UIViewController]()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let firstViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as!
        FirstViewController
        
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        
        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ThirdViewController") as!
        ThirdViewController
        
        vcs.append(firstViewController)
        vcs.append(secondViewController)
        vcs.append(thirdViewController)

        return vcs
    }

}

