//
//  FlightsViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit
protocol FlightsCellProtocol: AnyObject {
    func fillField(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage )
}
class FlightsViewCell: UITableViewCell, FlightsCellProtocol {
    static let key = "FlightsViewCell"
    @IBOutlet weak var departAt: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var returnAt: UILabel!
    @IBOutlet weak var transfer: UILabel!
    @IBOutlet weak var iconAirlines: UIImageView!
    @IBOutlet weak var timeInFlight: UILabel!
    var presenter: FlightsCellPresenterProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure(){
        presenter = FlightsCellPresenter(view: self)
    }
    
    func fillField(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage ) {
        origin.text = originCity
        destination.text = destinationCity
        price.text = priceFlights
        transfer.text = transferFlight
        timeInFlight.text = flightTime
        iconAirlines.image = icon
    }
}
