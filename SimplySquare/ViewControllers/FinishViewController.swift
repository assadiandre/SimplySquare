//
//  FinishViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 12/3/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase
import M13ProgressSuite

struct imageVars {
    static var imageToEdit = UIImage()
}

struct imagesDisplayed {
    static var data:[Data] = []
    static var newData:[Data?] = []
    
    static var testImage = UIImage(named:"back")
    //static var images:[UIImage]? = []
}


class FinishViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CropViewControllerDelegate,  UINavigationControllerDelegate, UITextFieldDelegate{
    

    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet var prices:[UILabel]!
    @IBOutlet var priceDes:[UILabel]!
    @IBOutlet var blueCheck:[UIImageView]!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var promoButton: UIButton!
    
    
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    var currentImageIndex:Int = 0
    var promos:[String:String] = [:]
    let promoInput = UIAlertController(title: "Promo Code", message: "Got a code?", preferredStyle: .alert)
    var discount = 0.0
    var totalPrice = 0.0
    var cameraAssets:[PHAsset] = []
    var albumAssets:[PHAsset] = []
    var imagesCopy:[UIImage?] = []
    

    @objc func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func configureNavigationController() {
        
        let helpButton = UIBarButtonItem(title: "Help",style: UIBarButtonItemStyle.done,target:self, action: #selector(helpPressed))
        let helpColor = UIColor(red: 0.03, green: 0.57, blue: 0.92, alpha: 1.0)
        helpButton.tintColor = helpColor
        self.navigationItem.rightBarButtonItem = helpButton
        
        
        let backImage = UIImage(named: "back")
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        navigationController?.navigationBar.isHidden = false
        
    }
    
    func configurePromoTextField() {
        
        promoInput.addTextField(configurationHandler: nil)
        promoInput.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        promoInput.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: confirmHandler))
        
        let promoTextField = promoInput.textFields![0]
        promoTextField.delegate = self
        promoTextField.autocapitalizationType = .allCharacters
        promoTextField.placeholder = "ENTER HERE"
        
    }
    
    func configureImages() {
        DispatchQueue.global(qos: .background).async {
            for i in 0 ..< imagesDisplayed.data.count {
                let image = UIImage(data:imagesDisplayed.data[i])
                let newImage = self.cropToBounds(image: image!, width: 1, height: 1)
                imagesDisplayed.newData.append( UIImageJPEGRepresentation(newImage, 0.7)! )
            }
            
            DispatchQueue.main.sync {
                self.imagesCollection.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func configureBlueChecks() {
        let userDefaults = UserDefaults.standard
        
        blueCheck[0].alpha = ((userDefaults.string(forKey:"creditNumber")) != nil) ? 1 : 0
        blueCheck[1].alpha = ((userDefaults.string(forKey:"address")) != nil) ? 1 : 0
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(true)
        configureBlueChecks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollection.dataSource = self
        imagesCollection.delegate = self
        
        
        for (_, value) in photosTaken.newCheckedImage {
            cameraAssets.append(photosTaken.cameraRollAssets[value])
        }
        
        for (_, value) in photosTaken.newCheckedImageAlbum {
            albumAssets.append( photosTaken.albumRollAssets[value[1]][value[0]] )
        }
        
        
        for i in 0 ..< self.cameraAssets.count {
            photosTaken.getImageWithData(asset:self.cameraAssets[i],index:i)
        }
        
        for i in 0 ..< self.albumAssets.count {
            photosTaken.getImageWithData(asset:self.albumAssets[i],index:i)
        }
        
        configureImages()
        configureNavigationController()
        configurePromoTextField()
        configureBlueChecks()
        updatePrices()
    }
    

    // Code for promo
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addPromoValue(sender:UIAlertAction) -> Void {
        updatePrices()
    }

    func confirmHandler(sender:UIAlertAction) -> Void {
        
            var didFindPromo = false
    
            for (key, value) in (promos) {
    
                if key == promoInput.textFields![0].text {
                    // Here we want to execute code for given promo
                    didFindPromo = true
                    self.discount = Double(value)!
                    
                    let validPromo = UIAlertController(title: "Success!", message: "" , preferredStyle: .alert)
                    validPromo.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default, handler: addPromoValue))

                    switch self.discount {
                        
                        case 0.1 ... 1.0:
                        
                            validPromo.message = "Congratulation! Enjoy your " + String( Int( Double(value)! * 100 )) + "% off!"
                        
                        default:
                            validPromo.message = "Congratulation! Enjoy your $" + String(self.discount) + " off!"
                        

                    }
                    
                    present(validPromo,animated: true,completion: nil)
  
                }
            }
    
            if didFindPromo == false {
                // Here we want to show an alert
                var invalidPromo = UIAlertController()
                
                if Reachability.isConnectedToNetwork(){
                  invalidPromo = UIAlertController(title: "Invalid Promo!", message: "Your promotion code is not valid.", preferredStyle: .alert)
                }else{
                  invalidPromo = UIAlertController(title: "Network Error", message: "Please connect to the internet and try again.", preferredStyle: .alert)
                }
                invalidPromo.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                present(invalidPromo,animated: true,completion: nil)

                
            }
    
        
    }
    

    @IBAction func addPromo(_ sender: Any) {
        

        present(promoInput,animated: true,completion: nil)
        
        
        let promoData = Database.database().reference()
        
        promoData.child("Promos").observe(.value, with: { snapshot in
            
            
            for (key, value) in (snapshot.value as! NSDictionary) {
                self.promos[key as! String] = "\(value)"
            }
            
            
        })

    }
    
    // Help button pressed
    @IBAction func helpPressed(sender: UIButton) -> Void {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "help")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    // Updates the prices
    
    
    func updatePrices() {
        
        var attributedString:NSMutableAttributedString?
        
            totalPrice = Double( 55 + (imagesDisplayed.data.count - 3) * 12 )
        
        
            priceDes[1].text = (imagesDisplayed.data.count <= 3) ? "No additional squares": (imagesDisplayed.data.count - 3 == 1) ? String(imagesDisplayed.data.count - 3) + " additional square" : String(imagesDisplayed.data.count - 3) + " additional squares"
            

        
        switch discount {
            case 0.1 ... 0.99 :
                prices[0].text = "$55"
                prices[1].text = (imagesDisplayed.data.count <= 3) ? "" : "$" + String((imagesDisplayed.data.count - 3) * 12)
                prices[2].text = "-$" + String( round( (Double(totalPrice) * discount) * 100 )/100)
                prices[3].text = "FREE"
                totalPrice = round(100 * (Double(totalPrice) - ( Double(totalPrice) * discount) ) ) / 100
                    attributedString = NSMutableAttributedString(string: "TOTAL $" + String( totalPrice ), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
            case 1.01 ... 5000 :
                totalPrice = ( totalPrice - Double(discount) < 0 ) ? 0 : totalPrice - Double(discount)
                prices[0].text = "$55"
                prices[1].text = (imagesDisplayed.data.count <= 3) ? "" : "$" + String((imagesDisplayed.data.count - 3) * 12)
                prices[2].text =  "-$" + String(discount)
                prices[3].text = "FREE"
                
                if totalPrice == 0 {
                    attributedString = NSMutableAttributedString(string: "FREE", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
                }
                else {
                    attributedString = NSMutableAttributedString(string: "TOTAL $" + String( totalPrice ), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
                }
            case 1.0:
                totalPrice = 0
                prices[0].text = "   "
                prices[1].text = "   "
                prices[2].text = "FREE"
                prices[3].text = "   "
                
                attributedString = NSMutableAttributedString(string: "FREE", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
            default :
                prices[0].text = "$55"
                prices[1].text = (imagesDisplayed.data.count - 3 > 0) ? "$" + String((imagesDisplayed.data.count - 3) * 12) : ""
                prices[2].text = "   "
                prices[3].text = "FREE"
                attributedString = NSMutableAttributedString(string: "Total $" + String(totalPrice), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        }
        

        doneButton.setAttributedTitle(attributedString, for: UIControlState.normal)
        
    }
    
    
    // Code for image selection w alerts
    
    func reselectHandler(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    func editHandler(alert: UIAlertAction!) {
        imageVars.imageToEdit = UIImage(data:imagesDisplayed.data[currentImageIndex])!//imagesDisplayed.testImage!
        cropImage()
    }
    
    func deleteHandler(alert:UIAlertAction!) {
        if imagesDisplayed.data.count > 3 {
            imagesDisplayed.data.remove(at: currentImageIndex)
            imagesDisplayed.newData.remove(at: currentImageIndex)
            imagesCollection.reloadData()
            updatePrices()
        }
        else {
            let alert = UIAlertController(title: "Uh Oh", message: "You need at least 3 squares to complete your order!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Reselect", style: UIAlertActionStyle.default, handler: reselectHandler ))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func imageTapped(sender: UIButton) -> Void {
        
        currentImageIndex = Int(sender.accessibilityIdentifier!)!
        let alert = UIAlertController(title: "Select Action", message: "Edit your square or delete it", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: editHandler))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: deleteHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    var itemCellSize: CGSize = CGSize(width: 230 ,height:230)
    var itemCellsGap: CGFloat = 10.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemCellsGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 10.0, 0.0, 20.0)
    }
    
    // Setting the collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDisplayed.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )

            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = ( imagesDisplayed.newData.indices.contains(indexPath.row) == true ) ? UIImage(data:imagesDisplayed.newData[indexPath.row]!) : UIImage(named:"blueBack")
        
            let button = cell.viewWithTag(2) as! UIButton
            button.addTarget(self, action: #selector(imageTapped), for: UIControlEvents.touchUpInside)
            button.accessibilityIdentifier = String(indexPath.row)
        
            let ring = cell.viewWithTag(3) as? M13ProgressViewRing
            ring?.progressRingWidth = 12
            ring?.backgroundRingWidth = 12
            ring?.showPercentage = false
            ring?.indeterminate = true
            ring?.primaryColor = UIColor.white
            ring?.secondaryColor = UIColor.white
            ring?.alpha = ( imagesDisplayed.newData.indices.contains(indexPath.row) == true ) ? 0 : 1

            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
        
            return cell

    }
    
    
  
    
    
    /// Crop Functions
    
    
    func cropImage() {
    
        let theImage = imageVars.imageToEdit
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: theImage)
        cropController.delegate = self
        
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPreset = .presetSquare;
        cropController.aspectRatioLockEnabled = true
        
        self.present(cropController, animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        let index = IndexPath(row: currentImageIndex , section: 0 )
        let cell = self.imagesCollection.cellForItem(at: index)
        
        let newImageView = cell!.viewWithTag(1) as! UIImageView
        newImageView.image = image
        
        imagesDisplayed.data[currentImageIndex] = UIImageJPEGRepresentation(image,0.7)!
        imagesDisplayed.newData[currentImageIndex] = UIImageJPEGRepresentation(image,0.7)!
        
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }


}








