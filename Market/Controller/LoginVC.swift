//
//  LoginVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/28/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView


class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var resendBtn: UIButton!
    
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndactor: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndactor = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: .blue, padding: nil)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if complation() {
            login()
        } else {
            hud.textLabel.text = "Please Fill Fields!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func registerBTn(_ sender: Any) {
        if complation() {
            registerUser()
        } else {
            hud.textLabel.text = "Please Fill Fields!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func forgetBTn(_ sender: Any) {
        if emailText.text != "" {
            USer.resetPassword(email: emailText.text!) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "Reset Email Password sent!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        } else {
            hud.textLabel.text = "Please Fill Fields!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func resendBTn(_ sender: Any) {
        if emailText.text != "" {
            USer.resendVerification(email: emailText.text!) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "Reset Email Verification sent!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        } else {
            hud.textLabel.text = "Please Fill Fields!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func gestarPress(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    
    //MARK: Login
    func login() {
        showIndactor()
        
        USer.loginUserWith(emial: emailText.text!, password: passwordText.text!) { (error, isVerified) in
            if error == nil {
                if isVerified {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.hud.textLabel.text = "Please Verify Email!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendBtn.isHidden = false
                }
            } else {
                self.hud.textLabel.text = "Please Fill Fields!"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideIndactor()
        }
    }
    
    //MARK: REgister
    func registerUser() {
        showIndactor()
        
        USer.registerUserWith(emial: emailText.text!, password: passwordText.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "Verifaction Email Sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = "Please Fill Fields!"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideIndactor()
        }
    }
    
    
    //MARK: Halper
    func complation() -> Bool {
        return (emailText.text != nil && passwordText.text != nil)
    }
    
    func showIndactor() {
        if activityIndactor != nil {
            self.view.addSubview(activityIndactor!)
            activityIndactor!.startAnimating()
        }
    }
    
    func hideIndactor() {
        if activityIndactor != nil {
            activityIndactor!.removeFromSuperview()
            activityIndactor!.startAnimating()
        }
    }
    
}
