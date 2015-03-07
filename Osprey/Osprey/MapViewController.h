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
#import "ShareViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate> {    
    GMSMapView *map;
    CLLocationManager *locationManager;
    ShareViewController *shareVC;
}

- (id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) NSMutableArray *pindrops;


@end