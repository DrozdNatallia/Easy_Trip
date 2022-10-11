//
//  ViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import UIKit
import Alamofire
import CoreLocation

protocol HomeViewProtocol: AnyObject {
    func setPopularFlights(city: String, isName: Bool)
    func updateIcon(image: UIImage)
}
// Попыталась переделать паттерн, не факт, что правильно, но как есть. Возможно, немного смесь получилась
class HomeViewController: UIViewController, HomeViewProtocol {
    
    // точечки для скрола картинок
    @IBOutlet weak var pageControl: UIPageControl!
    // менеджер corelocation
    lazy var coreManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blur: UIVisualEffectView!
    // текстовое поле для поиска направлений
    @IBOutlet weak var searchDirection: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    // лэйбл для локации
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    // экземпляр в котором хранятся массивы с картинками и именами популярных направлений
    var presenter: HomeViewPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDirection.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PopularFlightsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PopularFlightsCollectionViewCell.key)
        blur.isHidden = false
        activityIndicator.startAnimating()
        coreManager.delegate = self
        coreManager.requestWhenInUseAuthorization()
    }
    // функция для работы pageControl
      func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
    }
    func stopAnimating(){
        blur.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func updateIcon(image: UIImage) {
        iconImageView.image = image
    }
    @IBAction func onHotelsButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImageView.image else { return }
        presenter.tapOnButtonHotels(location: location, icon: icon)
    }
    
    @IBAction func onPlacesButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImageView.image else { return }
        presenter.tapOnButtonPlaces(location: location, icon: icon)
    }
    @IBAction func onFlightsButton(_ sender: Any) {
        guard let location = userLocation.text else { return }
        presenter.tapOnButton(location: location, icon: iconImageView.image)
    }
    
    // поиск по заданному направлению
    @IBAction func onSearchButton(_ sender: Any) {
        blur.isHidden = false
        activityIndicator.startAnimating()
        presenter.clearArrays()
        guard let nameDirection = searchDirection.text else {return}
        // функция конвертирует полное имя в IATA - код
        presenter.getNamePopularCityByCode(code: nameDirection, isName: false)
    }
    
    // Получение имени города по коду/ код города по имени
    func setPopularFlights(city: String, isName: Bool){
        //если получили полное имя(т.к. может быть код), то добавдяем в массив и обновляем таблицу
        if isName {
            self.stopAnimating()
            self.collectionView.reloadData()
        } else {
            // если получен код, то вызываем функцию для получения популярных полетов
            presenter.getPopularFlights(nameDirection: city)
        }
    }
}


//MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getArrayNameCity().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularFlightsCollectionViewCell.key, for: indexPath) as? PopularFlightsCollectionViewCell {
        // заполнение ячеек через перезентер
            presenter.configure(cell: cell, row: indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: CLLOcation
extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            self.stopAnimating()
            coreManager.startUpdatingLocation()
            
        } else if manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied {
            self.userLocation.text = "LONDON"
            presenter.getPopularFlights(nameDirection: "LON")
        }
    }
    // 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locations = locations.last else {
            self.stopAnimating()
            return }
        let userLocation = locations as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                self.stopAnimating()
                print(error.localizedDescription)
            }
            if let placemarks = placemarks, let placemark = placemarks.first, let locality = placemark.locality, self.userLocation.text == "" {
                // функция вызывается 3 раза так как стоит kCLLocationAccuracyBest, чтоб запрос тоже не вызывался 3 раза присваиваю значение, только если его не было. Обновляется при каждом запуске приложения, больше Геолокация не нужна. Другого способа пока не придумала
                    self.userLocation.text = locality
                    self.presenter.addImageFromStorage()
                    self.presenter.getNamePopularCityByCode(code: locality, isName: false)
            }
        }
        self.stopAnimating()
        coreManager.stopUpdatingLocation()
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
