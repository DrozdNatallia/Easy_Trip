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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PopularFlightsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PopularFlightsCollectionViewCell.key)
        // экземпляр класса в котором хранится массив имен популярных городов, и картинок
        coreManager.delegate = self
        coreManager.requestWhenInUseAuthorization()
        
    }
    // функция для работы pageControl
      func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
    }
    @IBAction func onFlightsButton(_ sender: Any) {
        let vc = HomeBuilderClass.createFlightsModule()
        
        vc.modalPresentationStyle = .fullScreen
        
      //  navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    // поиск по заданному направлению
    @IBAction func onSearchButton(_ sender: Any) {
        presenter.clearArrays()
        guard let nameDirection = searchDirection.text else {return}
        // функция конвертирует полное имя в IATA - код
        presenter.getNamePopularCityByCode(code: nameDirection, isName: false)
    }
    
    // Получение имени города по коду/ код города по имени
    func setPopularFlights(city: String, isName: Bool){
        //если получили полное имя(т.к. может быть код), то добавдяем в массив и обновляем таблицу
        if isName {
            self.collectionView.reloadData()
        } else {
            // если получен код, то вызываем функцию для получения популярных полетов
            presenter.getPopularFlights(nameDirection: city)
        }
    }
    
    
    
    
   
    
    
    
    
    
    
    
    
    

    // Эти функции нужны, пока закоменчены, т.к. пока не реализованы
    /*
     // получение отелей по имени города
     fileprivate func getHotelsByCityName() {
     alamofireProvaider.getHoltelsByCityName(name: "moscow") { result in
     switch result {
     case .success(let value):
     guard let val = value.results, let hotels = val.hotels else {return}
     for hotel in hotels {
     // название отеля
     print(hotel.fullName)
     // по id, можно получить фото отеля
     print("id: \(hotel.id)")
     }
     
     case .failure(let error):
     print(error.localizedDescription)
     }
     }
     }
     // получение инфы о полетах
     fileprivate func getFlightInfo() {
     alamofireProvaider.getFlightsInfo(origin: "MOW", date: "2202-11", destination: "BCN")  { result in
     switch result {
     case .success(let value):
     guard let val = value.data else {return}
     for flight in val.values {
     // все билеты по указанному направлению за месяц, можно ограничить
     print("price: \(flight.price)")
     print("дата возвращения: \(flight.returnAt)")
     print("дата вылета: \(flight.departureAt)")
     print("номер рейса: \(flight.flightNumber)")
     }
     case .failure(let error):
     print(error.localizedDescription)
     }
     }
     }
     // получение инфы об экскурсиях
     fileprivate func getExcursionInfo() {
     alamofireProvaider.getExcursionInfo(codeCity: "LON") { result in
     switch result {
     case .success(let value):
     guard let val = value.data else {return}
     for exc in val {
     // название экскурсий
     print(exc.content)
     }
     case .failure(let error):
     print(error.localizedDescription)
     }
     }
     }
     */
}


//MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getArrayNameCity().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularFlightsCollectionViewCell.key, for: indexPath) as? PopularFlightsCollectionViewCell {
            cell.namePopularCity.text = presenter.getArrayNameCity()[indexPath.row]
            cell.imagePopularCity.image = presenter.getArrayImageCity()[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: CLLOcation
extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            coreManager.startUpdatingLocation()
        } else if manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied {
            // если отказано в получении геолокации, то будет лондон, возможно потом буду передавать город из личного кабинета
            self.userLocation.text = "LONDON"
            presenter.getPopularFlights(nameDirection: "LON")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locations = locations.last else { return }
        let userLocation = locations as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
            }
            if let placemarks = placemarks, let placemark = placemarks.first, let locality = placemark.locality {
                // функция вызывается 3 раза так как стоит kCLLocationAccuracyBest, чтоб запрос тоже не вызывался 3 раза присваиваю значение, только если его не было. Обновляется при каждом запуске приложения, больше Геолокация не нужна. Другого способа пока не придумала
                if self.userLocation.text == "" {
                    self.userLocation.text = locality
                    self.presenter.getNamePopularCityByCode(code: locality, isName: false)
                }
            }
        }
        coreManager.stopUpdatingLocation()
    }
}
