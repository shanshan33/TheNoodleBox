//
//  RestaurantDetailsViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 04/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit
import MapKit


class RestaurantDetailsViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    var viewModel = PlaceViewModel()
    var placeLocation: CLLocationCoordinate2D? // place location

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupMapViewer()
    }
    
    func setupViewController() {
        self.placeImageView.image = viewModel.placeImage
        self.placeNameLabel.text = viewModel.name
        self.placeAddressLabel.text = viewModel.address
        self.placeLocation = viewModel.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!

    
    
    
    @IBAction func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var placeDetailsScrollView: UIScrollView!
     @IBOutlet weak var placeInfoStackView: UIStackView!

    func setupMapViewer() {
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        addGestureForMap()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if let placeLocation = placeLocation {
            let region = MKCoordinateRegion(center: placeLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placeLocation
            annotation.title = viewModel.name
            annotation.subtitle = viewModel.address
            mapView.addAnnotation(annotation)
        }
    }
    
    func addGestureForMap() {
        let mapGestureView = UIView(frame:mapView.bounds)
        mapGestureView.backgroundColor = UIColor.clear
        mapView.addSubview(mapGestureView)
        mapGestureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapGestureView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openAppleMap))
        tap.delegate = self
        mapGestureView.addGestureRecognizer(tap)
    }

    @objc func openAppleMap(_ sender: UITapGestureRecognizer) {

        guard let coordinate = placeLocation else { return }
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.02))
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        mapItem.openInMaps(launchOptions: options)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let imageHeight = placeImageView.frame.height
        //    if let hasPhoto = pro.thumbURL?.isEmpty {
        
//        if !hasPhoto {
//            let newOrigin = CGPoint(x: 0, y: -imageHeight)
//
//            infoDetailScrollView.contentOffset = newOrigin
//            infoDetailScrollView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
//        } else {

        placeDetailsScrollView.contentOffset = CGPoint(x: 0, y: -375)
        placeDetailsScrollView.contentInset = UIEdgeInsets(top: 375, left: 0, bottom: 0, right: 0)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y        
        if offsetY < 0 {
            placeImageView.frame.size.height = -offsetY
        } else {
            placeImageView.frame.size.height = placeImageView.frame.height
        }
    }
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
