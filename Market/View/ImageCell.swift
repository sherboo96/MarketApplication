//
//  ImageCell.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/24/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    func configCell(itemImage: UIImage) {
        image.image = itemImage
    }
}
