//
//  AllTownsController.swift
//  Weather App
//
//  Created by Егор Пашкевич on 11.11.2021.
//

import UIKit

class AlltownsController: BasedViewController, UITableViewDelegate, UITableViewDataSource {


    @IBAction func clearAll(_ sender: Any) {
        storage.clearAll()
        AllTownsTable.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
        closure!(nil)
    }
    
    @IBOutlet weak var AllTownsTable: UITableView!
    
    var refresh :  UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:) ), for: .valueChanged)
        return refreshControl
    }

    
    @objc private func refresh(sender: UIRefreshControl ) {
        self.storage.reloadAllTowns {
            DispatchQueue.main.async {
                self.AllTownsTable.reloadData()
                sender.endRefreshing()
            }
        }
    }
    

 

    // MARK: TableView
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickedTown = storage.allTowns[indexPath.row]
        let actionSwipeInstance = UIContextualAction(style: .destructive, title: "Удалить") { [self] _,_,_ in
            self.storage.deleteTown(pickedTown)
            self.AllTownsTable.deleteRows(at: [indexPath], with: .automatic)
            if self.storage.count == 0 {self.navigationController?.popToRootViewController(animated: true)
                self.closure!(nil)
            
            }
        }
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedTown = storage.allTowns[indexPath.row]
        if currentPickedTown?.id == pickedTown.id {return}
        currentPickedTown = pickedTown
        closure!(pickedTown)
        self.navigationController?.popToRootViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTown = storage.allTowns[indexPath.row]
    
        let cell = AllTownsTable.dequeueReusableCell(withIdentifier: "TownTable", for: indexPath)
        let name = cell.viewWithTag(1) as? TownName
        let temp = cell.viewWithTag(2) as? TempLabel
        let icon = cell.viewWithTag(3) as? WeatherImageDescription
        cell.backgroundColor = .gray
        icon?.setTemp(currentTown)
        temp?.setTemp(currentTown)
        name?.setTemp(currentTown)
        
        if currentTown.id == self.currentPickedTown?.id {cell.accessoryType = .checkmark}
        else {cell.accessoryType = .none}
        return cell
    }

    
// MARK: CustomLifeCicle
    

    
  // MARK: LifeCicle of View
    override func viewDidLoad() {
        
        self.AllTownsTable.delegate = self
        self.AllTownsTable.dataSource = self
        self.AllTownsTable.refreshControl = refresh
        self.AllTownsTable.backgroundColor = .clear
        super.viewDidLoad()
        
    
}
    override func viewWillAppear(_ animated: Bool) {
        super.reloadWeather()
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }
    }



