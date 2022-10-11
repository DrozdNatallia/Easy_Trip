//
//  FlightsViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit
protocol FlightsCellProtocol: AnyObject {
    func fillField(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage, depart: String )
}
class FlightsViewCell: UITableViewCell, FlightsCellProtocol {
    static let key = "FlightsViewCell"
    @IBOutlet weak var departAt: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var transfer: UILabel!
    @IBOutlet weak var iconAirlines: UIImageView!
    @IBOutlet weak var timeInFlight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillField(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage, depart: String ) {
        origin.text = originCity
        destination.text = destinationCity
        price.text = priceFlights
        transfer.text = transferFlight
        timeInFlight.text = flightTime
        iconAirlines.image = icon
        departAt.text = depart
    }
}
