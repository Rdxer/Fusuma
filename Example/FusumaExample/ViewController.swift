//
//  ViewController.swift
//  Fusuma
//
//  Created by ytakzk on 01/31/2016.
//  Copyright (c) 2016 ytakzk. All rights reserved.
//

import UIKit
import Photos



class ViewController: UIViewController, FusumaDelegate
{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var fileUrlLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showButton.layer.cornerRadius = 2.0
        self.fileUrlLabel.text = ""
        
        fusumaSelectImageCellLayerInitFunc = {
            $0.borderWidth = 2
            $0.borderColor = UIColor.blue.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let fusuma = FusumaViewController()
    
    @IBAction func showButtonPressed(_ sender: AnyObject) {

        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = true
        fusumaSavesImage = true

        self.present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
        
        case .library:
            
            print("Image selected from Camera Roll")
        
        default:
        
            print("Image selected")
        }
        
        imageView.image = image
    }
    func fusumaMultipleImagePHAssetSelected(_ imageAssets: [PHAsset], source: FusumaMode) {
        print("Number of selection images: \(imageAssets.count)")
        var count: Double = 0
        
        for asset in imageAssets {
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                self.fusuma.requestImage(with: asset, completion: { (asset, img) in
                    self.imageView.image = img
                })
            }
            count += 1
        }
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")

        var count: Double = 0
        
        for image in images {
        
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
            
                self.imageView.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("video completed and output to file: \(fileURL)")
        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
        switch source {
        
        case .camera:
        
            print("Called just after dismissed FusumaViewController using Camera")
        
        case .library:
        
            print("Called just after dismissed FusumaViewController using Camera Roll")
        
        default:
        
            print("Called just after dismissed FusumaViewController")
        }
    }
}

