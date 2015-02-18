//
//  MapViewController.m
//  DixiChixProto
//
//  Created by Tyler Fallon on 2/17/15.
//  Copyright (c) 2015 Tyler Fallon. All rights reserved.
//

#import "MapViewController.h"

#define MAX_COUNT 5

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize pindrops;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super init]) {
        pindrops = [[NSMutableArray alloc] initWithCapacity:MAX_COUNT];
        tapCount = 0;
        
        map = [[UIImageView alloc] initWithFrame:frame];
        map.userInteractionEnabled = YES;
        map.image = [UIImage imageNamed:@"BrnoTrackMap.png"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinDropped:)];
        [map addGestureRecognizer:tapGesture];
        
        popExplanation = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - frame.size.width/2, frame.size.width, frame.size.width/2)];
        popExplanation.backgroundColor = [UIColor redColor];
        popExplanation.alpha = 0;
        [map addSubview:popExplanation];
        
        [self.view addSubview:map];
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

- (void)addPin:(CGPoint) touchPoint {
    UILabel *pin = [[UILabel alloc] initWithFrame:CGRectMake(touchPoint.x-10, touchPoint.y-10, 20, 20)];
    pin.text = [NSString stringWithFormat:@"%i", tapCount];
    
    [map addSubview:pin];
}

- (void)pinDropped:(UITapGestureRecognizer*)tap {
    if(tapCount == MAX_COUNT) {
        tap.cancelsTouchesInView = YES;
        popExplanation.text = @"Cannot add more than 10";
        [self.view bringSubviewToFront:popExplanation];
        popExplanation.alpha = 1;
        [UIView animateWithDuration:1 delay:.5 options:0 animations:^{
            popExplanation.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
    CGPoint touchPoint = [tap locationInView:self.view];
    if ([self tooClose:touchPoint]) {
        tap.cancelsTouchesInView = YES;
        popExplanation.text = @"Too close to other point";
        [self.view bringSubviewToFront:popExplanation];
        popExplanation.alpha = 1;
        [UIView animateWithDuration:1 delay:.5 options:0 animations:^{
            popExplanation.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
    tapCount++;
    [pindrops addObject:[NSValue valueWithCGPoint:touchPoint]];
    [self addPin:touchPoint];
}

@end
