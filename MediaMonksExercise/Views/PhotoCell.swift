//
//  PhotoCollectionCellCollectionViewCell.swift
//  MediaMonksExercise
//
//  Created by Suresh Sagwal on 09/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet var thumbnailImgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(photo: Photo) {
        self.lblTitle.text = photo.title
        let thumbnailUrl = photo.thumbnailUrl
        if let data = ServiceManager.shared.thumbnailImage[thumbnailUrl] {
            self.thumbnailImgView.image = UIImage(data: data)
        } else {
            self.displayThumbnailImage(thumbnailUrl)
        }
    }
    
    func displayThumbnailImage(_ urlString: String) {
        serviceManager.downlaodThumbnailImage(urlString, completionHandler: { (result) in
            switch result {
            case .error(let error):
                print(error)
                break
            case .results(let result):
                serviceManager.thumbnailImage[urlString] = result
                self.thumbnailImgView.image = UIImage(data: result)
                break
            }
        })
    }
    
}
