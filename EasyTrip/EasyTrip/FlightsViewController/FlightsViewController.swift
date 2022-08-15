//
//  FlightsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit
struct InfoFlight {
    var arrayPrice: [Int] = []
    var arrayDepart: [String] = []
    var arrayArrive: [String] = []
    var arrayTransfer: [Int] = []

}
class FlightsViewController: UIViewController {
    var alamofireProvaider: AlamofireProvaider!
    @IBOutlet weak var originCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var infoFlight = InfoFlight()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FlightsViewCell", bundle: nil), forCellReuseIdentifier: FlightsViewCell.key)
        
        alamofireProvaider = AlamofireProvaider()
        print("fjfjfjfjfjjfjfjfjfjjfjfjfjjf")
        getFlightInfo()
    }

    // получение инфы о полетах
    fileprivate func getFlightInfo() {
    alamofireProvaider.getFlightsInfo(origin: "MOW", date: "2202-10-13", destination: "BCN")  { result in
    switch result {
    case .success(let value):
    guard let val = value.data else {return}
    for flight in val.values {
        guard let price = flight.price, let depart = flight.departureAt, let arrive = flight.returnAt, let transfer = flight.transfers else { return }
        self.infoFlight.arrayPrice.append(price)
        self.infoFlight.arrayDepart.append(depart)
        self.infoFlight.arrayArrive.append(arrive)
        self.infoFlight.arrayTransfer.append(transfer)
        self.tableView.reloadData()
    // все билеты по указанному направлению за месяц, можно ограничить
    print("price: \(flight.price)")
    print("дата возвращения: \(flight.returnAt)")
    print("дата вылета: \(flight.departureAt)")
    print("номер рейса: \(flight.flightNumber)")
    }
    case .failure(let error):
    print(error.localizedDescription)
    }
    }
}
    
    

}

extension FlightsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       infoFlight.arrayPrice.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FlightsViewCell.key) as? FlightsViewCell {
           // guard let origin = originCity.text, let depart = destinationCity.text else {return}
           // cell.origin.text = origin
            cell.price.text = infoFlight.arrayPrice[indexPath.row].description
            cell.transfer.text = infoFlight.arrayTransfer[indexPath.row].description
            cell.departAt.text = infoFlight.arrayDepart[indexPath.row]
            cell.returnAt.text = infoFlight.arrayArrive[indexPath.row]

            return cell
        
    }
        print("KJNKJKKJH")
        return UITableViewCell()
    
    
}
}


// получение инфы о полетах
//fileprivate func getFlightInfo() {
//alamofireProvaider.getFlightsInfo(origin: "MOW", date: "2202-11", destination: "BCN")  { result in
//switch result {
//case .success(let value):
//guard let val = value.data else {return}
//for flight in val.values {
//// все билеты по указанному направлению за месяц, можно ограничить
//print("price: \(flight.price)")
//print("дата возвращения: \(flight.returnAt)")
//print("дата вылета: \(flight.departureAt)")
//print("номер рейса: \(flight.flightNumber)")
//}
//case .failure(let error):
//print(error.localizedDescription)
//}
//}
//}
