//
//  BasketVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/26/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class BasketVC: UIViewController {

    //MARK: IBoutlet
    
    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var itemsPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    //Vars
    var basker: Basket!
    var allItems: [Items] = []
    var parchesItemsIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadBasketFromFirebase()
        
    }

    
    @IBAction func checkoutBtn(_ sender: Any) {
       
    }
    
    func loadBasketFromFirebase() {
        
        downloadBasketItems(ownerId: USer.currentId()) { (basket) in
            if basket != nil {
                self.basker = basket
                self.getBaskItems()
            } else {
                self.allItems = []
            }
        }
        if Auth.auth().currentUser == nil {
            self.allItems = []
            self.updateAllLabels(isEmpty: allItems.count == 0)
        }
    }
    
    func getBaskItems() {
        if basker != nil {
            downloadItemsFromBasket(itemsIds: basker.itemsIds) { (items) in
                self.allItems = items
                self.updateAllLabels(isEmpty: items.count == 0)
                self.tableView.reloadData()
            }
            self.updateAllLabels(isEmpty: allItems.count == 0)
        }
    }
    
    func updateAllLabels(isEmpty: Bool) {
        if isEmpty {
            itemNumber.text = "0"
            itemsPrice.text = returnAllPrices()
            checkOutBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            itemNumber.text = "\(allItems.count)"
            itemsPrice.text = returnAllPrices()
            checkOutBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        updateCheckoutButton()
    }
    
    func returnAllPrices() -> String {
        
        var price = 0.0
        
        for item in allItems {
            price += item.price
        }
        
        return "Total Price is: \(price)"
    }
    
    func updateCheckoutButton() {
        checkOutBtn.isEnabled = allItems.count > 0
        
        if checkOutBtn.isEnabled {
            checkOutBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else {
            checkOutBtn.isEnabled = false
            checkOutBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    func removeItemFromBasket(itemsId: String) {
        
        for i in 0..<basker!.itemsIds.count {
            if itemsId == basker!.itemsIds[i] {
                basker!.itemsIds.remove(at: i)
                return
            }
        }
        
    }
    
    func showItems(item: Items) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemDetails") as! ItemViewVC
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
}

extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.cellConfig(item: allItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemsId: itemToDelete.Id)
            
            updateBasketFireestore(basker!, withValues: [KITEMSIDS: basker!.itemsIds]) { (error) in
                if error != nil {
                    print("Error")
                }
                self.getBaskItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItems(item: allItems[indexPath.row])
    }
    
}
