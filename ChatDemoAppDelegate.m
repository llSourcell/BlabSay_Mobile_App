//
//  ChatDemoAppDelegate.m
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatDemoAppDelegate.h"

#import "ChatDemoViewController.h"
#import "LoginViewController.h"
#import <UIKit/UIKit.h>

NSString *const BSSessionStateChangedNotification = @"com.facebook.BlabSay:BSSessionStateChangedNotification";


@implementation ChatDemoAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize viewController2 = _viewController2;


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv count] > 1) {
            NSString *val = [[kv objectAtIndex:1]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
           
                // We have a valid session
                NSLog(@"User session found");
                //added FIX 
           // [FBSession.activeSession closeAndClearTokenInformation];
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    // Ask for permissions for publishing, getting info about uploaded
    // custom photos.
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"publish_actions",
                            nil];
    
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
    
    

}


- (void) closeSession 
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - Personalization methods
/*
 * Makes a request for user data and invokes a callback
 */




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [FBPlacePickerViewController class];
    [FBFriendPickerViewController class];
    
   
    
    [self.window setBackgroundColor:[UIColor blackColor]];
    self.window.rootViewController = self.viewController2;
    [self.window makeKeyAndVisible];
    return YES;
     

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) 
    {
        [FBSession.activeSession close]; // so we close our session and start over
    }
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation 
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_viewController2 release];
    [super dealloc];
}

@end
