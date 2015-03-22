//
//  ShareViewCell.m
//  Osprey
//
//  Created by Tyler Fallon on 3/7/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import "ShareViewCell.h"

@implementation ShareViewCell

@synthesize image, location, shareButton, shareGesture, contentTapGesture, playButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        shareGesture = contentTapGesture = NO;
        
        int labelWidth = frame.size.width/3;
        int buttonSize = frame.size.width/8;
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        image.userInteractionEnabled = YES;
        
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - buttonSize/2, frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)];
        [playButton setImage:[UIImage imageNamed:@"logo_play.png"] forState:UIControlStateNormal];
        playButton.alpha = 0;
        [image addSubview:playButton];
        
        location = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - labelWidth/4 - 5, 2*labelWidth, labelWidth/4)];
        location.textAlignment = NSTextAlignmentLeft;
        location.font = [UIFont systemFontOfSize:16];
        location.textColor = [UIColor whiteColor];
        location.numberOfLines = 1;
        location.adjustsFontSizeToFitWidth = NO;
        [image addSubview:location];
        
        [self addSubview:image];
        
        shareButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-3*buttonSize/2, (frame.size.height-buttonSize)/2, buttonSize, buttonSize)];
        shareButton.backgroundColor = [UIColor blueColor];
        [shareButton setTitle: @"Share" forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        CALayer *buttonLayer = shareButton.layer;
        [buttonLayer setCornerRadius:buttonSize/2];
        
        [self addSubview:shareButton];
    }
    
    return self;
}

@end
