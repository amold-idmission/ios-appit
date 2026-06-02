//
//  DownloadTemplateData.h
//  AppItFramework
//
//  Created by Sanket Garde on 06/11/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadTemplateData : NSObject<NSXMLParserDelegate> {
    
}

+(void)download_SeacrhCompanyTemplate;
+(NSMutableArray *)get_SeacrhCompanyTemplateFieldArray;

@end

