//
//  FlightsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit

protocol FlightsViewProtocol: AnyObject {
    func setInfoFlights()
}

class FlightsViewController: UIViewController, FlightsViewProtocol {
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
        
    }
    // переделать через async Await
    @IBAction func onSearchButton(_ sender: Any) {
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
    
    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setInfoFlights() {
        tableView.reloadData()
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
            
//            let isoDate = "\(presenter.getArrayInfo(type: .depart)[indexPath.section])"
//            print (isoDate)
//            let isoDateFormatter = ISO8601DateFormatter()
//            isoDateFormatter.timeZone = .init(abbreviation: "UTC")
//            // isoDateFormatter.formatOptions = .withFullTime
//            let date = isoDateFormatter.date(from: isoDate)
//            print(isoDateFormatter.string(from: date!))
//            print(date)
//            var dateе = DateFormatter()
//            dateе.dateFormat = "HH:mm"
//            dateе.timeZone = .init(abbreviation: "UTC")
//            print(dateе.date(from: isoDate))
//            print(dateе.string(from: date!))
            
            cell.iconAirlines.image = presenter.getImage()[indexPath.section]
            cell.price.text = "\(presenter.getArrayInfo(type: .price)[indexPath.section]) $"
            cell.transfer.text = "пересадок: \(presenter.getArrayInfo(type: .transfer)[indexPath.section])"
            cell.departAt.text = "\(presenter.getArrayInfo(type: .depart)[indexPath.section])"
            cell.origin.text = "\(presenter.getArrayInfo(type: .origin)[indexPath.section])"
            cell.destination.text = "\(presenter.getArrayInfo(type: .destination)[indexPath.section])"
            cell.timeInFlight.text = "\(presenter.getArrayInfo(type: .duration)[indexPath.section])"
            //  cell.returnAt.text = "\(presenter.getArrayInfo(type: .arrave)[indexPath.row])"
            return cell
        }
        return UITableViewCell()
    }
}
