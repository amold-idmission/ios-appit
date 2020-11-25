//
//  IDServerInterface.mm
//  appit-ios
//
//  Created by idmission on 24/06/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"
#import "DocumentTemplateFactory.h"
#include "IDServerInterface.h"

@interface IDServerInterface ()
@end

@implementation IDServerInterface {
    NSString *statusCode;
    NSInteger templateDownloadStatus;
}
@synthesize currentTemplateLocation;

+ (NSString*)getURLFromProperty:(NSString*) propertyName{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist" ];
    NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *url = [properties objectForKey:propertyName];
    return url;
}

- (BOOL)isTemplateDownloadingRequire:(NSDictionary*)templateDownload{
    BOOL isTemplateDownloadingRequire = false;
    
    NSArray *templateIds = [templateDownload objectForKey:@"TemplateIds"];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    for (NSDictionary *templateIdValue in templateIds) {
        NSString *templateId = [templateIdValue objectForKey:@"TemplateID"];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", currentTemplateLocation, templateId, @".xml"];
        BOOL fileExists = [filemgr fileExistsAtPath:filePath];
        if(fileExists){
            
            //Current available template in local storage
            auto doc = [DocumentTemplateFactory load_document_template:filePath];
            
            //Last updation date of currently available template
            NSString *lastUpdDateLocalTemplt = [NSString stringWithUTF8String:doc->last_updated_on().c_str()];
            
            //Last updation date of template available on server
            NSString *lastUpdDateServerTemplt = [templateIdValue objectForKey:@"CreationDate"];
            
            if(![lastUpdDateLocalTemplt isEqualToString:lastUpdDateServerTemplt]){
                isTemplateDownloadingRequire = true;
                break;
            }
        }else{
            isTemplateDownloadingRequire = true;
            break;
        }
    }
    
    return isTemplateDownloadingRequire;
}

- (NSString*)downloadTemplates:(NSDictionary*)templateDownload{

    NSString *serverURL = [templateDownload objectForKey:@"IDServerUrl"];
    NSMutableURLRequest *urlRequest = [self getRequestURL:serverURL];
    NSArray *templateIds = [templateDownload objectForKey:@"TemplateIds"];
    NSString *loginId = [templateDownload objectForKey:@"loginId"];
    NSString *password = [templateDownload objectForKey:@"password"];
    NSString *merchantId = [templateDownload objectForKey:@"merchantId"];
    merchantId = [NSString stringWithFormat:@"%@%@", @"", merchantId];
    int templateCounter = 0;
    BOOL isLastTemplate = false;
    BOOL isLastTemplateDownloadStart = false;
    if([templateIds count] == 0){
        templateDownloadStatus = 2;
    }
    int totalTemplates = [templateIds count];

    NSFileManager *filemgr = [NSFileManager defaultManager];
    for (NSDictionary *templateIdValue in templateIds) {
        templateCounter++;
        //NSLog(@"templateCounter: %d, %d", templateCounter, totalTemplates);
        if (templateCounter == totalTemplates) {
            isLastTemplate = true;
        }
        //NSLog(@"isLastTemplate: %s", isLastTemplate ? "true" : "false");
        NSString *templateId = [templateIdValue objectForKey:@"TemplateID"];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", currentTemplateLocation, templateId, @".xml"];
        BOOL fileExists = [filemgr fileExistsAtPath:filePath];
        bool downloadTemplateFile = false;
        //if template is already downloaded, check last modification date, and download only if modified
        if (fileExists) {
            
            //Current available template in local storage
            auto doc = [DocumentTemplateFactory load_document_template:filePath];
            
            //Last updation date of currently available template
            NSString *lastUpdDateLocalTemplt = [NSString stringWithUTF8String:doc->last_updated_on().c_str()];
            
            //Last updation date of template available on server
            NSString *lastUpdDateServerTemplt = [templateIdValue objectForKey:@"CreationDate"];
            
            if(![lastUpdDateLocalTemplt isEqualToString:lastUpdDateServerTemplt]){
                downloadTemplateFile = true;
            }
        }else{
            //if template is not already downloaded, download it
            downloadTemplateFile = true;
        }
        
        if (downloadTemplateFile) {
            
            NSLog(@"downloadTemplates ID: %@", templateId);
            
            templateId = [NSString stringWithFormat:@"%@%@", @"", templateId];
            
            NSData *requestBodyData = [self getTemplateDownloadRequestXML:templateId loginId:loginId password:password merchantId:merchantId];
        
            [urlRequest setHTTPBody:requestBodyData];
            if (isLastTemplate) {
                isLastTemplateDownloadStart = true;
            }
            [self downloadTemplate:urlRequest templateId:templateId isLastTemplate:isLastTemplate];
        }
         //NSLog(@"isLastTemplateDownloadStart: %s", isLastTemplateDownloadStart ? "true" : "false");
        if (isLastTemplate && !isLastTemplateDownloadStart){
            templateDownloadStatus = 2;
        }
    }
    
    
    return statusCode;
}

- (NSMutableURLRequest*)getRequestURL:(NSString*)serverURL{
    //string for the URL request
    /*NSString *myUrlString = [IDServerInterface getURLFromProperty:@"IDSUrl"];// @"https://lab.idmission.com:9043/IDS/service/ids/";*/
    NSString *myUrlString = serverURL;
    //create a NSURL object from the string data
    NSURL *myUrl = [NSURL URLWithString:myUrlString];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    //sets the receiver’s timeout interval, in seconds
    [urlRequest setTimeoutInterval:30.0f];
    //sets the receiver’s HTTP request method
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    return urlRequest;

}

- (NSData*)getTemplateDownloadRequestXML:(NSString*)templateId loginId:(NSString*)loginId password:(NSString*)password merchantId:(NSString*)merchantId  {
    NSString *stringData = @"<GenericInterface><DocumentTemplateInterface><DocumentTemplateInterfaceCustomSearchRQ><Security_Data><Unique_Data><Login_Data><Login_Id>#loginId#</Login_Id><Application_Code>IDMAXWEB</Application_Code></Login_Data></Unique_Data><Password>#password#</Password><Merchant_Id>#merchantId#</Merchant_Id></Security_Data><DocumentTemplate><Template_Id>#templateId#</Template_Id></DocumentTemplate></DocumentTemplateInterfaceCustomSearchRQ></DocumentTemplateInterface></GenericInterface>";
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#templateId#"
                                         withString:templateId];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#loginId#"
                                                       withString:loginId];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#password#"
                                                       withString:password];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#merchantId#"
                                                       withString:merchantId];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    return requestBodyData;
}

-(void)downloadTemplate:(NSMutableURLRequest*)urlRequest templateId:(NSString*)templateId isLastTemplate:(bool)isLastTemplate{
    
    //allocate a new operation queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //Loads the data for a URL request and executes a handler block on an
    //operation queue when the request completes or fails.
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         //looks like we received some data from the server
         if ([data length] >0 && error == nil){
             
             //convert the data to string so that we can display in console log
//             NSString *myXMLData = [[NSString alloc] initWithData:data
//                                                         encoding:NSUTF8StringEncoding];
             //NSLog(@"%@", myXMLData);
             NSDictionary *xmlData = [XMLReader dictionaryForXMLData:data error:error];
             if (([xmlData count] > 0)){
                 xmlData = [xmlData objectForKey:@"GenericInterface"];
                 xmlData = [xmlData objectForKey:@"DocumentTemplateInterface"];
                 xmlData = [xmlData objectForKey:@"DocumentTemplateInterfaceCustomSearchRS"];
                 NSDictionary *status = [xmlData objectForKey:@"Status"];
                 status = [status objectForKey:@"Status_Code"];
                 statusCode = [status objectForKey:@"text"];
                 if ([statusCode isEqualToString:@"000"]) {
                     xmlData = [xmlData objectForKey:@"DocumentTemplate"];
                     xmlData = [xmlData objectForKey:@"Template_Def"];
                     NSString *templateDef  = [xmlData objectForKey:@"text"];
                     //template def is encoded, decode it and write to file
                     NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:templateDef options:0];
                     NSString *docPath = [NSString stringWithFormat:@"%@/%@%@", currentTemplateLocation, templateId, @".xml"];
                     NSString *fileData = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                     [fileData writeToFile:docPath
                                atomically:YES
                                  encoding:NSUTF8StringEncoding
                                     error:NULL];
                 
                 }
                 
            }
             //NSLog(@"%@", xmlData);
             
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"Empty Response, not sure why?");
         }
         else if (error != nil){
             NSLog(@"NOoooooo, what is the error = %@", error);
         }
         if (isLastTemplate) {
             templateDownloadStatus = 2;
         }
     }];

}

- (NSInteger) getTemplateDownloadStatus
{
    return templateDownloadStatus;
}

- (void) getTemplateIdsFromServer:(NSString*) merchantId loginId:(NSString*)loginId password:(NSString*)password
{
    NSString *stringData = @"<Interface><Data_Interface><GetReportRQ><Security_Data><Unique_Data><Login_Data><Login_Id>#loginId#</Login_Id><Application_Code>IDMAXWEB</Application_Code></Login_Data></Unique_Data><Password>#password#</Password><Merchant_Id>#merchantId#</Merchant_Id></Security_Data><ReportRequest_Data><Report_Name>SEARCH_COMPANY_TEMPLATE_DETAILS</Report_Name><Report_Parameters><Parameter_Name>COMPANY_HIEARCHY</Parameter_Name><Parameter_Value>Y</Parameter_Value></Report_Parameters><Report_Output><Skip_Filter>N</Skip_Filter><Report_Output_Type><On_Line>Y</On_Line></Report_Output_Type></Report_Output></ReportRequest_Data></GetReportRQ></Data_Interface></Interface>";
    
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#loginId#"
                                                       withString:loginId];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#password#"
                                                       withString:password];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"#merchantId#"
                                                       withString:merchantId];
    
    NSString *serverURL = [IDServerInterface getURLFromProperty:@"IDSUrl"];
    NSMutableURLRequest *urlRequest = [self getRequestURL:serverURL];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:requestBodyData];
    //allocate a new operation queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //Loads the data for a URL request and executes a handler block on an
    //operation queue when the request completes or fails.
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         //looks like we received some data from the server
         if ([data length] >0 && error == nil){
             NSDictionary *xmlData = [XMLReader dictionaryForXMLData:data error:error];
             if (([xmlData count] > 0)){
                 xmlData = [xmlData objectForKey:@"Interface"];
                 xmlData = [xmlData objectForKey:@"Data_Interface"];
                 xmlData = [xmlData objectForKey:@"GetReportRS"];
                 NSDictionary *status = [xmlData objectForKey:@"Status_Data"];
                 status = [status objectForKey:@"Status_Code"];
                 statusCode = [status objectForKey:@"text"];
                 if ([statusCode isEqualToString:@"000"]) {
                     xmlData = [xmlData objectForKey:@"Report_Data"];
                     NSArray* fieldValues = [xmlData objectForKey:@"Field_Values"];
                     int fieldValuesCount = [fieldValues count];
                     NSMutableArray *templateIds = [NSMutableArray arrayWithCapacity:fieldValuesCount];
                     if ( fieldValuesCount > 0) {
                         for (int fieldValueIndex=0; fieldValueIndex<fieldValuesCount; fieldValueIndex++) {
                             NSDictionary *fieldValueFromRQ = [fieldValues objectAtIndex:fieldValueIndex];
                             NSString* fieldValueText = [fieldValueFromRQ objectForKey:@"text"];
                             NSArray *fieldValueArray = [fieldValueText componentsSeparatedByString:@"||"];
                             NSMutableDictionary *fieldValue = [NSMutableDictionary new];
                             [fieldValue setObject:[fieldValueArray objectAtIndex:2] forKey:@"TemplateID"];
                             [fieldValue setObject:[fieldValueArray objectAtIndex:10] forKey:@"CreationDate"];
                             [templateIds addObject:fieldValue];
                         }
                         
                         NSMutableDictionary *templateDownload = [NSMutableDictionary new];
                         [templateDownload setObject:templateIds forKey:@"TemplateIds"];
                         [templateDownload setObject:loginId forKey:@"loginId"];
                         [templateDownload setObject:password forKey:@"password"];
                         [templateDownload setObject:merchantId forKey:@"merchantId"];
                         
                         [self downloadTemplates:templateDownload];
                     }
                 }
                 
             }
         }else if ([data length] == 0 && error == nil){
             NSLog(@"Empty Response, not sure why?");
         }
         else if (error != nil){
             NSLog(@"NOoooooo, what is the error = %@", error);
         }
         
     }];
    
}

@end
