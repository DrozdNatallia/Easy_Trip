//
//  PopularFlightsCollectionViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 10.08.22.
//

import UIKit

class PopularFlightsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagePopularCity: UIImageView!
    @IBOutlet weak var namePopularCity: UILabel!
    static let key = "PopularFlightsCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
