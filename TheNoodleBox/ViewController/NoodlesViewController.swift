//
//  FirstViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 07/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class NoodlesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
  //      navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension NoodlesViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension NoodlesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "NoodleCell", for: indexPath)
        cell.layer.cornerRadius = 20
        return cell
    }
    
}


