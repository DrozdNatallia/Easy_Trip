//
//  PlacesViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 22.08.22.
//

import UIKit

protocol PlacesViewProtocol: AnyObject {
    func updateTableView()

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

    }

    @IBAction func onExploreButton(_ sender: Any) {
    }
    
    @IBAction func onFlightsButton(_ sender: Any) {
    }
    @IBAction func onHotelsButton(_ sender: Any) {
    }
    @IBAction func onPlacesButton(_ sender: Any) {
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        presenter.getExcursionInfo(code: "LON")
    }
    func updateTableView() {
        tableView.reloadData()
    }
}


extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getArrayPrice().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesViewCell.key) as? PlacesViewCell {
            cell.nameExcursion.text = presenter.getArrayNameExc()[indexPath.row]
            cell.price.text = presenter.getArrayPrice()[indexPath.row].description
            return cell
        }
        return UITableViewCell()
    }
    
}
