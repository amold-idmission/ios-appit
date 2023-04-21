//
//  AppDelegate.m
//  appit-ios
//
//  Created by Goran Rauker on 1/29/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonUtils.h"
#import "TemplateDownloadViewController.h"
#import "Settings.h"
#import "ViewController.h"
#import <Firebase.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    
    NSString *tess_data_path;
    
    NSString *templates_path;
    NSString* resettingUrl;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //FireBase App Configuration
    [FIRApp configure];
    
    tess_data_path = [self setup_tesseract_data];
    
    //Skip iCloud back-up of tessdata folder else build will be rejected as this is a large data to be backed up on icloud
    [self addSkipBackupAttributeToItemAtPath:tess_data_path];
    
    templates_path = [self create_templates_directory];
    
    //Skip iCloud back-up of templates folder
    [self addSkipBackupAttributeToItemAtPath:templates_path];
    
    //creating "recording" directory inside "tmp" directory to temporary keep voice recording file
    [self create_recording_directory_in_tmp];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    NSLog(@"Open url called  %@ ", url);
//    NSLog(@"Open [url path]  %@ ", [url path]);
//    NSLog(@"Open [url query] %@ ", [url query]);
    NSString* thirdPartyUrlScheme = [url scheme];
    if([thirdPartyUrlScheme  isEqual: @"idmission"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [dict setObject:val forKey:key];
        }
        NSLog(@"query dict: %@", dict);
        NSString* tokenId = [dict valueForKey:@"tokenId"];
        NSString* productId = [dict valueForKey:@"productId"];
        NSString* requestId = [dict valueForKey:@"requestId"];
        NSString* templateId = [dict valueForKey:@"templateId"];
        NSString* language = [dict valueForKey:@"language"];
        NSString* formId = [dict valueForKey:@"formId"];
        NSString* formKey = [dict valueForKey:@"formKey"];
        NSString* formData = [dict valueForKey:@"formData"];
        
        NSString * encodedFormData = [formData stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
 
        NSString* identifier1 = [dict valueForKey:@"identifier1"];
        NSString* identifier2 = [dict valueForKey:@"identifier2"];
        
        NSURL* appitURL = [NSURL URLWithString:[Settings getCurrentURL]];
        
        NSURLComponents* comp = [NSURLComponents new];
        comp.scheme = [appitURL scheme];
        comp.host = [appitURL host];
        comp.port = [appitURL port];
        NSURL* launchURL = [comp URL];
        NSMutableString *launchURLstring = [NSMutableString stringWithString:launchURL.absoluteString];
        
        [launchURLstring appendString:@"/inform/invokeInform?"];
        
        [launchURLstring appendString:@"productId="];
        [launchURLstring appendString:productId];
        [launchURLstring appendString:@"&"];
        
        [launchURLstring appendString:@"tokenId="];
        [launchURLstring appendString:tokenId];
        [launchURLstring appendString:@"&"];
        
        [launchURLstring appendString:@"requestId="];
        [launchURLstring appendString:requestId];
        
        [launchURLstring appendString:@"&templateId="];
        [launchURLstring appendString:templateId];
        
        [launchURLstring appendString:@"&language="];
        [launchURLstring appendString:language];
        
        [launchURLstring appendString:@"&formId="];
        [launchURLstring appendString:formId];
        
        [launchURLstring appendString:@"&formKey="];
        [launchURLstring appendString:formKey];
        
        [launchURLstring appendString:@"&formData="];
        [launchURLstring appendString:encodedFormData];
        
        [launchURLstring appendString:@"&identifier1="];
        [launchURLstring appendString:identifier1];
        
        [launchURLstring appendString:@"&identifier2="];
        [launchURLstring appendString:identifier2];
        
        [launchURLstring appendString:@"&returnurl="];
        [launchURLstring appendString:@"https://demo.idmission.com/inform"];
        
        [launchURLstring appendString:@"&isThirdPartyAppit="];
        [launchURLstring appendString:@"Y"];
        
        [launchURLstring appendString:@"&d="];
        [launchURLstring appendString:@"y"];
        
        NSString* launchURLFormated = [NSString stringWithFormat:@"%@", launchURLstring];
        resettingUrl = [Settings getCurrentURL];        
        [Settings setCurrentURL:launchURLFormated];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
        [controller setresettingUrl:resettingUrl];
        UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController =nil;
        self.window.rootViewController = navigationController;
        [navigationController setNavigationBarHidden:NO];
        [self.window makeKeyAndVisible];
        return true;

    }
    NSString *action = [url path];
    
    NSDictionary *params = [CommonUtils getUrlParams:[url query]];
    
    NSString *reqParam = [params valueForKey:@"requestParam"];
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:reqParam options:0];
    
    NSDictionary *imageProcessingData = [NSJSONSerialization JSONObjectWithData:nsdataFromBase64String options:0 error:nil];
    
    NSString *respURL = [imageProcessingData valueForKey:@"response_url"];

    if ([action containsString:@"callFaceDetection"]) {

//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FaceDetectionViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FaceDetectionViewController"];
////        viewController.threshold = [[imageProcessingData objectForKey:@"threshold"] intValue];
////        viewController.thresholdSetting = [imageProcessingData objectForKey:@"thresholdSetting"];
////        viewController.support_eyewear = [[imageProcessingData objectForKey:@"support_eyewear"] boolValue];
////        viewController.take_image_while_processing = [[imageProcessingData objectForKey:@"take_image_while_processing"] boolValue];
////        viewController.verify_final_image = [[imageProcessingData objectForKey:@"verify_final_image"] boolValue];
////        viewController.verify_final_image_Minimum_Match = [[imageProcessingData objectForKey:@"verify_final_image_Minimum_Match"] intValue];
////        viewController.LowLightThresholdValue = [[imageProcessingData objectForKey:@"LowLightThresholdValue"] intValue];
////
////        viewController.launchedFromApp = YES;
////        [viewController.responseUrl appendString:respURL];
//
//        self.window.rootViewController = viewController;
//        [self.window makeKeyAndVisible];

    }else if([action containsString:@"callImageProc"]){
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        OpenCvViewControllerAppit *controller = [storyboard instantiateViewControllerWithIdentifier:@"OpenCvViewControllerAppitId"];
//
//        BOOL highResolutionImageMode = [[imageProcessingData objectForKey:@"HighResolutionImageMode"] boolValue];
//
//        if(highResolutionImageMode){
//
//        }else{
//
//            controller.single_high_res_snapshot_mode = highResolutionImageMode;
//
//            NSString *templateIds = [imageProcessingData objectForKey:@"TemplateIds"];
//            controller.template_ids = templateIds;
//
//            NSString *imageCaptureCount = [imageProcessingData objectForKey:@"ImageCaptureCount"];
//            int imagesToInsert = 4;
//            if (imageCaptureCount != nil) {
//                imagesToInsert = [imageCaptureCount intValue];
//            }
//            controller.ImagesToInsert = imagesToInsert;
//            controller.ImagesToConsume = imagesToInsert-1;
//
//
//            controller.launchedFromApp = YES;
//            controller.responseUrl = [NSMutableString stringWithString:respURL];
//
//            self.window.rootViewController = controller;
//            [self.window makeKeyAndVisible];
//        }
    }else if([action containsString:@"callDownloadTemplate"]){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TemplateDownloadViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TemplateDownloadViewControllerId"];
        
        controller.merchantId = [imageProcessingData objectForKey:@"merchantId"];
        controller.loginId = [imageProcessingData objectForKey:@"loginId"];
        controller.password = [imageProcessingData objectForKey:@"password"];
        
        controller.launchedFromApp = YES;
        controller.responseUrl = [NSMutableString stringWithString:respURL];
        
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
        
        [controller downloadTemplates];
        [controller checkDownloadStatus];
        NSLog(@"request param : %@",respURL);
    }else if([action containsString:@"invokeInform"]){
        [Settings setCurrentURL:@"https://lab.idmission.com:9043/inform/"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
        self.window.rootViewController = controller;
//        [self.window makeKeyAndVisible];
    }
    
    return true;
}
 

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground ...");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   // [self.window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive ...");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate ...");
}

- (NSString*)setup_tesseract_data
{
    // Set up the tessdata path. This is included in the application bundle but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    return dataPath;
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
        return NO;
    }
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"AppDelegate Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

-(NSString*)create_templates_directory{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"/templates"];
    
    if (![defaultManager fileExistsAtPath:dataPath]){
        [defaultManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
    }
    return dataPath;
}

-(NSString*)create_recording_directory_in_tmp{
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    NSString *dataPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/recording"];
    
    if (![defaultManager fileExistsAtPath:dataPath]){
        [defaultManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    }else{
        NSArray *filearray = [defaultManager contentsOfDirectoryAtPath:dataPath error:nil];
        NSString *file;
        for (file in filearray) {
            NSLog(@"AppDelegate recording file %@", file);
            NSString *deletefile = [NSString stringWithFormat:@"%@/%@", dataPath, file];
            
            [defaultManager removeItemAtPath:deletefile error:nil];
        }
    }
    return dataPath;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictOrientationToSupportAll)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

@end
