//
//  LGECViewController.m
//  Vocation
//
//  Created by CHIH YUAN CHEN on 13/6/7.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECViewController.h"
#import "LGECAppDelegate.h"
#define banklist [NSArray arrayWithObjects:  @"Learning Words",@"Places Nearby", nil]






@interface LGECViewController ()

@end

@implementation LGECViewController

@synthesize WordBank;
@synthesize SequeTarget;

- (void)viewDidLoad
{
    [super viewDidLoad];
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    self.managedObjectContext = context;
    [self.VocBanktableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.WordBank = banklist;
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate=self ;
    _locationManager.desiredAccuracy= kCLLocationAccuracyBest;
    _locationManager.distanceFilter=30;
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_fluidMapview setMapType:MKMapTypeStandard];
    [_fluidMapview  setZoomEnabled:YES];
    [_fluidMapview  setScrollEnabled:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_locationManager.location.coordinate, 2000, 2000);
    [_fluidMapview  setRegion:region];
    _fluidMapview.showsUserLocation =YES;

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 3000, 3000);
    [_fluidMapview  setRegion:region];
    _fluidMapview.showsUserLocation =YES;
}







-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell)"];
    }
//    //    cell.textLabel.text = [[json_array objectAtIndex:indexPath.row] objectForKey:@"status"];
//    //    cell.detailTextLabel.text = [[json_array objectAtIndex:indexPath.row] objectForKey:@"status"];
//    
     cell.textLabel.text = self.WordBank[indexPath.row];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    SequeTarget = cell.textLabel.text;
//    placename = [NSString stringWithFormat:@"%@", cell.textLabel.text];
//    wordType = [[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"type"];
//    lat=[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"latitude"];
//    lon=[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"longitude"];
//    self.locationLabel.text = placename;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Conditionally perform segues, here is an example:
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"segue1" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segue2" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
