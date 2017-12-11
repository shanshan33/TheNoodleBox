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
    @IBOutlet weak var marthRestaurantTableView: UITableView!
    
    @IBOutlet weak var restoPopupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        performRamenSearch()
        configureLayout()
        restoPopupView.addGestureRecognizer(tapRecognizer)
    }
    
    func setupNavigationBar() {
 //       navigationController?.navigationBar.prefersLargeTitles = true
 //       navigationItem.largeTitleDisplayMode = .always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        bottomConstraint = restoPopupView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 240)
        bottomConstraint.isActive = true
        restoPopupView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
 //       recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
//    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case .began:
//            animateTransitionIfNeeded(to: currentState.opposite, duration: 1.5)
//            transitionAnimator.pauseAnimation()
//        case .changed:
//            let translation = recognizer.translation(in: popupView)
//            var fraction = -translation.y / popupOffset
//            if currentState == .open { fraction *= -1 }
//            transitionAnimator.fractionComplete = fraction
//        case .ended:
//            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//        default:
//            ()
//        }
//    }
    
    @objc func popupViewTapped(recognizer: UITapGestureRecognizer) {
        marthRestaurantTableView.reloadData()
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
                self.bottomConstraint.constant = 240
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
                self.bottomConstraint.constant = 240
            }
        }
        transitionAnimator.startAnimation()
    }
}

extension RamenAroundYouViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchRestoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoCell")
        cell?.textLabel?.text = matchRestoNames[indexPath.row]
        return cell!
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


