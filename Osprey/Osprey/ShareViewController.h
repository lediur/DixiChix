//
//  ShareViewController.h
//  Osprey
//
//  Created by Tyler Fallon on 3/7/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    UICollectionView *shareCollection;
}

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSMutableArray *images;

@end
