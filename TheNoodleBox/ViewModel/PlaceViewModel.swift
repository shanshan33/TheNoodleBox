//
//  RestaurantPlaceViewModel.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PlaceViewModel {
    
     let requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=48.8566,2.3522&radius=5000&type=restaurant&keyword=ramen&key=AIzaSyAKkJYVkhKjBJB9fe3kkx-zjl9S3gpuwhA"
    
    let fetchImageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=750&photoreference=%photoref%&key=AIzaSyAKkJYVkhKjBJB9fe3kkx-zjl9S3gpuwhA"
    

    let searchPlacesAPI = SearchPlacesAPI()

    var placeImage: UIImage?
    var placeID: String?
    var name: String?
    var rating: Double?
    var address: String?
    var location: CLLocationCoordinate2D?
    
    
    convenience init(placeImage: UIImage?, placeID: String?, name: String?, rating: Double?, address: String?, location: CLLocationCoordinate2D? ) {
        self.init()
        self.placeImage = placeImage
        self.placeID = placeID
        self.name = name
        self.rating = rating
        self.address = address
        self.location = location
    }

    func fetchRemanRequestForParis(completionHandler: @escaping (_ viewModels: [PlaceViewModel], _ error: Error?) -> Void) {
        var restoViewModels: [PlaceViewModel] = []
        searchPlacesAPI.fetchRequestPlaces(requestURL, withCompletion: { [weak self] (result) in
            switch result {
            case.success (let searchResult):
                guard let results = searchResult.results else { return }
                for place in results {
                    self?.getPlaceImage(reference: (place.photos?.first?.reference)!, completionHandler: {(image) in
                        self?.rating = place.rating
                        self?.placeID = place.placeID
                        self?.name  = place.name
                        self?.address = place.address
                        if let latitude = place.geometry?.location?.latitude, let longitude = place.geometry?.location?.Longitude {
                            self?.location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
                        }
                        self?.placeImage = image
                        let viewModel = PlaceViewModel(placeImage: self?.placeImage, placeID: self?.placeID, name:self?.name, rating: self?.rating, address: self?.address, location: self?.location)
                        restoViewModels.append(viewModel)
                        completionHandler(restoViewModels, nil)
                    })
                }
            case.failure(let error):
                completionHandler([],error?.localizedDescription as? Error)
            }
        })
    }
    
    private func getPlaceImage(reference: String, completionHandler: @escaping (_ image: UIImage) -> Void) {
        let urlString = fetchImageURL.replacingOccurrences(of: "%photoref%", with: reference)
        if let url = URL(string:urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if error != nil {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchPlaceIcon(url:URL, completion:@escaping (_ icon: UIImage) -> Void ) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
    }
    
//    func fetchIcon(viewModel: PlaceViewModel, completion:@escaping (_ icon: UIImage) -> Void ) {
//        searchPlacesAPI.loadFirstPhotoForPlace(placeID: viewModel.placeID!) { (photo) in
//            DispatchQueue.main.async {
//                completion(photo)
//            }
//        }
//    }
}
