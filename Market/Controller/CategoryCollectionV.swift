//
//  CategoryCollectionV.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/19/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionV: UICollectionViewController {

    
    
    
    // MARK: Variables
    var categoryArray: [Category] = []
    
    private let sectionInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    private let itemPerRow: CGFloat = 3
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //createCategorySet()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        loadCategories()
    }
    

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.configCell(category: categoryArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: categoryArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            let vc = segue.destination as! ItemTableVC
            vc.category = sender as! Category
        }
    }
    
    //MARK: Load Data from Firestore
    private func loadCategories() {
        downloadData { (categories) in
            self.categoryArray = categories
            self.collectionView.reloadData()
        }
    }
}

extension CategoryCollectionV: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemPerRow + 1) * 2
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemPerRow
        
        return CGSize(width: withPerItem, height: withPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
