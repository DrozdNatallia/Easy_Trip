//
//  PopularFlightsCollectionViewCell.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 10.08.22.
//

import UIKit
protocol PopularCellProtocol: AnyObject {
    func fillField(name: String, image: UIImage)
}
class PopularFlightsCollectionViewCell: UICollectionViewCell, PopularCellProtocol {
    @IBOutlet weak var imagePopularCity: UIImageView!
    @IBOutlet weak var namePopularCity: UILabel!
    static let key = "PopularFlightsCollectionViewCell"
    var presenter: PopularCellPresenterProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    private func configure(){
        presenter = PopularCellPresenter(view: self)
    }
    
    func fillField(name: String, image: UIImage){
        imagePopularCity.image = image
        namePopularCity.text = name
    }

}
