//
//  IDServerInterface.h
//  appit-ios
//
//  Created by idmission on 24/06/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//


@interface IDServerInterface : NSObject

@property(nonatomic) NSString *currentTemplateLocation;

- (BOOL)isTemplateDownloadingRequire:(NSDictionary*)templateDownload;
- (NSString*)downloadTemplates:(NSDictionary*)templateDownload;
+ (NSString*)getURLFromProperty:(NSString*) propertyName;
- (NSInteger) getTemplateDownloadStatus;
- (void) getTemplateIdsFromServer:(NSString*) merchantId loginId:(NSString*)loginId password:(NSString*)password;
@end

