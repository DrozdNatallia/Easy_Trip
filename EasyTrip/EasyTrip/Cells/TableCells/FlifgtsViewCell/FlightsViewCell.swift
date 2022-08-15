//
//  FlightsViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit

class FlightsViewCell: UITableViewCell {
    static let key = "FlightsViewCell"
    @IBOutlet weak var departAt: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var returnAt: UILabel!
    @IBOutlet weak var transfer: UILabel!
    @IBOutlet weak var timeInFlight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
