//
//  LGECRegisterViewController.m
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/7/25.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import "LGECRegisterViewController.h"

@interface LGECRegisterViewController ()

@end

@implementation LGECRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_txtNickname setPlaceholder: NSLocalizedString(@"Please choose a user name", nil)];
    [_txtEmail setPlaceholder:NSLocalizedString(@"Please input your Email", nil)];
    [_txtPassword setPlaceholder:NSLocalizedString(@"Password here", nil)];
    [_txtPwdAgain setPlaceholder:NSLocalizedString(@"Confirm your password", nil)];
    [_labelNickname setText:NSLocalizedString(@"Nickname", nil)];
    [_labelEmail setText:NSLocalizedString(@"Email", nil)];
    [_labelPassword setText:NSLocalizedString(@"Password", nil)];
    [_labelPassword2 setText:NSLocalizedString(@"Pwd Again", nil)];
    [_btnRegister setTitle:NSLocalizedString(@"Register", nil) forState:
     UIControlStateNormal];
    [_labelTitle setText:NSLocalizedString(@"Registration", nil)];
    [_btnRegister    setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_txtNickname becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGSize scrollviewSize;
    scrollviewSize.height =553;
    scrollviewSize.height=320;
    [_LoginScrollView setContentSize:scrollviewSize];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoginScrollView:nil];
    [self setLabelTitle:nil];
    [self setLabelNickname:nil];
    [self setLabelEmail:nil];
    [self setLabelPassword:nil];
    [self setLabelPassword2:nil];
    [self setBtnRegister:nil];
    [self setBtnCancel:nil];
    [self setTxtEmail:nil];
    [self setTxtPassword:nil];
    [self setTxtPwdAgain:nil];
    [self setLoginScrollView:nil];
    [super viewDidUnload];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)actCancelLogin:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


@end
