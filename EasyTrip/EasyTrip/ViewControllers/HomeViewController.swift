//
//  ViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import UIKit
import Alamofire
import CoreLocation

class HomeViewController: UIViewController {
    // точечки для скрола картинок
    @IBOutlet weak var pageControl: UIPageControl!
    // менеджер corelocation
    lazy var coreManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    // техтовое поле для поиска направлений
    @IBOutlet weak var searchDirection: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    // лэйбл для локации
    @IBOutlet weak var userLocation: UILabel!
    var alamofireProvaider = AlamofireProvaider()
    
    @IBOutlet weak var collectionView: UICollectionView!
    // экземпляр в котором хранятся массивы с картинками и именами популярных направлений
    var popularCity: PopulareCityDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PopularFlightsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PopularFlightsCollectionViewCell.key)
        // экземпляр класса в котором хранится массив имен популярных городов, и картинок
        popularCity = PopulareCityDate()
        
        coreManager.delegate = self
        coreManager.requestWhenInUseAuthorization()
        // функции нужны для теста, потом уберу
        //getPopularFlights(localCodeCity: "MOW" )
        // getHotelsByCityName()
        // getFlightInfo()
        // getExcursionInfo()
        
    }
    // функция для работы pageControl
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            pageControl.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
        }
    // поиск по заданному направлению
    @IBAction func onSearchButton(_ sender: Any) {
        // чистим массивы имеющихся картинок и имен
        self.popularCity.removePopularcityDate()
        guard let nameDirection = searchDirection.text else {return}
        getNamePopularCityByCode(code: nameDirection, isName: false) { code in
            self.getPopularFlights(localCodeCity: code)
        }
    }
    // получение картинки по URL
    func getImagebyURL(url: String) -> UIImage {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return UIImage()}
                return icon
            } catch _ {
                print("error")
            }
        }
        return UIImage()
    }
    
    // Получение имени города по коду/ код города по имени
    func getNamePopularCityByCode(code: String, isName: Bool, completion: @escaping (String) -> Void){
        alamofireProvaider.getNameCityByCode(code: code) { result in
            switch result {
            case .success(let value):
                // некоторых городов нет в базе, в этом случае  направления будут стандартные
                guard !value.isEmpty else {
                    completion (isName ? "SanFrancisco" : "SFO")
                    return
                }
                guard let name = value.first?.name, let code = value.first?.code else { return }
                completion(isName ? name : code)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // получение популярных направлений, в параметре передаем код города геолокации
    func getPopularFlights(localCodeCity: String) {
        alamofireProvaider.getPopularFlights(country: localCodeCity) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let date = value.data, !date.isEmpty else {
                    guard let image = UIImage(named: "error2.jpeg") else { return }
                    self.popularCity.addNewImage(image: image)
                    self.popularCity.addNewName(name: "Sorry! Directions not found.")
                    self.collectionView.reloadData()
                    return}
                for flight in date.values {
                    // код страны прибытия
                    guard let destination = flight.destination else {return}
                    let size = Int(self.view.frame.width)
                    let url = Constants.getImageCityByURL + "\(size)x250/" + "\(destination).jpg"
                    // добавляем массив картинок
                    self.popularCity.addNewImage(image: self.getImagebyURL(url: url))
                    self.getNamePopularCityByCode(code: destination, isName: true) { result in
                        // добавляем массив имен
                        self.popularCity.addNewName(name: result)
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
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
