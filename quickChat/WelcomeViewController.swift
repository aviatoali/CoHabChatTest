//
//  WelcomeViewController.swift
//  quickChat
//
//  Created by Shan-e-Ali Shah on 4/5/16.
//  Copyright © 2016 Shan-e-Ali Shah. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController
{
    //backendless instance mostly for checking is user login info is there
    let backendless = Backendless.sharedInstance()
    var currentUser: BackendlessUser? //optional var to hold currentUser info
    
    //Called before viewDidLoad, going to use it to check if there is a current user or we need to prompt for register/login
    override func viewWillAppear(animated: Bool)
    {
        backendless.userService.setStayLoggedIn(true)
        
        currentUser = backendless.userService.currentUser
        //check if backendless has current user info
        if(currentUser != nil)
        {
            //because of transition before loaded view, makes sure to run on main queue to avoid xcode warning
            dispatch_async(dispatch_get_main_queue())
            {
                //segue to recents viewcontroller
                let vc = UIStoryboard(name : "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
                //to ensure the first default view upon entering is recents by using top bar button index
                vc.selectedIndex = 0
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
