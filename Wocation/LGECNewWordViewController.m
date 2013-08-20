//
//  LGECNewWordViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/20.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECNewWordViewController.h"
#import "LGECAppDelegate.h"

static NSString * const kWordsdb = @"Words";
static NSString * const kPlacedb = @"Places";
static NSString * const kLon = @"longitude";
static NSString * const kLat = @"latitude";
static NSString * const kFtime = @"firsttimeseen";
static NSString * const kLtime = @"Lasttimeseen";
static NSString * const kWord = @"word";
static NSString * const kWid = @"id";
static NSString * const kPid = @"placeid";
static NSString * const kType = @"type";
static NSString * const kPname = @"placename";
static NSString * const kImage = @"image";



@interface LGECNewWordViewController ()
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;

@end

@implementation LGECNewWordViewController
@synthesize segmentControl;
@synthesize arrayImage;
@synthesize lat;
@synthesize lon;
@synthesize Type;
@synthesize placename;
@synthesize placeid;
@synthesize wPlace;
@synthesize InputView;
@synthesize placePickerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [InputView becomeFirstResponder];
    
    //[typeImage addGestureRecognizer:singleTap];
    //[typeImage setUserInteractionEnabled:YES];
    for (id imageview in arrayImage)
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [imageview addGestureRecognizer:singleTap];
        [imageview setUserInteractionEnabled:YES];
    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // We don't want to be notified of small changes in location,
    // preferring to use our last cached results, if any.
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];

    wPlace.titleLabel.text=placename;
    // Do any additional setup after loading the view.
}

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *image = (UIImageView*)gestureRecognizer.view;
    if (image.alpha == 1.0f)
    {
        image.alpha = 0.5f;
    }else
    {
        image.alpha = 1.0f;
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
}


#pragma mark - Image Picker Controller delegate methods
- (void)updateDisplay
{
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        self.imageView.image = self.image;
        self.imageView.hidden = NO;
        self.moviePlayerController.view.hidden = YES;
    } else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc]
                                      initWithContentURL:self.movieURL];
        [self.moviePlayerController play];
        UIView *movieView = self.moviePlayerController.view;
        movieView.frame = self.imageView.frame;
        movieView.clipsToBounds = YES;
        [self.view addSubview:movieView];
        self.imageView.hidden = YES;
    }
}

- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
                               availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                                   message:@"Device doesn’t support that media source."
                                  delegate:nil
                         cancelButtonTitle:@"Drat!"
                         otherButtonTitles:nil];
        [alert show];
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

- (IBAction)shootPictureOrVideo:(id)sender
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPictureOrVideo:(id)sender
{
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)Choose_place:(id)sender {
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
    self.placePickerController.searchText=nil;
    [self.placePickerController loadData];
    [self.navigationController pushViewController:self.placePickerController
                                         animated:true];
    [self addSearchBarToPlacePickerView];

    
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

- (void)placePickerViewControllerSelectionDidChange:
(FBPlacePickerViewController *)placePicker
{
    self.selectedPlace = placePicker.selection;
    lat =[NSString stringWithFormat:@"%f", placePicker.locationCoordinate.latitude];
    lon =[NSString stringWithFormat:@"%f", placePicker.locationCoordinate.longitude];
    self.wPlace.titleLabel.text =[NSString stringWithFormat:@"@%@", self.selectedPlace.name];
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



#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        UIImage *shrunkenImage = [self shrinkImage:chosenImage
                                            toSize:self.imageView.bounds.size];
        self.image = shrunkenImage;
    } else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        self.movieURL = info[UIImagePickerControllerMediaURL];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction) segmentControlIndexChanged{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            self.segmentControl.selected = FALSE;
            [self selectExistingPictureOrVideo:self];
            
            break;
        case 1:
            self.segmentControl.selected = FALSE;
            [self shootPictureOrVideo:self];
            
            break;
            
        default:
            break;
    }
    
}


-(void) saveWord:(NSString *)saveWord
{

    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    _managedObjectContext = context;
    NSFetchRequest *requestWord = [[NSFetchRequest alloc] initWithEntityName:kWordsdb];
    NSError *error;
    NSArray *objectsWord = [_managedObjectContext executeFetchRequest:requestWord error:&error];
    if (!(objectsWord == nil))
    {
        NSManagedObject *theWord = nil;
        theWord = [NSEntityDescription
                   insertNewObjectForEntityForName:kWordsdb
                   inManagedObjectContext:_managedObjectContext];
        
        //not a good way to put the id, beed to be modified later
        NSNumber *wid = [NSNumber numberWithInt:[objectsWord count]];
        NSData *data = UIImageJPEGRepresentation(self.image,1.0);
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSError *error = nil;
//        [data writeToFile:[documentsDirectory stringByAppendingPathComponent:@"/One.png"] options:NSAtomicWrite error:&error];
        [theWord setValue:wid forKey:kWid];
        [theWord setValue:saveWord forKey:kWord];
        NSNumber *plon = [NSNumber numberWithDouble:lon.doubleValue];
        NSNumber *plat = [NSNumber numberWithDouble:lat.doubleValue];

        [theWord setValue:plon forKey:kLon];
        [theWord setValue:plat forKey:kLat];
        [theWord setValue:Type forKey:kType];
        [theWord setValue:data forKey:kImage];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"%@", strDate);
        [theWord setValue:strDate forKey:kFtime];
        [theWord setValue:placeid forKey:kPid];
        
    }
    
    [appDelegate saveContext];
    
}


-(void) savePlace:(NSString *)savePlace
{
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    _managedObjectContext = context;
    NSFetchRequest *requestPlace = [[NSFetchRequest alloc] initWithEntityName:kPlacedb];
    NSError *error;
    NSArray *objectsPlace = [_managedObjectContext executeFetchRequest:requestPlace error:&error];
    NSLog(@"Place Count:%u",[objectsPlace count]);
    if (!(objectsPlace == nil))
    {
        if ([objectsPlace count] > 0)
        {
            BOOL same = FALSE;
            for (NSManagedObject *oneObject in objectsPlace) {
                NSString *wlat = [oneObject valueForKey:kLat];
                NSString *wlon= [oneObject valueForKey:kLon];
                NSString *wplacename = [oneObject valueForKey:kPname];
                if ((wlat.doubleValue == lat.doubleValue) && (wlon.doubleValue == lon.doubleValue) && ([wplacename isEqualToString:placename]))
                {
                    same = TRUE;
                    placeid = [oneObject valueForKey:kPid];
                    NSLog(@"Find the same Place:%@",placename);
                    
                }
            }
            if (same == FALSE)
            {
                NSManagedObject *thePlace = nil;
                thePlace = [NSEntityDescription
                            insertNewObjectForEntityForName:kPlacedb
                            inManagedObjectContext:_managedObjectContext];
                [thePlace setValue:savePlace forKey:kPname];
                NSNumber *plon = [NSNumber numberWithDouble:lon.doubleValue];
                NSNumber *plat = [NSNumber numberWithDouble:lat.doubleValue];
                [thePlace setValue:plon forKey:kLon];
                [thePlace setValue:plat forKey:kLat];
                NSNumber *pid = [NSNumber numberWithInt:[objectsPlace count]];
                [thePlace setValue:pid forKey:kPid];
                placeid =pid;
                NSLog(@"Save Place:%@",placename);
                
            }
        }
        else
        {
            NSManagedObject *thePlace = nil;
            thePlace = [NSEntityDescription
                        insertNewObjectForEntityForName:kPlacedb
                        inManagedObjectContext:_managedObjectContext];
            [thePlace setValue:savePlace forKey:kPname];
            NSNumber *plon = [NSNumber numberWithDouble:lon.doubleValue];
            NSNumber *plat = [NSNumber numberWithDouble:lat.doubleValue];
            [thePlace setValue:plon forKey:kLon];
            [thePlace setValue:plat forKey:kLat];
            NSNumber *pid = [NSNumber numberWithInt:[objectsPlace count]];
            [thePlace setValue:pid forKey:kPid];
            placeid =pid;
            NSLog(@"Save Place:%@",placename);
            
        }
    }
    
    [appDelegate saveContext];
    
}

- (void)just_learned{
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    NSString *urlStr =[NSString stringWithFormat: @"https://www.logyuan.tw/%@.html",InputView.text ];
    params.link = [NSURL URLWithString:urlStr];
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
        [action setObject:urlStr forKey:@"word"];
        id<FBGraphPlace> place = (id<FBGraphPlace>)[FBGraphObject graphObject];
        [place setId:self.selectedPlace.id];
        [action setPlace:place];
        
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //[self savePlace:placename];
    //[self saveWord:InputView.text];
    //self.navigationController.title = @"Saved";
    [textField resignFirstResponder];
    [self just_learned];
    return NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self saveWord:InputView.text];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInputView:nil];
    [self setSegmentControl:nil];
    [self setArrayImage:nil];
    [self setWPlace:nil];
    [self setWPlace:nil];
    [self setPlacePickerController : nil];
    [self setSearchBar : nil];
    [super viewDidUnload];
}
@end
