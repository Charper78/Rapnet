//
//  CustomOpenAlertView.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 04/12/11.
//  Copyright (c) 2011 coolban@gmail.com. All rights reserved.
//

#import "CustomOpenAlertView.h"

@implementation CustomOpenAlertView

@synthesize oldBtn,currentBtn,msgLbl,delegate,cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [msgLbl release];
	[oldBtn release];
	[currentBtn release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // [idDiamond becomeFirstResponder];
}

-(IBAction)oldBtn:(id)sender{
    
    self.view.hidden =YES;
    [delegate alertOpenFinished:1];
}

-(IBAction)currentBtn:(id)sender{
    self.view.hidden =YES;
    [delegate alertOpenFinished:2];
}

-(IBAction)cancelBtn:(id)sender{
    self.view.hidden =YES;
    [delegate alertOpenFinished:3];
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

@end
