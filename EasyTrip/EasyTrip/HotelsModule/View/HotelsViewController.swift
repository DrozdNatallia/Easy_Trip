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
        presenter.getLocation()
    }
    
    func setLocation(location: String) {
        userLocation.text = location
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        presenter.clearArray()
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let checkIn = date.string(from: checkIn.date)
        let checkOut = date.string(from: checkOut.date)
        guard let nameCity = nameCityTextField.text, let personCount = personCount.text, let adults = Int(personCount) else { return }
        presenter.getHotelsByCityName(name: nameCity, checkIn: checkIn, checkOut: checkOut, adults: adults)
    }

    func updateCollectionView() {
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
            return cell
        }
       return UICollectionViewCell()
    }
    
}
