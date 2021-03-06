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
    var isFromUnity : Bool = false
    var momentAsFirstScreen : Bool = false
    var aViewLayer : collectionViewController?
    var pageControl = UIPageControl()
    /*
     23/05/2018
     //confirm OTP button click event
     */
    /*Initialize the screens
     If the user is not Logged in the Home screen and Login screen will be presented
     else the user will be provided with the Home screen and Moment screen
    */
    lazy var ViewControllerList : [UIViewController] = {
        StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if isLoggedIn() {
            home = StoryBoard.instantiateViewController(withIdentifier: "Home")
            login = StoryBoard.instantiateViewController(withIdentifier: "Moment")
        }
        else {
            home = StoryBoard.instantiateViewController(withIdentifier: "Home")
            login = StoryBoard.instantiateViewController(withIdentifier: "Login")
            
        }
        return [home,login]
    }()
    /*
     23/05/2018
     //confirm OTP button click event
     */
    //checks if the user is logged in or not
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoggedIn")
        //return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        staticVariables.iUserID = UserDefaults.standard.integer(forKey: "iUserID")
        // Do any additional setup after loading the view.
        if isFromUnity {
            // call the Home screen here
            if let firstViewController = ViewControllerList.first{
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        else
        {
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
        }

        
        configurePageControl()
    }
    /*
     25/05/2018
     This function does the initial configuration of the pageControl
     to display it on to the bottom of the screen.
     */
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 35,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = ViewControllerList.count
        if isFromUnity
        {
            self.pageControl.currentPage = 0
        }
        else
        {
            if isLoggedIn() {
                self.pageControl.currentPage = 1
            }
            else {
                self.pageControl.currentPage = 0
            }
        }
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    override func viewDidLayoutSubviews() {
       /* self.pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        
        self.pageControl.currentPage = ViewControllerList.index(of: pageContentViewController)!
        //self.pageControl.tintColor = UIColor.red
    }
    //25/05/2018
    //Keeps track of the previous screen index (ViewController index)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcindex = ViewControllerList.index(of: viewController) else {
            return nil
        }
        let previousIndex = vcindex - 1
        guard previousIndex >= 0 else { return nil }
        
        guard ViewControllerList.count > previousIndex else { return nil }
        return ViewControllerList[previousIndex]
    }
    //25/05/2018
    //Keeps track of the next screen Index (ViewController index)
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
}


