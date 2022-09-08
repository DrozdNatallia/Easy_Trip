//
//  PlacesViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 22.08.22.
//

import UIKit
protocol PlacesCellDelegate: AnyObject {
    func showAlertFromCell(cell: PlacesCellProtocol, didTapButton button: UIButton)
}
protocol PlacesCellProtocol: AnyObject {
    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String)
    func setUserId(id: String)
}
class PlacesViewCell: UITableViewCell, PlacesCellProtocol {
static let key = "PlacesViewCell"
    weak var delegate: PlacesCellDelegate?
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var excursionImage: UIImageView!
    @IBOutlet weak var nameExcursion: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    var presenter: PLacesCellPresenterProtocol!
    var url: String!
    private var userId: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        presenter.getCurrentUserId()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   private func configure() {
       let firebase = FirebaseManager()
       presenter = PlacesCellPresenter(view: self, firebase: firebase)
    }
    
    func setUserId(id: String){
        userId = id
    }
    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String) {
        price.text = excPrice
        excursionImage.image = image
        nameExcursion.text = name
        url = urlPlaces
       
    }
    // по нажатию на кнопку записыавем место в избранное. Ui пока не делала, еще буду менять
    @IBAction func onLikesButton(_ sender: Any) {
        self.delegate?.showAlertFromCell(cell: self, didTapButton: sender as! UIButton)
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let name = nameExcursion.text, let url = url, let id = userId else { return }
        presenter.getAllFavouritesDocuments(id: id, name: name, url: url)
    }
}
