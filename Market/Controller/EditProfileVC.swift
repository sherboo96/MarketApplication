//
//  EditProfileVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/30/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class EditProfileVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var fNAme: UITextField!
    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var address: UITextField!
    
    //MARK: - VArs
       var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaData()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        finishONBoard()
        view.endEditing(false)
    }
    
    @IBAction func loggedOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    func loaData() {
        if USer.currentUser() != nil {
            let current = USer.currentUser()!
            fNAme.text = current.firstName
            sName.text = current.lastName
            address.text = current.fullAddress
        }
    }
    
    func finishONBoard() {
        let data = [KFIRSTNAME: fNAme.text!, KLASTNAME: sName.text!, KFULLNAME: fNAme.text! + " " + sName.text!, KFULLADDRESS: address.text!] as [String : Any]
        updateUser(withValues: data) { (error) in
            if error == nil {
                self.hud.textLabel.text = "Updated"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }

}
