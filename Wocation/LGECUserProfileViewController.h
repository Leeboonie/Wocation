//
//  LGECUserProfileViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/7/28.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LGECAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface LGECUserProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView *FBProfile;

@property (nonatomic, weak) IBOutlet UIImageView* profileBgImageView;

@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView1;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView2;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView3;

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* LearningWordsLabel;

@property (nonatomic, weak) IBOutlet UILabel* MemorizedWordsLabel;

@property (nonatomic, weak) IBOutlet UILabel* VisitedPlaceLabel;

@property (nonatomic, weak) IBOutlet UILabel* LearningWordsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* MemorizedWordsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* VisitedPlaceCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* bioLabel;

@property (nonatomic, weak) IBOutlet UILabel* friendLabel;

@property (nonatomic, weak) IBOutlet UIView* bioContainer;

@property (nonatomic, weak) IBOutlet UIView* friendContainer;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;


@end
