//
//  HotelsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit
protocol HotelsViewProtocol: AnyObject {
    func updateCollectionView()
    func setLocation(location: String)
    func addIconImage(image: UIImage)
    func stopAnimation()
    func showAlertWithMassage()
    
}
class HotelsViewController: UIViewController, HotelsViewProtocol, HotelsCellDelegate {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var personCount: UITextField!
    @IBOutlet weak var checkIn: UIDatePicker!
    @IBOutlet weak var checkOut: UIDatePicker!
    @IBOutlet weak var nameCityTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: HotelsViewPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HotelsCell", bundle: nil), forCellWithReuseIdentifier: HotelsCell.key)
        
        personCount.delegate = self
        nameCityTextField.delegate = self
        presenter.getIconImage()
        presenter.getLocation()
    }
    // добавление тконки пользователя
    func addIconImage(image: UIImage) {
        iconImage.image = image
    }
    // установление локации
    func setLocation(location: String) {
        userLocation.text = location
    }
    // оставнока анимации ксли нет отелей
    func stopAnimation(){
        blur.isHidden = true
        activity.stopAnimating()
    }
    // переход на HomeViewController
    @IBAction func onExploreButton(_ sender: Any) {
        presenter.tapOnButtonExplore()
    }
    // переход на FlightsViewController
    @IBAction func onFlightsButton(_ sender: Any) {
        guard let location = userLocation.text, let image = iconImage.image else { return }
        presenter.tapOnButtonFlights(location: location, icon: image)
    }
    // переход на placesViewController
    @IBAction func onPlaceButton(_ sender: Any) {
        guard let location = userLocation.text, let image = iconImage.image else { return }
        presenter.tapOnButtonPlaces(location: location, icon: image)
    }
    
    // поиск отелей после нажатия на кнопку
    @IBAction func onSearchButton(_ sender: Any) {
        blur.isHidden = false
        activity.startAnimating()
        presenter.clearArray()
        let checkIn = checkIn.date.convertDateToString(formattedType: .date)
        let checkOut = checkOut.date.convertDateToString(formattedType: .date)
        guard let nameCity = nameCityTextField.text, let personCount = personCount.text, let adults = Int(personCount) else { return }
        presenter.getHotelsByCityName(name: nameCity, checkIn: checkIn, checkOut: checkOut, adults: adults)
    }
// обновление таблицы, когда получены результаты
    func updateCollectionView() {
        stopAnimation()
        self.collectionView.reloadData()
    }
 // алерт с сообщенией еслт отель добавлен в избранное
    func showAlertWithMassage() {
        let alert = UIAlertController(title: "Added to favourites", message: nil, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    
    func getInfoAboutHotel(name: String, url: String) {
        presenter.getIdUser { [weak self] id in
            guard let self = self, let id = id else { return }
            self.presenter.getFavouritesHotels(id: id, name: name, url: url)
        }
    }
    
    func addRowCell(row: Int) {
        presenter.addRowCell(row: row)
    }
    
}

extension HotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getArrayNameHotel().count
    }
    // не получается закинуть ячкейки в презетнер (
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelsCell.key, for: indexPath) as? HotelsCell {
            //заполненение ячеек через презентер
            cell.delegate = self
//            if presenter.getArrayRows().contains(indexPath.row) {
//                cell.likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            } else {
//                cell.likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            }
            presenter.configure(cell: cell, section: indexPath.row)
            
            return cell
        }
       return UICollectionViewCell()
    }
    
}

extension HotelsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
