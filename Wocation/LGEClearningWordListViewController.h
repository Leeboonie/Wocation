//
//  LGEClearningWordListViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/12.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreData/CoreData.h>


@interface LGEClearningWordListViewController : UIViewController<UINavigationControllerDelegate,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *wordsTableview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *wordMapview;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableString *lat;
@property (strong, nonatomic) NSMutableString *lon;
@property (strong, nonatomic) NSMutableArray *sections_Array;
@property (strong, nonatomic) NSMutableArray *rows_Array;
@property (strong, nonatomic) NSMutableArray *words_Array;
@property (strong, nonatomic) NSMutableArray *places_Array;
@property (strong, nonatomic) NSMutableArray *images_Array;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
-(IBAction) segmentControlIndexChanged;
-(void) reloadMap;
@end
