//
//  Downloader.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/23/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func loadImages(images: [UIImage?], itemsId: String, complation: @escaping (_ imagesArrays: [String]) -> ()) {
    
    var imageCount = 0
    var imageLinkeArray: [String] = []
    var nameSuffix = 0
    
    if Reachability.isConnectedToNetwork() {
        
        for image in images {
            
            let fileName = "itemImages/" + itemsId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInFireBase(imageData: imageData!, fileName: fileName) { (imageLinks) in
                
                if imageLinks != nil {
                    imageLinkeArray.append(imageLinks!)
                    imageCount += 1
                    if imageCount == images.count {
                        complation(imageLinkeArray)
                    }
                }
            }
            nameSuffix += 1
        }
    } else {
        print("Error")
    }
    
}

func saveImageInFireBase(imageData: Data, fileName: String, complation: @escaping (_ imageLinks: String?) -> ()) {
    
    var task: StorageUploadTask!
    
    let storageRef = storage.reference(forURL: FIREBASEKEY).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadate, error) in
        task.removeAllObservers()
        
        if error != nil {
            print("Error Uploading", error!.localizedDescription)
            complation(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                complation(nil)
                return
            }
            
            complation(downloadUrl.absoluteString)
        }
        
    })
    
}

func downloadImages(imageUrls: [String], complation: @escaping (_ images: [UIImage?]) -> ()) {
    
    var imagesArray: [UIImage] = []
    
    var downloadCounter = 0
    
    for image in imageUrls {
        let url = NSURL(string: image)
        
        let downloadQueue = DispatchQueue(label: "ImageDownloadQueue")
        
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imagesArray.append(UIImage(data: data! as Data)!)
                
                if downloadCounter == imagesArray.count {
                    DispatchQueue.main.async {
                        complation(imagesArray)
                    }
                }
            } else {
                complation(imagesArray)
            }
        }
    }
    
}
