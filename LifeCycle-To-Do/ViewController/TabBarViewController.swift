//
//  TabBarViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 18/5/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
}
