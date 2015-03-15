//
//  ShareViewController.m
//  Osprey
//
//  Created by Tyler Fallon on 3/7/15.
//  Copyright (c) 2015 Dixi Chix. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize images;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        alreadyUploaded = [[NSMutableSet alloc] init];
        
        NSDictionary *placeholderImage = @{@"Date": @"March 7th, 2015", @"Location":@"Laguna Seca", @"Image":@"sick_aerial_car.jpg"};
        images = [[NSMutableArray alloc] initWithObjects:placeholderImage, placeholderImage, placeholderImage, placeholderImage, placeholderImage, nil];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0.0f];
        [flowLayout setMinimumLineSpacing:0.0f];
        
        shareCollection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [shareCollection registerClass:[ShareViewCell class] forCellWithReuseIdentifier:@"ShareViewCell"];
        
        shareCollection.pagingEnabled = NO;
        shareCollection.showsVerticalScrollIndicator = NO;
        shareCollection.backgroundColor = [UIColor whiteColor];
        shareCollection.delegate = self;
        shareCollection.dataSource = self;
        
        [self.view addSubview:shareCollection];
        
        int buttonLength = frame.size.width/12;
        UIButton *compassButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-3*buttonLength/2, buttonLength/2, buttonLength,buttonLength)];
        [compassButton setImage:[UIImage imageNamed:@"compass_icon.jpg"] forState:UIControlStateNormal];
        [compassButton addTarget:self action:@selector(backToMap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:compassButton];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ShareCollection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return images.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(shareCollection.frame.size.width, shareCollection.frame.size.height/4);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareViewCell *shareCell = (ShareViewCell *)[shareCollection dequeueReusableCellWithReuseIdentifier:@"ShareViewCell" forIndexPath:indexPath];
    
    NSDictionary *imageInfo = [images objectAtIndex:indexPath.row];
    
    shareCell.image.image = [UIImage imageNamed:imageInfo[@"Image"]];
    shareCell.location.text = imageInfo[@"Location"];
    shareCell.date.text = imageInfo[@"Date"];
    shareCell.shareButton.tag = indexPath.row;
    if (!shareCell.tapGesture)
        [shareCell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return shareCell;
}

#pragma Compass Button

- (void)backToMap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Share Button

- (void)shareButtonPressed:(UIButton *)shareButton{
    if ([alreadyUploaded containsObject:[NSNumber numberWithInt:(int)shareButton.tag]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Uploaded!" message:@"You already uploaded this to Facebook." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error)
                NSLog(@"Login failed");
            else {
                [FBSession setActiveSession:session];
                [self shareContent:(int)shareButton.tag];
            }
        }];
    } else {
        [self shareContent:(int)shareButton.tag];
    }
}

- (void)shareContent:(int)index {
    NSDictionary *imageInfo = [images objectAtIndex:index];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%@, %@", imageInfo[@"Date"], imageInfo[@"Location"]] forKey:@"message"];
    [params setObject:UIImagePNGRepresentation([UIImage imageNamed:imageInfo[@"Image"]]) forKey:@"source"];
    
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [alreadyUploaded addObject:[NSNumber numberWithInt:index]];
        } else
            NSLog(@"Upload failed");
    }];
}

@end
