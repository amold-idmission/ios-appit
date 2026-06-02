//
//  GPSText.h
//  AppItFramework
//
//  Created by  on 08/05/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppItSDK.h"

@interface GPSText : NSObject<CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
}

-(void)startCapturingLocation;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@end
