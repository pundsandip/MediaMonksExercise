//
//  PhotoViewController.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 09/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    let lodingView = LodingView()
    @IBOutlet var collectionView: UICollectionView!
    var albumId: Int = 0
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lodingView.show()
        self.view.addSubview(lodingView)
        serviceManager.fetchPhotosList { [unowned self] result in
            self.lodingView.hide()
            switch result {
            case .error(let error):
                print(error)
                break
            case .results(let result):
                self.photos = result.filter({$0.albumId == self.albumId })
                self.collectionView.reloadData()
            }
        }
        
    }

}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        cell.backgroundColor = .white
        let photo = self.photos[indexPath.row]
        cell.setData(photo: photo)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.bounds.width / 4 - 6
        let height: CGFloat = 100.0
        return CGSize(width: width, height: height)
    }
    
}
