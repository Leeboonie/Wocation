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

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* LearningWordsLabel;

@property (nonatomic, weak) IBOutlet UILabel* MemorizedWordsLabel;

@property (nonatomic, weak) IBOutlet UILabel* VisitedPlaceLabel;

@property (nonatomic, weak) IBOutlet UILabel* LearningWordsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* MemorizedWordsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* VisitedPlaceCountLabel;

@property (strong, nonatomic) IBOutlet UITableView *feedView;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) NSMutableDictionary *json_dictionary;

@property (copy, nonatomic) NSMutableArray *json_array;


@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;

//- (IBAction)addNewWord:(id)sender;
- (IBAction)FetchUserFeeds:(id)sender;
- (void)json_loaded;
- (IBAction)logout:(id)sender;


@end
