//
//  LGECRegisterViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/7/25.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGECRegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *LoginScrollView;

@property (strong, nonatomic) IBOutlet UITextField *txtNickname;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPwdAgain;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelNickname;
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelPassword;
@property (strong, nonatomic) IBOutlet UILabel *labelPassword2;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)actCancelLogin:(id)sender;

@end
