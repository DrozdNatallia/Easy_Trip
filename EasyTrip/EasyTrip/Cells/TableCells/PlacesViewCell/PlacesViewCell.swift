//
//  PlacesViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 22.08.22.
//

import UIKit
import SwiftUI
protocol PlacesCellDelegate: AnyObject {
    func getAllFavouritesDocuments(name: String, url: String)
    func addNumberRow(rowNumber: Int)
}
protocol PlacesCellProtocol: AnyObject {
    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String,  rowNumber: Int, imageButton: String)
}
class PlacesViewCell: UITableViewCell, PlacesCellProtocol {
static let key = "PlacesViewCell"
    weak var delegate: PlacesCellDelegate?
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var excursionImage: UIImageView!
    @IBOutlet weak var nameExcursion: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    private var url: String!
    private var row: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String, rowNumber: Int, imageButton: String) {
        price.text = excPrice
        excursionImage.image = image
        nameExcursion.text = name
        url = urlPlaces
        row = rowNumber
        likesButton.setImage(UIImage(systemName: "\(imageButton)"), for: .normal)
    }
    // по нажатию на кнопку записыавем место в избранное. Ui пока не делала, еще буду менять
    @IBAction func onLikesButton(_ sender: Any) {
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let name = nameExcursion.text, let url = url, let row = row else { return }
        self.delegate?.getAllFavouritesDocuments(name: name, url: url)
        self.delegate?.addNumberRow(rowNumber: row)
    }
}
