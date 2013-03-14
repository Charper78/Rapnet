//
//  CustomUpdatePriceListALert.m
//  Rapnet
//
//  Created by Nikhil Bansal on 04/04/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "CustomUpdatePriceListALert.h"

@implementation CustomUpdatePriceListALert

@synthesize delegate,yesBtn,noBtn,msgLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [msgLbl release];
	[yesBtn release];
	[noBtn release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)yesBtn:(id)sender{
    
    self.view.hidden =YES;
    [delegate alertUpdatePriceListFinished:1];
}

-(IBAction)noBtn:(id)sender{
    self.view.hidden =YES;
    [delegate alertUpdatePriceListFinished:2];
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
