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
        @IBOutlet weak var typeFavourites: UISegmentedControl!
    var presenter: FavouritesViewPresenterProtocol!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "FavouritesViewCell", bundle: nil), forCellReuseIdentifier: FavouritesViewCell.key)
        
        
        presenter.getAllDocument(collection: "favouritesHotels")
    }
        @IBAction func onSegmentControl(_ sender: Any) {
            presenter.clearArray()
            // в зависимости от сегмент контрола, подгружаем избранное
            if typeFavourites.selectedSegmentIndex == 0 {
                presenter.getAllDocument(collection: "favouritesHotels")
            } else {
                presenter.getAllDocument(collection: "favouritesPlaces")
            }
        }
        
        func updateTable() {
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
            cell.name.text = presenter.getArrayName()[indexPath.section]
            cell.favouritesImage.image = presenter.getArrayImage()[indexPath.section]
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
            print(name)
            if typeFavourites.selectedSegmentIndex == 0 {
                presenter.deleteDocument(collection: "favouritesHotels", name: name)
            } else {
                presenter.deleteDocument(collection: "favouritesPlaces", name: name)
            }
            presenter.deleteElementFromArray(num: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
    }
}
