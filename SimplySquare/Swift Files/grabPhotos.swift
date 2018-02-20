//
//  grabPhotos.swift
//  SimplySquare
//
//  Created by Andre Assadi on 11/18/17.
//  Copyright © 2017 Andre Assadi. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Darwin

class grabPhotos {
    
    var cameraRollPhotos = [UIImage]()
    var albumPhotos = [[UIImage]()]
    var albumPhotosQuality = [[Double]()]
    var allAlbums = [String]()
    var itemTag = [String]()
    var lowQuality = [Double]()
    var selected = [Double]()
    var selectedAlbum = [[Double]()]
    var checkedImages:[[Int]] = []
    
    var testTable = [UIImage]()
    
    var newCheckedImage:[Int : Int ] = [:]
    
    var newCheckedImageAlbum:[String : [Int] ] = [:]
    
    var backgroundColor = [[CGFloat]()]
    var textColor = [[CGFloat]()]
    
    var cameraRollAssets = [PHAsset]()
    var albumRollAssets = [[PHAsset]()]
    

    
    init() {}//Do nothing
    
    let manager = PHImageManager.default()
    
    func fetchNSData (asset:PHAsset) -> Double? {
        
        var returnValue:Double?
        
        manager.requestImageData(for: asset, options: nil, resultHandler: { (data, str, orientation, info) -> Void in
            
            if let Data = data {
                let imageSize = (Data.count)/1024
                if imageSize < 1000 {
                    returnValue = 0.8
                }
                    
                else {
                    returnValue = 0.0
                }
                
            }

        })

        return returnValue
    }
    
    
    func getImageWithData(asset:PHAsset,index:Int)   {
        
        let specialRequestOptions = PHImageRequestOptions()
        specialRequestOptions.isSynchronous = true
        
//        let specialRequestOptions2 = PHImageRequestOptions()
//        specialRequestOptions2.isSynchronous = false
        
        self.manager.requestImageData(for: asset, options: specialRequestOptions, resultHandler: { (data, str, orientation, info) -> Void in
            
            imagesDisplayed.data.append(data!)
            
        })
        
//        self.manager.requestImage(for: asset, targetSize: CGSize(width:300,height:300), contentMode: PHImageContentMode.aspectFill, options: specialRequestOptions2) { (image, info) in
//
//            if imagesDisplayed.images!.count - 1 < index {
//                imagesDisplayed.images!.append(image!)
//
//            }
//            else {
//                imagesDisplayed.images![index] = (image!)
//
//            }
//
//            print(index)
//
//        }
        

    }
    

    
    
    func cacheImages(assets:[PHAsset]) {
        let imageCaching = PHCachingImageManager()
        imageCaching.allowsCachingHighQualityImages = true
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        
        imageCaching.startCachingImages(for:assets,targetSize:CGSize(width:300,height:300),contentMode:.aspectFill,options:requestOptions )
        
    }


    
    func grabAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending: false)]

        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        assets.enumerateObjects({ (asset, count, stop) in
            // self.cameraAssets.add(object)
            
            print(count)
            self.lowQuality.append(0)
            self.selected.append(0)
            self.cameraRollAssets.append(asset)
        })
    }
    
    
    func grabAlbumPhotos(albumName:String,albumPosition:Int) {


        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        let newfetchOptions = PHFetchOptions()
        newfetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending: false)]
        newfetchOptions.predicate = NSPredicate(format: "mediaType = %d",1)
        
        let assetCollection = collection.firstObject! as PHAssetCollection
        
        let photoAssets = PHAsset.fetchAssets( in: assetCollection, options: newfetchOptions)
        photoAssets.enumerateObjects { (asset, count, stop) in
            
            self.albumPhotosQuality[albumPosition].append(0)
            self.selectedAlbum[albumPosition].append(0)
            self.albumRollAssets[albumPosition].append(asset)
            
        }
        
        
    }
    

    func start() {

        let fetchOptions = PHFetchOptions()
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        // grab camera roll photos
        grabAllPhotos()
        
        self.allAlbums.append("All Photos")
        self.itemTag.append(String(0))
        self.backgroundColor[0] = ([0.67,0.67,0.67,1.0])
        self.textColor[0] = ([0.3,0.3,0.3,1.0])
        

        for i in 0 ..< collection.count {
            self.allAlbums.append(collection[i].localizedTitle!)
            self.albumRollAssets.append([PHAsset]())
            self.albumPhotosQuality.append([Double]())
            self.itemTag.append(String(i+1))
            self.selectedAlbum.append([Double]())
            self.backgroundColor.append([1.0,1.0,1.0,1.0])
            self.textColor.append([0.3,0.3,0.3,1.0])
        }
        
        
        
        for i in 1 ..< allAlbums.count {

            self.grabAlbumPhotos(albumName:allAlbums[i], albumPosition: i)

        }
        
        

    }
    
    
    
    
    /// These function fetch the images from camera roll
    func grabCertainPhotoInAlbum(albumName:String,index:Int) -> UIImage {
        
        
        var myImage = UIImage(named:"")
        let imgManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        let assetCollection = collection.firstObject as! PHAssetCollection
        
        
        let newFetchOptions = PHFetchOptions()
        newFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending: false)]
        newFetchOptions.predicate = NSPredicate(format: "mediaType = %d",1)
        
        let photoAssets = PHAsset.fetchAssets( in: assetCollection, options: newFetchOptions) as! PHFetchResult<AnyObject>

        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        
        imgManager.requestImage(for: photoAssets.object(at: index) as! PHAsset , targetSize: CGSize(width:300,height:300),contentMode: .aspectFill, options: requestOptions, resultHandler: {
            
            image,error in
            
            
            myImage = image!
            
        } )
        
        return myImage!
        
    }
    
    
    var myImage:UIImage?
    let imgManager = PHImageManager.default()
    let requestOptions = PHImageRequestOptions()

    func grabCertainPhoto(asset:PHAsset)  -> UIImage {


        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        // cameraRollAssets[index]
        
        imgManager.requestImage(for: asset  , targetSize: PHImageManagerMaximumSize,contentMode: .aspectFill, options: requestOptions, resultHandler: {
                
                image,error in
                
                
                
                self.myImage = image
                
                
                
            } )

        
        return myImage!
        
    }
    
    
    
    
    
    

    
    
}


    
    
    
    
    
    
    
    
    
    
    
    

