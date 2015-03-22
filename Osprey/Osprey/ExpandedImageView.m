//
//  ExpandedImageView.m
//  Osprey
//
//  Created by Tyler Fallon on 3/21/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import "ExpandedImageView.h"

@implementation ExpandedImageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor blackColor];
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.center = self.center;
        [self addSubview:imageView];
    }
    
    return self;
}

- (void)setNewFrame:(CGRect)newFrame {
    [imageView setFrame:newFrame];
    imageView.center = self.center;
}

- (void)setImage:(UIImage *)image {
    imageView.image = image;
}

@end
