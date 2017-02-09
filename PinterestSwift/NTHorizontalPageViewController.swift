//
//  NTHorizontalPageViewController.swift
//  PinterestSwift
//
//  Created by longwei on 7/1/14.
//  Copyright (c) 2014 longwei. All rights reserved.
//

import Foundation
import UIKit

let horizontalPageViewCellIdentify = "horizontalPageViewCellIdentify"

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{

}

class NTHorizontalPageViewController : UICollectionViewController, NTTransitionProtocol ,NTHorizontalPageViewControllerProtocol ,UINavigationControllerDelegate{
    
    var imageNameList : Array <NSString> = []
    var pullOffset = CGPoint.zero
    var percentDrivenInteractiveTransition:UIPercentDrivenInteractiveTransition?
    var inited = false
    
    
    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: IndexPath){
        super.init(collectionViewLayout:layout)
        let collectionView :UICollectionView = self.collectionView!;
        collectionView.isPagingEnabled = true
        collectionView.register(NTHorizontalPageViewCell.self, forCellWithReuseIdentifier: horizontalPageViewCellIdentify)
        collectionView.setToIndexPath(indexPath)
        collectionView.performBatchUpdates({collectionView.reloadData()},
                                           completion: { finished in
                                            if finished {
                                                collectionView.scrollToItem(at: indexPath,at:.centeredHorizontally, animated: true)
                                            }});
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell: NTHorizontalPageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: horizontalPageViewCellIdentify, for: indexPath) as! NTHorizontalPageViewCell
        collectionCell.imageName = self.imageNameList[(indexPath as NSIndexPath).row] as String
        collectionCell.tappedAction = {}
        collectionCell.pullAction = { offset in
            self.pullOffset = offset
            self.navigationController?.tt_popViewController(animated: true)
        }
        collectionCell.horizontalVC = self
        collectionCell.setNeedsLayout()
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageNameList.count;
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    func pageViewCellScrollViewContentOffset() -> CGPoint{
        return self.pullOffset
    }

    func tt_scrollViewDidScroll(contentOffsetY: CGFloat)
    {
        //NSLog("contentOffsetY = %f", contentOffsetY)
        var process:CGFloat = 0.0
        let offset = -contentOffsetY
        process = offset / (screenHeight/2)
        
        if offset > 10 && inited == false {
            inited = true
            self.percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.tt_popViewController(animated: true)
        }
        else if offset > 10 && process < 0.5 {
            self.percentDrivenInteractiveTransition?.update(process)
        }
        else if offset > 10 {
            self.percentDrivenInteractiveTransition?.finish()
        }
        else if inited == true {
            self.percentDrivenInteractiveTransition?.cancel()
            self.percentDrivenInteractiveTransition = nil
            inited = false
        }
    }
    
// MARK: - navigationController delegate
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = NTTransition()
        transition.pop = operation == .pop
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return percentDrivenInteractiveTransition
    }
    
    // MARK: -
    
} //class
