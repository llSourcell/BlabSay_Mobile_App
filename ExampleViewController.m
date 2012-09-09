//
//  ExampleViewController.m
//  ChatDemo
//
//  Created by User on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExampleViewController.h"
#import "ChatDemoViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    topButton.frame = CGRectMake(0, 0, 320, 50);
    [topButton setBackgroundImage:[UIImage imageNamed:@"profile3.png"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
    


    
}

- (void)topButtonAction:(id)sender
{
    
    ChatDemoViewController *search = [[ChatDemoViewController alloc] init];
    [self presentViewController:search animated:YES completion:NULL];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
