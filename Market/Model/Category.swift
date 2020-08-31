//
//  Category.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/19/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(name: String, imageName: String) {
        self.id = ""
        self.name = name
        self.imageName = imageName
        self.image = UIImage(named: imageName)
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary[KOBJECTID] as! String
        name = dictionary[KNAME] as! String
        image = UIImage(named: dictionary[KIMAGENAME] as? String ?? "")
    }
}


//MARK: Save category function
func saveCategoryToFirebase(_ category: Category){
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseRef(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String: Any])
}

//MARK: Services
func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    return NSDictionary(objects: [category.id, category.name, category.imageName as Any], forKeys: [KOBJECTID as NSCopying, KNAME as NSCopying, KIMAGENAME as NSCopying])
}

//Mark: Download Data
func downloadData(complation: @escaping (_ categoryArray: [Category]) -> ()) {
    var categoryArray: [Category] = []
    
    FirebaseRef(.Category).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { complation(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            for categoryData in snapshot.documents {
                categoryArray.append(Category(dictionary: categoryData.data() as NSDictionary))
            }
        }
        complation(categoryArray)
    }
}

//use only one
func createCategorySet() {
    
    let wommanClothes = Category(name: "Jep", imageName: "womenCloth")
    let baby = Category(name: "Baby Staff", imageName: "baby")
    
    let categoryArray = [wommanClothes, baby]
    
    for category in categoryArray {
        saveCategoryToFirebase(category)
    }
    
}
