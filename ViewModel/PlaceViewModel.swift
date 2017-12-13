//
//  RestaurantPlaceViewModel.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation
import UIKit


class PlaceViewModel {
    
     let requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=48.8566,2.3522&radius=5000&type=restaurant&keyword=ramen&key=AIzaSyBQJD3y2EQN720QXY_BRvE7O95URRD7TY8"

    let searchPlacesAPI = SearchPlacesAPI()
    
    var iconURL: URL?
    var placeID: String?
    var name: String?
    var rating: Double?
    var address: String?
    
    convenience init(iconURL: URL?, placeID: String?, name: String?, rating: Double?, address: String?) {
        self.init()
        self.iconURL = iconURL
        self.placeID = placeID
        self.name = name
        self.rating = rating
        self.address = address
    }

    func fetchRemanRequestForParis(completionHandler: @escaping (_ viewModels: [PlaceViewModel], _ error: Error?) -> Void) {
        var restoViewModels: [PlaceViewModel] = []
        searchPlacesAPI.fetchRequestPlaces(requestURL, withCompletion: { (result) in
            switch result {
            case.success (let searchResult):
                guard let results = searchResult.results else { return }
                for place in results {
                    self.iconURL = URL(string: place.icon!)
                    self.name  = place.name
                    self.rating = place.rating
                    self.address = place.address
                    self.placeID = place.placeID
                    
                    let viewModel = PlaceViewModel(iconURL: self.iconURL, placeID: self.placeID, name:self.name, rating: self.rating, address: self.address)
                    restoViewModels.append(viewModel)
                }
                completionHandler(restoViewModels, nil)
            case.failure(let error):
                completionHandler([],error?.localizedDescription as? Error)
            }
        })
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
}
