//
//  PlacesViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 22.08.22.
//

import UIKit

protocol PlacesViewProtocol: AnyObject {
    func updateTableView()
    func setInfoExc(code: String)
    func setLocation(location: String)
    func setIconImage(image: UIImage)
    func stopAnimation()
}

class PlacesViewController: UIViewController, PlacesViewProtocol, PlacesCellDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var endDate: UIDatePicker!

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var countChild: UITextField!
    @IBOutlet weak var countAdults: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameCityArea: UITextField!
    @IBOutlet weak var userLocation: UILabel!
    var presenter: PlacesViewPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PlacesViewCell", bundle: nil), forCellReuseIdentifier: PlacesViewCell.key)
        
        countChild.delegate = self
        countAdults.delegate = self
        nameCityArea.delegate = self
        presenter.addIconImage()
        presenter.getLocation()
    }
    
    func setIconImage(image: UIImage) {
        iconImage.image = image
    }
    func setLocation(location: String) {
        userLocation.text = location
    }
    
    func stopAnimation(){
        blur.isHidden = true
        activity.stopAnimating()
    }
    
    @IBAction func onExploreButton(_ sender: Any) {
        presenter.tapOnButtonExplore()
    }
    
    @IBAction func onFlightsButton(_ sender: Any) {
        guard let location = userLocation.text, let image = iconImage.image else { return }
        presenter.tapOnButtonFlights(location: location, icon: image)
    }
    @IBAction func onHotelsButton(_ sender: Any) {
        guard let location = userLocation.text, let image = iconImage.image else { return }
        presenter.tapOnButtonHotels(location: location, icon: image)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        activity.startAnimating()
        blur.isHidden = false
        presenter.clearArray()
        guard let name = nameCityArea.text else { return }
        presenter.getCodeByNameCity(code: name)
    }
  
    func setInfoExc(code: String){
        guard let adults = countAdults.text, let children = countChild.text else {
            return
        }
        presenter.getExcursionInfo(code: code, start: startDate.date, end: endDate.date, adults: adults, child: children)
    }
    
    func updateTableView() {
        stopAnimation()
        tableView.reloadData()
    }
    
    func showAlertFromCell(cell: PlacesCellProtocol, didTapButton button: UIButton) {
            let alert = UIAlertController(title: "Added to favourites", message: nil, preferredStyle: .alert)
            let button = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(button)
            present(alert, animated: true)
    }
   
}


extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getArrayNameExc().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesViewCell.key) as? PlacesViewCell {
            cell.delegate = self
            cell.presenter.fieldCell(image: presenter.getArrayImage()[indexPath.section], excPrice: presenter.getArrayPrice()[indexPath.section].description, name: presenter.getArrayNameExc()[indexPath.section], urlPlaces: presenter.getArrayUrl()[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
}

extension PlacesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
