//
//  MapViewController.h
//  Osprey
//
//  Created by Tyler Fallon on 3/5/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate> {
    int tapCount;
    //UIImageView *map;
    UILabel *popExplanation;
    
    GMSMapView *map;
    CLLocationManager *locationManager;
}

- (id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) NSMutableArray *pindrops;


@end