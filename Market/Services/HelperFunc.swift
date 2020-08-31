//
//  HelperFunc.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/23/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation


func convertToCurrancy(_ number: Double) -> String {
    
    let currancyFormater = NumberFormatter()
    currancyFormater.usesGroupingSeparator = true
    currancyFormater.numberStyle = .currency
    currancyFormater.locale = Locale.current
    
    let priceString = currancyFormater.string(from: NSNumber(value: number))!
    
    return priceString
}
