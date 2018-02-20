//
//  PaymentViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 12/11/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import SwiftLuhn


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

/// Payment class starts here

class PaymentViewController: UIViewController,UITextFieldDelegate {
    
    
 
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var creditcardField: UITextField!
    @IBOutlet weak var monthyearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet var xcollection:[UIView]!
    let userDefaults = UserDefaults.standard

    
    @IBAction func donePressed(sender: UIButton) -> Void {
        view.endEditing(true)
        

        
        if (creditcardField.text!.count == 19 && (monthyearField.text!.count == 5 && xcollection[1].isHidden == true ) && cvvField.text!.count == 3 && (emailField.text!.contains("@") && emailField.text!.contains(".") ) && phoneField.text!.count == 14) {
            let cardTable = monthyearField.text!.split(separator: "/")
            let cardNumberString = creditcardField.text!.removingWhitespaces()
            
            userDefaults.set(Int(cardNumberString)!,forKey:"creditNumber")
            userDefaults.set(cardTable[0],forKey:"creditExpMonth")
            userDefaults.set(cardTable[1],forKey:"creditExpYear")
            userDefaults.set(Int(cvvField.text!)!,forKey:"creditCvv")
            userDefaults.set(emailField.text!,forKey:"email")
            userDefaults.set(phoneField.text!,forKey:"phoneNumber")

            
            if cardNumberString.isValidCardNumber() {
                ///paymentToFinish
                navigationController?.popViewController(animated: true)

            }
            else {
                let alert = UIAlertController(title: "Invalid Information", message: "Please make sure your card information is correct.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
        else {
            let alert = UIAlertController(title: "Warning", message: "One or more fields have not been completed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if userDefaults.string(forKey: "phoneNumber") != nil {
            creditcardField.text = modifyCreditCardString(creditCardString: String(userDefaults.integer(forKey: "creditNumber")))
            monthyearField.text = userDefaults.string(forKey: "creditExpMonth")! + "/" + userDefaults.string(forKey: "creditExpYear")!
            cvvField.text = String(userDefaults.integer(forKey: "creditCvv"))
            emailField.text = userDefaults.string(forKey: "email")
            phoneField.text = userDefaults.string(forKey: "phoneNumber")

        }
        
        
        creditcardField.delegate = self
        creditcardField.addTarget(self, action: #selector(creditcardFieldChanged), for:.editingChanged)
        monthyearField.delegate = self
        monthyearField.addTarget(self, action: #selector(monthyearFieldChanged), for:.editingChanged)
        cvvField.delegate = self
        cvvField.addTarget(self, action: #selector(cvvFieldChanged), for:.editingChanged)
        cvvField.isSecureTextEntry = true
        emailField.addTarget(self, action: #selector(emailFieldChanged), for:.editingChanged)
        phoneField.delegate = self
        phoneField.addTarget(self, action: #selector(phoneFieldChanged), for:.editingChanged)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:.done,target:self, action: #selector(donePressed))
        
        self.navigationItem.rightBarButtonItem = doneButton

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @objc func creditcardFieldChanged(){
        creditcardField.text = modifyCreditCardString(creditCardString: creditcardField.text!)
        
        if creditcardField.text!.count < 19 {
            xcollection[0].isHidden = false
        }
        else {
            xcollection[0].isHidden = true
        }
    }
    
    
    @objc func monthyearFieldChanged(){
        modifyMonthYearString()
        if monthyearField.text!.count < 5 {
            xcollection[1].isHidden = false
        }
        else {
            xcollection[1].isHidden = true
            
            let cardTable = monthyearField.text!.split(separator: "/")

            if Int(cardTable[0])! > 12 {
                xcollection[1].isHidden = false
            }
            else if Int(cardTable[1])! > 50  {
                xcollection[1].isHidden = false
            }
            
        }
    }
    
    @objc func cvvFieldChanged(){
        
        if cvvField.text!.count < 3 {
            xcollection[2].isHidden = false
        }
        else {
            xcollection[2].isHidden = true
        }
        
        
    }
    
    @objc func emailFieldChanged(){
        if emailField.text!.contains("@") && emailField.text!.contains(".")  {
            xcollection[3].isHidden = true
        }
        else {
            xcollection[3].isHidden = false
        }
        
        
    }
    
    @objc func phoneFieldChanged(){
        modifyPhoneFieldString()
        
        
        if phoneField.text!.count < 14 {
            xcollection[4].isHidden = false
        }
        else {
            xcollection[4].isHidden = true
        }
        
    }
    
    var phonePass = [false, false]
    
    func modifyPhoneFieldString() {
        
        if phoneField.text!.count == 3 && phonePass[0] == false  {
            phonePass[0] = true
            phoneField.text = "(" + phoneField.text! + ")-"
            
            
        }
            
        else if phoneField.text!.count == 9 && phonePass[1] == false  {
            phonePass[1] = true
            phoneField.text =  phoneField.text! + "-"
            
        }
        
        if phoneField.text!.count == 5 && phonePass[0] == true{
            phoneField.text!.removeFirst()
            let i = phoneField.text!.index(of: ")")
            phoneField.text!.remove(at:i!)
            phonePass[0] = false
        }
        
        if phoneField.text!.count == 6 {
            phonePass[1] = false
        }
        
    }
    
    var slashPassed = false
    func modifyMonthYearString() {
        
        if monthyearField.text!.count == 2 && slashPassed == false  {
            monthyearField.text = monthyearField.text! + "/"
            slashPassed = true
        }
        if monthyearField.text!.count == 1 {
            slashPassed = false
        }
        
    }

    
    
    func modifyCreditCardString(creditCardString : String) -> String
    {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0)
        {
            for i in 0...arrOfCharacters.count-1
            {
                modifiedCreditCardString.append(arrOfCharacters[i])
                
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count)
                {
                    
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = textField.text!.count + string.count - range.length
        
        if(textField == creditcardField)
        {
            return newLength <= 19
        }
        else if(textField == monthyearField)
        {
            return newLength <= 5
        }
        else if(textField == cvvField)
        {
            return newLength <= 3
        }
        else if(textField == phoneField)
        {
            return newLength <= 14
        }
        return true
    }


}



