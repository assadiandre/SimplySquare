//
//  ConfirmViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 1/9/18.
//  Copyright © 2018 Andre Assadi. All rights reserved.
//

import UIKit

struct goBack {
    
    static var value = false
}

class ConfirmViewController: UIViewController {
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func update() {
        navigationController!.popViewController(animated:true)
        goBack.value = true
    }

}
