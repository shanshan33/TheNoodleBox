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
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
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
    
    func performRamenSearch() {
        matchingItems.removeAll()
        
        let parisLocation = CLLocationCoordinate2DMake(48.8566, 2.3522)
        let span = MKCoordinateSpanMake(0.05, 0.05)
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
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Animation
    private var bottomConstraint = NSLayoutConstraint()
    
    private func configureLayout() {
        restoPopupView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = restoPopupView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 240)
        bottomConstraint.isActive = true
        restoPopupView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    @IBOutlet weak var restoPopupViewHeightConstraint: NSLayoutConstraint!
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .expanded:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = 240
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoCell")
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


