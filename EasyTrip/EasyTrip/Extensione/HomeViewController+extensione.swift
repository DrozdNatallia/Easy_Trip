//
//  HomeViewController+extensione.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 10.08.22.
//

import Foundation
import UIKit
import CoreLocation

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
