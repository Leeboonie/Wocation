//
//  LGECPlaceNearbyViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#import "LGECPlaceNearbyViewController.h"
#import "LGECAnnotation.h"
#define ConnectStr @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=%@&sensor=false&key=AIzaSyBY-vTp3r_rox3HX8OPbEL2LqWL2wxhdBY"



@interface LGECPlaceNearbyViewController ()

@end

@implementation LGECPlaceNearbyViewController
@synthesize json_array;
@synthesize json_dictionary;
@synthesize lat;
@synthesize lon;
@synthesize placename;
@synthesize locationLabel;
@synthesize wordType;

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
    
    //[self.placeTableview reloadData];

    // Do any additional setup after loading the view from its nib.
}




//-------------------------for Location----------------------------------------------
- (IBAction)refreshLocation:(id)sender {
    
    NSMutableString *lat1 = [NSString stringWithFormat:@"%f",[_placeMapview centerCoordinate].latitude];
    NSMutableString *lon1 = [NSString stringWithFormat:@"%f",[_placeMapview centerCoordinate].longitude];
    
    NSLog(@"lat=%@,lon=%@,lat1=%@,lon1=%@",lat,lon,lat1,lon1);
//    if (!(lat1.doubleValue == lat.doubleValue || lon1.doubleValue == lon.doubleValue))
//    {
        lat = lat1;
        lon = lon1;
    [self findNewPlaces];
    [self reloadMap];
        //[self performSelectorOnMainThread:@selector(reloadMap) withObject:nil waitUntilDone:YES];
//    }
    
}


-(void)findNewPlaces
{
    dispatch_async(kBgQueue, ^{
        NSString *urlStr = [[NSString alloc] initWithFormat:ConnectStr,lat,lon,@"food"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url: %@ ", urlStr);
        NSError *error = nil;
        NSData *jsonData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
        if (!(jsonData == nil))
        {
        NSString *stringToLookup = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"stringToLookup: %@", stringToLookup);
        //json_array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        json_dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
        NSMutableArray *annoArray = [[NSMutableArray alloc]init];
        for (id json in [json_dictionary objectForKey:@"results"])
        {
            LGECAnnotation *annoArrayObject = [[LGECAnnotation alloc]init];
            annoArrayObject.title = [json objectForKey:@"name"];
            NSLog(@"%@", [json objectForKey:@"name"]);
            annoArrayObject.subTitle =[json objectForKey:@"open_now"];
            //
            annoArrayObject.coordinate = CLLocationCoordinate2DMake([[json objectForKey:@"latitude"] doubleValue], [[json objectForKey:@"longitude"]  doubleValue]);
            
            //NSLog(@"%f",[[[[json objectForKey:@"geometry"] objectForKey:@"location" ] objectForKey:@"lng"] doubleValue]);
            [annoArray addObject:annoArrayObject];
        }
        
            NSLog(@"%D", [annoArray count]);
            
            NSMutableArray * annotationsToRemove = [_placeMapview.annotations mutableCopy];
            [annotationsToRemove removeObject:_placeMapview.userLocation ] ;
            [_placeMapview removeAnnotations:annotationsToRemove ] ;
            [_placeMapview addAnnotations:annoArray];
            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",lat,lon];

            [self.placeTableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
        }


    });
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    lon = [NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    NSLog(@"%@", lon);
    lat= [NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    NSLog(@"%@", lat);
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",lat,lon];
//    if (!(lon ==nil & lat==nil))
//    {
//            //1 Prepare NSURL for performing the request
//            //NSString *urlStr = [[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=%@&sensor=false&key=AIzaSyBY-vTp3r_rox3HX8OPbEL2LqWL2wxhdBY",lat,lon,@"food"];
//            NSString *urlStr = [[NSString alloc] initWithFormat:@"http://arnose.net:8000/place/search/nearby?radius=500&location=%@,%@&format=json",lat,lon];
//            //NSString *urlStr = @"http://www.logyuan.tw:8082/logservice/ws_geo_getvoc2.php?geotable=temp.jpvoc&lon=121.545038&lat=25.03191&format=json";
//            NSLog(@"%@", urlStr);
//            //NSURL *url = [NSURL URLWithString:urlStr];
//            NSURL *url = [NSURL URLWithString:urlStr];
//            //NSLog(@"%@", url);
//            NSError *error = nil;
//            //2 Prepare NSData for receiving the JSON data
//            NSData *jsonData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
//            //NSLog(@"%@", jsonData);
//            
////            NSString *stringToLookup = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
////            NSLog(@"stringToLookup: %@ ", stringToLookup);
//            //3 Parse the retrieved JSON to an NSArray
//            //json_array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//            
//            //NSLog(@"%@", jsonObject);
//            //NSLog(@"%@", json_array);
//            //NSLog(@"%lu", (unsigned long)json_array.count);
//            
//            json_dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
//            //NSLog(@"%@", json_dictionary);
//            //NSLog(@"%lu", (unsigned long)[[json_dictionary objectForKey:@"results"] count]);
//           //[self.placeTableview reloadData];
//            
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_locationManager.location.coordinate, 1000, 1000);
//            [_placeMapview setRegion:region];
//            self.placeMapview.showsUserLocation =YES;
//            //[_locationManager stopUpdatingLocation];
//            NSMutableArray *annoArray = [[NSMutableArray alloc]init];
//            for (id json in [json_dictionary objectForKey:@"results"])
//            {
//                LGECAnnotation *annoArrayObject = [[LGECAnnotation alloc]init];
//                annoArrayObject.title = [json objectForKey:@"name"];
//                NSLog(@"%@", [json objectForKey:@"name"]);
//                annoArrayObject.subTitle =[json objectForKey:@"open_now"];
//                //
//                annoArrayObject.coordinate = CLLocationCoordinate2DMake([[json objectForKey:@"latitude"] doubleValue], [[json objectForKey:@"longitude"]  doubleValue]);
//                
//                //NSLog(@"%f",[[[[json objectForKey:@"geometry"] objectForKey:@"location" ] objectForKey:@"lng"] doubleValue]);
//                [annoArray addObject:annoArrayObject];
//            }
//            NSLog(@"%D", [annoArray count]);
//            NSMutableArray * annotationsToRemove = [_placeMapview.annotations mutableCopy];
//            [ annotationsToRemove removeObject:_placeMapview.userLocation ] ;
//            [ _placeMapview removeAnnotations:annotationsToRemove ] ;
//            [_placeMapview addAnnotations:annoArray];
//            [self.placeTableview reloadData];
//            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",lat,lon];
//            CLLocationCoordinate2D center = _placeMapview.centerCoordinate;
//            _placeMapview.centerCoordinate = center;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
        [_placeMapview setRegion:region];
        self.placeMapview.showsUserLocation =YES;
        [self findNewPlaces];
        [self performSelectorOnMainThread:@selector(reloadMap) withObject:nil waitUntilDone:YES];

//    };
    
}



//create function
-(void) reloadMap
{
    [_placeMapview setRegion:_placeMapview.region animated:FALSE];
}




//-------------------------for tableView----------------------------------------------



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[json_dictionary objectForKey:@"results"] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    if (cell==nil){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell)"];
//    }
    //    cell.textLabel.text = [[json_array objectAtIndex:indexPath.row] objectForKey:@"status"];
    //    cell.detailTextLabel.text = [[json_array objectAtIndex:indexPath.row] objectForKey:@"status"];
    
    cell.textLabel.text = [[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"type"];
    //[NSString stringWithFormat:@"%@,%@",[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"latitude"],[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"longitude"]];
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    placename = [NSString stringWithFormat:@"%@", cell.textLabel.text];
    wordType = [[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"type"];
    lat=[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"latitude"];
    lon=[[[json_dictionary objectForKey:@"results"] objectAtIndex:indexPath.row] objectForKey:@"longitude"];
    self.locationLabel.text = placename;
    return indexPath;
}

//-------------------------for segue----------------------------------------------


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //將page2設定成Storyboard Segue的目標UIViewController
    id page2 = segue.destinationViewController;
    if ([page2 respondsToSelector:@selector(setDelegate:)]) {
        [page2 setValue:self forKey:@"delegate"];
        [page2 setValue:wordType forKey:@"Type"];
               [page2 setValue:lat forKey:@"lat"];
        [page2 setValue:lon forKey:@"lon"];
        [page2 setValue:placename forKey:@"placename"];
        
    }
    
    
    //將值透過Storyboard Segue帶給頁面2的string變數
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
