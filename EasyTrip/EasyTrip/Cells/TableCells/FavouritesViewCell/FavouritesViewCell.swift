//
//  FavouritesViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 25.08.22.
//

import UIKit

class FavouritesViewCell: UITableViewCell {
    static let key = "FavouritesViewCell"

    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
