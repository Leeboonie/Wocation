//
//  LGECDetailViewController.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/8.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGECDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
