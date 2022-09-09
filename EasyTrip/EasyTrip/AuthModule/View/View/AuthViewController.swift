//
//  AuthViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 31.08.22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
protocol AuthViewProtocol: AnyObject {
    func closeVc()
    func showAlertError(alert: UIAlertController)
    
}
class AuthViewController
: UIViewController, AuthViewProtocol {
    @IBOutlet weak var questionLabel: UILabel!
    var signUp: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Registration"
                questionLabel.text = "Do you have account?"
                enterButton.setTitle("Sign in", for: .normal)
                buttonSign.setTitle("Sign up", for: .normal)
            } else {
                titleLabel.text = "Sign in"
                questionLabel.text = "Do you want register?"
                enterButton.setTitle("Registration", for: .normal)
                buttonSign.setTitle("Sign in", for: .normal)
            }
        }
    }
    @IBOutlet weak var buttonSign: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var emailUser: UITextField!
    var presenter: AuthViewPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordUser.delegate = self
        emailUser.delegate = self
    }
    // закрытие
    func closeVc() {
        dismiss(animated: true)
    }
    // сообщение с ошибкой при регистрации
    func showAlertError(alert: UIAlertController){
        present(alert, animated: true)
    }
    // создаем нового пользователя, тлт входти по данным
    @IBAction func onSignButton(_ sender: Any) {
        guard let email = emailUser.text, let password = passwordUser.text else {return }
        if signUp {
            presenter.createUser(email: email, password: password)
        } else {
            presenter.signIn(email: email, password: password)
        }
    }
    @IBAction func onEnterButton(_ sender: Any) {
        signUp.toggle()
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
