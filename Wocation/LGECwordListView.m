//
//  LGECwordListView.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/11.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#import "LGECwordListView.h"
#import "LGECAppDelegate.h"

#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60

static NSString * const kWordsdb = @"Words";
static NSString * const kPlacedb = @"Places";
static NSString * const kLon = @"longitude";
static NSString * const kLat = @"latitude";
static NSString * const kFtime = @"firsttimeseen";
static NSString * const kLtime = @"Lasttimeseen";
static NSString * const kWord = @"word";
static NSString * const kWid = @"id";
static NSString * const kPid = @"placeid";
static NSString * const kPname = @"placename";
static NSString * const kType = @"type";

@implementation LGECwordListView

@synthesize tableViewRecognizer;
@synthesize word_dict;
@synthesize word_array;
@synthesize lat;
@synthesize lon;
@synthesize delegate;
@synthesize selected_Voc;
@synthesize Type;
@synthesize placename;
@synthesize placeid;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.VocListview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"wordCell"];

    dispatch_async(kBgQueue, ^{

        //1 Prepare NSURL for performing the request
        //NSString *urlStr = [[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=%@&sensor=false&key=AIzaSyBY-vTp3r_rox3HX8OPbEL2LqWL2wxhdBY",lat,lon,@"food"];
        //NSString *urlStr = [[NSString alloc] initWithFormat:@"http://www.logyuan.tw:8082/logservice/ws_geo_getvoc2.php?geotable=temp.jpvoc&lat=%@&lon=%@&format=json",self.lat,self.lon];
        NSString *urlStr = [[NSString alloc] initWithFormat:@"http://arnose.net:8000/place/get_words_in?place=%@",Type];
        NSLog(@"%@", urlStr);
        //NSURL *url = [NSURL URLWithString:urlStr];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        //NSLog(@"%@", url);
        NSError *error = nil;
        //2 Prepare NSData for receiving the JSON data
        NSData *jsonData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
        //NSLog(@"%@", jsonData);
        NSLog(@"%@",[NSDate date]);
        //NSString *stringToLookup = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"stringToLookup: %@ ", stringToLookup);
        //3 Parse the retrieved JSON to an NSArray
        word_dict = [[NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error] objectForKey:@"words"];
        word_array = [[word_dict allValues] mutableCopy];
        NSLog(@"%@", word_array);
        //NSLog(@"%lu", (unsigned long)word_dict.count);
        //[self.VocListview reloadData];
        [self.VocListview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    });

    self.tableViewRecognizer = [self.VocListview enableGestureTableViewWithDelegate:self];
    self.VocListview.backgroundColor = [UIColor whiteColor];
    self.VocListview.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.VocListview.rowHeight       = NORMAL_CELL_FINISHING_HEIGHT;
    [self.VocListview reloadData];
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    _managedObjectContext = context;
    
    //[self savePlace:placename];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewList:(id)sender {
    //    if([[EvernoteSession sharedSession] isEvernoteInstalled]) {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NORMAL_CELL_FINISHING_HEIGHT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return (unsigned long)word_array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSObject *object = [self.word_array objectAtIndex:indexPath.row];
//    UIColor *backgroundColor = [[UIColor whiteColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:self.VocListview numberOfRowsInSection:indexPath.section]];
//    if ([object isEqual:ADDING_CELL]) {
//        NSString *cellIdentifier = nil;
//        TransformableTableViewCell *cell = nil;
//        
//        // IndexPath.row == 0 is the case we wanted to pick the pullDown style
//        if (indexPath.row == 0) {
//            cellIdentifier = @"PullDownTableViewCell";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            
//            if (cell == nil) {
//                cell = [TransformableTableViewCell transformableTableViewCellWithStyle:TransformableTableViewCellStylePullDown
//                                                                       reuseIdentifier:cellIdentifier];
//                cell.textLabel.adjustsFontSizeToFitWidth = YES;
//                cell.textLabel.textColor = [UIColor whiteColor];
//                cell.textLabel.textAlignment = UITextAlignmentCenter;
//            }
//            
//            
//            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
//            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
//                //cell.imageView.image = [UIImage imageNamed:@"reload.png"];
//                cell.tintColor = [UIColor blackColor];
//                cell.textLabel.text = @"Return to list...";
//            } else if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
//                cell.imageView.image = nil;
//                // Setup tint color
//                cell.tintColor = backgroundColor;
//                cell.textLabel.text = @"Release to create cell...";
//            } else {
//                cell.imageView.image = nil;
//                // Setup tint color
//                cell.tintColor = backgroundColor;
//                cell.textLabel.text = @"Continue Pulling...";
//            }
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.detailTextLabel.text = @" ";
//            return cell;
//            
//        } else {
//            // Otherwise is the case we wanted to pick the pullDown style
//            cellIdentifier = @"UnfoldingTableViewCell";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            
//            if (cell == nil) {
//                cell = [TransformableTableViewCell transformableTableViewCellWithStyle:TransformableTableViewCellStyleUnfolding reuseIdentifier:cellIdentifier];
//                cell.textLabel.adjustsFontSizeToFitWidth = YES;
//                cell.textLabel.textColor = [UIColor blackColor];
//                cell.textLabel.textAlignment = UITextAlignmentCenter;
//            }
//            
//            // Setup tint color
//            cell.tintColor = backgroundColor;
//            
//            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
//            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
//                cell.textLabel.text = @"Release to create cell...";
//            } else {
//                cell.textLabel.text = @"Continue Pinching...";
//            }
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.detailTextLabel.text = @" ";
//            return cell;
//        }
//        
//    } else {
//        
//        static NSString *cellIdentifier = @"MyCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.textLabel.adjustsFontSizeToFitWidth = YES;
//            cell.textLabel.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", (NSString *)object];
//        cell.detailTextLabel.text = @" ";
//        if ([object isEqual:DONE_CELL]) {
//            cell.textLabel.textColor = [UIColor grayColor];
//            cell.contentView.backgroundColor = [UIColor darkGrayColor];
//        } else if ([object isEqual:DUMMY_CELL]) {
//            cell.textLabel.text = @"";
//            cell.contentView.backgroundColor = [UIColor clearColor];
//        } else {
//            cell.textLabel.textColor = [UIColor blackColor];
//            cell.contentView.backgroundColor = backgroundColor;
//        }
//        return cell;
//    }

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordCell" forIndexPath:indexPath];
    NSString *cellIdentifier = nil;
    cellIdentifier = @"wordCell";
    TransformableTableViewCell *cell = nil;
    cell = [TransformableTableViewCell transformableTableViewCellWithStyle:TransformableTableViewCellStyleUnfolding reuseIdentifier:cellIdentifier];
    [cell.imageView setImage:[UIImage imageNamed:@"logo.png"]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.detailTextLabel.textAlignment= UITextAlignmentCenter;
    cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
    // Configure the cell...
    NSLog(@"%@",[word_array objectAtIndex:indexPath.row]);
    cell.textLabel.text = [word_array objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [word_array objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [[word_dict objectAtIndex:indexPath.row] objectForKey:@"kanji"];
    return cell;
}


-(void) saveWord:(NSString *)saveWord
{
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
        [theWord setValue:wid forKey:kWid];
        [theWord setValue:saveWord forKey:kWord];
        [theWord setValue:lon forKey:kLon];
        [theWord setValue:lat forKey:kLat];
        [theWord setValue:Type forKey:kType];
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
                [thePlace setValue:lon forKey:kLon];
                [thePlace setValue:lat forKey:kLat];
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
            [thePlace setValue:lon forKey:kLon];
            [thePlace setValue:lat forKey:kLat];
            NSNumber *pid = [NSNumber numberWithInt:[objectsPlace count]];
            [thePlace setValue:pid forKey:kPid];
            placeid =pid;
            NSLog(@"Save Place:%@",placename);

        }
    }
    
    [appDelegate saveContext];
    
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
//         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//     }
//     else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     }
// }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (UITableViewCell*)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selected_Voc = [NSString stringWithFormat:@"%@:%@",[NSString stringWithFormat:@"%@", cell.detailTextLabel.text],[NSString stringWithFormat:@"%@", cell.textLabel.text]];
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger row = [indexPath row];
//    [word_array removeObjectAtIndex:row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    
//    [self.delegate setValue:selected_Voc forKey:@"voc"];
//    
//}

#pragma mark -
#pragma mark JTTableViewGestureAddingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.word_array insertObject:ADDING_CELL atIndex:indexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.word_array replaceObjectAtIndex:indexPath.row withObject:@"Added!"];
//    TransformableTableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
//    if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
//        [self.word_array removeObjectAtIndex:indexPath.row];
//        [self.VocListview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//        // Return to list
//    }
//    else {
//        cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
//        cell.imageView.image = nil;
//        cell.textLabel.text = @"Just Added!";
//    }
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.word_array removeObjectAtIndex:indexPath.row];
}

// Uncomment to following code to disable pinch in to create cell gesture
//- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return indexPath;
//    }
//    return nil;
//}

#pragma mark JTTableViewGestureEditingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.VocListview cellForRowAtIndexPath:indexPath];
    
    UIColor *backgroundColor = nil;
    switch (state) {
        case JTTableViewCellEditingStateMiddle:
            backgroundColor = [[UIColor whiteColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:self.VocListview numberOfRowsInSection:indexPath.section]];
            break;
        case JTTableViewCellEditingStateRight:
            backgroundColor = [UIColor greenColor];
            break;
        default:
            backgroundColor = [UIColor darkGrayColor];
            break;
    }
    cell.contentView.backgroundColor = backgroundColor;
    if ([cell isKindOfClass:[TransformableTableViewCell class]]) {
        ((TransformableTableViewCell *)cell).tintColor = backgroundColor;
    }
}

// This is needed to be implemented to let our delegate choose whether the panning gesture should work
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = gestureRecognizer.tableView;
    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        // An example to discard the cell at JTTableViewCellEditingStateLeft
        [self.word_array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
        NSMutableString *celltext = [[self.word_array objectAtIndex:indexPath.row] mutableCopy];
        [self savePlace:placename];
        [self saveWord:celltext];
        [celltext appendString:@"(Saved)"];
        [self.word_array replaceObjectAtIndex:indexPath.row withObject:celltext];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
    }
    [tableView endUpdates];
    
    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];
}

#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.grabbedObject = [self.word_array objectAtIndex:indexPath.row];
    [self.word_array replaceObjectAtIndex:indexPath.row withObject:DUMMY_CELL];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self.word_array objectAtIndex:sourceIndexPath.row];
    [self.word_array removeObjectAtIndex:sourceIndexPath.row];
    [self.word_array insertObject:object atIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.word_array replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
    self.grabbedObject = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //將page2設定成Storyboard Segue的目標UIViewController
    id page2 = segue.destinationViewController;
    if ([page2 respondsToSelector:@selector(setDelegate:)]) {
        [page2 setValue:self forKey:@"delegate"];
        [page2 setValue:Type forKey:@"Type"];
        [page2 setValue:lat forKey:@"lat"];
        [page2 setValue:lon forKey:@"lon"];
        [page2 setValue:placename forKey:@"placename"];
        [page2 setValue:placeid forKey:@"placeid"];
    }
    
    
    //將值透過Storyboard Segue帶給頁面2的string變數
    
}



@end

