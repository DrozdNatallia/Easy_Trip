//
//  FirebaseProvaiderProtocol.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 29.08.22.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

protocol FirebaseProtocol {
    func getIMageFromStorage(url: String, completion: @escaping (UIImage?) -> Void)
    func upload(id: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void)
    func deleteDocument(collection: String, nameDoc: String)
    func createUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func signOut()
    func getCurrentUserId(completion: @escaping (String?) -> Void)
    func writeUser(collectionName: String, docName: String, name: String, secondName: String, patronumic: String, date: String, url: URL, sex: Int, city: String, completion: @escaping (String?) -> Void)
    func deleteUser()
    func getInfoUser(collection: String, userId: String, completion: @escaping (Users?) -> Void )
    func getAllFavouritesDocuments(collection: String, docName: String, completion: @escaping (FavouritesHotels?) -> Void )
    func writeFavourites(collection: String, docName: String, hotels: [String : String])
    func reauthenticate(password: String, completion: @escaping (Error?) -> Void)
}
