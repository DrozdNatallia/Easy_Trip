//
//  AuthPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 1.09.22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthViewPresenterProtocol {
    func createUser(email: String, password: String)
    func signIn(email: String, password: String)
    func signOut()
    func showAlert(message: String)
}

class AuthPresenter: AuthViewPresenterProtocol {
    private weak var view: AuthViewProtocol?
    private var router: RouterProtocol?
    private var firebaseProvaider: FirebaseProtocol!
    
    required init(view: AuthViewProtocol, provaider: FirebaseProtocol, router: RouterProtocol) {
        self.view = view
        self.firebaseProvaider = provaider
        self.router = router
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(button)
        view?.showAlertError(alert: alert)
    }
    
    func createUser(email: String, password: String) {
        firebaseProvaider.createUser(email: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let err = error {
                self.showAlert(message: err.localizedDescription)
            }
            if authResult != nil {
                self.view?.closeVc()
            }
        }
    }
    
    func signIn(email: String, password: String) {
        firebaseProvaider.signIn(email: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            }
            if authResult != nil {
                self.view?.closeVc()
            }
        }
    }
    // выход из аккаунта в личном кабинете. Будет настроен позже
    func signOut() {
        firebaseProvaider.signOut()
        
    }
}
