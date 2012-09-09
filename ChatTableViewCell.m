//
//  ChatTableViewCell.m
//  ChatDemo
//
//  Created by Charlene Jiang on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface UITextView (Chat)

- (BOOL)canBecomeFirstResponder;

@end


@implementation UITextView (Chat)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}


@end



@implementation ChatTableViewCell

#define DATE_LABEL_TAG      300
#define IMAGE_BUTTON_TAG    301
#define BUBBLE_VIEW_TAG     302
#define BUBBLE_IMAGE_VIEW_TAG     303
#define BUBBLE_LABEL_TAG     304


#define LEFT_CAP_HEIGHT 14
#define TOP_CAP_HEIGHT 25

@synthesize profile, msg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        /*
        UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
         */
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)drawCell
{
   self.userInteractionEnabled=NO;
    
    UILabel *dateLabel = [self viewWithTag:DATE_LABEL_TAG];
    
    if (dateLabel == nil) {
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8, 2, 70, 10)] autorelease];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:10];
        dateLabel.tag = DATE_LABEL_TAG;
        [self addSubview:dateLabel];
        
        if (msg.isMe) {
            CGRect rect = dateLabel.frame;
            rect.origin.x = 320 - dateLabel.frame.size.width - 8;
            dateLabel.frame = rect;
        }
    } 

    //
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd hh:mm:ss"];
    dateLabel.text = [formatter stringFromDate:msg.messageDate];
    [formatter release];
    
    //
    UIButton *imgButton = [self viewWithTag:IMAGE_BUTTON_TAG];    
    
    if (imgButton == nil) {
        imgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        imgButton.frame = CGRectMake(8, 14, 50, 50); 
        [imgButton setBackgroundImage:profile.userPhoto forState:UIControlStateNormal];  
        [imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        imgButton.tag = IMAGE_BUTTON_TAG;
        [self addSubview:imgButton];
        
        if (msg.isMe) {
            CGRect rect = imgButton.frame;
            rect.origin.x = 320 - imgButton.frame.size.width - 8;
            imgButton.frame = rect;
        }
    } 
    
    UIView *bubbleView = [self viewWithTag:BUBBLE_VIEW_TAG];
    
    if (bubbleView == nil) {
        bubbleView = [[UIView alloc] initWithFrame:CGRectZero];
        bubbleView.backgroundColor = [UIColor clearColor];
        
        //
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg.isMe?@"popo_02":@"popo_01" ofType:@"gif"]];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:LEFT_CAP_HEIGHT topCapHeight:TOP_CAP_HEIGHT]];
        bubbleImageView.tag = BUBBLE_IMAGE_VIEW_TAG;
        bubbleImageView.backgroundColor = [UIColor clearColor];
        [bubbleView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        //
        UITextView *bubbleText = [[UITextView alloc] initWithFrame:CGRectMake(12, 4, 150, 50)];
        bubbleText.backgroundColor = [UIColor clearColor];
        bubbleText.font = [UIFont systemFontOfSize:14];
        bubbleText.textColor = [UIColor blackColor];
        bubbleText.scrollEnabled = NO;
        bubbleText.editable = NO;
        bubbleText.delegate = self;
        bubbleText.tag = BUBBLE_LABEL_TAG;
        [bubbleView addSubview:bubbleText];
        [bubbleText release];
        
        //
        bubbleView.tag = BUBBLE_VIEW_TAG;
        [self addSubview:bubbleView];

    } 
        
    //
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [msg.message sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    
    //
    UITextView *bubbleText = (UITextView *)[bubbleView viewWithTag:BUBBLE_LABEL_TAG];
    if (msg.isMe) {
        bubbleText.frame = CGRectMake(2, 1, size.width + 20, size.height + 20);
    } else {
        bubbleText.frame = CGRectMake(10, 1, size.width + 20, size.height + 20);
    }
    bubbleText.text = msg.message;
    
    //
    CGFloat imageWidth = bubbleText.frame.size.width + 12;
    CGFloat imageHeight = bubbleText.frame.size.height + 2;
    UIImageView *bubbleImageView = (UIImageView *)[bubbleView viewWithTag:BUBBLE_IMAGE_VIEW_TAG];
    bubbleImageView.frame = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
    
    //
    if(msg.isMe) {
        
        bubbleView.frame = CGRectMake(320.0f - imageWidth - 60.0f, 14.0f, imageWidth, imageHeight);
    } else {
        bubbleView.frame = CGRectMake(60.0f, 14.0f, imageWidth, imageHeight);
    }
}

- (void)imgButtonAction:(id)sender
{
   
    NSLog(@"imgButtonAction");
}


+ (float)heightOfCellWithMessage:(NSString *) message
{
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [message sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];

    return size.height + 20 + 2 + 16;
}

//
//- (void)textViewDidChangeSelection:(UITextView *)textView
//{
//    NSLog(@"textViewDidChangeSelection");
//}
//
//- (void)selectionWillChange:(id <UITextInput>)textInput
//{
//    NSLog(@"selectionWillChange");
//}
@end
