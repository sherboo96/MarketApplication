//
//  ProfileVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/29/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {

    
    @IBOutlet weak var registerBnt: UIButton!
    @IBOutlet weak var puchaseBtn: UIButton!
    
    // MARK: - var
    var editBtn = UIBarButtonItem()
    
    
    // MARK: - View LifeCycele
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLoginStatus()
        checkOnBoard()
    }

    // MARK: - Helper
    
    func checkLoginStatus() {
        if USer.currentId() == "" {
            createRightBtn(title: "Login")
        } else {
            createRightBtn(title: "Edit")
        }
    }
    
    func createRightBtn(title: String) {
        editBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBtnPress))
        self.navigationItem.rightBarButtonItem = editBtn
    }
    
    @objc func rightBtnPress() {
        if editBtn.title == "Login" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
            present(vc, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "ProfileToEdit", sender: nil)
        }
    }
    
    func checkOnBoard() {
        if USer.currentId() == "" {
            registerBnt.setTitle("Logged Out", for: .normal)
            registerBnt.isEnabled = false
            puchaseBtn.isEnabled = false
        } else {
            if USer.currentUser()!.onBoard {
                registerBnt.setTitle("Account is Active", for: .normal)
                registerBnt.isEnabled = false
            } else {
                registerBnt.setTitle("Finish Registration", for: .normal)
                registerBnt.isEnabled = true
                registerBnt.tintColor = .red
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
