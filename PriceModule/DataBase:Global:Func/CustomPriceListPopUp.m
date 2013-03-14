//
//  CustomPriceListPopUp.m
//  Rapnet
//
//  Created by Nikhil Bansal on 04/03/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "CustomPriceListPopUp.h"

@implementation CustomPriceListPopUp

@synthesize oldBtn,msgLbl,delegate,cancelBtn;
@synthesize rapAvgDLbl,rapAvgDCLbl,rapAvgPLbll,rapBestDLbl,rapBestPLbl,rapListDLbl,rapListPlbl,rapBestDCLbl;

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
    [rapListDLbl release];
    [rapAvgDCLbl release];
    [rapAvgDLbl release];
    [rapAvgPLbl release];
    [rapBestDCLbl release];
    [rapBestDLbl release];
    [rapBestPLbl release];
    [rapListPlbl release];
    [msgLbl release];
	[oldBtn release];
	[cancelBtn release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)oldBtn:(id)sender{
    
    self.view.hidden =YES;
    [delegate alertPriceListFinished:1];
}

-(IBAction)cancelBtn:(id)sender{
    self.view.hidden =YES;
    [delegate alertPriceListFinished:2];
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
