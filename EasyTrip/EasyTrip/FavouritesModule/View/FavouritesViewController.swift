//
//  FavouritesViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 25.08.22.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {
    func updateTable()
    
}
    class FavouritesViewController: UIViewController, FavouritesViewProtocol {
    var firebaseProvaider: FirebaseProtocol!
    var hotels = Hotels()
    var presenter: FavouritesViewPresenterProtocol!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "FavouritesViewCell", bundle: nil), forCellReuseIdentifier: FavouritesViewCell.key)
        
        presenter.getAllDocument(collection: "favouritesHotels")
    }
        
        func updateTable() {
            tableView.reloadData()
        }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getArrayNameHotels().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesViewCell.key) as? FavouritesViewCell {
            cell.name.text = presenter.getArrayNameHotels()[indexPath.section]
            cell.favouritesImage.image = presenter.getArrayImage()[indexPath.section]
            return cell
        }
        return UITableViewCell()
    }
}
