//
//  LGECLoginViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECLoginViewController.h"
#import "LGECViewController.h"

static NSString * const kUserEntityName = @"User";
static NSString * const kUsername = @"username";
static NSString * const kUserPassword = @"password";



@interface LGECLoginViewController ()

@end

@implementation LGECLoginViewController

@synthesize password;
@synthesize userID;
@synthesize managedObjectContext;

- (void)loginServer:(id)sender {
    [self.spinner setHidden:FALSE];
    [self.spinner startAnimating];
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://arnose.net:8000/place/login/login.json?user=%@&password=%@",userID.text,password.text];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    //NSLog(@"%@", url);
    NSError *error = nil;
    //2 Prepare NSData for receiving the JSON data
    NSData *authData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
    //NSLog(@"%@", jsonData);
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
        NSString *stringToLookup = [[NSString alloc]initWithData:authData encoding:NSUTF8StringEncoding];
        NSLog(@"stringToLookup: %@ ", stringToLookup);
        
        //3 Parse the retrieved JSON to an NSArray
        NSDictionary *Auth_Dictionay = [NSJSONSerialization JSONObjectWithData:authData options:
                                        NSJSONReadingMutableContainers error:&error];
        if ([[Auth_Dictionay objectForKey:@"message"] isEqual: @"OK"])
        {
            NSLog(@"OK");
            //do any setup you need for myNewVC
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kUserEntityName];
            NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
            NSManagedObject *theLine = nil;
            if ([objects count] > 0) {
                theLine = [objects objectAtIndex:0];
            } else {
                theLine = [NSEntityDescription
                           insertNewObjectForEntityForName:kUserEntityName
                           inManagedObjectContext:managedObjectContext];
            }
            [theLine setValue:userID.text forKey:kUsername];
            [theLine setValue:password.text forKey:kUserPassword];
            [appDelegate saveContext];
            [self performSegueWithIdentifier:@"NavigationControl" sender:sender];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login error"
                                                            message:@"PLease check your id and password"
                                                           delegate:self
                                                  cancelButtonTitle:@"cancel"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"NO");
        }

    }
   [self.spinner stopAnimating];
}





//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [textField resignFirstResponder];
//    return NO;
//}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //password.delegate = self;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // See if the app has a valid token for the current state.
    [self.btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal] ;
    self.userID.placeholder = NSLocalizedString(@"Email", nil);
    self.password.placeholder = NSLocalizedString(@"Passward", nil);
        
}

- (void)viewDidAppear:(BOOL)animated
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        NSLog(@"will login Automatically");
        [self performFBLogin:(self)];
        
    } else {
        NSLog(@"Show FB Icon");
        // No, display the login page.
    }
}


- (IBAction)performFBLogin:(id)sender
{
    [self.spinner startAnimating];
    
    LGECAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    [self.spinner stopAnimating];
    
}

-(IBAction)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}


-(void) loginWithUserID
{
    [self.spinner startAnimating];
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    managedObjectContext = context;
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kUserEntityName];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects.count == 0) {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    else
    {
        for (NSManagedObject *oneObject in objects) {
            NSString *autologinID = [oneObject valueForKey:kUsername];
            NSString *autologinPassword = [oneObject valueForKey:kUserPassword];
            userID.text = autologinID;
            password.text = autologinPassword;
            NSLog(@"%@",autologinID);
            
        }
        NSString *urlStr = [[NSString alloc] initWithFormat:@"http://arnose.net:8000/place/login/login.json?user=%@&password=%@",userID.text,password.text];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        //NSLog(@"%@", url);
        NSError *error = nil;
        //2 Prepare NSData for receiving the JSON data
        NSData *authData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
        //NSLog(@"%@", jsonData);
        
        NSString *stringToLookup = [[NSString alloc]initWithData:authData encoding:NSUTF8StringEncoding];
        NSLog(@"stringToLookup: %@ ", stringToLookup);
        NSDictionary *Auth_Dictionay = [NSJSONSerialization JSONObjectWithData:authData options:
                                        NSJSONReadingMutableContainers error:&error];
        if ([[Auth_Dictionay objectForKey:@"message"] isEqual: @"OK"])
        {
            [self performSegueWithIdentifier:@"NavigationControl" sender:self];
        }
    }
    [self.spinner stopAnimating];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //將page2設定成Storyboard Segue的目標UIViewController
    id page2 = segue.destinationViewController;
    if ([page2 respondsToSelector:@selector(setDelegate:)]) {
        [page2 setValue:self forKey:@"delegate"];
//        [page2 setValue:wordType forKey:@"Type"];
//        NSLog(@"SetType:%@",wordType);
//        [page2 setValue:lat forKey:@"lat"];
//        [page2 setValue:lon forKey:@"lng"];
    }
    
    
    //將值透過Storyboard Segue帶給頁面2的string變數
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

- (void)viewDidUnload {
    [self setBtnLogin:nil];
    [self setBtnRegister:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}
@end
