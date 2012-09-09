//
//  ChatDemoViewController.m
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatDemoViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ExampleViewController.h"
#import "LoginViewController.h"
#import "ChatDemoAppDelegate.h"
#import "SBJSON.h"

//#import "ASIHTTPRequest.h"


@implementation ChatDemoViewController

@synthesize cell;
@synthesize slideButton;
@synthesize chatButton;
@synthesize photoButton;
@synthesize searchField;
@synthesize keyword;
@synthesize examplesButton;
@synthesize username;

NSString *placeholder;
NSString *placeholder2;
NSString *placeholder3;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //sets up buttons
    searchField.returnKeyType = UIReturnKeySearch;
    slideButton.hidden = YES;
    photoButton.hidden = YES;
    [examplesButton setHighlighted:YES];
    
    
    ChatDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    if (FBSession.activeSession.isOpen)   
    {
        NSLog(@"Session is still open");
    }
    //new way of getting pic and name 
   [self populateUserDetails];
    


    

    
    //removes keyboard on touch up outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard 
{
    [searchField resignFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


///new way of getting usename and pic 
- (void)populateUserDetails {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.username.text = user.name;
            //     self.userProfileImage.profileID = [user objectForKey:@"id"];
             }
         }];
    }
}

- (void)getUsername:(NSString*)log
{
    placeholder = log;
    NSLog(@"its youuu %@", placeholder);
}

- (void)getId:(NSString*)log
{
    placeholder2 = log;
    NSLog(@"its youuu2 %@", placeholder2);
}

- (void)getAccessKey:(NSString*)log
{
    placeholder3 = log;
    NSLog(@"its youuu3 %@", placeholder3);
}

- (IBAction)chatButtonAction:(id)sender
{
 

}

- (IBAction) search
{
    //If you search for a keyword 
    
    NSString *keyword2 =  [[NSString alloc] initWithString:searchField.text];
    
    keyword = keyword2;
    NSLog(@"The search term is %@", keyword); 
    
     if (FBSession.activeSession.isOpen) {
         NSLog(@"Its still open!");
     }

    
    //publish to facebook///
    [self postToWall];
       
    //send it to the new chatview 
    [ChatTableViewController getString:keyword];
   
    
        chatController = [[ChatTableViewController alloc] init];
    
    
    //switch views
    UIView *newView = chatController.view;
    UIView *theWindow = [UIApplication sharedApplication].keyWindow;
    [theWindow insertSubview:newView atIndex:0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    
    [[self.view superview] exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
    
}



- (void) postToWall 
{
    
    ChatDemoAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    //open a session
    
    
    //Get the active session working first, then worry about publishing actions like this.
    /*
    //blab about namespace: action, object 
    if (appDelegate.session.isOpen) 
    {
        
        // Get the object representing the blab 
        id<BlabTopic> topic = (id<BlabTopic>)[FBGraphObject graphObject];
        topic.url = @"http://www.blabsay.com";
        
         id<BlabAction> action = (id<BlabAction>)[FBGraphObject graphObject];
            action.topic = topic;
        
      //Publish Action  
    [FBRequestConnection startForPostWithGraphPath:@"me/blabbing:blab_about"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) 
                                {
                                     if (!error) 
                                     {
                                         NSLog(@"Published order action: %@", [result objectForKey:@"id"]);
                                     }
                                 }];
    }
    else 
    {
        NSLog(@"Session is not open bitch");
    }
    */
}


- (IBAction) examples

{
    

    //view to switch too
    ExampleViewController *example = [[ExampleViewController alloc] init];
    
    [self presentViewController:example animated:YES completion:NULL];
    
    
    [examplesButton setHighlighted:YES];

    
    
}

- (void)highlightButton:(UIButton *)b { 
    
}
     



@end
