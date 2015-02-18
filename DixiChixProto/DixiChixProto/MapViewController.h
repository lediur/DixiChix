//
//  MapViewController.h
//  DixiChixProto
//
//  Created by Tyler Fallon on 2/17/15.
//  Copyright (c) 2015 Tyler Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController {
    int tapCount;
    UIImageView *map;
    UILabel *popExplanation;
}

- (id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) NSMutableArray *pindrops;


@end

