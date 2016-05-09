//
//  LoginViewController.swift
//  MyLittleCoffeeShopDemo
//
//  Created by Dameon D Bryant on 5/7/16.
//  Copyright © 2016 Dameon D Bryant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var currentUser: NSString!
    var currentUserEmail: NSString!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("The user is already signed in")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showTabView", sender: nil)
            }
            self.returnUserData()
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            
        }
    }
    
    
    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                //                dispatch_async(dispatch_get_main_queue()) {
                //                    self.performSegueWithIdentifier("showTabView", sender: nil)
                self.returnUserData()
                //                }
            }
        }
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                self.currentUser = userName
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                self.currentUserEmail = userEmail
                print("User Email is: \(userEmail)")
                
                //Store user and user email address as NSUserDefaults
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(userName, forKey: "UserName")
                defaults.setValue(userEmail, forKey: "UserEmail")
                
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    
                    // Timer ensures that all views are available to be presented
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(LoginViewController.showMainTabView), userInfo: nil, repeats: false)
                }
            }
        })
    }
    
    func showMainTabView() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showTabView", sender: nil)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}