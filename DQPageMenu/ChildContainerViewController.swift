//
//  ChildContainerViewController.swift
//  DQPageMenu
//
//  Created by Ju on 2017/7/6.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class ChildContainerViewController: UIViewController {
    
    // MAR: - Private ... copy from  MenuContainerViewController
    private var menus: [UIButton] = [UIButton]()
    private var viewControllers: [UIViewController] = [UIViewController]()

    private var itemColor = UIColor.white
    private var indicatorColor = UIColor.red

    // MARK: - Private properties
    private var scrollView: UIScrollView!
    
    private var itemsTitle: [String] = [String]()
    private var viewControllersFrame: [CGRect] = [CGRect]()
    fileprivate var itemsOriginX: [CGFloat] = [CGFloat]()
    
    fileprivate var indicatorView: UIView!
    
    fileprivate var indicatorViewLastOriginX: CGFloat = 0.0 {
        didSet {
            indicatorCopyView?.frame.origin.x = indicatorViewLastOriginX
        }
    }
    
    fileprivate let indicatorViewWidth: CGFloat = 30
    
    fileprivate var scale: CGFloat!
    
    fileprivate let moveDuration: TimeInterval = 0.2
    
    // Due to 'sectionIndicatorView' will reset frame when viewDidDisappear did called,
    // so, add 'indicatorCopyView' as the copy view
    fileprivate var indicatorCopyView: UIView!
    fileprivate var shouldAdjustCopyIndicatorView = false

    
    // MARK: - Outlets
    
    @IBOutlet weak var menuView: UIView!
    
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
        
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "OneViewController") as!
        OneViewController
        
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "TwoViewController") as! TwoViewController
        
        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ThreeViewController") as!
        ThreeViewController
        
        vcs.append(firstViewController)
        vcs.append(secondViewController)
        vcs.append(thirdViewController)
        
        return vcs
    }

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menus = pageItems()
        viewControllers = pageViewContorllers()
        
        automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        
        scrollView = UIScrollView()
        let customTitleView = UIView()
        let titleStackView = UIStackView()
        indicatorView = UIView()
        indicatorCopyView = UIView()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        for button in menus {
            button.setTitleColor(itemColor, for: .normal)
            itemsTitle.append(button.currentTitle!)
        }
        
        for item in menus {
            titleStackView.addArrangedSubview(item)
        }
        titleStackView.alignment = .center
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        
        for i in 0 ..< viewControllers.count {
            let subvc = viewControllers[i]
            self.addChildViewController(subvc)
            scrollView.addSubview(subvc.view)
            subvc.didMove(toParentViewController: self)
        }
        
        let titleViewWidth: CGFloat = UIScreen.main.bounds.width
        let titleViewHeight: CGFloat = 44
        let stackViewHeight: CGFloat = 40
        
        let titleViewFrame = CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight)
        let stackViewFrame = CGRect(x: 0, y: 0, width: titleViewWidth, height: stackViewHeight)
        let indicatorViewFrame = CGRect(x: 0, y: titleViewHeight - 2, width: indicatorViewWidth, height: 1)
        
        customTitleView.frame = titleViewFrame
        customTitleView.frame.origin.x = self.view.frame.midX - titleViewWidth/2
        
        titleStackView.frame = stackViewFrame
        
        indicatorView.frame = indicatorViewFrame
        indicatorView.backgroundColor = indicatorColor
        
        // for menuItems originX
        var itemOriginX: CGFloat = 0
        let itemWidth: CGFloat = titleViewWidth/3
        for item in menus {
            item.addTarget(self, action: #selector(contentOffSetXForButton(sender:)), for: .touchUpInside)
            let itemFrame = CGRect(x: itemOriginX, y: 0, width: itemWidth, height: stackViewHeight)
            item.frame = itemFrame
            let indicatorOriginX = itemFrame.midX - indicatorViewWidth/2
            itemsOriginX.append(indicatorOriginX)
            itemOriginX += itemWidth
        }
        
        // for sectionIndicatorView
        indicatorView.frame.origin.x = itemsOriginX[0]
        indicatorViewLastOriginX = indicatorView.frame.origin.x
        
        // indicator copy view
        indicatorCopyView.frame = indicatorView.frame
        indicatorCopyView.backgroundColor = indicatorView.backgroundColor
        indicatorCopyView.isHidden = true
        
        // indicator scroll scale
        let indicatorScale = itemsOriginX[1] - itemsOriginX[0]
        scale = indicatorScale / UIScreen.main.bounds.size.width
        
        customTitleView.addSubview(titleStackView)
        customTitleView.addSubview(indicatorView)
        customTitleView.addSubview(indicatorCopyView)
        
        menuView.addSubview(customTitleView)
        
        
        view.addSubview(scrollView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var scrollViewFrame = view.frame
        scrollViewFrame.size.height -= 49
        scrollViewFrame.origin.y = 49
        
        scrollView.frame = scrollViewFrame
        
        let width = scrollViewFrame.width
        let height = scrollViewFrame.height
        
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        
        // has [viewControllersFrame]
        var vcOriginX: CGFloat = 0
        for _ in 0 ..< viewControllers.count {
            viewControllersFrame.append(CGRect(x: vcOriginX, y: 0, width: width, height: height))
            vcOriginX += width
        }
        
        for i in 0 ..< viewControllers.count {
            viewControllers[i].view.frame = viewControllersFrame[i]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAdjustCopyIndicatorView {
            UIView.animate(withDuration: 0.0, animations: {
                self.indicatorView?.frame.origin.x = self.indicatorViewLastOriginX
            }) { (_) in
                self.indicatorCopyView?.isHidden = true
                self.indicatorView?.isHidden = false
                
                self.shouldAdjustCopyIndicatorView = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        indicatorCopyView.isHidden = false
        indicatorView.isHidden = true
        shouldAdjustCopyIndicatorView = true
    }
    
    // MARK: - Helper
    @objc private func contentOffSetXForButton(sender: UIButton){
        let currentTitle = sender.currentTitle!
        let index = itemsTitle.index(of: currentTitle)!
        
        scrollView.setContentOffset(viewControllersFrame[index].origin, animated: true)
        UIView.animate(withDuration: moveDuration, animations: {
            self.indicatorView.frame.origin.x = self.itemsOriginX[index]
            self.indicatorViewLastOriginX = self.indicatorView.frame.origin.x
        })
    }
    
    // MARK: - Outlets action
    
    @IBAction func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ChildContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0.0 {
            return
        }

        UIView.animate(withDuration: moveDuration, animations: {
            let x = scrollView.contentOffset.x * self.scale + self.itemsOriginX[0]
            self.indicatorView.frame.origin.x = x
            self.indicatorViewLastOriginX = x
        })
    }
}



