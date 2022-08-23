//
//  PlacesViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 22.08.22.
//

import UIKit

class PlacesViewCell: UITableViewCell {
static let key = "PlacesViewCell"

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var excursionImage: UIImageView!
    @IBOutlet weak var nameExcursion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
