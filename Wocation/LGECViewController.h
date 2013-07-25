//
//  LGECViewController.h
//  Vocation
//
//  Created by CHIH YUAN CHEN on 13/6/7.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface LGECViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *VocBanktableview;
@property (strong, nonatomic) NSMutableArray *WordBank;
@property (strong, nonatomic) NSString *SequeTarget;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *fluidMapview;
@end
