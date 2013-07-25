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
    wPlace.text=placename;
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




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self savePlace:placename];
    [self saveWord:InputView.text];
    self.navigationController.title = @"Saved";
    [textField resignFirstResponder];
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
    [super viewDidUnload];
}
@end
