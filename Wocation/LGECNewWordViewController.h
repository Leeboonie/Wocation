//
//  LGECNewWordViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/20.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LGECAppDelegate.h"


@interface LGECNewWordViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,FBPlacePickerDelegate,CLLocationManagerDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrayImage;
@property (strong, nonatomic) IBOutlet UITextField *InputView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id delegate;
@property (copy,nonatomic)  NSString *Type;
@property (copy,nonatomic)  NSString *lat;
@property (copy,nonatomic)  NSString *lon;
@property (strong, nonatomic) NSString *placename;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *placeid;
@property (strong, nonatomic) IBOutlet UIButton *wPlace;
@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;
@property (strong, nonatomic) NSObject<FBGraphPlace>* selectedPlace;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

-(IBAction) segmentControlIndexChanged;
- (IBAction)shootPictureOrVideo:(id)sender;
- (IBAction)selectExistingPictureOrVideo:(id)sender;
- (IBAction)Choose_place:(id)sender;
-(void) saveWord:(NSString *)saveWord;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
