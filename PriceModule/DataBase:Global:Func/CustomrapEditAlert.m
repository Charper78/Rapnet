//
//  CustomrapEditAlert.m
//  RapnetPriceModule
//
//  Created by EM Mlab on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomrapEditAlert.h"

@implementation CustomrapEditAlert

@synthesize delegate,addBtn,cancelBtn,valText;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    value = 0;
    valText.text = [NSString stringWithFormat:@"%d%%",value];
}

-(IBAction)plusBtn:(id)sender{
    value++;
    valText.text = [NSString stringWithFormat:@"%d%%",value];
}

-(IBAction)minusBtn:(id)sender{
    value--;
    valText.text = [NSString stringWithFormat:@"%d%%",value];
}

-(IBAction)addBtn:(id)sender
{
    value = [valText.text intValue];
	self.view.hidden =YES;
    [delegate alertrapEditFinished:1:value];
    
}



-(IBAction)cancelBtn:(id)sender
{
    value = 0;
	self.view.hidden =YES;
    [delegate alertrapEditFinished:2:value];
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
