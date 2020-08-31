//
//  Basket.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/26/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation

class Basket {
    
    var id: String!
    var ownerId: String!
    var itemsIds: [String]!
    
    init() {
        
    }
    
    init(_ dicitionary: NSDictionary) {
        id = dicitionary[KOBJECTID] as? String
        ownerId = dicitionary[KOWNERID] as? String
        itemsIds = dicitionary[KITEMSIDS] as? [String]
    }
}

//MARK: Save to firebase
func saveItemsToBasket(_ basket: Basket) {
    FirebaseRef(.Basket).document(basket.id).setData(basketData(basket) as! [String : Any])
}

func basketData(_ basket: Basket) -> NSDictionary {
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemsIds], forKeys: [KOBJECTID as NSCopying, KOWNERID as NSCopying, KITEMSIDS as NSCopying])
}

//MARK: update basket
func updateBasketFireestore(_ basket: Basket, withValues: [String: Any], complation: @escaping (_ error: Error?) -> ()) {
    FirebaseRef(.Basket).document(basket.id).updateData(withValues) { (error) in
        
        complation(error)
    }
}

//MARK: Download Items
func downloadBasketItems(ownerId: String, complation: @escaping (_ basket: Basket?) -> ()) {
    
    FirebaseRef(.Basket).whereField(KOWNERID, isEqualTo: ownerId).getDocuments { (snapShot, error) in
        
        guard let snapShot = snapShot else {
            complation(nil)
            return
        }
        
        if !snapShot.isEmpty && snapShot.documents.count > 0 {
            let basket = Basket(snapShot.documents.first!.data() as NSDictionary)
            complation(basket)
        } else {
            complation(nil)
        }
    }
}

