//
//  HotelsCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit

class HotelsCell: UICollectionViewCell {
    static let key = "HotelsCell"
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    var url: String!
    var provaider: FirebaseProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        provaider = FirebaseManager()
    }

    @IBAction func onButton(_ sender: Any) {
        guard let name = nameHotel.text, let url = url else {
            return
        }
        provaider.writeDate(collectionName: "favouritesHotels", docName: name, name: name, url: url)
    }
    
    
}
