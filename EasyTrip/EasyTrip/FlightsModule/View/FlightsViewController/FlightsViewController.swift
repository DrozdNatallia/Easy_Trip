//
//  FlightsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}


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
    // переделать через async Await, позже переделаю
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
            
            // пока оставлю, вернусь позже к этому, все равно работает не правильно(
            if let isoDate = presenter.getArrayInfo(type: .depart)[indexPath.section] as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                cell.departAt.text = dateFormatter.string(from: isoDate)
                
            }
            //            let dateFormatter = ISO8601DateFormatter()
            //            let date = dateFormatter.date(from:isoDate)?.convertToTimeZone(initTimeZone: TimeZone(secondsFromGMT: 0) ?? .current, timeZone: TimeZone.current)
            //            print(date)
            
            cell.iconAirlines.image = presenter.getImage()[indexPath.section]
            cell.price.text = "\(presenter.getArrayInfo(type: .price)[indexPath.section]) $"
            cell.transfer.text = "пересадок: \(presenter.getArrayInfo(type: .transfer)[indexPath.section])"
            cell.origin.text = "\(presenter.getArrayInfo(type: .origin)[indexPath.section])"
            cell.destination.text = "\(presenter.getArrayInfo(type: .destination)[indexPath.section])"
            cell.timeInFlight.text = "\(presenter.getArrayInfo(type: .duration)[indexPath.section])"
            //  cell.returnAt.text = "\(presenter.getArrayInfo(type: .arrave)[indexPath.row])"
            return cell
        }
        return UITableViewCell()
    }
}
