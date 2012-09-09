//
//  ChatTableViewController.m
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableView.h"
#import <FacebookSDK/FacebookSDK.h>



@implementation ChatTableViewController

@synthesize channel2, empty, empty2, msgDate;

#define TOP_BUTTON_HEIGHT 60
#define BOUNDARY_HEIGHT 4
#define PUSH_UP_HEIGHT 216
#define PUSH_UP_FOOT_VIEW_DURATION 0.31
#define PUSH_DOWN_FOOT_VIEW_DURATION 0.31
#define PUSH_UP_KB_DURATION 0.28
#define PUSH_DOWN_KB_DURATION 0.32


#define FOOT_VIEW_HEIGHT 43

@synthesize chatDelegate;
NSString *placeholder;
NSMutableArray *placeholder2;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

+ (void)getString:(NSString*)log
{
    placeholder = log;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //sets background blue dots
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
  //checking to see if session is still open. its been open. 
    if (FBSession.activeSession.isOpen)   
    {
        NSLog(@"Session is still open");
    }




    
    change2ExpressionKB = NO;
    
    //
    topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    topButton.frame = CGRectMake(0, 0, 320, TOP_BUTTON_HEIGHT-11);
    [topButton setBackgroundImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
    
    //
    tableView = [[ChatTableView alloc] initWithFrame:CGRectMake(0, TOP_BUTTON_HEIGHT + BOUNDARY_HEIGHT, 320, 460 - TOP_BUTTON_HEIGHT - BOUNDARY_HEIGHT - FOOT_VIEW_HEIGHT) style:UITableViewStylePlain];
    tableView.chatDelegate = self;
    [tableView setBackgroundColor:[UIColor clearColor]];
    self.chatDelegate = tableView;
    
    //
    UserProfile *myProfile = [[UserProfile alloc] initWithUserName:@"Charlene" photo:[UIImage imageNamed:@"dot.PNG"]];
    tableView.me = myProfile;
    [myProfile release];
    
    //
    UIImage * dot = [UIImage imageNamed:@"dot.PNG"];
    CGSize newSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(newSize);
    [dot drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    dot = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    
    
    UserProfile *myFriendProfile = [[UserProfile alloc] initWithUserName:@"姜小迎" photo:dot];
    tableView.myFriend = myFriendProfile;
    [myFriendProfile release];
    
    //
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 460 - FOOT_VIEW_HEIGHT, 320, FOOT_VIEW_HEIGHT)];
    UIImageView *footBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
    footBackGroundView.image = [UIImage imageNamed:@"INPUT_bg.png"];
    [footView addSubview:footBackGroundView];


    
    //
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(320 - 76, 0, 76, 43);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"button_send.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sendButton]; 
    
    //
    [footView addSubview:[self textFieldRounded]];
    
    //
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    [tableView release];
    
    [self.view addSubview:footView];
    [footView release];
    
    //
    expKB = [[[NSBundle mainBundle] loadNibNamed:@"ExpressionKB" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:expKB];
    CGRect rect = expKB.frame;
    rect.origin = CGPointMake(0, 460);
    expKB.frame = rect;


    
    NSLog(@"viewdidload");
    
}



- (void) pubnub:(CEPubnub*)pubnub ConnectToChannel:channel
{
    
}

- (void) pubnub:(CEPubnub*)pubnub didReceiveTime:(NSTimeInterval)time
{
    NSLog(@"received the time");
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //initializes dynamic channel variable
     channel2 = placeholder;
    
    //sets blabbox title 
    UILabel *BlabBox = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 700, 70)];
    NSString *pound = @"#";
    NSString *concate = [pound stringByAppendingString:channel2];
    BlabBox.text = concate;
    BlabBox.font = [UIFont fontWithName:@"Futura" size: 13.0];
    [self.view addSubview:BlabBox];
    BlabBox.backgroundColor = [UIColor clearColor]; 
    BlabBox.shadowColor = [UIColor grayColor];
	BlabBox.shadowOffset = CGSizeMake(1,1);
    BlabBox.textColor = [UIColor whiteColor];
    
//Connects to Pubnub
    
       //initializes pubnub variable with my keys
    pubnub = [[CEPubnub alloc] initWithPublishKey:@"pub-f84b22d9-ab10-4678-830f-190e94f0466a" subscribeKey:@"sub-008cca42-5218-11e1-a9f0-31bc26addfff" secretKey:@"sec-bc804583-b3eb-4927-9109-b118cdf802c1" cipherKey:nil useSSL:NO];   
    [pubnub setDelegate:self];
    
    
    //connects to the specified pubnub channel 
    [pubnub subscribe:channel2];
    
    
 
    //Retrieve messages 
    NSInteger limit = 100;
    NSNumber * aWrappedInt = [NSNumber numberWithInteger:limit];
    
    
    [pubnub fetchHistory:[NSDictionary dictionaryWithObjectsAndKeys: aWrappedInt,@"limit", channel2,@"channel",nil]];
    
   
[pubnub getTime];
    
    NSLog(@"ViewWillAppear");
    
    
    //////////////////////////////////////////////////////////////////////////////////////////

}
- (void) pubnub:(CEPubnub*)pubnub didFetchHistory:(NSArray*)messages forChannel:(NSString*)channel
{
    placeholder2 =[NSMutableArray arrayWithArray:messages];
    channel2 = channel;
    

    //friend's messages. 
    //Need to pull. Alter logic. 
    //create for loop for every message pulled from pubnub and publish as friend message with 
    //the count being the initwithmessage
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
  
        for(int x = 0; x<[placeholder2 count]; x++)
        {
            NSString *retrievedMessage = [placeholder2 objectAtIndex:x];
            MessageItem *myFriendMsg = [[[MessageItem alloc] initWithMessage:retrievedMessage date:nowDate isMe:NO] autorelease];
            [self.chatDelegate messageRecieved:myFriendMsg];
            
        }
    
    empty = [[UILabel alloc] initWithFrame:CGRectMake(3, 132, 700, 70)];
    NSString *line1;
    empty2 = [[UILabel alloc] initWithFrame:CGRectMake(117, 158, 700, 70)];
    NSString *line2;
    if([placeholder2 count] == 0)
    {
        empty = [[UILabel alloc] initWithFrame:CGRectMake(3, 132, 700, 70)];
        line1 = @"No one is blabbing about this topic yet. ";
        empty.text = line1;
        empty.font = [UIFont fontWithName:@"Futura" size: 17.5];
        [self.view addSubview:empty];
        empty.backgroundColor = [UIColor clearColor]; 
        empty.shadowColor = [UIColor grayColor];
        empty.shadowOffset = CGSizeMake(1,1);
        empty.textColor = [UIColor whiteColor];
        
        line2 = @"Be the First!";
        empty2.text = line2;
        empty2.font = [UIFont fontWithName:@"Futura" size: 17.5];
        [self.view addSubview:empty2];
        empty2.backgroundColor = [UIColor clearColor]; 
        empty2.shadowColor = [UIColor grayColor];
        empty2.shadowOffset = CGSizeMake(1,1);
        empty2.textColor = [UIColor whiteColor];
    }
    
}



//retrieves messages
+ (void) getTheMessages:(NSMutableArray*)log
{
    placeholder2 = log;
    NSLog(@"got em %@", placeholder2);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
  
    NSLog(@"ViewDidAppear"); 

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self shouldDismissKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



#pragma mark - 
- (void)topButtonAction:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    
    [[self.view superview] exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
    
    [self.view removeFromSuperview];
}

- (void)expressionButtonAction:(id)sender
{
    CGPoint p = footView.center;
    
    if (p.y > 400) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3];
        
        p.y -= PUSH_UP_HEIGHT;
        footView.center = p;
        
        [UIView commitAnimations];
        
        [self showUpExpressionKB];
        
        return;
    }
    
    if ([textFieldRounded isFirstResponder]) {
        [self showUpExpressionKB];
        [textFieldRounded resignFirstResponder];
    } else {
        [textFieldRounded becomeFirstResponder];
        [self dismissExpressionKB];
    }
}

- (void)sendButtonAction:(id)sender
{
    empty.text = @"";
    empty2.text = @"";
    
    if (textFieldRounded.text && [textFieldRounded.text length] <= 0) {
        return;
    }
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];

    
    //Your messages sent here
    
        MessageItem *myMsg = [[[MessageItem alloc] initWithMessage:textFieldRounded.text date:nowDate isMe:YES] autorelease];
        
        [pubnub publish:[NSDictionary dictionaryWithObjectsAndKeys:channel2,@"channel",textFieldRounded.text,@"message", nil]];
        
        [self.chatDelegate messageRecieved:myMsg];
    
 
    
    
    textFieldRounded.text = @"";
}


- (IBAction)expressionChoosed:(id)sender
{
    NSLog(@"expressionChoosed");
    
    int index = ((UIButton *)sender).tag;
    
    NSString *expString = [NSString stringWithFormat:@"[expression %d]", index];
    if (textFieldRounded.text == nil) {
        textFieldRounded.text = @"";
    }
    textFieldRounded.text = [textFieldRounded.text stringByAppendingString:expString];
}



- (void)dismissExpressionKB
{
    CGPoint p = expKB.center;
    
    if (p.y > 450) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:PUSH_DOWN_KB_DURATION];
    
    p.y += PUSH_UP_HEIGHT;
    expKB.center = p;
    
    [UIView commitAnimations];

}

- (void)showUpExpressionKB
{
    CGPoint p = expKB.center;
    
    if (p.y < 450) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:PUSH_UP_KB_DURATION];
    
    p.y -= PUSH_UP_HEIGHT;
    expKB.center = p;
    
    [UIView commitAnimations];
}

- (void)pushDownFootView
{
    CGPoint p = footView.center;
    
    if (p.y > 400) {
        return;
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:PUSH_DOWN_FOOT_VIEW_DURATION];
    //
    p.y += PUSH_UP_HEIGHT;
    footView.center = p;
    //
    CGRect rect = tableView.frame;
    rect.size.height = rect.size.height + PUSH_UP_HEIGHT;
    tableView.frame = rect;
    
    NSLog(@"rect = %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    [UIView commitAnimations];
    
}

- (void)pushUpFootView
{    
    CGPoint p = footView.center;
    
    if (p.y < 400) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:PUSH_UP_FOOT_VIEW_DURATION];
    //
    p.y -= PUSH_UP_HEIGHT;
    footView.center = p;
    //
    CGRect rect = tableView.frame;
    rect.size.height = rect.size.height - PUSH_UP_HEIGHT;
    tableView.frame = rect;
    
    NSLog(@"rect = %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    [UIView commitAnimations];

}

#define kLeftMargin				43.0 + 4
#define kTopMargin				8.0
#define kRightMargin			8.0
#define kTweenMargin			8.0

#define kTextFieldHeight		30.0
#define kTextFieldWidth         320.0 - 43 - 76 - 8

- (UITextField *)textFieldRounded
{
	if (textFieldRounded == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin-45, 6.5, kTextFieldWidth+42, kTextFieldHeight);
		textFieldRounded = [[UITextField alloc] initWithFrame:frame];
		
		textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		textFieldRounded.textColor = [UIColor blackColor];
		textFieldRounded.font = [UIFont systemFontOfSize:17.0];
		//textFieldRounded.placeholder = @"<enter text>";
		textFieldRounded.backgroundColor = [UIColor whiteColor];
		textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		textFieldRounded.keyboardType = UIKeyboardTypeDefault;
		textFieldRounded.returnKeyType = 0;
        
		
		textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[textFieldRounded setAccessibilityLabel:NSLocalizedString(@"RoundedTextField", @"")];
	}
	return textFieldRounded;
}



- (UITextView *)textViewRounded
{
	if (textViewRounded == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, 6.5, kTextFieldWidth, kTextFieldHeight);
		textViewRounded = [[UITextView alloc] initWithFrame:frame];
		
		textViewRounded.inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input.png"]];
		textViewRounded.textColor = [UIColor whiteColor];
		textViewRounded.font = [UIFont systemFontOfSize:17.0];
		textViewRounded.backgroundColor = [UIColor grayColor];
		textViewRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		textViewRounded.keyboardType = UIKeyboardTypeDefault;
		textViewRounded.returnKeyType = UIReturnKeyDone;
		
		//textViewRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[textViewRounded setAccessibilityLabel:NSLocalizedString(@"RoundedTextField", @"")];
	}
	return textViewRounded;
}



#pragma mark -
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self pushUpFootView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField;           
// became first responder
{
    [self pushUpFootView];
    
    [tableView scrollToBottom];
}

- (void)textFieldDidEndEditing:(UITextField *)textField             
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    
}

#pragma -
- (void)shouldDismissKeyboard
{
    if ([textFieldRounded isFirstResponder]) {
        [textFieldRounded resignFirstResponder];
    }
    
    [self dismissExpressionKB];
    
    [self pushDownFootView];
    
}




@end
