//
//  MapViewController.m
//  Osprey
//
//  Created by Tyler Fallon on 3/5/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
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
        
        shareVC = [[ShareViewController alloc] initWithFrame:frame];

//Note: Simulator can't use CoreLocation, so we mimic it for now. Uncomment these lines before testing on phone
//        CLLocation *startLocation = map.myLocation;
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: startLocation.coordinate.latitude longitude:startLocation.coordinate.longitude zoom:9];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 37.424 longitude:-122.165 zoom:13];
        
        map = [GMSMapView mapWithFrame:frame camera:camera];
        map.delegate = self;
        map.myLocationEnabled = YES;
        map.userInteractionEnabled = YES;
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 50; //50 meters
        [locationManager startUpdatingLocation];
        
        int buttonLength = frame.size.width/12;
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-3*buttonLength/2, buttonLength/2, buttonLength, 4*buttonLength/5)];
        [shareButton setImage:[UIImage imageNamed:@"sharing_icon.png"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(sharePage) forControlEvents:UIControlEventTouchUpInside];
        [map addSubview:shareButton];
        
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

#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    GMSCameraPosition *update = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:6];
    [map setCamera:update];
}

#pragma GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if ([pindrops count] == MAX_COUNT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot add pin!" message:@"The drone can't get to this location." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.draggable = YES;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.flat = YES;
    marker.map = map;
    [pindrops addObject:marker];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    [pindrops removeObject:marker];
    marker.map = nil;
    return YES;
}

#pragma Share Button

- (void)sharePage {
    [self presentViewController:shareVC animated:YES completion:nil];
}

@end

