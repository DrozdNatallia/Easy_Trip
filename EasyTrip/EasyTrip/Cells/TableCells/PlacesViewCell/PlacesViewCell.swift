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
    var firebase: FirebaseProtocol!
    var url: String!
    private var userId: String!
    var dict: [String : String]!
    override func awakeFromNib() {
        super.awakeFromNib()
        firebase = FirebaseManager()
        firebase.getCurrentUserId { id in
            guard let id = id else { return }
            self.userId = id
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // по нажатию на кнопку записыавем место в избранное. Ui пока не делала, еще буду менять
    @IBAction func onLikesButton(_ sender: Any) {
        guard let name = nameExcursion.text, let url = url, let id = userId else { return }
        firebase.getAllFavouritesDocuments(collection: "favouritesPlaces", docName: id) { [weak self] favourites in
            guard let self = self else { return }
            if favourites == nil {
                self.firebase.writeFavourites(collection: "favouritesPlaces", docName: id, hotels: [name : url])
            } else {
                guard var dictionary = favourites?.favourites else { return }
                dictionary[name] = "\(url)"
                self.firebase.writeFavourites(collection: "favouritesPlaces", docName: id, hotels: dictionary)
            }
        }
    }
}
