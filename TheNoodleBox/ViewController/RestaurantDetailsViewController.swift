//
//  RestaurantDetailsViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 04/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var placeDetailsScrollView: UIScrollView!
     @IBOutlet weak var placeInfoStackView: UIStackView!
    
    
    func setupViewController(placeViewModel: PlaceViewModel) {
        placeViewModel.fetchPlaceIcon(url: placeViewModel.iconURL!, completion: {(image) in
            self.placeImageView.image = image
        })
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

        placeDetailsScrollView.contentOffset = CGPoint(x: 0, y: -320)
        placeDetailsScrollView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)

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
