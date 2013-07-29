//
//  LGECLoginViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGECAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LGECLoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userID;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (void)loginServer:(id)sender;
- (void)loginFailed;
- (IBAction)performFBLogin:(id)sender;
- (void)receiptSegue;

@end
