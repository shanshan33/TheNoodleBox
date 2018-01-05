//
//  RecipeViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 07/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var noodleImageView: UIImageView!
    @IBOutlet weak var recipeScrollView: UIScrollView!
    @IBOutlet weak var recipeDetailStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension RecipeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            noodleImageView.frame.size.height = 320 - offsetY
        } else {
            noodleImageView.frame.size.height = noodleImageView.frame.height
        }
    }
    
}
