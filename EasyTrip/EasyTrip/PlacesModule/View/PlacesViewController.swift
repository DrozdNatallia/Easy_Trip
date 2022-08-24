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
}

class PlacesViewController: UIViewController, PlacesViewProtocol {

    @IBOutlet weak var endDate: UIDatePicker!

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
    @IBAction func onHotelsButton(_ sender: Any) {
        guard let location = userLocation.text else { return }
        presenter.tapOnButtonHotels(location: location)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
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
        tableView.reloadData()
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
            cell.excursionImage.image = presenter.getArrayImage()[indexPath.section]
            cell.nameExcursion.text = presenter.getArrayNameExc()[indexPath.section]
            cell.price.text = presenter.getArrayPrice()[indexPath.section].description
            return cell
        }
        return UITableViewCell()
    }
    
}
