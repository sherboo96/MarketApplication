//
//  ItemViewVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/24/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class ItemViewVC: UIViewController {

    
    @IBOutlet weak var imagerVirew: UICollectionView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var item: Items!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let height: CGFloat = 196.0
    private let itemPerRow: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            self.title = item.name
            nameText.text = item.name
            priceLbl.text = convertToCurrancy(item.price ?? 0)
            descriptionText.text = item.description
        }
        images()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "basket"), style: .plain, target: self, action: #selector(self.basketAction))
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func basketAction() {
        if Auth.auth().currentUser != nil {
            downloadBasketItems(ownerId: USer.currentId()) { (basket) in
                if basket == nil {
                    self.saveDataToBasket()
                } else {
                    basket!.itemsIds.append(self.item.Id)
                    self.updateBasketDate(basket: basket!, withValue: [KITEMSIDS: basket!.itemsIds])
                }
            }
        } else {
            showLoginVC()
        }
    }
    
    func saveDataToBasket() {
        let basket = Basket()
        basket.id = UUID().uuidString
        basket.itemsIds = [self.item.Id]
        basket.ownerId = Auth.auth().currentUser!.uid
        saveItemsToBasket(basket)
        
        self.hud.textLabel.text = "Added to Basket!"
        self.hud.indicatorView = JGProgressHUDIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    func updateBasketDate(basket: Basket, withValue: [String: Any]) {
        updateBasketFireestore(basket, withValues: withValue) { (error) in
            if error != nil {
                self.hud.textLabel.text = "Error! \(error?.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = "Added to Basket!"
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    func images() {
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (images) in
                if images.count > 0 {
                    self.itemImages = images as! [UIImage]
                    self.imagerVirew.reloadData()
                }
            }
        }
    }
    
    func showLoginVC() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
        present(vc, animated: true, completion: nil)
    }
}

extension ItemViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1: itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCell{
            if itemImages.count > 0 {
                cell.configCell(itemImage: itemImages[indexPath.row])
            }
            return cell
        } else {
            return ImageCell()
        }
        
    }
    
    
}

extension ItemViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let withPerItem = collectionView.frame.width - sectionInsets.left
        
        return CGSize(width: withPerItem, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
