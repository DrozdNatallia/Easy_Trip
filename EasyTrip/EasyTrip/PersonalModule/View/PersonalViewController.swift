    //
    //  PersonalViewController.swift
    //  EasyTrip
    //
    //  Created by Natalia Drozd on 25.08.22.
    //

    import UIKit
    import FirebaseStorage
    protocol PersonalViewProtocol: AnyObject {
        func writeUser(id: String)
        func fillTextField(name: String?, secondName: String?, patronicum: String?, date: String?, image: UIImage?)
        
    }
    class PersonalViewController: UIViewController, PersonalViewProtocol {
        var presenter: PersonalViewPresenterProtocol!
        @IBOutlet weak var cityUser: UITextField!
        @IBOutlet weak var dateBirth: UIDatePicker!
        @IBOutlet weak var chooseSexUser: UIPickerView!
        @IBOutlet weak var iconImageView: UIImageView!
        @IBOutlet weak var secondNameUser: UITextField!
        @IBOutlet weak var nameUser: UITextField!
        @IBOutlet weak var chooseImageButton: UIButton!
        @IBOutlet weak var patronymicUser: UITextField!
        @IBOutlet weak var nameCityTextField: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.fillField()
            
        }
        
        @IBAction func onSignOutButton(_ sender: Any) {
            presenter.signOut()
        }
        
        func fillTextField(name: String?, secondName: String?, patronicum: String?, date: String?, image: UIImage?) {
            guard let name = name, let secondName = secondName, let patronicum = patronicum, let date = date, let image = image else { return }
            nameUser.text = name
            secondNameUser.text = secondName
            patronymicUser.text = patronicum
            iconImageView.image = image
        }
        
        
        @IBAction func onDeleteAccountButton(_ sender: Any) {
            presenter.deleteUser()
        }
        
        
        @IBAction func onAddPhotoButton(_ sender: Any) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        
        @IBAction func onSaveButton(_ sender: Any) {
            presenter.getIdCurrentUser()
        }
        
        func writeUser(id: String) {
            guard let name = nameUser.text, let secondName = secondNameUser.text, let patronymic = patronymicUser.text, let image = iconImageView.image else {
                return
            }
            let dateFormatter = DateFormatter()
            let strDate = dateFormatter.string(from: dateBirth.date)
            presenter.upload(id: id, image: image) { result in
                switch result {
                case .success(let url):
                    self.presenter.writeUser(collectionName: "User", docName: id, name: name, secondName: secondName, patronumic: patronymic, date: strDate, url: url)
                case .failure(_):
                    print("ERROR")
                }
            }
        }
    }

    extension PersonalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageURL = info[.imageURL] as? URL,
               let image = info[.originalImage] as? UIImage {
                iconImageView.image = image
                let imageJPEG = image.jpegData(compressionQuality: 1)
                do {
                    try imageJPEG?.write(to: imageURL)
                    
                } catch {
                    print (error.localizedDescription)
                }
                self.dismiss(animated: true)
            }
        }
    }
