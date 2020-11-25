//
//  AppDelegate.m
//  ios-appit-client
//
//  Created by idmission on 04/11/15.
//  Copyright © 2015 idmission. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonUtils.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    NSLog(@"Open url called  %@ ", url);
//    NSLog(@"Open [url path]  %@ ", [url path]);
//    NSLog(@"Open [url query] %@ ", [url query]);
    
    NSString *action = [url path];
    
    NSDictionary *params = [CommonUtils getUrlParams:[url query]];
    
    NSString *reqParam = [params valueForKey:@"requestParam"];
    
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:reqParam options:0];
    
    NSDictionary *imageProcessingData = [NSJSONSerialization JSONObjectWithData:nsdataFromBase64String options:0 error:nil];
    
    NSString *status = [imageProcessingData valueForKey:@"Status"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    if ([status isEqualToString:@"0"]) {
        viewController.status = @"Success";
    }else if ([status isEqualToString:@"101"]) {
        viewController.status = @"Template Not Found!";
    }else{
        viewController.status = @"Failed";
    }
    
    if ([action containsString:@"faceDetectionResponse"]) {
    
        NSString *originalImage = [imageProcessingData valueForKey:@"OriginalImage"];
        NSString *ovalImage = [imageProcessingData valueForKey:@"EllipseImage"];
        
        if(nil != originalImage){
            NSData *originalImageData = [[NSData alloc]initWithBase64EncodedString:originalImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *originalUIImage = [UIImage imageWithData:originalImageData];
            NSLog(@"Origional Image Found");
            
            originalUIImage = [viewController imageWithImage:originalUIImage scaledToSize:CGSizeMake(200, 300)];
            viewController.orImage = originalUIImage;
            //        [viewController setOrigionalImage:originalUIImage];
        }
        
        
        if(nil != ovalImage){
            NSData *ovalImageData = [[NSData alloc]initWithBase64EncodedString:ovalImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *ovalUIImage = [UIImage imageWithData:ovalImageData];
            NSLog(@"Oval Image Found");
            
            ovalUIImage = [viewController imageWithImage:ovalUIImage scaledToSize:CGSizeMake(200, 300)];
            viewController.ovImage = ovalUIImage;
            //        [viewController setOvalImage:ovalUIImage];
        }
        
    }else if([action containsString:@"imageProcResponse"]){

        NSString *responseXml = [imageProcessingData valueForKey:@"ResponseXML"];
        viewController.imageProcResponseXML = responseXml;
        
        
        NSString *processedImageString = [imageProcessingData valueForKey:@"ProcessedImage"];
        if(nil != processedImageString){
            NSData *processedImageData = [[NSData alloc]initWithBase64EncodedString:processedImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *processedImage = [UIImage imageWithData:processedImageData];
            
            processedImage = [viewController imageWithImage:processedImage scaledToSize:CGSizeMake(200, 300)];
            viewController.processedImage = processedImage;
        }
        
        NSString *faceImageStr = [imageProcessingData valueForKey:@"FaceImage"];
        if(nil != faceImageStr){
            NSData *faceImageData = [[NSData alloc]initWithBase64EncodedString:faceImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *faceImage = [UIImage imageWithData:faceImageData];
            
            faceImage = [viewController imageWithImage:faceImage scaledToSize:CGSizeMake(200, 300)];
            viewController.faceImage = faceImage;
        }
        
        NSString *inputImageStr = [imageProcessingData valueForKey:@"InputImage"];
        if(nil != inputImageStr){
            NSData *inputImageData = [[NSData alloc]initWithBase64EncodedString:inputImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *inputImage = [UIImage imageWithData:inputImageData];
            
            inputImage = [viewController imageWithImage:inputImage scaledToSize:CGSizeMake(200, 300)];
            viewController.inputImage = inputImage;
        }
        
        NSString *templateImageStr = [imageProcessingData valueForKey:@"TemplateImage"];
        if(nil != templateImageStr){
            NSData *templateImageStrData = [[NSData alloc]initWithBase64EncodedString:templateImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *templateImage = [UIImage imageWithData:templateImageStrData];

            templateImage = [viewController imageWithImage:templateImage scaledToSize:CGSizeMake(200, 300)];
            viewController.templateImage = templateImage;
        }
        NSLog(@"");
    }else if ([action containsString:@"downloadTemplateResponse"]){
    
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
