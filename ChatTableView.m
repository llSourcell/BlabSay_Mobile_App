//
//  ChatTableView.m
//  ChatDemo
//
//  Created by Charlene Jiang on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatTableView.h"
#import "ChatTableViewCell.h"

@implementation UserProfile

@synthesize userPhoto, userName;

- (id)initWithUserName:(NSString *)name photo:(UIImage *)photo
{
    if (self = [super init]) {
        self.userPhoto = photo;
        self.userName = name;
    }
    return self;
}

@end

@implementation MessageItem

@synthesize isMe, message, messageDate;

- (id)initWithMessage:(NSString *)msg date:(NSDate *)msgDate isMe:(BOOL)value
{
    if (self = [super init]) {
        self.isMe = value;
        self.message = msg;
      //  self.messageDate = msgDate;
        
    }
    
    return self;
}

@end

@implementation ChatTableView

@synthesize me, myFriend, messageItems;
@synthesize chatDelegate;

const NSInteger kViewTag = 1;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code here.
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = [UIColor clearColor];
        self.messageItems = [[NSMutableArray alloc] init];
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        view.delegate = self;
        [self addSubview:view];
        _refreshHeaderView = view;
        [view release];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
    return self;
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 1;
    } 
    
    if (section == 1) {
        if (messageItems) {
            return [messageItems count];
        }
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = [UIColor clearColor];
   // tableView.userInteractionEnabled = NO;
    
    
    UITableViewCell *cell = nil;
	NSUInteger section = [indexPath section];
	if (section == 0)
	{
		static NSString *kCellHistory_ID = @"CellHistory_ID";
        
        cell = [tableView dequeueReusableCellWithIdentifier:kCellHistory_ID];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellHistory_ID] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
      

        }                          
    }

    if (section == 1) {
        MessageItem *msgItem = [self.messageItems objectAtIndex:indexPath.row];
        static NSString *kCellHistory_ID = @"CellHistory_ID";
        if (msgItem.isMe) {
            kCellHistory_ID = @"CellMyMessage_ID";
        } else {
            kCellHistory_ID = @"CellMyFriendMessage_ID";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:kCellHistory_ID];
        if (cell == nil) {
            cell = [[[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellHistory_ID] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (msgItem.isMe) {
                ((ChatTableViewCell *)cell).profile = me;
             
                
            } else {
                ((ChatTableViewCell *)cell).profile = myFriend;
             

            }
        } 
                
        ((ChatTableViewCell *)cell).msg = msgItem;
        
      [(ChatTableViewCell *)cell drawCell];
        
    }
    
    return cell;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    } 
    
    if (indexPath.section == 2) {
        return 50;
    }
    
    if (indexPath.row >= [messageItems count]) {
        return 0;
    }
    
    NSString *theStringToDisplay = ((MessageItem *)[messageItems objectAtIndex:indexPath.row]).message;  
    
    float height = [ChatTableViewCell heightOfCellWithMessage:theStringToDisplay];

    if (height < 66) {
        height = 66;
    }
   
    return height;
}

// Accessories (disclosures). 
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryNone;
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
//// Called after the user changes the selection.
//{
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    
//}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleNone;
}


// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
//{
//    
//}

// Indentation
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//// return 'depth' of row for hierarchies
//{
//    
//}

#pragma mark -
- (void)historyButtonAction:(id)sender
{
    [self.messageItems removeAllObjects];
    [self reloadData];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chatDelegate shouldDismissKeyboard];
}


#pragma -
- (void)messageRecieved:(MessageItem *)msg
{
    if (msg) {
        [messageItems addObject:msg];
        [self reloadData];
    }
    
    if ([messageItems count] == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messageItems count] - 1 inSection:1];
        
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (void)scrollToBottom
{
    if ([messageItems count] == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messageItems count] - 1 inSection:1];
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#define DefaultContentLabelFont 13
#define DefaultContentLabelHeight 
#define DefaultCellSize CGSizeMake(300,40)

- (CGFloat) heightOfContent: (NSString *)content
{

}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}




#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	
	//  model should call this when its done loading
	_reloading = NO;
    
    for (int i = 0; i < 2; i ++) 
    {
        NSDate *oldestDate = [NSDate date];
        if ([messageItems count] > 0) 
        {
            MessageItem *oldestItem = [messageItems objectAtIndex:0];
            oldestDate = oldestItem.messageDate;

        }
        /*
        MessageItem *item = [[MessageItem alloc] initWithMessage:@"Xixi ^_^" date:[oldestDate dateByAddingTimeInterval:-10] isMe:YES];
        
        [messageItems insertObject:item atIndex:0];
        
        item = [[MessageItem alloc] initWithMessage:@"Haha :)" date:[oldestDate dateByAddingTimeInterval:-20] isMe:NO];
        
        [messageItems insertObject:item atIndex:0];
    
    
         */
    }
    [self reloadData];
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	
}



@end
