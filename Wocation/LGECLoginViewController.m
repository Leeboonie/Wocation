//
//  LGECLoginViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECLoginViewController.h"
#import "LGECViewController.h"
#import "LGECAppDelegate.h"

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
    LGECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://arnose.net:8000/place/login/login.json?user=%@&password=%@",userID.text,password.text];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    //NSLog(@"%@", url);
    NSError *error = nil;
    //2 Prepare NSData for receiving the JSON data
    NSData *authData=[NSData dataWithContentsOfURL:url  options:NSDataReadingMapped error:&error];
    //NSLog(@"%@", jsonData);
    
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
    [self.btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal] ;
    self.userID.placeholder = NSLocalizedString(@"Email", nil);
    self.password.placeholder = NSLocalizedString(@"Passward", nil);

}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.shouldSkipLogIn) {
        [self performSelector:@selector(transitionToMainViewController) withObject:nil afterDelay:.5];
    }

}

- (void)setShouldSkipLogIn:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"ScrumptiousSkipLogIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldSkipLogIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ScrumptiousSkipLogIn"];
}

-(void) loginWithUserID
{
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




- (void)viewDidUnload {
    [self setBtnLogin:nil];
    [self setBtnRegister:nil];
    [self setFBLoginView:nil];
    [super viewDidUnload];
}
@end
