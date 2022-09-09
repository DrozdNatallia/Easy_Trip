//
//  FlightsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit

protocol FlightsViewProtocol: AnyObject {
    func setInfoFlights()
    func setLocation(location: String)
    func updateIcon(image: UIImage)
    func stopAnimation()
}

class FlightsViewController: UIViewController, FlightsViewProtocol {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var originCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var presenter: FlightsViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FlightsViewCell", bundle: nil), forCellReuseIdentifier: FlightsViewCell.key)
        
        originCity.delegate = self
        destinationCity.delegate = self
        presenter.getIconImage()
        presenter.getLocation()
    }
    // переделать через async Await, позже переделаю
    @IBAction func onSearchButton(_ sender: Any) {
        blur.isHidden = false
        activity.startAnimating()
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let setDate = date.string(from: datePicker.date)
        guard var originName = originCity.text, var destinationName = destinationCity.text else { return }
        presenter.getCodeCityByName(code: originName) { [weak self] result in
            guard let self = self else { return }
            originName = result
            self.presenter.getCodeCityByName(code: destinationName) { [weak self] result in
                guard let self = self else { return }
                destinationName = result
                self.presenter.getFlightsInfo(originName: originName, destinationName: destinationName, date: setDate)
            }
        }
    }
    
    @IBAction func onExploreButton(_ sender: Any) {
        presenter.tapOnButtonExplore()
    }
    
    func stopAnimation(){
        blur.isHidden = true
        activity.stopAnimating()
    }
    
    func updateIcon(image: UIImage) {
        iconImage.image = image
    }
    func setLocation(location: String) {
        self.userLocation.text = location
    }
    
    func setInfoFlights() {
        stopAnimation()
        tableView.reloadData()
    }
    @IBAction func onPlaceButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImage.image else { return }
        presenter.tapOnButtonPlaces(location: location, icon: icon)
    }
    
    @IBAction func onHotelsButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImage.image else { return }
        presenter.tapOnButtonHotels(location: location, icon: icon)
    }
}

//MARK: Extension
extension FlightsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getArrayInfo(type: .price).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FlightsViewCell.key) as? FlightsViewCell {
            guard let durationInMin = presenter.getArrayInfo(type: .duration)[indexPath.section] as? Int else { return UITableViewCell() }
            let flightTime = "in flight: \(durationInMin / 60):\(durationInMin % 60)"
            let departureTime = "departure: \(presenter.getArrayInfo(type: .depart)[indexPath.section])"
            let image = presenter.getImage()[indexPath.section]
            let price = "\(presenter.getArrayInfo(type: .price)[indexPath.section])$"
            let transfer = "transfer: \n \(presenter.getArrayInfo(type: .transfer)[indexPath.section])"
            let origin = "From: \(presenter.getArrayInfo(type: .origin)[indexPath.section])"
            let destination = "To: \n \(presenter.getArrayInfo(type: .destination)[indexPath.section])"
            
            cell.presenter.getInfoFlight(originCity: origin, destinationCity: destination, priceFlights: price, transferFlight: transfer, flightTime: flightTime, icon: image, depart: departureTime)
            return cell
        }
        return UITableViewCell()
    }
}

extension FlightsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
