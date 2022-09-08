//
//  FavouritesViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 25.08.22.
//

import UIKit
protocol FavouritesCellProtocol: AnyObject {
    func fillField(nameFavourites: String, image: UIImage)
}
class FavouritesViewCell: UITableViewCell, FavouritesCellProtocol {
    static let key = "FavouritesViewCell"
    var presenter: FavouritesCellPresenterProtocol!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    private func configure(){
        presenter = FavouritesCellPresenter(view: self)
    }
    
    func fillField(nameFavourites: String, image: UIImage){
        favouritesImage.image = image
        name.text = nameFavourites
    }
}
