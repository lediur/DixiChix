//
//  ExpandedImageView.h
//  Osprey
//
//  Created by Tyler Fallon on 3/21/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandedImageView : UIView {
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame;
- (void)setNewFrame:(CGRect)newFrame;
- (void)setImage:(UIImage *)image;

@end
