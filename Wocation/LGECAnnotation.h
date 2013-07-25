//
//  LGECAnnotation.h
//  Wocation
//
//  Created by CHIH YUAN CHEN on 13/6/10.
//  Copyright (c) 2013年 CHIH YUAN CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LGECAnnotation : NSObject<MKAnnotation>

@property (copy,nonatomic)  NSString *title;
@property(copy,nonatomic) NSString *subTitle;
@property (assign,nonatomic) CLLocationCoordinate2D coordinate;

@end
