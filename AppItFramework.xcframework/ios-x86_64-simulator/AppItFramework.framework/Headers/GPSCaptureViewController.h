//
//  GPSCaptureViewController.h
//  AppItFramework
//
//  Created by  on 07/05/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CommonImporter.h"

//@interface GPSCaptureViewController : UIViewController <CLLocationManagerDelegate> {
@interface GPSCaptureViewController : NSObject <CLLocationManagerDelegate> {
     CLLocationManager *locationManager;
}

-(id) initWithData:(id)instance isFromInitializeCall:(bool)isFromInitializeCall verifyViewControllerResultDictionary:(NSMutableDictionary *)verifyViewControllerResultDictionary;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)bool isFromInitializeCall;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSMutableDictionary *verifyViewControllerResultDictionary;


@end
