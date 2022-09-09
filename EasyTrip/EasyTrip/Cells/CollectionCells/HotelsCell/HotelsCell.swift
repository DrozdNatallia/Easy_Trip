//
//  HotelsCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit
protocol HotelsCellDelegate: AnyObject {
    func showAlertFromCell(cell: HotelsCellProtocol, didTapButton button: UIButton)
}
protocol HotelsCellProtocol: AnyObject {
    func fillField(name: String, image: UIImage, hotelsUrl: String)
    func setIdUser(id: String)
    
}
class HotelsCell: UICollectionViewCell, HotelsCellProtocol {
    static let key = "HotelsCell"
    weak var delegate: HotelsCellDelegate?
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    var presenter: HotelsCellPresenterProtocol!
    var url: String!
    var provaider: FirebaseProtocol!
    private var userId: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        presenter.getIdUser()
    }
    private func configure(){
        let firebase = FirebaseManager()
        presenter = HotelsCellPresenter(view: self, firebase: firebase)
    }
    //устанаваем номер
    func setIdUser(id: String){
        userId = id
    }
    // заполнение ячеек
    func fillField(name: String, image: UIImage, hotelsUrl: String) {
        nameHotel.text = name
        imageView.image = image
        url = hotelsUrl
    }
    // по нажатию на кнопку записыавем место в избранное.
    @IBAction func onButton(_ sender: Any) {
        // с помощью делегата вызываем сообщение в контроллере о добавлении в избранное
        self.delegate?.showAlertFromCell(cell: self, didTapButton: sender as! UIButton)
        // меняется картинка по нажатию
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let name = nameHotel.text, let url = url, let id = userId  else { return }
        presenter.getFavouritesHotels(id: id, name: name, url: url)
    }
}
