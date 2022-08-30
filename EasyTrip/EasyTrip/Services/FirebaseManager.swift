//
//  FirebaseManager.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 26.08.22.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: FirebaseProtocol {
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    // получение всех документов
    func getAllDocuments(collection: String, completion: @escaping ([FavouritesHotels?]) -> Void ) {
        let db = configureFB()
        db.collection(collection).getDocuments { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
            }
            if let querySnapshot = querySnapshot {
                var res: [FavouritesHotels?] = []
                for document in querySnapshot.documents {
                    let doc = FavouritesHotels(name: document.get("name") as! String, url: document.get("url") as! String)
                    res.append(doc)
                }
                completion(res)
            }
        }
    }
    // запись данных в базу
    func writeDate(collectionName: String, docName: String, name: String, url: String) {
        let db = configureFB()
        db.collection(collectionName).document(docName).setData([
            "name": name,
            "url": url
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Document successfully written!")
            }
        }
    }
    // буду позже использовать
//    func checkFavouritesList(collection: String, nameDoc: String) {
//        let db = configureFB()
//        print(db.collection(collection).whereField("name", isEqualTo: nameDoc))
//        db.collection(collection).whereField("name", isEqualTo: "Minsk")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print(document.data())
//                }
//            }
//        }
//    }
}
