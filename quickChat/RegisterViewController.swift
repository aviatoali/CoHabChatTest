//
//  RegisterViewController.swift
//  quickChat
//
//  Created by Shan-e-Ali Shah on 4/6/16.
//  Copyright © 2016 Shan-e-Ali Shah. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController
{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //creates instance of backendless so we can use it to call functions of backendless SDK
    var backendless = Backendless.sharedInstance()
    
    
    //building email, username, password, avatarImage and backendless newUser instance
    var newUser: BackendlessUser?
    var email: String?
    var username: String?
    var password: String?
    var avatarImage: UIImage?
    
    //going to instantiate backendless user through here for additional setup
    override func viewDidLoad()
    {
        super.viewDidLoad()

        newUser = BackendlessUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    @IBAction func RegisterButtonPressed(sender: UIButton)
    {
        //Check if user has input text in the 3 text fields and if they're not empty set email username and password. Avatar image set later
        if(emailTextField.text != "" && usernameTextField.text != "" && passwordTextField.text != "")
        {
            ProgressHUD.show("Registering...") //Use ProgressHUD to show registration status
            email = emailTextField.text
            username = usernameTextField.text
            password = passwordTextField.text
            
            //call register function to register backendless user
            register(self.email!, username: self.username!, password: self.password!, avatarImage: self.avatarImage)
            
        }
        
        //if user hasn't filled in required textboxes, prompt them to do so
        else
        {
            //use ProgressHUD to show login warning to user if text fields vacant or incorrectly filled
            ProgressHUD.showError("All fields are required")
        }
        
    }
    
    //MARK: Backendless user registration
    
    /*takes email, username, password string and optional UIIMage avatar image. Call to register new user. Note that we can just use .email, .password and .username on values because they're the default values of our server and defined in SDK, but for any custom properties use .setProperty for the value*/
    func register(email: String, username: String, password: String, avatarImage: UIImage?)
    {
        //check if optional avatar image passed in:
        
        //if not passed in...
        if (avatarImage == nil)
        {
            //...dynamically create a new property in database with name Avatar that will appear in user table in database, and the object/value of it will be empty string since no image passed
            newUser!.setProperty("Avatar", object: "")
        }
        
        //else if avatar image passed...
        
        //unwrap optional newUser and set other passed property values():
        newUser!.email = email
        newUser!.name = username
        newUser!.password = password
        
        //Call the function to register the new user with backendless registration service
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) -> Void in
            
            //dismiss the ProgressHUD registering status animation
            ProgressHUD.dismiss()
            //because backendless doesn't automatically log user in, if user gets registered, call login function to log newly registered user in.
            self.loginUser(email, username: username, password: password) //since this function isn't called on main thread and is called later when user is registered, we use self. before the function.
            
            //set user input info in textfields to empty
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
            
            }) { (fault : Fault!) -> Void in //error handler, prints message and passes error
                print("Server reported an error, couldn't register new users: \(fault)")
        }
        
    }
    
    //function to log user in, takes in string email, username, password
    func loginUser(email: String, username: String, password: String)
    {
        
        backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            
            //here we seque to recents viewcontroller
            let vc = UIStoryboard(name : "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            //to ensure the first default view upon entering is recents by using top bar button index
            vc.selectedIndex = 0
            self.presentViewController(vc, animated: true, completion: nil)
            
            }) { (fault : Fault!) -> Void in //error handler, prints message and passes error
                print("Server reported an error: \(fault)")
        }
    }

}