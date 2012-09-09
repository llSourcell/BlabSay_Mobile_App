//
//  LoginViewController.m
//  ChatDemo
//
//  Created by User on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatDemoAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"


@interface LoginViewController ()


//Facebook//
@property (retain, nonatomic) IBOutlet UIButton *buttonLoginLogout;

- (IBAction)buttonClickHandler:(id)sender;
- (void) updateView;
- (void)populateUserDetails;

//Facebook//


@end

@implementation LoginViewController

//Facebook//
@synthesize buttonLoginLogout = _buttonLoginLogout;
@synthesize finalname;
//Facebook//



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateView];

}

-(void) updateView
{
        
}



- (IBAction)buttonClickHandler:(id)sender 
{
    
    ChatDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    NSLog(@"clicked");
    
//    if (FBSession.activeSession.isOpen) {
        NSLog(@"Opened");
        chatty = [[ChatDemoViewController alloc] init];
        [self presentViewController:chatty animated:NO completion:nil];
    
    
    
    //so an active session is open even though i havent logged in? 
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.buttonLoginLogout = nil;
}


@end
