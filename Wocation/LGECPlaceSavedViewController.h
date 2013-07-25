//
//  LGECPlaceSavedViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/26.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreData/CoreData.h>

@interface LGECPlaceSavedViewController : UIViewController<UINavigationControllerDelegate,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) NSMutableArray *places_Array;
@property (strong, nonatomic) NSMutableString *lat;
@property (strong, nonatomic) NSMutableString *lon;
@property (strong, nonatomic) NSMutableString *placename;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *placeTableview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *placeMapview;
-(void) reloadMap;
@end
