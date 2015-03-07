//
//  ShareViewCell.m
//  Osprey
//
//  Created by Tyler Fallon on 3/7/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import "ShareViewCell.h"

@implementation ShareViewCell

@synthesize image, date, location;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        int imageSize = frame.size.width/2;
        int labelWidth = frame.size.width/3;
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(imageSize/2, imageSize/12, imageSize, 2*imageSize/3)];
        [self addSubview:image];
        
        date = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth/2, image.frame.origin.y + image.frame.size.height, labelWidth, labelWidth/4)];
        date.textAlignment = NSTextAlignmentCenter;
        date.font = [UIFont systemFontOfSize:16];
        date.textColor = [UIColor blackColor];
        date.numberOfLines = 1;
        date.adjustsFontSizeToFitWidth = NO;
        [self addSubview:date];
        
        location = [[UILabel alloc] initWithFrame:CGRectMake(3*labelWidth/2, image.frame.origin.y + image.frame.size.height, labelWidth, labelWidth/4)];
        location.textAlignment = NSTextAlignmentCenter;
        location.font = [UIFont systemFontOfSize:16];
        location.textColor = [UIColor blackColor];
        location.numberOfLines = 1;
        location.adjustsFontSizeToFitWidth = NO;
        [self addSubview:location];
    }
    
    return self;
}

@end
