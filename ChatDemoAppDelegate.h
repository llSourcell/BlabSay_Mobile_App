//
//  ChatDemoAppDelegate.h
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#include "SBJSON.h"

extern NSString *const BSSessionStateChangedNotification;



@class ChatDemoViewController, LoginViewController;


@interface ChatDemoAppDelegate : NSObject <UIApplicationDelegate>
{
    ChatDemoViewController *chatty;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ChatDemoViewController *viewController;
@property (retain, nonatomic) IBOutlet LoginViewController *viewController2;


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end


