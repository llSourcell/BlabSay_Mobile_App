//
//  ChatTableView.h
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface UserProfile : NSObject {
@private
    UIImage     *userPhoto;
    NSString    *userName;
}

@property (nonatomic, retain) UIImage *userPhoto;
@property (nonatomic, retain) NSString *userName;

- (id)initWithUserName:(NSString *)name photo:(UIImage *)photo;

@end

@interface MessageItem : NSObject {
    BOOL        isMe;
    NSString    *message;
    NSDate      *messageDate;
}

@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDate *messageDate;

- (id)initWithMessage:(NSString *)msg date:(NSDate *)msgDate isMe:(BOOL)value;

@end


@protocol ChatTableViewDelegate <NSObject>

- (void)shouldDismissKeyboard;

@end


@interface ChatTableView : UITableView <UITableViewDelegate, UITableViewDataSource, ChatTableViewControllerDelegate, EGORefreshTableHeaderDelegate> 
{
    NSMutableArray         *messageItems;
    
    UserProfile     *me;
    UserProfile     *myFriend;
    
    EGORefreshTableHeaderView   *_refreshHeaderView;
    BOOL                        _reloading;
    
    id<ChatTableViewDelegate> chatDelegate;
}

@property (nonatomic, retain) NSMutableArray *messageItems;
@property (nonatomic, retain) UserProfile *me;
@property (nonatomic, retain) UserProfile *myFriend;
@property (nonatomic, assign) id<ChatTableViewDelegate> chatDelegate;

- (void)scrollToBottom;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
