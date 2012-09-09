//
//  ChatTableViewController.h
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEPubnub.h"


@class MessageItem;
@class ChatTableView;

@protocol ChatTableViewControllerDelegate

- (void)messageRecieved:(MessageItem *)msg;

@end


@protocol ChatTableViewDelegate
@end

@interface ChatTableViewController : UIViewController <CEPubnubDelegate> {
    UIButton        *topButton;
    
    ChatTableView   *tableView;
    UITextField     *textFieldRounded;
    UITextView      *textViewRounded;
    
    UIScrollView    *expKB;
    UIView          *footView;
    
    BOOL            change2ExpressionKB;
    
    id<ChatTableViewControllerDelegate> chatDelegate;
    CEPubnub *pubnub;
    

}

@property (nonatomic, retain) id<ChatTableViewControllerDelegate> chatDelegate;
@property (nonatomic ,assign) NSString * channel2;
@property (nonatomic, retain) CEPubnub *pubnub;
@property (nonatomic, assign) UILabel * empty;
@property (nonatomic, assign) UILabel * empty2;
@property (nonatomic ,assign) NSDate * msgDate;


- (IBAction)expressionChoosed:(id)sender;


//pub nub methods 
- (void) pubnub:(CEPubnub*)pubnub didSucceedPublishingMessageToChannel:(NSString*)channel withResponce: (id)responce;
- (void) pubnub:(CEPubnub*)pubnub didFailPublishingMessageToChannel:(NSString*)channel error:(NSString*)error message:(id)message;  // "error" may be nil
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)message onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)message onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveString:(NSString *)message onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveArray:(NSArray *)message onChannel:(NSString *)channel;
- (void) pubnub:(CEPubnub*)pubnub didFetchHistory:(NSArray*)messages forChannel:(NSString*)channel;
- (void) pubnub:(CEPubnub*)pubnub didFailFetchHistoryOnChannel:(NSString*)channel;
- (void) pubnub:(CEPubnub*)pubnub didReceiveTime:(NSTimeInterval)time;
- (void) pubnub:(CEPubnub*)pubnub ConnectToChannel:(NSString*)channel ;
- (void) pubnub:(CEPubnub*)pubnub DisconnectToChannel:(NSString*)channel ;
- (void) pubnub:(CEPubnub*)pubnub Re_ConnectToChannel:(NSString*)channel ;
- (void)pubnub:(CEPubnub *)pubnub presence:(NSDictionary *)message onChannel:(NSString *)channel;


//passing keyword 
+(void)getString:(NSString*)log;
//passing messages from pubnub
+ (void) getTheMessages:(NSMutableArray*)log;



@end
