//
//  Items.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/21/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation
import UIKit

class Items {
    
     var Id: String!
     var categoryId: String!
     var name: String!
     var description: String!
     var price: Double!
     var imageLinks: [String]!
    
    
    init() {
        
    }
    
    init(dictionary: NSDictionary) {
        Id = dictionary[KOBJECTID] as? String
        categoryId = dictionary[KCATEGORYID] as? String
        name = dictionary[KNAME] as? String
        description = dictionary[KDESCRIPTION] as? String
        price = dictionary[KPRICE] as? Double
        imageLinks = dictionary[KIMAGESLINKS] as? [String]
    }
}


func savaItemFirebase(item: Items) {
    
    FirebaseRef(.Items).document(item.Id).setData(itemDictionartFrom(item: item) as! [String : Any])
}

func itemDictionartFrom(item: Items) -> NSDictionary  {
    return NSDictionary(objects: [item.Id, item.categoryId, item.name, item.description, item.price, item.imageLinks], forKeys: [KOBJECTID as NSCopying, KCATEGORYID as NSCopying, KNAME as NSCopying, KDESCRIPTION as NSCopying, KPRICE as NSCopying, KIMAGESLINKS as NSCopying])
}

func downloadFirebase(categoryId: String, complation: @escaping (_ item: [Items]) -> ()) {
    var itemsArray: [Items] = []
    
    FirebaseRef(.Items).whereField(KCATEGORYID, isEqualTo: categoryId).getDocuments { (snapShot, error) in
        guard let snap = snapShot else { complation(itemsArray)
            return
        }
        
        if !snap.isEmpty {
            for item in snap.documents{
                itemsArray.append(Items(dictionary: item.data() as NSDictionary))
            }
            
        }
        complation(itemsArray)
    }
}


func downloadItemsFromBasket(itemsIds: [String], complation: @escaping (_ items: [Items]) -> ()) {
    
    var downlaodItems = 0
    var itemsArray: [Items] = []
    
    if itemsIds.count > 0 {
        for itemId in itemsIds {
            FirebaseRef(.Items).document(itemId).getDocument { (snapShot, error) in
                
                guard let snapShot = snapShot else {
                    complation(itemsArray)
                    return
                }
                
                if snapShot.exists  {
                    itemsArray.append(Items(dictionary: snapShot.data()! as NSDictionary))
                    downlaodItems += 1
                } else {
                    complation(itemsArray)
                }
                
                if downlaodItems == itemsIds.count {
                    complation(itemsArray)
                }
            }
            
        }
    }
}
