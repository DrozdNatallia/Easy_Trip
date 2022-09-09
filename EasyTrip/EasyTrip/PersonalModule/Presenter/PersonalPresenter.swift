//
//  PersonalPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 1.09.22.
//

import Foundation
import UIKit
import FirebaseStorage

protocol PersonalViewPresenterProtocol {
    func signOut()
    func deleteUser()
    func getIdCurrentUser()
    func writeUser(collectionName: String, docName: String, name: String, secondName: String, patronumic: String, date: String, url: URL, sex: Int, city: String)
    func fillField()
    func upload(id: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void)
    func deleteDocument(id: String)
    
}

class PersonalPresenter: PersonalViewPresenterProtocol {
    
    private weak var view: PersonalViewProtocol!
    private var router: RouterProtocol?
    private var firebaseProvaider: FirebaseProtocol!
    
    required init(view: PersonalViewProtocol, provaider: FirebaseProtocol, router: RouterProtocol) {
        self.view = view
        self.firebaseProvaider = provaider
        self.router = router
    }
    // добавление картинки в сторэдж
    func upload(id: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void){
        firebaseProvaider.upload(id: id, image: image) { result in
            switch result {
            case .success(_):
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //удаление пользователя
    func deleteDocument(id: String) {
        firebaseProvaider.deleteDocument(collection: "User", nameDoc: id)
    }
    // заполнение всех полей ( если данные были ранее сохранены)
    func fillField() {
        firebaseProvaider.getCurrentUserId { id in
            guard let id = id else { return }
            self.firebaseProvaider.getInfoUser(collection: "User", userId: id) { [weak self] user in
                guard let self = self else { return }
                if let user = user {
                    guard let name = user.name, let secondName = user.secondname, let patronicum = user.patronicum, let date = user.dateOfBirth, let url = user.url, let sex = user.sex, let city = user.city else { self.view.stopAnimating()
                        return }
                    self.firebaseProvaider.getIMageFromStorage(url: url) { [weak self] image in
                        guard let self = self else { return }
                        self.view.fillTextField(name: name, secondName: secondName, patronicum: patronicum, date: date, image: image, sex: sex, city: city, id: id)
                    }
                }
            }
        }
    }
    // выход из аккаунта
    func signOut() {
        firebaseProvaider.signOut()
    }
    // удаление пользователя
    func deleteUser() {
        firebaseProvaider.deleteUser()
    }
    // получение номера
    func getIdCurrentUser() {
        firebaseProvaider.getCurrentUserId { [weak self] id in
            guard let self = self, let id = id else {
                return
            }
            self.view.writeUser(id: id)
        }
    }
    // запись пользователя в базу данных
    func writeUser(collectionName: String, docName: String, name: String, secondName: String, patronumic: String, date: String, url: URL, sex: Int, city: String) {
        firebaseProvaider.writeUser(collectionName: collectionName, docName: docName, name: name, secondName: secondName, patronumic: patronumic, date: date, url: url, sex: sex, city: city) { result in
            guard result != nil else {
                return
            }
            self.view.showAlert()
        }
    }
}
