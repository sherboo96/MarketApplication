//
//  BasketCell.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/26/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

class BasketCell: UITableViewCell {

    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNAme: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    func setCell(basket: Basket) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
