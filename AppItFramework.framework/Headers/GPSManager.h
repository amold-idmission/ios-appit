//
//  GPSManager.h
//  AppItFramework
//
//  Created by  on 08/02/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSManager : NSObject

+(NSString *)getLatitude;
+(void)setLatitude:(NSString*)Latitude;

+(NSString *)getLongitude;
+(void)setLongitude:(NSString*)Longitude;

+(NSString *)getLatitudeGPS;
+(void)setLatitudeGPS:(NSString*)LatitudeGPS;

+(NSString *)getLongitudeGPS;
+(void)setLongitudeGPS:(NSString*)LongitudeGPS;

@end
