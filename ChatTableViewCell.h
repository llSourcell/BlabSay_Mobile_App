//
//  ChatTableViewCell.h
//  ChatDemo
//
//  Created by Charlene Jiang on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableView.h"

@interface ChatTableViewCell : UITableViewCell <UITextInputDelegate> {
    UserProfile *profile;
    MessageItem *msg;
}

@property (nonatomic, retain) UserProfile *profile;
@property (nonatomic, retain) MessageItem *msg;

- (void)drawCell;
+ (CGFloat)heightOfCellWithMessage:(NSString *) message;

@end
