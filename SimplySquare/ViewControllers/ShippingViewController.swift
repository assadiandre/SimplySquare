//
//  ShippingViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 12/16/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import SmartystreetsSDK

class ShippingViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet var xcollection:[UIView]!
    
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:.done,target:self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        
        if userDefaults.string(forKey: "zip") != nil {
            
            nameField.text! = userDefaults.string(forKey: "name")!
            addressField.text! = userDefaults.string(forKey: "address")!
            cityField.text! = userDefaults.string(forKey: "city")!
            stateField.text! = userDefaults.string(forKey: "state")!
            zipField.text! = userDefaults.string(forKey: "zip")!
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveInfo() {
        userDefaults.set(nameField.text!,forKey:"name")
        userDefaults.set(addressField.text!,forKey:"address")
        userDefaults.set(cityField.text!,forKey:"city")
        userDefaults.set(stateField.text!,forKey:"state")
        userDefaults.set(zipField.text!,forKey:"zip")
    }
    
    @IBAction func continueHandler(sender:UIAlertAction) -> Void {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
        saveInfo()
    }
    
    
    @IBAction func donePressed(sender: UIButton) -> Void {
        let address = checkAddress()
        
        if xcollection[0].isHidden == true && xcollection[1].isHidden == true && xcollection[2].isHidden == true && xcollection[3].isHidden == true && xcollection[4].isHidden == true {
            
            
            if Reachability.isConnectedToNetwork(){
                let result = address.run(address:addressField.text!,city:cityField.text!,state:stateField.text!,zip:zipField.text!)
                switch result {
                case 101 :
                    let alert = UIAlertController(title: "Warning", message: "Usps may not be able to ship to the given address. Is your info spelled correctly?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: continueHandler))
                    self.present(alert, animated: true, completion: nil)
                default :
                    navigationController?.popViewController(animated: true)
                    saveInfo()
                }
                
            }else{
                let alert = UIAlertController(title: "Could Not Verify Address", message: "Consider connecting to wifi or cellular", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: continueHandler))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
            
        else {
            
            let alert = UIAlertController(title: "Warning", message: "Make sure all of the fields have been completed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func lessThanTwo(textField:UITextField) -> Bool {
        if textField.text!.count < 2 {
            return false
        }
        else {
            return true
        }
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        xcollection[0].isHidden = lessThanTwo(textField:sender)
    }
    
    @IBAction func addressFieldChanged(_ sender: UITextField) {
        xcollection[1].isHidden = lessThanTwo(textField:sender)
    }
    
    
    @IBAction func cityFieldChanged(_ sender: UITextField) {
        xcollection[2].isHidden = lessThanTwo(textField:sender)
    }
    
    @IBAction func stateFieldChanged(_ sender: UITextField) {
        xcollection[3].isHidden = lessThanTwo(textField:sender)
    }
    
    @IBAction func zipFieldChanged(_ sender: UITextField) {
        xcollection[4].isHidden = lessThanTwo(textField:sender)
    }
    
    
    
    
}

