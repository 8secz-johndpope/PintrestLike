//
//  NTTransitionProtocol.swift
//  PinterestSwift
//
//  Created by longwei on 7/2/14.
//  Copyright (c) 2014 longwei. All rights reserved.
//

import Foundation
import UIKit

@objc protocol NTTransitionProtocol{
    func transitionCollectionView() -> UICollectionView!
}

@objc protocol NTTansitionWaterfallGridViewProtocol{
    func snapShotForTransition() -> UIView!
}

@objc protocol NTWaterFallViewControllerProtocol : NTTransitionProtocol{
    func viewWillAppearWithPageIndex(_ pageIndex : NSInteger)
}

@objc protocol NTHorizontalPageViewControllerProtocol : NTTransitionProtocol{
    func pageViewCellScrollViewContentOffset() -> CGPoint
}
