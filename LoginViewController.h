//
//  LoginViewController.h
//  ChatDemo
//
//  Created by User on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDemoViewController.h"


typedef void(^SelectItemCallback)(id sender, id selectedItem);


@interface LoginViewController : UIViewController
{
    ChatDemoViewController *chatty;
}


@property (nonatomic, copy) NSString *finalname;


@end
