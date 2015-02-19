//
//  ViewController.m
//  DixiChixProto2
//
//  Created by Tyler Fallon on 2/17/15.
//  Copyright (c) 2015 Tyler Fallon. All rights reserved.
//

#import "MapViewController.h"

#define ARC4RANDOM_MAX 0x100000000

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize pindrops;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super init]) {
        pindrops = [[NSMutableArray alloc] initWithCapacity:10];
        tapCount = 0;
        
        map = [[UIImageView alloc] initWithFrame:frame];
        map.userInteractionEnabled = YES;
        map.image = [UIImage imageNamed:@"StanfordRoute.png"];
        map.alpha = .2;
        [self.view addSubview:map];

        addPin = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - frame.size.width/2, frame.size.width, frame.size.width)];
        addPin.backgroundColor = [UIColor blueColor];
        [addPin setTitle:@"Drop a pin at your current location!" forState:UIControlStateNormal];
        [addPin.layer setCornerRadius:frame.size.width/2];
        [addPin.layer setMasksToBounds:YES];
        addPin.userInteractionEnabled = YES;
        [addPin addTarget:self action:@selector(addPin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addPin];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tooClose:(CGPoint) touchPoint{
    for (int i=0; i<tapCount; i++) {
        if(fabsf((([(NSValue*)[pindrops objectAtIndex:i] CGPointValue]).x - touchPoint.x)) < 10
           && fabsf((([(NSValue*)[pindrops objectAtIndex:i] CGPointValue]).y - touchPoint.y)) < 10) {
            return YES;
        }
    }
    return NO;
}

- (void)addPin: (UITapGestureRecognizer*)tap {
    tapCount++;
    
    CGPoint touchPoint = CGPointMake([self randomInRange:self.view.frame.size.width], [self randomInRange:self.view.frame.size.height]);
    NSLog(@"(%f, %f)", touchPoint.x, touchPoint.y);
    UILabel *pin = [[UILabel alloc] initWithFrame:CGRectMake(touchPoint.x-10, touchPoint.y-10, 20, 20)];
    pin.text = [NSString stringWithFormat:@"%i", tapCount];
    
    [map addSubview:pin];
    [map bringSubviewToFront:pin];
    addPin.backgroundColor = [UIColor greenColor];
    [pindrops addObject:[NSValue valueWithCGPoint:touchPoint]];
    
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        addPin.backgroundColor = [UIColor blueColor];
    } completion:^(BOOL finished) {
        
    }];
}

- (float)randomInRange:(CGFloat)max {
    float f = arc4random();
    f /= ARC4RANDOM_MAX;
    f *= max;
    return f;
}

@end

