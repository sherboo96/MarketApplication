//
//  USer.swift
//  Market
//
//  Created by Mahmoud Sherbeny on 8/28/20.
//  Copyright © 2020 Mahmoud Sherbeny. All rights reserved.
//

import Foundation
import FirebaseAuth

class USer {
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItems: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    
    init(objectId: String, email: String, firstName: String, lastName: String) {
        self.objectId = objectId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.fullAddress = ""
        self.onBoard = false
        self.purchasedItems = []
    }
    
    init(_ dictionary: NSDictionary) {
        objectId = dictionary[KOBJECTID] as! String
        
        if let mail = dictionary[KEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fName = dictionary[KFIRSTNAME] {
            firstName = fName as! String
        } else {
            firstName = ""
        }
        
        if let sName = dictionary[KLASTNAME] {
            lastName = sName as! String
        } else {
            lastName = ""
        }
        
        if let flName = dictionary[KFULLNAME] {
            fullName = flName as! String
        } else {
            fullName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let fAddress = dictionary[KFULLADDRESS] {
            fullAddress = fAddress as! String
        } else {
            fullAddress = ""
        }
        
        if let kpursh = dictionary[KPURCHAESITEMS] {
            purchasedItems = kpursh as! [String]
        } else {
            purchasedItems = []
        }
        
        if let onboad = dictionary[KONBOARD] {
            onBoard = onboad as! Bool
        } else {
            onBoard = false
        }
    }
    
    class func currentId() -> String {
        if Auth.auth().currentUser != nil {
             return Auth.auth().currentUser!.uid
        } else {
            return ""
        }
       
    }
    
    class func currentUser() -> USer? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.dictionary(forKey: KCURRENTUSER) {
                return USer.init(dictionary as NSDictionary)
            }
        }
        
        return nil
    }
    
    class func loginUserWith(emial: String, password: String, complation: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> ()) {
        
        Auth.auth().signIn(withEmail: emial, password: password) { (authRes, error) in
            if error == nil {
                if authRes!.user.isEmailVerified {
                    downloadUserData(userID: authRes!.user.uid, email: emial)
                    complation(error, true)
                } else {
                    complation(error, false)
                }
            } else {
                complation(error, false)
            }
        }
    }
    
    class func registerUserWith(emial: String, password: String, complation: @escaping (_ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: emial, password: password) { (authRes, error) in
            
            complation(error)
            
            if error == nil {
                authRes?.user.sendEmailVerification(completion: { (error) in
                    print("error verification")
                })
            }
        }
    }
    
    class func resetPassword(email: String,complation: @escaping (_ error: Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            complation(error)
        }
    }
    
    class func resendVerification(email: String,complation: @escaping (_ error: Error?) -> ()) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                complation(error)
            })
            
        })
        
    }
}


//MARK: Save to fireSatore
func savaToFirestore(user: USer) {
    FirebaseRef(.User).document(user.objectId).setData(userDictionaryFrom(user: user) as! [String: Any]) { (error) in
        if error != nil {
            print("Error to save data")
        } else {
            print("Data Saved!")
        }
    }
}

func saveLoacaly(mUserDic: NSDictionary) {
    UserDefaults.standard.set(mUserDic, forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}

func userDictionaryFrom(user: USer) -> NSDictionary {
    return NSDictionary(objects: [user.objectId, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.email, user.onBoard, user.purchasedItems], forKeys: [KOBJECTID as NSCopying, KFIRSTNAME as NSCopying, KLASTNAME as NSCopying, KFULLNAME as NSCopying, KFULLADDRESS as NSCopying, KEMAIL as NSCopying, KONBOARD as NSCopying, KPURCHAESITEMS as NSCopying])
}

func downloadUserData(userID: String, email: String) {
    FirebaseRef(.User).document(userID).getDocument { (snapShot, error) in
        guard let snapShot = snapShot else {
            return
        }
        
        if snapShot.exists {
            saveLoacaly(mUserDic: snapShot.data()! as NSDictionary)
        } else {
            let user = USer(objectId: userID, email: email, firstName: "", lastName: "")
            saveLoacaly(mUserDic: userDictionaryFrom(user: user))
            savaToFirestore(user: user)
        }
    }
}

func updateUser(withValues: [String: Any], complation: @escaping (_ errror: Error?) -> ()) {
    if let dictionary = UserDefaults.standard.object(forKey: KCURRENTUSER) {
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        FirebaseRef(.User).document(USer.currentId()).updateData(withValues) { (error) in
            complation(error)
            if error == nil {
                saveLoacaly(mUserDic: userObject)
            }
        }
    }
}
