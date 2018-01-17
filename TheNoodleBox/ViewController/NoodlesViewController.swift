//
//  FirstViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 07/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class NoodlesViewController: UIViewController {

    @IBOutlet weak var noodleCollectionView: UICollectionView!
    var ramens: [Noodle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureRecommendRamen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
  //      navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureRecommendRamen() {
        let noodle1 = Noodle(title: "KURUGOMA RAMEN", image: #imageLiteral(resourceName: "KURUGOMARAMEN"), restaurantName: "Kodawari Ramen")
        let noodle2 = Noodle(title: "AKAMARU RAMEN", image: #imageLiteral(resourceName: "AKAMARU"), restaurantName: "iPPUDO Saint- Germain")
        let noodle3 = Noodle(title: "SHIO RAMEN", image: #imageLiteral(resourceName: "SHIORAMEN"), restaurantName: "Kodawari Ramen")
        ramens = [noodle1, noodle2, noodle3]
    }
}

extension NoodlesViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension NoodlesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ramens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "NoodleCell", for: indexPath) as! NoodleCell
        cell.configureCell(noodle: ramens[indexPath.row])
        cell.layer.cornerRadius = 15
        return cell
    }
    
}


