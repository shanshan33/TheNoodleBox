//
//  SecondViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 07/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces

private enum State {
    case expanded
    case closed
}

extension State {
    var opposite: State {
        switch self {
        case .expanded: return .closed
        case .closed:   return .expanded
        }
    }
}

class RamenAroundYouViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var matchingItems: [MKMapItem] = [ ]
    var matchRestoNames : [String] = []
    
    @IBOutlet weak var closedRestoTitle: UILabel!
    @IBOutlet weak var RamenRestosListCollectionView: UICollectionView!
    @IBOutlet weak var restoPopupView: UIView!
    
    let transitionAnimator: AppStoreAnimator = AppStoreAnimator(transitionType: .present)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        fetchDataOnLoad()
        
        performRamenSearch()
        configureLayout()
        closedRestoTitle.addGestureRecognizer(tapRecognizer)
        
        RamenRestosListCollectionView?.register(AnimatedLoadingCell.self, forCellWithReuseIdentifier: "Loader")
        
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
 //       navigationItem.largeTitleDisplayMode = .always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var viewModel = PlaceViewModel()
    var placeViewModels: [PlaceViewModel] = []

    func fetchDataOnLoad() {
        viewModel.fetchRemanRequestForParis { (viewModels, error) in
            self.placeViewModels = viewModels
            DispatchQueue.main.async {
                self.RamenRestosListCollectionView.reloadData()
            }
        }
    }
    
    
    func performRamenSearch() {
        matchingItems.removeAll()
        
        let parisLocation = CLLocationCoordinate2DMake(48.8566, 2.3522)
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: parisLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "ramen"
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response?.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                guard let result = response?.mapItems else { return }
                for item in result {
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.matchRestoNames.append(item.name!)
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }

    // Animation
    private var bottomConstraint = NSLayoutConstraint()
    
    private func configureLayout() {
        restoPopupView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = restoPopupView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 400)
        bottomConstraint.isActive = true
        restoPopupView.heightAnchor.constraint(equalToConstant: 460).isActive = true
    }
    
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        return recognizer
    }()
    
    
    @objc func popupViewTapped(recognizer: UITapGestureRecognizer) {
        RamenRestosListCollectionView.reloadData()
        animateTransitionIfNeeded(to: currentState.opposite, duration: 1.5)
    }
    
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .expanded:
                self.closedRestoTitle.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
                self.bottomConstraint.constant = 0
                self.restoPopupView.layer.cornerRadius = 25
                self.closedRestoTitle.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

            case .closed:
                self.closedRestoTitle.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.medium)
                self.bottomConstraint.constant = 400
                self.restoPopupView.layer.cornerRadius = 0
                self.closedRestoTitle.transform = .identity

            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .expanded:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = 400
            }
        }
        transitionAnimator.startAnimation()
    }
}

extension RamenAroundYouViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlaceCollectionViewCell {
            transitionAnimator.originFrame = cell.convert(cell.iconImageView.bounds, to: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let restoDetail = storyboard.instantiateViewController(withIdentifier: "RestaurantDetails") as! RestaurantDetailsViewController
            restoDetail.viewModel = self.placeViewModels[indexPath.row]
            restoDetail.transitioningDelegate = self
            transitionAnimator.resizeFrame = restoDetail.view.convert(restoDetail.placeImageView.bounds, to: nil)
            self.present(restoDetail, animated: true, completion: nil)
        }
    }
}

extension RamenAroundYouViewController: UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.placeViewModels.count > 0 ? self.placeViewModels.count : 5
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell: UICollectionViewCell = {
            if self.placeViewModels.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCollectionViewCell
                cell.configCell(viewModel: self.placeViewModels[indexPath.row])
       //         cell.iconImageView.layer.cornerRadius = 10
                return cell
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Loader", for: indexPath)
        }()
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension RamenAroundYouViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let backAnimator = AppStoreAnimator(transitionType: .dismiss)
        backAnimator.originFrame = transitionAnimator.originFrame
        backAnimator.resizeFrame = transitionAnimator.resizeFrame
        return backAnimator
    }
}
extension RamenAroundYouViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            for location in locations{
                print("location:: \(location)")
            }
        }
    }
}


