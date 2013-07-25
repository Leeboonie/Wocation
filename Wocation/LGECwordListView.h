//
//  LGECwordListView.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/11.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTTableViewGestureRecognizer.h"
#import "TransformableTableViewCell.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import <CoreData/CoreData.h>

@interface LGECwordListView : UIViewController<JTTableViewGestureEditingRowDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate>
@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@property (nonatomic, strong) id grabbedObject;

@property (copy,nonatomic)  NSString *Type;
@property (copy,nonatomic)  NSString *lat;
@property (copy,nonatomic)  NSString *lon;
@property (copy, nonatomic) NSMutableDictionary *word_dict;
@property (copy, nonatomic) NSMutableArray *word_array;
@property (copy,nonatomic)  NSString *selected_Voc;
@property (weak, nonatomic) IBOutlet UITableView *VocListview;
@property (strong, nonatomic) NSMutableString *placename;
@property (strong, nonatomic) NSNumber *placeid;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id delegate;
- (void)viewList:(id)sender;

@end
