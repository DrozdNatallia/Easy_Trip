//
//  FlightsViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 14.08.22.
//

import UIKit

protocol FlightsViewProtocol: AnyObject {
    func setInfoFlights()
    func setLocation(location: String)
    func updateIcon(image: UIImage)
    func stopAnimation()
}

class FlightsViewController: UIViewController, FlightsViewProtocol {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var originCity: UITextField!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var presenter: FlightsViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FlightsViewCell", bundle: nil), forCellReuseIdentifier: FlightsViewCell.key)
        
        originCity.delegate = self
        destinationCity.delegate = self
        presenter.getIconImage()
        presenter.getLocation()
    }
// если успею переделаю
    @IBAction func onSearchButton(_ sender: Any) {
        // activity indicator, пока загрузка полетов
        blur.isHidden = false
        activity.startAnimating()
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let setDate = date.string(from: datePicker.date)
        guard var originName = originCity.text, var destinationName = destinationCity.text else { return }
        presenter.getCodeCityByName(code: originName) { [weak self] result in
            guard let self = self else { return }
            originName = result
            self.presenter.getCodeCityByName(code: destinationName) { [weak self] result in
                guard let self = self else { return }
                destinationName = result
                self.presenter.getFlightsInfo(originName: originName, destinationName: destinationName, date: setDate)
            }
        }
    }
    // переход на HomeViewController
    @IBAction func onExploreButton(_ sender: Any) {
        presenter.tapOnButtonExplore()
    }
    // остановка анимации
    func stopAnimation(){
        blur.isHidden = true
        activity.stopAnimating()
    }
    // обновление иконки пользователя
    func updateIcon(image: UIImage) {
        iconImage.image = image
    }
    // установление геолокации
    func setLocation(location: String) {
        self.userLocation.text = location
    }
    // обновление таблицы после получения инфы
    func setInfoFlights() {
        stopAnimation()
        tableView.reloadData()
    }
    // переход на PlaceViewController, передаем location
    @IBAction func onPlaceButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImage.image else { return }
        presenter.tapOnButtonPlaces(location: location, icon: icon)
    }
    // переход на HotelsViewController, передаем location
    @IBAction func onHotelsButton(_ sender: Any) {
        guard let location = userLocation.text, let icon = iconImage.image else { return }
        presenter.tapOnButtonHotels(location: location, icon: icon)
    }
}

//MARK: Extension
extension FlightsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getArrayFligts().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FlightsViewCell.key) as? FlightsViewCell {
            // ячейки заполняю из перезентера
            presenter.configure(cell: cell, row: indexPath.section)
            return cell
        }
        return UITableViewCell()
    }
}
// закрытие клавиатуры по нажатию на кнопку на телефоне
extension FlightsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
