//
//  HelpViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 12/19/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import MessageUI




class HelpViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func exit(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func contact(_ sender: Any) {
        
//        let navigationBarAppearance = UINavigationBar.appearance()
//        let previousColor = navigationBarAppearance.barTintColor
//        navigationBarAppearance.barTintColor = .black
//        let textPrevious = navigationBarAppearance.titleTextAttributes
//        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let mailComposeViewController = configuredMailComposeViewController()
//        navigationBarAppearance.barTintColor = previousColor
//        navigationBarAppearance.titleTextAttributes = textPrevious
        
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        mailComposerVC.setToRecipients(["info@simplysquareapp.com"])
        mailComposerVC.setSubject("New Message")
        mailComposerVC.setMessageBody("Hey SimplySquare,", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle:UIAlertControllerStyle.alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
    

