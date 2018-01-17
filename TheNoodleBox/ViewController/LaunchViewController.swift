//
//  LaunchScreenViewController.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 06/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = tabBarViewController
        }
        
        /* play video
        let filepath: String? = Bundle.main.path(forResource: "qidong", ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)

        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        //  hide show control
        avPlayerController.showsPlaybackControls = false
        // play video
        
        avPlayerController.player?.play()
        self.view.addSubview(avPlayerController.view)
        */
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
