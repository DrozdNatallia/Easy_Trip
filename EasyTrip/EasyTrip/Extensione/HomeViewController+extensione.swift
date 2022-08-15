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
        popularCity.getarrayNameCity().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularFlightsCollectionViewCell.key, for: indexPath) as? PopularFlightsCollectionViewCell {
            cell.namePopularCity.text = popularCity.getarrayNameCity()[indexPath.row]
            cell.imagePopularCity.image = popularCity.getarrayImageCity()[indexPath.row]
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
            self.userLocation.text = "LONDON"
            self.getPopularFlights(localCodeCity: "LON")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
            }
            if let placemarks = placemarks, let placemark = placemarks.first, let locality = placemark.locality {
                // функция вызывается 3 раза так как стоит kCLLocationAccuracyBest, чтоб запрос тоже не вызывался 3 раза. 
                if self.userLocation.text == "" {
                    self.userLocation.text = locality
                    self.getNamePopularCityByCode(code: locality, isName: false) { result in
                        self.getPopularFlights(localCodeCity: result)
                    }
                }
            }
        }
    }
}
