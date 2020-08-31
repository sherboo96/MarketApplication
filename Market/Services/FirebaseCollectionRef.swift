//
//  ServiceAuth.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/19/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionRef: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseRef(_ collectionRef: FCollectionRef) -> CollectionReference {
    return Firestore.firestore().collection(collectionRef.rawValue)
}
