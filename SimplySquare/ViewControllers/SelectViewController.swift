//
//  SelectViewController.swift
//  SimplySquare
//
//  Created by Andre Assadi on 11/11/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import UIKit
import Photos

struct totalPhotos {
    static var num = 0
}

class SelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var cameraRollView: UICollectionView!
    @IBOutlet weak var buttonsView: UICollectionView!
    var myVar = 0
    var anotherVar = 0
    var albumName:String = ""
    var previousSender:UIButton?
    var allowsReloadingOfTcrdata = true
    var position = 0

 
    
    var allPhotosSelected = true
    
    @IBOutlet weak var squareIndicator: UIView!
    @IBOutlet weak var selectedPhotosText: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        //imagesDisplayed.images!.removeAll()
        imagesDisplayed.data.removeAll()
        imagesDisplayed.newData.removeAll()
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
     
        configureNavigationController()
        
        
        cameraRollView.delegate = self
        cameraRollView.dataSource = self
        
        buttonsView.delegate = self
        buttonsView.dataSource = self
        
        cameraRollView.allowsSelection = true
        //cameraRollView.allowsMultipleSelection = true
        
        if totalPhotos.num > 0 {
            animateSquareIndicator()
        }
        
        photosTaken.backgroundColor[0] = [0.67,0.67,0.67,1.0]
        photosTaken.textColor[0] = [0.3,0.3,0.3,1.0]
        
        for i in 1 ... photosTaken.backgroundColor.count - 1 {
            
            photosTaken.backgroundColor[i] = [1.0,1.0,1.0,1.0]
            photosTaken.textColor[i] = [0.3,0.3,0.3,1.0]
        }
        buttonsView.reloadData()
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        squareIndicator.addGestureRecognizer(tapGestureRecognizer)
        
        
        imagesDisplayed.data.removeAll()
        imagesDisplayed.newData.removeAll()
    }
    
    
  
    func eraseChosenPhotos(sender: UIAlertAction) -> Void {
        
        
        for i in 0 ... photosTaken.selected.count - 1 {
            
            photosTaken.selected[i] = 0.0
   
        }
        
        for e in 0 ... photosTaken.selectedAlbum.count - 1 {
            
            for i in stride(from:0, to: (photosTaken.selectedAlbum[e].count) , by: 1) {
                photosTaken.selectedAlbum[e][i] = 0.0
            }
            
        }
        
        photosTaken.newCheckedImage.removeAll()
        photosTaken.newCheckedImageAlbum.removeAll()
        
        animateSquareIndicator()
        totalPhotos.num = 0
        cameraRollView.reloadData()
        
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Remove Photos", message: "Would you like to erase all your chosen photos?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: eraseChosenPhotos))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func helpPressed(sender: UIButton) -> Void {
        let vc = storyboard?.instantiateViewController(withIdentifier: "help")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func animateSquareIndicator() {
        
        
        totalPhotos.num = photosTaken.newCheckedImageAlbum.count + photosTaken.newCheckedImage.count
        selectedPhotosText.text = (totalPhotos.num > 1) ? String(totalPhotos.num) + " Photos Selected" : "1 Photo Selected"
        
        if photosTaken.newCheckedImageAlbum.count > 0 || photosTaken.newCheckedImage.count > 0 {
                
            UIView.animate(withDuration: 0.2, delay:0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.squareIndicator.center = CGPoint(x: self.squareIndicator.center.x , y: self.view.frame.height - (self.squareIndicator.frame.height + self.squareIndicator.frame.height/1.5) )
            },completion: nil )
            
        }
        
        else {
            
            UIView.animate(withDuration: 0.2, delay:0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.squareIndicator.center = CGPoint(x: self.squareIndicator.center.x , y: self.view.frame.height + (self.squareIndicator.frame.height + self.squareIndicator.frame.height/2) )
            },completion: nil )
            
        }
        
    }
    
    
    func selectLowQualityPhoto()  {
        
        photosTaken.selected[position] = 0.8
        photosTaken.newCheckedImage[position] = position
//        let indexPath = IndexPath(row:position , section: 0 )
//        cameraRollView.reloadItems(at: [indexPath])
        
        allowsReloadingOfTcrdata = false
        cameraRollView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 ) {
             self.allowsReloadingOfTcrdata = true
        }
        

        animateSquareIndicator()

    }
    
    func selectLowQualityPhotoFromAlbum()  {
        
        photosTaken.selectedAlbum[anotherVar][position] = 0.8
        photosTaken.newCheckedImageAlbum[String(position) + "0000" + String(anotherVar)] = [position,anotherVar]
        allowsReloadingOfTcrdata = false
        cameraRollView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.allowsReloadingOfTcrdata = true
        }
        animateSquareIndicator()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cameraRollView {
            if myVar == 0 {
                return photosTaken.cameraRollAssets.count
            }
            else {
                return photosTaken.albumRollAssets[anotherVar].count
            }
        }
        else {
            // Do other stuff
            return photosTaken.allAlbums.count
            

        }
    }
    
    let manager = PHImageManager.default()
    
    let tstFetchOptions = PHImageRequestOptions()
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.cameraRollView {
                tstFetchOptions.isSynchronous = true
                tstFetchOptions.isNetworkAccessAllowed = true
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )


                if myVar == 0 {
                    
                    
                        let imageView = cell.viewWithTag(1) as! UIImageView
                        let colorView = cell.viewWithTag(2) as UIView!
                        

                        manager.requestImage(for: photosTaken.cameraRollAssets[indexPath.row],
                                                  targetSize: CGSize(width: 120, height:120),
                                                  contentMode: .aspectFill,
                                                  options: tstFetchOptions) { (result, _) in
                                                    if let image = result {

                                                        imageView.image = image


                            }
                        }
                        
                        
                        if allowsReloadingOfTcrdata == true {
                            
                        manager.requestImageData(for: photosTaken.cameraRollAssets[indexPath.row], options: nil, resultHandler: { (data, str, orientation, info) -> Void in

                            if let Data = data {
                                let imageSize = (Data.count)/1024
                                if imageSize < 1000 {
                                    colorView?.alpha = 0.8
                                    photosTaken.lowQuality[indexPath.row] = 0.8
                                }

                                else {
                                    colorView?.alpha = 0
                                    photosTaken.lowQuality[indexPath.row] = 0
                                }

                            }
                            else {
                                colorView?.alpha = 0.8
                                photosTaken.lowQuality[indexPath.row] = 0.88
                            }
                        })

                    }
                    else {
                        colorView?.alpha = CGFloat(photosTaken.lowQuality[indexPath.row] )
                            
                    }
                    
                    
                    let imageView2 = cell.viewWithTag(4) as! UIImageView
                    imageView2.image = UIImage(named:"check")
                    imageView2.alpha = CGFloat(photosTaken.selected[  indexPath.row ])
                    
                    cell.layer.shouldRasterize = true
                    cell.layer.rasterizationScale = UIScreen.main.scale

                }
            
                else {
                
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    let colorView = cell.viewWithTag(2) as UIView!
                    
                    
                    
                    manager.requestImage(for: photosTaken.albumRollAssets[anotherVar][indexPath.row],
                                         targetSize: CGSize(width: 120.0, height: 120.0),
                                         contentMode: .aspectFill,
                                         options: tstFetchOptions) { (result, _) in
                                            if let image = result {
                                                
                                                imageView.image = image
                                                
                                                
                                            }
                    }
                
                    if allowsReloadingOfTcrdata == true {
                    manager.requestImageData(for: photosTaken.albumRollAssets[anotherVar][indexPath.row], options: nil, resultHandler: { (data, str, orientation, info) -> Void in
                        
                        if let Data = data {
                            let imageSize = (Data.count)/1024
                            if imageSize < 1000 {
                                colorView?.alpha = 0.8
                                photosTaken.albumPhotosQuality[self.anotherVar][indexPath.row] = 0.8
                            }

                            else {
                                colorView?.alpha = 0
                                photosTaken.albumPhotosQuality[self.anotherVar][indexPath.row] = 0
                            }

                        }
                        else {
                            colorView?.alpha = 0.8
                            photosTaken.albumPhotosQuality[self.anotherVar][indexPath.row] = 0.88
                        }

                    })
                        
                    }
                    else {
                        colorView!.alpha = CGFloat(photosTaken.albumPhotosQuality[anotherVar][indexPath.row])
                    }
                    
                    let imageView2 = cell.viewWithTag(4) as! UIImageView
                    imageView2.image = UIImage(named:"check")
                    imageView2.alpha = CGFloat(photosTaken.selectedAlbum[anotherVar][  indexPath.row ])
                    
                }
            
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
            
            
                return cell
        }
        else {
            
            let textColors = photosTaken.textColor[indexPath.row]
            let backColors = photosTaken.backgroundColor[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
            let text = cell.viewWithTag(1) as! UILabel
            text.text = photosTaken.allAlbums[indexPath.row]
            text.textColor = UIColor(red:textColors[0], green:textColors[1], blue:textColors[2],alpha:textColors[3])
            text.backgroundColor = UIColor(red:backColors[0], green:backColors[1], blue:backColors[2],alpha:backColors[3])
            

            return cell
        }
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cameraRollView {
            let width = collectionView.frame.width / 3 - 1
            return CGSize(width: width ,height:width)
        }
        else {
            // Do stuff
            //print( photosTaken.allAlbums[indexPath.row].count )
            let width = CGFloat( photosTaken.allAlbums[indexPath.row].count * 12 ) 
            return CGSize(width: width ,height:collectionView.frame.height )
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cameraRollView {
            return 1.0
        }
        else {
            // Do stuff
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cameraRollView {
            return 1.0
        }
        else {
            // Do stuff
            return 0.0
        }
    }
    
    
    
    
    func yesHandler(sender:UIAlertAction) -> Void {
        if anotherVar == 0 {
            selectLowQualityPhoto()
        }
        else {
            selectLowQualityPhotoFromAlbum()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.cameraRollView {
            position = indexPath.row
            
            if anotherVar == 0 {

                if photosTaken.lowQuality[position] == 0.8 && photosTaken.selected[position] == 0.0  {

                    let alert = UIAlertController(title: "Warning", message: "This photo is of low quality. Would you like to procceed?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yesHandler))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else if photosTaken.lowQuality[position] == 0.88 {
                    let alert = UIAlertController(title: "Uh Oh", message: "It looks like this photo is stored on iCloud, this is likeley due to the amount of photos stored on your device. Download the image or click 'Get Photo' for assistance.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Get Photo", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    if photosTaken.selected[position] == 0.0 {
                        // if selected by camera roll
                        photosTaken.selected[position] = 0.8
                        photosTaken.newCheckedImage[position] = position
                        
                    }
                    else if photosTaken.selected[position] == 0.8 {
                        // if deselected by camera roll
                        photosTaken.selected[position] = 0.0
                        photosTaken.newCheckedImage.removeValue(forKey: position)
                        
                    }
                }
                
                
            }
            else {
                
                if photosTaken.albumPhotosQuality[anotherVar][position] == 0.8 && photosTaken.selectedAlbum[anotherVar][position] == 0.0 {
                    
                    let alert = UIAlertController(title: "Warning", message: "This photo is of low quality. Would you like to procceed?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yesHandler))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if photosTaken.albumPhotosQuality[anotherVar][position] == 0.88 {
                    let alert = UIAlertController(title: "Uh Oh", message: "It looks like this photo is stored on iCloud, this is likeley due to the amount of photos stored on your device. Download the image or click 'Get Photo' for assistance.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Get Photo", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    if photosTaken.selectedAlbum[anotherVar][position] == 0.0 {
                        // if selected from one othe albums
                        photosTaken.selectedAlbum[anotherVar][position] = 0.8
                        photosTaken.newCheckedImageAlbum[String(position) + "0000" + String(anotherVar)] = [position,anotherVar]
                    }
                    else if photosTaken.selectedAlbum[anotherVar][position] == 0.8 {
                        // if deslected by one of the albums
                        photosTaken.selectedAlbum[anotherVar][position] = 0.0
                        photosTaken.newCheckedImageAlbum.removeValue(forKey: String(position) + "0000" + String(anotherVar))
                    }
                }
                
                
            }
            animateSquareIndicator()
            
            allowsReloadingOfTcrdata = false
            cameraRollView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.05) {
                self.allowsReloadingOfTcrdata = true
            }
        }
        
        else {
            
            photosTaken.backgroundColor[anotherVar] = [1.0,1.0,1.0,1.0]
            photosTaken.textColor[anotherVar] =  [0.3,0.3,0.3,1.0]
            
            let tag2 = Int( indexPath.row )
            anotherVar = tag2
            
            if anotherVar == 0 {
                myVar = 0
                cameraRollView.reloadData()
                
            }
            else {
                //            if photosTaken.albumRollAssets[self.anotherVar].count == 0 {
                //                photosTaken.grabAlbumPhotos(albumName:photosTaken.allAlbums[self.anotherVar], albumPosition: self.anotherVar)
                //            }
                myVar = 1
                cameraRollView.reloadData()
            }
            
            photosTaken.backgroundColor[self.anotherVar] = [0.67,0.67,0.67,1.0]
            photosTaken.textColor[self.anotherVar] = [0.3,0.3,0.3,1.0]
            
            let topOffest:CGPoint = CGPoint(x:0,y:self.cameraRollView.contentInset.top)
            self.cameraRollView.setContentOffset(topOffest, animated: true)
            
            
            //
            //        if currentIndex != previousIndex {
            //            buttonsView.reloadItems(at: [currentIndex,previousIndex] )
            //        }
            
            buttonsView.reloadData()
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if photosTaken.cameraRollAssets.count > 1000 && anotherVar == 0 {
//            cameraRollView.reloadData()
//        }
//    }
    

    

    
    
    @IBAction func `continue`(_ sender: UIButton) {
        if totalPhotos.num >= 3 {
        
            performSegue(withIdentifier: "selectToFinish",sender: self)
            
        }
        else {
            
            let alert = UIAlertController(title: "Warning", message: "You must select at least 3 photos to proceed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }}









