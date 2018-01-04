//
//  RestaurantDetailsViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 04/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {

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
    
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
