////
////  CollectionViewController.swift
////  SimplySquare
////
////  Created by Andre Assadi on 11/16/17.
////  Copyright © 2017 Andre Assadi. All rights reserved.
////
//
//import UIKit
//import Photos
//
//
//class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//
//
//
//    var imageArray = [UIImage]()
//
//    var anotherImageArray = [UIImage]()
//
//    override func viewDidLoad(){
//        //grabPhotos()
//        FetchCustomAlbumPhotos(albumName:"Snapchat")
//
//    }
//
//
//
//    func FetchCustomAlbumPhotos(albumName:String)
//    {
//        let albumName = albumName
//        var assetCollection = PHAssetCollection()
//        var albumFound:Bool
//        var photoAssets = PHFetchResult<AnyObject>()
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let _:AnyObject = collection.firstObject{
//            //found the album
//            assetCollection = collection.firstObject as! PHAssetCollection
//            albumFound = true
//        }
//        else { albumFound = false }
//        _ = collection.count
//        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
//        let imageManager = PHCachingImageManager()
//
//        //        let imageManager = PHImageManager.defaultManager()
//
//        photoAssets.enumerateObjects{(object: AnyObject!,
//            count: Int,
//            stop: UnsafeMutablePointer<ObjCBool>) in
//
//            print(count)
//
//            if object is PHAsset{
//                let asset = object as! PHAsset
//
//                let imageSize = CGSize(width: asset.pixelWidth,
//                                       height: asset.pixelHeight)
//
//                /* For faster performance, and maybe degraded image */
//                let options = PHImageRequestOptions()
//                options.deliveryMode = .fastFormat
//                options.isSynchronous = true
//
//                imageManager.requestImage(for: asset,
//                  targetSize: imageSize,
//                  contentMode: .aspectFill,
//                  options: options,
//                  resultHandler: {
//                    (image, info) -> Void in
//                    //self.addImgToArray(uploadImage: image!)
//                    self.imageArray.append(image!)
//                })
//
//            }
//        }
//    }
////
////    func addImgToArray(uploadImage:UIImage)
////    {
////        anotherImageArray.append(uploadImage)
////
////    }
////
////    func grabPhotos(){
////
////
////        let imgManager = PHImageManager.default()
////        let requestOptions = PHImageRequestOptions()
////        requestOptions.isSynchronous = true
////        requestOptions.deliveryMode = .opportunistic
////
////
////        let fetchOptions = PHFetchOptions()
////        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending: false)]
////
////        let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
////
////
////
////
////        if fetchResult.count > 0 {
////
////            for i in 0..<fetchResult.count {
////
////                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width:200,height:200),contentMode: .aspectFill, options: requestOptions, resultHandler: {
////
////                    image,error in
////
////                    self.imageArray.append(image!)
////
////                } )
////            }
////
////        }
////        else {
////            print("You got no photos!")
////            self.collectionView?.reloadData()
////        }
////
////    }
//
//
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageArray.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
//
//        let imageView = cell.viewWithTag(1) as! UIImageView
//        imageView.image = imageArray[indexPath.row]
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width / 3 - 1
//
//        return CGSize(width: width ,height:width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
//
//
//
//}

