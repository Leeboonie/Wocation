//
//  LGECUserProfileViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/7/28.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#import "LGECUserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface LGECUserProfileViewController ()<FBPlacePickerDelegate,CLLocationManagerDelegate,UISearchBarDelegate>

@end




@implementation LGECUserProfileViewController
@synthesize placePickerController;
@synthesize json_dictionary;
@synthesize json_array;
@synthesize selectedPlace;
//@synthesize table_array;


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

//**---------------view Event----------------**

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.9f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
//    NSString* boldFontName = @"Avenir-Black";
    
    
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
    
    
    //self.profileImageView.image = [UIImage imageNamed:@"profile.jpg"];
    self.FBProfile.contentMode = UIViewContentModeScaleAspectFill;
    self.FBProfile.clipsToBounds = YES;
    self.FBProfile.layer.borderWidth = 4.0f;
    self.FBProfile.layer.cornerRadius = 55.0f;
    self.FBProfile.layer.borderColor = imageBorderColor.CGColor;
    
    
    [self addDividerToView:self.scrollView atLocation:230];
    [self addDividerToView:self.scrollView atLocation:300];
    //[self addDividerToView:self.scrollView atLocation:370];
    
    self.scrollView.contentSize = CGSizeMake(320, 850);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:LGECSessionStateChangedNotification
     object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // We don't want to be notified of small changes in location,
    // preferring to use our last cached results, if any.
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(json_loaded) name:@"jsonListener" object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self populateUserDetails];
    [self FetchUserFeeds:self];
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



//**---------------Upadte Profile----------------**

-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}



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
                 //self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.location[@"name"]];
                 self.FBProfile.profileID = user.id;
             }
         }];
    }
}

-(IBAction)logout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self performSegueWithIdentifier:@"backtoLoginPage" sender:self];
}



- (void)viewDidUnload {
    [self setFBProfile:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setFeedView:nil];
    self.placePickerController = nil;
    self.searchBar = nil;
    [super viewDidUnload];
}




- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
    //[self FetchUserFeeds:self];
}

- (void)json_loaded
{
    json_array = [[NSMutableArray alloc]init];
    for (id json in [json_dictionary objectForKey:@"data" ])
    {
        
            if ([[[json objectForKey:@"application"] objectForKey:@"name"] isEqual: @"wocation"])
            {
                [json_array insertObject:json atIndex:[json_array count]];
            }
    }
    [self.feedView reloadData];
}

- (IBAction)FetchUserFeeds:(id)sender {
    
    [FBSession.activeSession requestNewReadPermissions:@[@"read_stream"]
                                     completionHandler:^(FBSession *session,
                                                         NSError *error) {
                                         // Handle new permissions callback
                                     }];
    NSString *token;
    
    LGECAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    if (FBSession.activeSession.isOpen == TRUE)
    {
        
        token = FBSession.activeSession.accessTokenData.accessToken;
        NSLog(@"The value access token is: %@", token);
        
    } else {
        [appDelegate openSession];
        token = FBSession.activeSession.accessTokenData.accessToken;
        NSLog(@"The value access token is: %@", token);
        // No, display the login page.
    }
    dispatch_sync(kBgQueue, ^{
        NSString *urlStr = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/me/wocation:learn?&access_token=%@&method=GET",token];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url: %@ ", urlStr);
        NSError *error = nil;
        NSData *jsonData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
        if (error) {
            NSLog(@"Error fetching the feeds.");
        }
        if (!(jsonData == nil))
        {
            //            NSString *stringToLookup = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            //NSLog(@"stringToLookup: %@", stringToLookup);
            json_dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jsonListener" object:nil];
        }
        
    });
    
    
    
}



//**---------------LBS----------------------------**

- (IBAction)explore_nearby:(id)sender {
    if (!self.placePickerController) {
        self.placePickerController = [[FBPlacePickerViewController alloc]
                                      initWithNibName:nil bundle:nil];
        
        self.placePickerController.title = @"Select a place";
    }
    // Hide the done button
    placePickerController.doneButton = nil;
    
    // Hide the cancel button
    placePickerController.cancelButton = nil;
    self.placePickerController.delegate = self;
    self.placePickerController.locationCoordinate =
    self.locationManager.location.coordinate;
    self.placePickerController.radiusInMeters = 1000;
    self.placePickerController.resultsLimit = 100;
    self.placePickerController.searchText=@"bank";
    [self.placePickerController loadData];
    [self.navigationController pushViewController:self.placePickerController
                                         animated:true];
    [self addSearchBarToPlacePickerView];
}

- (IBAction)just_learned:(id)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://example.com/book/Snow-Crash.html"];
    BOOL canShare = [FBDialogs canPresentShareDialogWithParams:params];
    if (!canShare) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Need Facebook App to launch this function!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:@"https://www.logyuan.tw/paddle.html" forKey:@"word"];
    
    [FBDialogs presentShareDialogWithOpenGraphAction:action
                                          actionType:@"wocation:learn"
                                 previewPropertyName:@"word"
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if(error) {
                                                     NSLog(@"Error: %@", error.description);
                                                 } else {
                                                     NSLog(@"Success!");
                                                 }
                                             }];
    }
}

- (void)placePickerViewControllerSelectionDidChange:
(FBPlacePickerViewController *)placePicker
{
    self.selectedPlace = placePicker.selection;
    self.usernameLabel.text =[NSString stringWithFormat:@"@%@", self.selectedPlace.name];
    if (self.selectedPlace.count > 0) {
        [self.navigationController popViewControllerAnimated:true];
    }
}


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



//- (IBAction)addNewWord:(id)sender {
//    NSString *linkURL = @"https://www.logyuan.tw/hippopotamus.html";
//    NSString *pictureURL = @"http://farm8.staticflickr.com/7030/6672141083_306ab84d88.jpg";
//    
//    // Prepare the native share dialog parameters
//    FBShareDialogParams *shareParams = [[FBShareDialogParams alloc] init];
//    shareParams.link = [NSURL URLWithString:linkURL];
//    shareParams.name = @"hippopotamus";
//    shareParams.caption= @"河馬";
//    shareParams.picture= [NSURL URLWithString:pictureURL];
//    shareParams.description =@"一種嘴巴很大的動物";
//    
//    if ([FBDialogs canPresentShareDialogWithParams:shareParams]){
//        
//        [FBDialogs presentShareDialogWithParams:shareParams
//                                    clientState:nil
//                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                            if(error) {
//                                                NSLog(@"Error publishing story.");
//                                            } else if (results[@"completionGesture"] && [results[@"completionGesture"] isEqualToString:@"cancel"]) {
//                                                NSLog(@"User canceled story publishing.");
//                                            } else {
//                                                NSLog(@"Story published.");
//                                            }
//                                        }];
//        
//    }else {
//        
//        // Prepare the web dialog parameters
//        NSDictionary *params = @{
//                                 @"name" : shareParams.name,
//                                 @"caption" : shareParams.caption,
//                                 @"description" : shareParams.description,
//                                 @"picture" : pictureURL,
//                                 @"link" : linkURL
//                                 };
//        
//        // Invoke the dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:
//         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//             if (error) {
//                 NSLog(@"Error publishing story.");
//             } else {
//                 if (result == FBWebDialogResultDialogNotCompleted) {
//                     NSLog(@"User canceled story publishing.");
//                 } else {
//                     NSLog(@"Story published.");
//                 }
//             }}];
//    }
//}



//**---------------UI----------------------------**


- (BOOL)placePickerViewController:(FBPlacePickerViewController *)placePicker
                 shouldIncludePlace:(id<FBGraphPlace>)place
{
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [place.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.placePickerController updateView];
}


- (void)addSearchBarToPlacePickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.placePickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.placePickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.placePickerController.tableView.frame = newFrame;
    }
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"json_array_count=%U", [json_array count]);
    //NSLog(@"table_array_count=%U", [table_array count]);
    return [json_array count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *path = [NSString stringWithFormat:@"%@",[json_array[indexPath.row] objectForKey:@"picture"]];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.9f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSLog(@"%u",indexPath.row);
    CGRect picSize;
    picSize.size.height=40;
    picSize.size.width=40;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.bounds=picSize;
    cell.imageView.layer.borderWidth = 1.0f;
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.layer.borderColor = imageBorderColor.CGColor;
    cell.imageView.image =[[UIImage alloc] initWithData:data];
    cell.textLabel.textColor = mainColor;
    cell.textLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    cell.detailTextLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"Learnt %@", [[[json_array[indexPath.row] objectForKey:@"data"] objectForKey:@"word"]objectForKey:@"title"] ];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"at %@", [[json_array[indexPath.row] objectForKey:@"place"] objectForKey:@"name"] ];
    //[NSString stringWithFormat:@"%@,%@",[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"latitude"],[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"longitude"]];
    
    
    return cell;
}


-(void)dealloc
{
    placePickerController.delegate = nil;
}

@end

