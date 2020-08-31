//
//  CategoryCell.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/19/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    func configCell(category: Category) {
        categoryName.text = category.name
        categoryImage.image = category.image
    }
    
}
