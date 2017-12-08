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

class RamenAroundYouViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        performRamenSearch()
    }
    
    func performRamenSearch() {
        matchingItems.removeAll()
        
        let parisLocation = CLLocationCoordinate2DMake(48.8566, 2.3522)
        let span = MKCoordinateSpanMake(0.027, 0.027)
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
}

extension RamenAroundYouViewController : CLLocationManagerDelegate {
    
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

