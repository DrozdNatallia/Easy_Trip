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
    
}
class HotelsViewController: UIViewController, HotelsViewProtocol {

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
        presenter.getLocation()
    }
    
    func setLocation(location: String) {
        userLocation.text = location
    }
    
    @IBAction func onExploreButton(_ sender: Any) {
        presenter.tapOnButtonExplore()
    }
    
    @IBAction func onFlightsButton(_ sender: Any) {
        guard let location = userLocation.text else { return }
        presenter.tapOnButtonFlights(location: location)
    }
    @IBAction func onPlaceButton(_ sender: Any) {
        guard let location = userLocation.text else { return }
        presenter.tapOnButtonPlaces(location: location)
    }
    @IBAction func onSearchButton(_ sender: Any) {
        blur.isHidden = false
        activity.startAnimating()
        presenter.clearArray()
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let checkIn = date.string(from: checkIn.date)
        let checkOut = date.string(from: checkOut.date)
        guard let nameCity = nameCityTextField.text, let personCount = personCount.text, let adults = Int(personCount) else { return }
        presenter.getHotelsByCityName(name: nameCity, checkIn: checkIn, checkOut: checkOut, adults: adults)
    }

    func updateCollectionView() {
        blur.isHidden = true
        activity.stopAnimating()
        self.collectionView.reloadData()
    }
}

extension HotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getArrayNameHotel().count
    }
    // не получается закинуть ячкейки в презетнер (
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelsCell.key, for: indexPath) as? HotelsCell {
            cell.nameHotel.text = presenter.getArrayNameHotel()[indexPath.row]
            cell.imageView.image = presenter.getArrayImages()[indexPath.row]
            cell.url = presenter.getArrayUrl()[indexPath.row]
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
