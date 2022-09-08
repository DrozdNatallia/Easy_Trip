//
//  FavouritesViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 25.08.22.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {
    func updateTable()
    func stopAnimation()
    
}
class FavouritesViewController: UIViewController, FavouritesViewProtocol {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var typeFavourites: UISegmentedControl!
    @IBOutlet weak var blur: UIVisualEffectView!
    var presenter: FavouritesViewPresenterProtocol!
    private var userId: String!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FavouritesViewCell", bundle: nil), forCellReuseIdentifier: FavouritesViewCell.key)
        
        activity.startAnimating()
        presenter.getCurrentUserId { id in
            guard let id = id else { return }
            self.userId = id
        }
        presenter.getAllFavouritesDocument(collection: "favouritesHotels", docName: userId)
        
    }
    @IBAction func onSegmentControl(_ sender: Any) {
        presenter.clearArray()
        blur.isHidden = false
        activity.startAnimating()
        // в зависимости от сегмент контрола, подгружаем избранное
        if typeFavourites.selectedSegmentIndex == 0 {
            presenter.getAllFavouritesDocument(collection: "favouritesHotels", docName: userId)
        } else {
            presenter.getAllFavouritesDocument(collection: "favouritesPlaces", docName: userId)
        }
    }
    func stopAnimation(){
        blur.isHidden = true
        activity.stopAnimating()
    }
    
    func updateTable() {
        stopAnimation()
        tableView.reloadData()
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getArrayName().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // добавоение избранного в ячейки. Удаления пока нет,сделаю позже, не решила где именно будет реализовано
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesViewCell.key) as? FavouritesViewCell {
            cell.presenter.getInfoFavourites(nameFavourites: presenter.getArrayName()[indexPath.section], image: presenter.getArrayImage()[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = presenter.getArrayName()[indexPath.section]
            if typeFavourites.selectedSegmentIndex == 0 {
                presenter.deleteElementFromFavourites(collection: "favouritesHotels", docName: userId, key: name)
            } else {
                presenter.deleteElementFromFavourites(collection: "favouritesPlaces", docName: userId, key: name)
            }
            presenter.deleteElementFromArray(num: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
    }
}
