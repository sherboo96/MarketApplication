//
//  OnBoardVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/29/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import JGProgressHUD

class OnBoardVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var fNAme: UITextField!
    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    //MARK: - VArs
    var hud = JGProgressHUD(style: .dark)
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fNAme.addTarget(self, action: #selector(self.textFieldDidChane(_:)), for: UIControl.Event.editingChanged)
        sName.addTarget(self, action: #selector(self.textFieldDidChane(_:)), for: UIControl.Event.editingChanged)
        address.addTarget(self, action: #selector(self.textFieldDidChane(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func textFieldDidChane(_ textField: UITextField) {
        updateDoneBtn()
    }
    
    @IBAction func gesture(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
         finishONBoard()
    }
    
    func updateDoneBtn() {
        if fNAme.text != "" && sName.text != "" && address.text != "" {
            doneBtn.isEnabled = true
            doneBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else {
            doneBtn.isEnabled = false
            doneBtn.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    func finishONBoard() {
        let data = [KFIRSTNAME: fNAme.text!, KLASTNAME: sName.text!, KFULLNAME: fNAme.text! + " " + sName.text!, KFULLADDRESS: address.text!, KONBOARD: true] as [String : Any]
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
