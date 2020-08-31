//
//  ItemTableVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/21/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

class ItemTableVC: UITableViewController {

    var category: Category?
    var itemsArray: [Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell {
            
            cell.cellConfig(item: itemsArray[indexPath.row])
            
            return cell
        } else {
            return ItemCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItems(item: itemsArray[indexPath.row])
    }
    
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InsertItems" {
            let vc = segue.destination as! ItemsDataVC
            vc.category = category!
        }
    }
    
    func showItems(item: Items) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemDetails") as! ItemViewVC
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    func loadItems() {
        downloadFirebase(categoryId: category!.id) { (items) in
            self.itemsArray = items
            self.tableView.reloadData()
        }
    }

}
