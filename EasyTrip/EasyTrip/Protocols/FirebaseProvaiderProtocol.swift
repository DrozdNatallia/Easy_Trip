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
    func getAllDocuments(collection: String, completion: @escaping ([FavouritesHotels?]) -> Void )
    func writeDate(collectionName: String, docName: String, name: String, url: String)
    func deleteDocument(collection: String, nameDoc: String)
   // func checkFavouritesList(collection: String, nameDoc: String)
}
