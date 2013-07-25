//
//  LGECPlaceNearbyViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface LGECPlaceNearbyViewController : UIViewController<UINavigationControllerDelegate,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>

@property (copy, nonatomic) NSMutableArray *json_array;
@property (copy, nonatomic) NSMutableDictionary *json_dictionary;
@property (strong, nonatomic) NSMutableString *lat;
@property (strong, nonatomic) NSMutableString *lon;
@property (strong, nonatomic) NSMutableString *placename;

@property (weak, nonatomic) IBOutlet UITableView *placeTableview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *placeMapview;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) NSMutableString *wordType;
-(void)findNewPlaces;
@end
