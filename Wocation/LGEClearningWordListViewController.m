//
//  LGEClearningWordListViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/12.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGEClearningWordListViewController.h"
#import "LGECAppDelegate.h"
#import "LGECAnnotation.h"
#define Userinfo [NSArray arrayWithObjects:  @"Learning Words",1, nil]


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

@interface LGEClearningWordListViewController ()

@end

@implementation LGEClearningWordListViewController
@synthesize lat;
@synthesize lon;
@synthesize words_Array;
@synthesize places_Array;
@synthesize images_Array;
@synthesize sections_Array;
@synthesize rows_Array;

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
    //-----------update location-------------
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate=self ;
    _locationManager.desiredAccuracy= kCLLocationAccuracyBest;
    _locationManager.distanceFilter=30;
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_wordMapview setMapType:MKMapTypeStandard];
    [_wordMapview  setZoomEnabled:YES];
    [_wordMapview  setScrollEnabled:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_locationManager.location.coordinate, 1000, 1000);
    [_wordMapview  setRegion:region];
    self.wordMapview.showsUserLocation =YES;
	//-----------Core data I/O-------------
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    _managedObjectContext = context;
    //[self FindNearWords:_locationManager.location];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kWordsdb];
    words_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    request = [[NSFetchRequest alloc]
               initWithEntityName:kPlacedb];
    places_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    sections_Array = [places_Array mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self FindNearWords:_locationManager.location];
}


- (void)applicationWillResignActive:(NSNotification *)notification
{
    
}



//-----------------------LocationManager-----------------------------------------


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{   
    CLLocation *newLocation = [locations lastObject];
    lon = [NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    NSLog(@"%@", lon);
    lat= [NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    NSLog(@"%@", lat);
    [self FindNearWords:newLocation];
    [self reloadMap];
}

- (IBAction)updateMap:(id)sender {
    [self RefreshWordMap];
}

- (void)RefreshWordMap
{
    NSLog(@"refresh");
    NSString *lat1 = [NSString stringWithFormat:@"%f",[_wordMapview centerCoordinate].latitude];
    NSString *lon1 = [NSString stringWithFormat:@"%f",[_wordMapview centerCoordinate].longitude];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1.doubleValue longitude:lon1.doubleValue];
    [self FindNearWords:loc1];
    [self reloadMap];
}



-(void)FindNearWords:(CLLocation *)newLocation
{
    NSFetchRequest *requestPlace = [[NSFetchRequest alloc] initWithEntityName:kPlacedb];
    NSError *error;
    NSArray *objectsPlace = [_managedObjectContext executeFetchRequest:requestPlace error:&error];
    CLLocation *center = newLocation;
    if (objectsPlace == nil) {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    else
    {
        NSMutableArray *annoArray = [[NSMutableArray alloc]init];
        for (NSManagedObject *onePlace in objectsPlace)
        {
            NSString *plat = [onePlace valueForKey:kLat];
            NSString *plon= [onePlace valueForKey:kLon];
            NSNumber *pid= [onePlace valueForKey:kPid];
            NSString *pname=[onePlace valueForKey:kPname];
            NSLog(@"pid=%u",pid.intValue);
            CLLocation *ploc = [[CLLocation alloc] initWithLatitude:plat.doubleValue longitude:plon.doubleValue];
            if ([center distanceFromLocation:ploc] < 1000)
            {
                NSFetchRequest *request2 = [[NSFetchRequest alloc]
                                            initWithEntityName:kWordsdb];
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"placeid == %u", pid.intValue];
                [request2 setPredicate:predicate];
                NSArray *objectsWord = [_managedObjectContext executeFetchRequest:request2 error:&error];

                if (objectsWord == nil) {
                    NSLog(@"There was an error!");
                    // Do whatever error handling is appropriate
                }
                else
                {
                    
                    LGECAnnotation *annoArrayObject = [[LGECAnnotation alloc]init];
                    annoArrayObject.title = [[NSString alloc] initWithFormat:@"%@(%u)", pname,[objectsWord count]];
                    annoArrayObject.coordinate = CLLocationCoordinate2DMake(plat.doubleValue,plon.doubleValue);
                    [annoArray addObject:annoArrayObject];
                }

            }
            NSMutableArray * annotationsToRemove = [_wordMapview.annotations mutableCopy];
            [annotationsToRemove removeObject:_wordMapview.userLocation] ;
            [_wordMapview removeAnnotations:annotationsToRemove ] ;
            [_wordMapview addAnnotations:annoArray];
        }

        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
        [_wordMapview setRegion:region];
        _wordMapview.showsUserLocation =YES;
    }
}


-(void) reloadMap
{
    [_wordMapview setRegion:_wordMapview.region animated:FALSE];
}

//-----------------------Table View-----------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Number of sections is the number of regions.
	NSLog(@"sections=%lu",(unsigned long)[sections_Array count] );
    return [sections_Array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the region name -- get this from the region at the section index.
    NSString *sTitle = [[NSString alloc] init];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            sTitle = [[sections_Array objectAtIndex:section]valueForKey:kPname];
            break;
        case 1:
            break;
        case 2:
            sTitle = [[sections_Array objectAtIndex:section] mutableCopy];
            break;

    }
    return sTitle;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kWordsdb];
    NSPredicate *pred  = [[NSPredicate alloc] init];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            pred  = [NSPredicate predicateWithFormat:@"(placeid == %@)",[[sections_Array objectAtIndex:section] valueForKey:kPid]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            NSLog(@"rows=%lu",(unsigned long)[rows_Array count] );
            NSLog(@"%@",[rows_Array valueForKey:kWord]);
            break;
        case 1:
            break;
        case 2:
            pred  = [NSPredicate predicateWithFormat:@"(type == %@)",[sections_Array objectAtIndex:section]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            NSLog(@"rows=%lu",(unsigned long)[rows_Array count] );
            NSLog(@"%@",[rows_Array valueForKey:kWord]);
            break;
    }
    
    return [rows_Array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WCell" forIndexPath:indexPath];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kWordsdb];
    NSPredicate *pred = [[NSPredicate alloc]init];
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            
            pred  = [NSPredicate predicateWithFormat:@"(placeid == %@)",[[sections_Array objectAtIndex:indexPath.section] valueForKey:kPid]];
            //,sectionTag, [[sections_Array objectAtIndex:section] valueForKey:kPid]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            //NSLog(@"%@",[[rows_Array objectAtIndex:indexPath.row] valueForKey:kImage]);
            cell.detailTextLabel.text =  [[NSString alloc] initWithFormat:@"%@",[[rows_Array objectAtIndex:indexPath.row] valueForKey:kType]];

            break;
        case 1:
            break;
        case 2:
            request = [[NSFetchRequest alloc]
                       initWithEntityName:kWordsdb];
            pred  = [NSPredicate predicateWithFormat:@"(type == %@)",[sections_Array objectAtIndex:indexPath.section]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            request = [[NSFetchRequest alloc]
                       initWithEntityName:kPlacedb];
            
            pred  = [NSPredicate predicateWithFormat:@"(placeid == %@)",[[rows_Array objectAtIndex:indexPath.row] valueForKey:kPid]];
            [request setPredicate:pred];
            NSMutableArray *p_array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@",[[p_array objectAtIndex:0] valueForKey:kPname]];
            break;
    }
    cell.textLabel.text =  [[NSString alloc] initWithFormat:@"%@",[[rows_Array objectAtIndex:indexPath.row] valueForKey:kWord]];
    
    UIImage *pImage = [[UIImage alloc] initWithData:[[rows_Array objectAtIndex:indexPath.row] valueForKey:kImage]];
    [cell.imageView setImage:pImage];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kWordsdb];
    NSPredicate *pred = [[NSPredicate alloc]init];

    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            
            pred  = [NSPredicate predicateWithFormat:@"(placeid == %@)",[[sections_Array objectAtIndex:indexPath.section] valueForKey:kPid]];
            //,sectionTag, [[sections_Array objectAtIndex:section] valueForKey:kPid]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            //NSLog(@"%@",[[rows_Array objectAtIndex:indexPath.row] valueForKey:kImage]);
            break;
        case 1:
            break;
        case 2:
            pred  = [NSPredicate predicateWithFormat:@"(type == %@)",[sections_Array objectAtIndex:indexPath.section]];
            NSLog(@"%@",pred);
            [request setPredicate:pred];
            rows_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            break;
    }
    
    
    lat=[[rows_Array objectAtIndex:indexPath.row] valueForKey:kLat];
    lon=[[rows_Array objectAtIndex:indexPath.row] valueForKey:kLon];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
    
    _wordMapview.showsUserLocation =YES;
    [self RefreshWordMap];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc1.coordinate, 300, 300);
    [_wordMapview setRegion:region];
    [self reloadMap];
    return indexPath;
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
    MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    
    pinView.animatesDrop=NO;
    pinView.canShowCallout=YES;
    pinView.pinColor=MKPinAnnotationColorRed;
    
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
//    
//    [rightButton addTarget:self
//                    action:@selector(showDetails:)
//          forControlEvents:UIControlEventTouchUpInside];
//    
//    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}

-(IBAction) segmentControlIndexChanged{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            sections_Array = [places_Array mutableCopy];
            break;
        case 1:
            //sections_Array = [NSArray arrayWithObjects:@"Today",@"This week",@"This Month",@"Earlier",nil];
            break;
        case 2:
            sections_Array = [words_Array mutableArrayValueForKey:kType];
            NSSet *section_set = [[NSSet alloc] initWithArray:sections_Array];
            sections_Array = [[section_set allObjects] mutableCopy];
            NSLog(@"sections_Array=%@", sections_Array );
            break;
    }
    [_wordsTableview reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSegmentControl:nil];
    [super viewDidUnload];
}
@end
