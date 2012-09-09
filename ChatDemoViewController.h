//
//  ChatDemoViewController.h
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewController.h"
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>





@interface ChatDemoViewController : UIViewController {
    IBOutlet UIButton *slideButton;
    IBOutlet UIButton *chatButton;
    IBOutlet UIButton *photoButton;
    
    //OG blabsay
    UITextField *searchField;
    UIButton *examplesButton;

    
    ChatTableViewController *chatController;
    NSString *keyword;
    
    IBOutlet UILabel *username;
    IBOutlet UIImageView *cell;
    
}
@property (nonatomic, retain) IBOutlet UIImageView *cell;
@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UIButton *slideButton;
@property (nonatomic, retain) IBOutlet UIButton *chatButton;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIButton *examplesButton;
@property (nonatomic, copy) NSString *keyword;




- (IBAction)slideButtonAction:(id)sender;
- (IBAction)chatButtonAction:(id)sender;
- (IBAction)photoButtonAction:(id)sender;

- (IBAction) search; 

- (IBAction) examples; 

- (void)getUsername:(NSString*)log;
- (void)getId:(NSString*)log;
- (void)getAccessKey:(NSString*)log;



@end


//2 Protocols for posting to Facebook ticker 

@protocol BlabTopic<FBGraphObject>

@property (retain, nonatomic) NSString  *id;
@property (retain, nonatomic) NSString  *url;

@end

@protocol BlabAction<FBOpenGraphAction>

@property (retain, nonatomic) id<BlabTopic> topic;

@end
