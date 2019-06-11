//
//  PhotoCell.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 09/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet var thumbnailImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(photo: Photo) {
        let thumbnailUrl = photo.thumbnailUrl
        // if thumbnail image is cache, display image from cache orelse download image from url
        if let data = ServiceManager.shared.thumbnailImage[thumbnailUrl] {
            self.thumbnailImgView.image = UIImage(data: data)
        } else {
            photo.displayImage(thumbnailUrl) { (data) in
                self.thumbnailImgView.image = UIImage(data: data)
            }
        }
    }
}
