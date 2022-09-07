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
    private var userId: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        provaider = FirebaseManager()
        provaider.getCurrentUserId { id in
            guard let id = id else { return }
            self.userId = id
        }
    }
    // по нажатию на кнопку записыавем место в избранное. Ui пока не делала, еще буду менять
    @IBAction func onButton(_ sender: Any) {
        guard let name = nameHotel.text, let url = url, let id = userId  else { return }
        provaider.getAllFavouritesDocuments(collection: "favouritesHotels", docName: id) { [weak self] favourites in
            guard let self = self else { return }
            if favourites == nil {
                self.provaider.writeFavourites(collection: "favouritesHotels", docName: id, hotels: [name : url])
            } else {
                guard var dictionary = favourites?.favourites else { return }
                dictionary[name] = "\(url)"
                self.provaider.writeFavourites(collection: "favouritesHotels", docName: id, hotels: dictionary)
            }
        }
    }
}
