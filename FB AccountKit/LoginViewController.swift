//
//  LoginViewController.swift
//  FB AccountKit
//
//  Created by 🅐🅝🅐🅢 on 12/05/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//


/**
 NOTE:
 1. Install pod 'AccountKit'
 2. Don't forget to add both your Facebook App ID and Account Kit Client Token to your Info.plist file as strings.
 3. You will get the App ID and Account Kit Client Token from the developers.facebook account inside your app.
 */

import UIKit
import AccountKit

class LoginViewController: UIViewController{
    
    //MARK: - Variabes
    var _accountKit: AKFAccountKit!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize Account Kit
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "showDetails", sender: self)
            })
        }
        else{
            // Show the login screen
        }
    }
    
    //MARK: - Helper Methods
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.setTheme(theme)
    }
    
    //Login with Email
    func loginWithEmail() {
        let inputState = NSUUID().uuidString
        let vc = _accountKit!.viewControllerForEmailLogin(withEmail: nil, state: inputState)
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    //Login with phone number
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func btnLoginWithPhoneOnClick(_ sender: UIButton) {
        self.loginWithPhone()
    }
    
    @IBAction func btnLoginWithEmailOnClick(_ sender: UIButton) {
        self.loginWithEmail()
    }
}

extension LoginViewController: AKFViewControllerDelegate {
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(state)")
    }
    
    // handle callback on successful login to show authorization code
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("didCompleteLoginWithAuthorizationCode")
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
        print("viewControllerDidCancel")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(viewController) did fail with error: \(error.localizedDescription)")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("didCompleteLoginWith")
    }
}
