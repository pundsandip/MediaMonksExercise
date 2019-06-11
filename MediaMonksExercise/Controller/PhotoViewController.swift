//
//  PhotoViewController.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 09/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var currentLeftSafeAreaInset  : CGFloat = 0.0
    var currentRightSafeAreaInset : CGFloat = 0.0
    
    var selectedIndexPath: IndexPath!
    
    
    @IBOutlet var collectionView: UICollectionView!
    var albumId: Int = 0
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lodingView = LodingView()
        lodingView.show()
        self.view.addSubview(lodingView)
        
        serviceManager.fetchPhotosList { [unowned self] result in
            lodingView.hide()
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
    
    override func viewSafeAreaInsetsDidChange() {
        
        if #available(iOS 11, *) {
            self.currentLeftSafeAreaInset = self.view.safeAreaInsets.left
            self.currentRightSafeAreaInset = self.view.safeAreaInsets.right
        }
        
    }
    
    
    
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        
        if !visibleCells.contains(self.selectedIndexPath) {
            
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            
            return guardedCell.thumbnailImgView
        }
        else {
            
            
            guard let guardedCell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell else {
                
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            
            return guardedCell.thumbnailImgView
        }
        
    }
    
    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        
        
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        
        if !visibleCells.contains(self.selectedIndexPath) {
            
            
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            
            
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            
            
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            
            return guardedCell.frame
        }
            
        else {
            
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            return guardedCell.frame
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "ShowPhotoPageView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoPageView" {
            let nav = self.navigationController
            let vc = segue.destination as! PhotoPageContainerViewController
            nav?.delegate = vc.transitionController
            vc.transitionController.fromDelegate = self
            vc.transitionController.toDelegate = vc
            vc.delegate = self
            vc.currentIndex = self.selectedIndexPath.row
            vc.photos = self.photos
        }
    }
    
}

extension PhotoViewController: PhotoPageContainerViewControllerDelegate {
    
    func containerViewController(_ containerViewController: PhotoPageContainerViewController, indexDidUpdate currentIndex: Int) {
        self.selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
    }
}

extension PhotoViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        let cell = self.collectionView.cellForItem(at: self.selectedIndexPath) as! PhotoCell
        
        let cellFrame = self.collectionView.convert(cell.frame, to: self.view)
        
        if cellFrame.minY < self.collectionView.contentInset.top {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .top, animated: false)
        } else if cellFrame.maxY > self.view.frame.height - self.collectionView.contentInset.bottom {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .bottom, animated: false)
        }
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        
        //Get a guarded reference to the cell's UIImageView
        let referenceImageView = getImageViewFromCollectionViewCell(for: self.selectedIndexPath)
        
        return referenceImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        
        //Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)
        
        let cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)
        
        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }
        
        return cellFrame
    }
    
}

