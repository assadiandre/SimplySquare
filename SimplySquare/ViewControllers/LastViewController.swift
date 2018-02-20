//
//  LastViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 12/16/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import M13ProgressSuite


class LastViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    let bar = M13ProgressViewBorderedBar()
    var postAllowed = true
    var CHARGEID:String?

    
    @IBAction func cancelTransaction(_ sender: UIButton) {
        
        
        
        let returnString = "https://cryptic-spire-59656.herokuapp.com/refund.php"
        let params = ["charge":CHARGEID!]
        
        
        Alamofire.request(returnString,method:.post, parameters: params).responseJSON { response in
            
            print(response.result)
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if goBack.value == true {
            
            navigationController?.popViewController(animated: true)
            goBack.value = false
        }
        
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        pay()
        
        let screenWidth = self.view.frame.size.width

        bar.frame = CGRect(x:(screenWidth / 2) - (self.view.frame.width/2) ,y:80,width:self.view.frame.width,height:80)
        bar.borderWidth = 0
        bar.backgroundColor = UIColor(red:0.078,green:0.27,blue:0.352,alpha:0.75)
        bar.primaryColor = UIColor.white
        bar.secondaryColor = UIColor.white
        bar.setProgress(0.6,animated: true)
        bar.animationDuration = 10
        
        view.addSubview(bar)
    }
    
    
    
    func pay() {
        
        let cardParams = STPCardParams()
        cardParams.number = "4242424242424242" //String(userDefaults.integer(forKey: "creditNumber"))
        cardParams.expMonth = UInt(userDefaults.string(forKey: "creditExpMonth")!)!
        cardParams.expYear = UInt( String("20" + userDefaults.string(forKey: "creditExpYear")!) )!
        cardParams.cvc = userDefaults.string(forKey: "creditCvv")!
        cardParams.name = userDefaults.string(forKey: "name")!
        cardParams.address.line1 = userDefaults.string(forKey: "address")
        cardParams.address.city = userDefaults.string(forKey:"city")
        cardParams.address.country = "USA"
        cardParams.address.state = userDefaults.string(forKey: "state")
        
        
        STPAPIClient.shared().createToken(withCard: cardParams, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                
                
                self.chargeUsingToken(token: token)
            }
        })
    }
    
    
    func chargeUsingToken(token:STPToken) {
        
        let requestString = "https://cryptic-spire-59656.herokuapp.com/charge.php"
        let params = [
              "stripeToken": token.tokenId,
              "amount": "100",
              "currency": "usd",
              "description": "tiles",
              "email": userDefaults.string(forKey: "email")!
        ]
       
        
        
        Alamofire.request(requestString,method:.post, parameters: params)
            .responseJSON { response in
                
                
                print("Result: \(response.result) ")
                self.CHARGEID = String(describing: response.result.value! )
                
                
                let finalResponse = String( describing: response.result )
                if finalResponse == "SUCCESS" {
                    self.bar.setProgress(1,animated: true)
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                    self.bar.animationDuration = 1
                }
                

        }
        
        


    }
    
    @objc func update() {
        self.performSegue(withIdentifier: "sendingToDone", sender: self)
    }


}
