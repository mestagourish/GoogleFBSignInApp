//
//  SwipeViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class SwipeViewController:  UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    var StoryBoard : UIStoryboard! = nil
    var login : UIViewController!
    var home : UIViewController!
    var momentAsFirstScreen : Bool = false
    var aViewLayer : collectionViewController?
    //Initialize the screens
    lazy var ViewControllerList : [UIViewController] = {
        StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if isLoggedIn() {
            home = StoryBoard.instantiateViewController(withIdentifier: "Home")
            login = StoryBoard.instantiateViewController(withIdentifier: "Moment")
        }else {
            home = StoryBoard.instantiateViewController(withIdentifier: "Home")
            login = StoryBoard.instantiateViewController(withIdentifier: "Login")
            
        }
        return [home,login]
    }()
    var pageControl = UIPageControl()
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 44,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = ViewControllerList.count
        if isLoggedIn() {
            self.pageControl.currentPage = 1
        }
        else {
            self.pageControl.currentPage = 0
        }
        
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoggedIn")
        //return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
        if isLoggedIn(){
            // call the Moment screen here
            if let firstViewController = ViewControllerList.last{
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        else {
            // call the Login screen here
            if let FirstViewController = ViewControllerList.first {
                self.setViewControllers([FirstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        configurePageControl()
    }
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            }else if view is UIPageControl{
                //view.tintColor = UIColor.black
                view.tintColor = UIColor.clear
                view.backgroundColor = UIColor.clear
            }
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        
        self.pageControl.currentPage = ViewControllerList.index(of: pageContentViewController)!
        //self.pageControl.tintColor = UIColor.red
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcindex = ViewControllerList.index(of: viewController) else {
            return nil
        }
        let previousIndex = vcindex - 1
        guard previousIndex >= 0 else { return nil }
        
        guard ViewControllerList.count > previousIndex else { return nil }
        return ViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcindex = ViewControllerList.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcindex + 1
        
        guard ViewControllerList.count != nextIndex else {
            return nil
        }
        
        guard ViewControllerList.count > nextIndex else {
            return nil
        }
        
        return ViewControllerList[nextIndex]
    }
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return ViewControllerList.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,let firstViewControllerIndex = ViewControllerList.index(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    */
}


