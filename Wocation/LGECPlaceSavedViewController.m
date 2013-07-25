//
//  LGECPlaceSavedViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/26.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECPlaceSavedViewController.h"
#import "LGECAppDelegate.h"
#import "LGECAnnotation.h"

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

@interface LGECPlaceSavedViewController ()

@end



@implementation LGECPlaceSavedViewController
@synthesize lat;
@synthesize lon;
@synthesize placename;
@synthesize places_Array;

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
	// Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate=self ;
    _locationManager.desiredAccuracy= kCLLocationAccuracyBest;
    _locationManager.distanceFilter=30;
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_placeMapview setMapType:MKMapTypeStandard];
    [_placeMapview setZoomEnabled:YES];
    [_placeMapview setScrollEnabled:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_locationManager.location.coordinate, 1000, 1000);
    [_placeMapview setRegion:region];
    self.placeMapview.showsUserLocation =YES;
    

}

- (void)viewDidAppear:(BOOL)animated
{
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    _managedObjectContext = context;
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kPlacedb];
    places_Array = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    [_placeTableview reloadData];
     NSLog(@"%@",[[places_Array objectAtIndex:0] valueForKey:kPname]);
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
    [_placeMapview setRegion:region];
    self.placeMapview.showsUserLocation =YES;

}

- (void)RefreshPlaceMap
{
    NSString *lat1 = [NSString stringWithFormat:@"%f",[_placeMapview centerCoordinate].latitude];
    NSString *lon1 = [NSString stringWithFormat:@"%f",[_placeMapview centerCoordinate].longitude];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1.doubleValue longitude:lon1.doubleValue];
    [self FindNearPlaces:loc1];
    [self reloadMap];
}

-(void) reloadMap
{
    [_placeMapview setRegion:_placeMapview.region animated:FALSE];
}

-(void)FindNearPlaces:(CLLocation *)newLocation
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
            NSMutableArray * annotationsToRemove = [_placeMapview.annotations mutableCopy];
            [annotationsToRemove removeObject:_placeMapview.userLocation] ;
            [_placeMapview removeAnnotations:annotationsToRemove ] ;
            [_placeMapview addAnnotations:annoArray];

        }
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
        [_placeMapview setRegion:region];
        _placeMapview.showsUserLocation =YES;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)[places_Array count]);
    return [places_Array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WCell" forIndexPath:indexPath];
    cell.textLabel.text =  [[places_Array objectAtIndex:indexPath.row] valueForKey:kPname];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lat=[[places_Array objectAtIndex:indexPath.row] valueForKey:kLat];
    lon=[[places_Array objectAtIndex:indexPath.row] valueForKey:kLon];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
    
    _placeMapview.showsUserLocation =YES;
    [self RefreshPlaceMap];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc1.coordinate, 300, 300);
    [_placeMapview setRegion:region];
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
    return pinView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
