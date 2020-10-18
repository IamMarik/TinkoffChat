//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Dzhanybaev Marat on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Themes.loadApplicationTheme()
        FirebaseApp.configure()
 /*
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
   
        let ref2 = db.collection("channels").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        db.collection("channels").document("TFS Channel")
        
        
        db.collection("channels/TFS Channel/messages").addDocument(data: [
            "content": "Я здесь",
            "created": "\(Date().timeIntervalSince1970)",
            "senderName": "Марат Джаныбаев"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
 */
//
//        db.collection("channels").document("TFS Channel").setData([
//            "content": "Я здесь",
//            "created": "\(Date().timeIntervalSince1970)",
//            "senderName": "Марат Джаныбаев"
//        ])
//        let ref3 = db.collection("channels").document("TFS Channel").collection("messages").addDocument(data: [
//                        "content": "Я здесь",
//                        "created": "\(Date().timeIntervalSince1970)",
//                        "senderName": "Марат Джаныбаев"
//                    ]) { err in
//                        if let err = err {
//                            print("Error adding document: \(err)")
//                        } else {
//                            print("Document added with ID: \(ref!.documentID)")
//                        }
//                    }
//
//
//        db.collection("channels").document("TFS Channel")
//            .addSnapshotListener { documentSnapshot, error in
//              guard let document = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//              }
//              guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//              }
//              print("Current data: \(data)")
//            }

//        ref = db.collection("channels").addDocument(data: [
//            "content": "Я здесь",
//            "created": "\(Date().timeIntervalSince1970)",
//            "senderName": "Марат Джаныбаев"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        return true
    }

}
