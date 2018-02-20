//
//  ViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 11/7/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import Photos
import M13ProgressSuite

var photosTaken = grabPhotos()

struct photoLibaryLoaded {
    static var status = false
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var dots: [UIImageView]!
    @IBOutlet weak var getStartedButton: UIButton!
    var imageArray:[UIImage] = []
    let bar = M13ProgressViewRing()
    let bar2 = M13ProgressViewRing()
    
    
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
    
    
    func configureNavigationController() {
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let backImage = UIImage(named: "back")
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        scrollView.delegate = self
        

        imageArray = [ UIImage(named:"f1")!,UIImage(named:"f2")!,UIImage(named:"f3")!,UIImage(named:"f4")!,UIImage(named:"f5")!]
        
        var contentWidth:CGFloat = 0

        for i in 0...4 {
            let imageToDisplay = UIImage(named: "f\(i)")
            let imageView = UIImageView(image:imageToDisplay)
            
            
            let xCoordinate = view.frame.midX + view.frame.width * CGFloat(i)
            contentWidth += view.frame.width
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x:xCoordinate - view.frame.width/2,y:0, width: view.frame.width, height: view.frame.height + 1)
        }
        
        scrollView.contentSize = CGSize(width:contentWidth,height:view.frame.height)
        
        
//

//        progress.mode = .determinate
//        progress.animationType = .fade


//        progress.areDefaultMotionEffectsEnabled = true
//        progress.progress = 0.5
//        view.addSubview(progress)
        
        
        let imgManager = PHImageManager.default() //Warmups up request

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x/CGFloat(view.frame.width))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    func createProgressRing() {
        bar.frame = CGRect(x:getStartedButton.center.x - 10,y:getStartedButton.center.y - 10,width:20,height:20)
        bar.progressRingWidth = 3
        bar.backgroundRingWidth = 3
        bar.showPercentage = false
        bar.indeterminate = true
        bar.indeterminateReverse = true
        bar.primaryColor = UIColor.black
        bar.secondaryColor = UIColor.black
        view.addSubview(bar)
        
        bar2.frame = CGRect(x:getStartedButton.center.x - 17.5,y:getStartedButton.center.y - 17.5,width:35,height:35)
        bar2.progressRingWidth = 3
        bar2.backgroundRingWidth = 3
        bar2.showPercentage = false
        bar2.indeterminate = true
        //bar.indeterminateReverse = true
        bar2.primaryColor = UIColor.black
        bar2.secondaryColor = UIColor.black
        view.addSubview(bar2)
    }
    
    func removeProgressRing() {
        
        bar.removeFromSuperview()
        bar2.removeFromSuperview()
        
    }
    
    @IBAction func getStarted(_ sender : Any) {
    
        if photoLibaryLoaded.status == false {
            createProgressRing()
            getStartedButton.setTitle("", for: .normal)
            DispatchQueue.global(qos: .background).async {
                photosTaken.start()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "startToSelect",sender: self)
                    self.removeProgressRing()
                    photoLibaryLoaded.status = true
                    self.getStartedButton.setTitle("Get Started", for: .normal)
                }
            }
        }
        else { self.performSegue(withIdentifier: "startToSelect",sender: self) }
            
        
            
    }


    
    
}

    // NOT PART OF CLASS
    extension UIScrollView {
        var currentPage: Int {
            return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
        }

    }



