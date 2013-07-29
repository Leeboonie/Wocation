//
//  LGECUserProfileViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/7/28.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECUserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface LGECUserProfileViewController ()<FBPlacePickerDelegate,CLLocationManagerDelegate>

@end




@implementation LGECUserProfileViewController
@synthesize placePickerController = _placePickerController;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//**---------------UI design----------------**
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.9f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    self.nameLabel.text = @"";
    
    self.usernameLabel.textColor =  mainColor;
    self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.usernameLabel.text = @"";
    
    UIFont* countLabelFont = [UIFont fontWithName:boldItalicFontName size:20.0f];
    UIColor* countColor = mainColor;
    
    self.LearningWordsCountLabel.textColor =  countColor;
    self.LearningWordsCountLabel.font =  countLabelFont;
    self.LearningWordsCountLabel.text = @"132k";
    
    self.MemorizedWordsCountLabel.textColor =  countColor;
    self.MemorizedWordsCountLabel.font =  countLabelFont;
    self.MemorizedWordsCountLabel.text = @"200";
    
    self.VisitedPlaceCountLabel.textColor =  countColor;
    self.VisitedPlaceCountLabel.font =  countLabelFont;
    self.VisitedPlaceCountLabel.text = @"20k";
    
    UIFont* socialFont = [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    self.LearningWordsLabel.textColor =  mainColor;
    self.LearningWordsLabel.font =  socialFont;
    self.LearningWordsLabel.text = @"Learning Words";
    
    self.MemorizedWordsLabel.textColor =  mainColor;
    self.MemorizedWordsLabel.font =  socialFont;
    self.MemorizedWordsLabel.text = @"Memorized Words";
    
    self.VisitedPlaceLabel.textColor =  mainColor;
    self.VisitedPlaceLabel.font =  socialFont;
    self.VisitedPlaceLabel.text = @"Visited Places";
    
    
    self.bioLabel.textColor =  mainColor;
    self.bioLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.bioLabel.text = @"Founder, CEO of Mavin Records, Entrepreneur mom and action gal";
    
    self.friendLabel.textColor =  mainColor;
    self.friendLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];;
    self.friendLabel.text = @"Friends";
    
    //self.profileImageView.image = [UIImage imageNamed:@"profile.jpg"];
    self.FBProfile.contentMode = UIViewContentModeScaleAspectFill;
    self.FBProfile.clipsToBounds = YES;
    self.FBProfile.layer.borderWidth = 4.0f;
    self.FBProfile.layer.cornerRadius = 55.0f;
    self.FBProfile.layer.borderColor = imageBorderColor.CGColor;
    
    self.bioContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bioContainer.layer.borderWidth = 4.0f;
    self.bioContainer.layer.cornerRadius = 5.0f;
    
    self.friendContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.friendContainer.layer.borderWidth = 4.0f;
    self.friendContainer.clipsToBounds = YES;
    self.friendContainer.layer.cornerRadius = 5.0f;
    
    
    [self addDividerToView:self.scrollView atLocation:230];
    [self addDividerToView:self.scrollView atLocation:300];
    [self addDividerToView:self.scrollView atLocation:370];
    
    self.scrollView.contentSize = CGSizeMake(320, 590);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // We don't want to be notified of small changes in location,
    // preferring to use our last cached results, if any.
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    [self populateUserDetails];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if (FBSession.activeSession.isOpen) {
//        [self populateUserDetails];
//        if (FBSession.activeSession.isOpen) {
//            FBPlacePickerViewController *placePicker = [[FBPlacePickerViewController alloc] init];
//            
//            placePicker.title = @"Select a restaurant";
//            
//            // SIMULATOR BUG:
//            // See http://stackoverflow.com/questions/7003155/error-server-did-not-accept-client-registration-68
//            // at times the simulator fails to fetch a location; when that happens rather than fetch a
//            // a meal near 0,0 -- let's see if we can find something good in Paris
//            if (self.placeCacheDescriptor == nil) {
//                [self setPlaceCacheDescriptorForCoordinates:CLLocationCoordinate2DMake(48.857875, 2.294635)];
//            }
//            
//            [placePicker configureUsingCachedDescriptor:self.placeCacheDescriptor];
//            [placePicker loadData];
//            [placePicker presentModallyFromViewController:self
//                                                 animated:YES
//                                                  handler:^(FBViewController *sender, BOOL donePressed) {
//                                                      if (donePressed) {
//                                                          self.selectedPlace = placePicker.selection;
//                                                          [self updateSelections];
//                                                      }
//                                                  }];
//        } else {
//            // if not logged in, give the user the option to log in
//            [self presentLoginSettings];
//        }
//
//    }
//}

-(void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

//**---------------Upadte Profile----------------**

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary <FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //self.usernameLabel.text = user.name;
                 self.nameLabel.text = user.name;
                 NSLog(@"%@",user.location);
                 self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.location[@"name"]];
                 self.FBProfile.profileID = user.id;
             }
         }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}


//**---------------LBS----------------------------**
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
            
            // To-do, add code for triggering view controller update
            NSLog(@"Got location: %f, %f",
                  newLocation.coordinate.latitude,
                  newLocation.coordinate.longitude);
        }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}
//**---------------others----------------------------**

- (void)viewDidUnload {
    [self setFBProfile:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
@end
