//
//  HotelsCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit
protocol HotelsCellDelegate: AnyObject {
    func getInfoAboutHotel(name: String, url: String)
    func addRowCell(row: Int)
}
protocol HotelsCellProtocol: AnyObject {
    func fillField(name: String, image: UIImage, hotelsUrl: String, section: Int, nameImage: String)
}
class HotelsCell: UICollectionViewCell, HotelsCellProtocol {
    static let key = "HotelsCell"
    weak var delegate: HotelsCellDelegate?
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    private var url: String!
    private var row: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // заполнение ячеек
    func fillField(name: String, image: UIImage, hotelsUrl: String, section: Int, nameImage: String) {
        nameHotel.text = name
        imageView.image = image
        url = hotelsUrl
        row = section
        likesButton.setImage(UIImage(systemName: "\(nameImage)"), for: .normal)
    }
    // по нажатию на кнопку записыавем место в избранное.
    @IBAction func onButton(_ sender: Any) {
        // меняется картинка по нажати
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let name = nameHotel.text, let url = url, let row = row else { return }
        self.delegate?.getInfoAboutHotel(name: name, url: url)
        self.delegate?.addRowCell(row: row)
    }
}
