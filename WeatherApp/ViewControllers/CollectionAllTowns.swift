//
//  CollectionAllTowns.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 22.11.2021.
//

import UIKit

class CollectionAllTowns: BasedViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    // MARK: Vars and Outlets

    @IBOutlet weak var collection: UICollectionView!

    let refreshControl = UIRefreshControl()

    // MARK: CollectionView Behavior

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storage.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionCell", for: indexPath) as! WeatherCollectionCell
       
        cell.setTemp(storage.allTowns[indexPath.row])
        if currentPickedTown?.id == storage.allTowns[indexPath.row].id
        { cell.currentTownCell = true}
     
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        closure!(storage.allTowns[indexPath.row])
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        storage.reloadAllTowns { [weak self] in
            self?.reloadWeather()
            self?.refreshControl.endRefreshing()
        }
    }
    
    
    // MARK: HandleTap

    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {

    let touchPoint = longPressGestureRecognizer.location(in: collection)
        if let indexPath = collection.indexPathForItem(at: touchPoint) {
            let cell = collection.cellForItem(at: indexPath) as! WeatherCollectionCell
            cell.isSelected = true
            self.present(alertForCell(indexPath), animated: true, completion: nil)
        
        }}
    }
    
    // MARK: Custom LifeCicle

    
    override func reloadWeather() {
        super.reloadWeather()
        self.collection.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: View LifeCicle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        super.reloadWeather()
        collection.backgroundColor = .clear
        let collectionCell = UINib(nibName: "WeatherCollectionCell", bundle: nil)
        collection.register(collectionCell, forCellWithReuseIdentifier: "WeatherCollectionCell")
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        collection.addGestureRecognizer(longPressRecognizer)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collection.refreshControl = refreshControl
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.reloadWeather()
    }
   
    
    
    
    // MARK: Alerts


    func alertForCell(_ indexPath: IndexPath) -> UIAlertController {
        let alert = UIAlertController(title: "Что нужно сделать?" , message: "", preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Подробнее", style: .default, handler: { [weak self] picked in
            
            self?.currentPickedTown = self?.storage.allTowns[indexPath.row]
            self?.collection.reloadData()
            self?.closure!(self?.currentPickedTown)
            self?.navigationController?.popToRootViewController(animated: true)
            
        })
        let actionTwo = UIAlertAction(title: "Показать на карте", style: .default, handler: { [weak self] picked in
            self?.currentPickedTown = self?.storage.allTowns[indexPath.row]
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            vc.currentPickedTown = self?.currentPickedTown
            vc.closure = {[weak self] data in
                self?.collection.reloadData()
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        let actionThree = UIAlertAction(title: "Удалить", style: .destructive, handler: {[weak self] picked in
            let town = self?.storage.allTowns[indexPath.row]
            self?.storage.deleteTown(town!)
            self?.collection.deleteItems(at: [indexPath])
            self?.collection.reloadData()
            if self?.storage.count == 0 {self?.noWeatherFound()}
        })

        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        alert.addAction(actionThree)
        return alert
    }

}


