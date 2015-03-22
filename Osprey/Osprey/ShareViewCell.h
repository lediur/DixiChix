//
//  ShareViewCell.h
//  Osprey
//
//  Created by Tyler Fallon on 3/7/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *playButton;
@property BOOL shareGesture;
@property BOOL contentTapGesture;


@end
