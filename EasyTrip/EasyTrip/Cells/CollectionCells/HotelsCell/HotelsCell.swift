//
//  HotelsCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit
protocol HotelsCellDelegate: AnyObject {
    func getInfoAboutHotel(name: String, url: String)
}
protocol HotelsCellProtocol: AnyObject {
    func fillField(name: String, image: UIImage, hotelsUrl: String)
}
class HotelsCell: UICollectionViewCell, HotelsCellProtocol {
    static let key = "HotelsCell"
    weak var delegate: HotelsCellDelegate?
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    var url: String!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // заполнение ячеек
    func fillField(name: String, image: UIImage, hotelsUrl: String) {
        nameHotel.text = name
        imageView.image = image
        url = hotelsUrl
    }
    // по нажатию на кнопку записыавем место в избранное.
    @IBAction func onButton(_ sender: Any) {
        // меняется картинка по нажати
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let name = nameHotel.text, let url = url else { return }
        self.delegate?.getInfoAboutHotel(name: name, url: url)
    }
}
