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
        func fillTextField(name: String?, secondName: String?, patronicum: String?, date: String?, image: UIImage?, sex: Int?, city: String?)
        
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
            chooseSexUser.dataSource = self
            chooseSexUser.delegate = self
            
            nameCityTextField.delegate = self
            patronymicUser.delegate = self
            nameUser.delegate = self
            secondNameUser.delegate = self
            presenter.fillField()
        }
        @IBAction func onSignOutButton(_ sender: Any) {
            presenter.signOut()
        }
        func fillTextField(name: String?, secondName: String?, patronicum: String?, date: String?, image: UIImage?, sex: Int?, city: String?) {
            guard let name = name, let secondName = secondName, let patronicum = patronicum, let date = date, let image = image, let sex = sex, let city = city else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dayBirth = dateFormatter.date(from: date)
            if let dayBirth = dayBirth {
                dateBirth.date = dayBirth
            }
            nameCityTextField.text = city
            nameUser.text = name
            secondNameUser.text = secondName
            patronymicUser.text = patronicum
            iconImageView.image = image
            chooseSexUser.selectRow(sex, inComponent: 0, animated: true)
            
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
            let row = chooseSexUser.selectedRow(inComponent: 0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dayBitrh = dateFormatter.string(from: dateBirth.date)
            
            guard let name = nameUser.text, let secondName = secondNameUser.text, let patronymic = patronymicUser.text, let image = iconImageView.image, let city = nameCityTextField.text else {
                return
            }
            presenter.upload(id: id, image: image) { result in
                switch result {
                case .success(let url):
                    self.presenter.writeUser(collectionName: "User", docName: id, name: name, secondName: secondName, patronumic: patronymic, date: dayBitrh, url: url, sex: row, city: city)
                case .failure(let error):
                    print(error.localizedDescription)
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

extension PersonalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerDate = ["female", "male"]
        return pickerDate[row]
    }

}

extension PersonalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
