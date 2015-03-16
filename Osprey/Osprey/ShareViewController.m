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
#import <AVFoundation/AVFoundation.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize images;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        alreadyUploaded = [[NSMutableSet alloc] init];
        
        NSMutableDictionary *placeholderImage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"March 7th, 2015", @"Date", @"Laguna Seca", @"Location", @"sick_aerial_car.jpg", @"Image", nil];
        NSMutableDictionary *placeholderVideo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"March 7th, 2015", @"Date", @"Laguna Seca", @"Location", [[NSBundle mainBundle] pathForResource:@"DroneRecordingCompressed" ofType:@"mp4"], @"Video", nil];
        images = [[NSMutableArray alloc] initWithObjects:[placeholderImage mutableCopy], [placeholderVideo mutableCopy], [placeholderImage mutableCopy], [placeholderVideo mutableCopy], [placeholderImage mutableCopy], nil];
        
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
    
    NSMutableDictionary *imageInfo = [images objectAtIndex:indexPath.row];
    
    if ([imageInfo objectForKey:@"Image"])
        shareCell.image.image = [UIImage imageNamed:imageInfo[@"Image"]];
    else if ([imageInfo objectForKey:@"Thumbnail"])
        shareCell.image.image = [imageInfo objectForKey:@"Thumbnail"];
    else {
        NSURL *contentUrl = [[NSURL alloc] initFileURLWithPath:imageInfo[@"Video"]];
        
        MPMoviePlayerController *videoController = [[MPMoviePlayerController alloc] initWithContentURL:contentUrl];
        [videoController setShouldAutoplay:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDone:) name:MPMoviePlayerDidExitFullscreenNotification object:videoController];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentUrl options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(10, 1);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        
        if (error == nil) {
            UIImage *frameImage= [[UIImage alloc] initWithCGImage:refImg];
            [shareCell.image setImage:frameImage];
        }
        
        [imageInfo setObject:videoController forKey:@"VideoController"];
    }
        
    shareCell.location.text = imageInfo[@"Location"];
    shareCell.date.text = imageInfo[@"Date"];
    
    shareCell.shareButton.tag = indexPath.row;
    if (!shareCell.shareTapGesture)
        [shareCell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    shareCell.image.tag = indexPath.row;
    if (!shareCell.contentTapGesture) {
        shareCell.image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewContent:)];
        [shareCell.image addGestureRecognizer:tap];
        shareCell.contentTapGesture = tap;
    }
    
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
    NSString *graphPath;
    if (imageInfo[@"Image"]) {
        graphPath = @"me/photos";
        [params setObject:[NSString stringWithFormat:@"%@, %@", imageInfo[@"Date"], imageInfo[@"Location"]] forKey:@"message"];
        [params setObject:UIImagePNGRepresentation([UIImage imageNamed:imageInfo[@"Image"]]) forKey:@"source"];
    } else {
        graphPath = @"me/videos";
        [params setObject:[NSString stringWithFormat:@"%@, %@", imageInfo[@"Date"], imageInfo[@"Location"]] forKey:@"description"];
        [params setObject:[NSData dataWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:imageInfo[@"Video"]]] forKey:@"DroneRecordingCompressed.mp4"];
    }
    
    
    
    [FBRequestConnection startWithGraphPath:graphPath parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [alreadyUploaded addObject:[NSNumber numberWithInt:index]];
        } else
            NSLog(@"Upload failed");
    }];
}

#pragma Content Button

- (void)viewContent:(UITapGestureRecognizer *)tapGesture {
    int index = (int)tapGesture.view.tag;
    NSDictionary *imageInfo = [images objectAtIndex:index];
    
    if (imageInfo[@"Image"]) {
        //expand image
    } else {
        MPMoviePlayerController *videoController = imageInfo[@"VideoController"];
        [videoController prepareToPlay];
        
        if (![[self.view subviews] containsObject:videoController.view]) {
            [videoController.view setFrame:self.view.frame];
            [self.view addSubview:videoController.view];
        } else
            videoController.view.alpha = 1;
        
        [videoController setFullscreen:YES animated:YES];
        [videoController play];
    }
}

//- (void)handleThumbnail:(NSNotification *)notification {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *imageInfo;
//        for (int i = 0; i < [images count]; i++) {
//            imageInfo = [images objectAtIndex:i];
//            if (imageInfo[@"VideoController"] == notification.object) {
//                UIImage *thumbnail = [notification.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
//                [imageInfo setValue:thumbnail forKey:@"Thumbnail"];
//                [shareCollection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
//                break;
//            }
//        }
//    });
//}

- (void)handleDone:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        ((MPMoviePlayerController*)(notification.object)).view.alpha = 0;
        [((MPMoviePlayerController*)(notification.object)) stop];
    });
}

@end
