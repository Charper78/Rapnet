//
//  CustomSaveExistListAlert.m
//  RapnetPriceModule
//
//  Created by EM Mlab on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomSaveExistListAlert.h"

@implementation CustomSaveExistListAlert

@synthesize delegate,addBtn,cancelBtn,newBtn;

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

- (void)dealloc
{
    [newBtn release];
	[addBtn release];
	[cancelBtn release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [Database fetchDiamonds:[Database getDBPath]];
    if ([[StoredData sharedData].dbSavedDiamondsArr count]>0) {
        addBtn.enabled=YES;
    } 
    else{
        addBtn.enabled=NO;
    }
    
    
}

-(IBAction)addBtn:(id)sender{
    [delegate alertSaveExistListFinished:1];
}

-(IBAction)cancelBtn:(id)sender{
    [delegate alertSaveExistListFinished:3];
}

-(IBAction)newBtn:(id)sender{
    [delegate alertSaveExistListFinished:2];
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
