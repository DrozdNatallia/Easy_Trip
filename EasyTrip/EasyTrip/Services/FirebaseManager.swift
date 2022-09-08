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
    func upload(id: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("avatars/\(id).jpeg")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    func getIMageFromStorage(url: String, completion: @escaping (UIImage?) -> Void){
        let ref = Storage.storage().reference(forURL: url)
        let size = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: size) { data, error in
            guard let imageDate = data else { return }
            let image = UIImage(data: imageDate)
            completion(image)
        }
    }
    
    func getInfoUser(collection: String, userId: String, completion: @escaping (Users?) -> Void) {
        db.collection(collection).document(userId).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                guard let name = document.get("name") as? String, let secondName = document.get("secondName") as? String, let patronicum = document.get("patronumic") as? String, let date = document.get("dateOfBirth") as? String, let url = document.get("urlImage") as? String, let sex = document.get("sex") as? Int, let city = document.get("city") as? String else {
                    let doc = Users()
                    completion(doc)
                    return }
                let doc = Users(name: name, secondname: secondName, patronicum: patronicum, city: city, sex: sex, dateOfBirth: date, url: url)
                completion(doc)
            }
        }
    } 
    func writeUser(collectionName: String, docName: String, name: String, secondName: String, patronumic: String, date: String, url: URL, sex: Int, city: String, completion: @escaping (String?) -> Void) {
        db.collection(collectionName).document(docName).setData([
            "name": name,
            "secondName": secondName,
            "patronumic": patronumic,
            "dateOfBirth" : date,
            "urlImage" : url.absoluteString,
            "sex" : sex,
            "city" : city
        ]) { err in
            if let err = err {
                completion(nil)
                print(err.localizedDescription)
            } else {
                print("Success")
                completion("Success")
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
    
    func getCurrentUserId(completion: @escaping (String?) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            completion(uid)
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("account removed")
            }
        }
    }
    
    func writeFavourites(collection: String, docName: String, hotels: [String : String]) {
        db.collection(collection).document(docName).setData([
            "favourites": hotels
            ]) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    func getAllFavouritesDocuments(collection: String, docName: String, completion: @escaping (FavouritesHotels?) -> Void ) {
        db.collection(collection).document(docName).getDocument { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
            }
            guard let document = querySnapshot else { return }
                if let name = document.get("favourites") as? [String : String] {
                    let doc = FavouritesHotels(favourites: name)
                completion(doc)
                 } else {
                completion(nil)
            }
        }
    }

}
