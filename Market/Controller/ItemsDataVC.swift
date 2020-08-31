//
//  ItemsDataVC.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/21/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class ItemsDataVC: UIViewController {

    //MARK: IBOUTLIT
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descText: UITextView!
    
    //MARK: Vars
    var category: Category!
    var gallery: GalleryController!
    let hub = JGProgressHUD(style: .dark)
    
    var activityIndactor: NVActivityIndicatorView?
    
    
    var images: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndactor = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: .blue, padding: nil)
    }
    

    @IBAction func cemaryBtn(_ sender: Any) {
        images = []
        showImageGallary()
    }
    
    @IBAction func doneBTn(_ sender: Any) {
        dismmisKey()
        
        if fieldComplations() {
            saveToFirebase()
        } else {
            
            self.hub.textLabel.text = "All Fileds are Required!"
            self.hub.indicatorView = JGProgressHUDIndicatorView()
            self.hub.show(in: self.view)
            self.hub.dismiss(afterDelay: 2.0)
            
//            let alart = UIAlertController(title: "Alart", message: "Fill Fields", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//            alart.addAction(action)
//            present(alart, animated: true, completion: nil)
        }
    }
    
    @IBAction func gestuteRec(_ sender: Any) {
        dismmisKey()
    }
    
    private func fieldComplations() -> Bool {
        return (titleText.text != "" && priceText.text != "" && descText.text != "")
    }
    
    private func dismmisKey() {
        self.view.endEditing(false)
    }
    
    private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveToFirebase() {
        
        showLoadinIndactor()
        let item = Items()
        item.Id = UUID().uuidString
        item.categoryId = category.id
        item.description = descText.text
        item.name = titleText.text
        item.price = Double(priceText.text!)
        
        if images.count > 0 {
            loadImages(images: images, itemsId: item.Id) { (links) in
                item.imageLinks = links
                savaItemFirebase(item: item)
                self.hideLoadinIndactor()
                self.popView()
            }
            
            
        } else {
            savaItemFirebase(item: item)
            popView()
        }
    }
    
    func showImageGallary() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
        
    }
    
    func hideLoadinIndactor() {
        if activityIndactor != nil {
            activityIndactor?.removeFromSuperview()
            activityIndactor?.stopAnimating()
        }
    }
    
    func showLoadinIndactor() {
        if activityIndactor != nil {
            self.view.addSubview(activityIndactor!)
            activityIndactor?.startAnimating()
        }
    }
}


extension ItemsDataVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.images = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
