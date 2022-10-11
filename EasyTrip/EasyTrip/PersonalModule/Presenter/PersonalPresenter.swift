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
    func reauthenticate(password: String)
    func showAlertWithMessage(message: String)
    func showAlertWithPassword()
}

final class PersonalPresenter: PersonalViewPresenterProtocol {
    
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
        firebaseProvaider.getCurrentUserId { [weak self] id in
            guard let id = id, let self = self else { return }
            self.firebaseProvaider.getInfoUser(collection: "User", userId: id) { [weak self] user in
                guard let self = self, let user = user else { return }
                    guard let name = user.name, let secondName = user.secondname, let patronicum = user.patronicum, let date = user.dateOfBirth, let url = user.url, let sex = user.sex, let city = user.city else {
                        self.view.stopAnimating()
                        return
                    }
                    self.firebaseProvaider.getIMageFromStorage(url: url) { [weak self] image in
                        guard let self = self else { return }
                        self.view.fillTextField(name: name, secondName: secondName, patronicum: patronicum, date: date, image: image, sex: sex, city: city, id: id)
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
        firebaseProvaider.writeUser(collectionName: collectionName, docName: docName, name: name, secondName: secondName, patronumic: patronumic, date: date, url: url, sex: sex, city: city) { [weak self] result in
            guard let self = self, result != nil else {
                return
            }
            self.showAlertWithMessage(message: "Success")
        }
    }
    // алерт с запросом пароля
    func showAlertWithPassword(){
        var pass: UITextField!
        let alert = UIAlertController(title: "Do you want delete your accout?", message: "Enter your password", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter password"
            pass = textField
        }
        let deletButton = UIAlertAction(title: "Delete", style: .default) { _ in
            guard let pass = pass.text else { return }
            self.reauthenticate(password: pass)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(deletButton)
        alert.addAction(cancelButton)
        self.view.showAlert(alert: alert)
    }
    // алерт с сообщением о сохранении данных в базу
    func showAlertWithMessage(message: String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(button)
        self.view.showAlert(alert: alert)
    }
    
    func reauthenticate(password: String){
        firebaseProvaider.reauthenticate(password: password) { [weak self] error in
            guard let self = self else { return}
            if let error = error {
                self.showAlertWithMessage(message: error.localizedDescription)
            }
        }
    }
}
