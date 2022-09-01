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
    var db = Firestore.firestore()
//    func configureFB() -> Firestore {
//        var db: Firestore!
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings
//        db = Firestore.firestore()
//        return db
//    }
    
    // получение всех документов
    func getAllDocuments(collection: String, completion: @escaping ([FavouritesHotels?]) -> Void ) {
        db.collection(collection).getDocuments { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
            }
            if let querySnapshot = querySnapshot {
                var res: [FavouritesHotels?] = []
                for document in querySnapshot.documents {
                    guard let name = document.get("name") as? String, let url = document.get("url") as? String else { return }
                    let doc = FavouritesHotels(name: name, url: url)
                    res.append(doc)
                }
                completion(res)
            }
        }
    }
    // запись данных в базу
    func writeDate(collectionName: String, docName: String, name: String, url: String) {
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
    //удаление
    func deleteDocument(collection: String, nameDoc: String) {
        db.collection(collection).document(nameDoc).delete() { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    }
    // буду позже использовать
//    func checkFavouritesList(collection: String, nameDoc: String) {
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
