//
//  InnerAlertView.m
//  Rapnet
//
//  Created by NEHA SINGH on 03/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "InnerAlertView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@implementation InnerAlertView
@synthesize msgLbl,joinNowBtn,logInBtn,okBtn;


-(void)viewDidLoad
{
    [super viewDidLoad];
	self.view.frame=CGRectMake(0,150, 320, 140);
}


-(IBAction)joinNowBtn:(id)sender
{
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	RegisterViewController *signUp =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
	[navC pushViewController:signUp animated:YES];
	[signUp release];
	signUp=nil;
}


-(IBAction)logInBtn:(id)sender
{	
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
	[navC pushViewController:login animated:YES];
	[login release];
	login=nil;
}


-(IBAction)okBtn:(id)sender
{
	self.view.hidden =YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc
{
	[msgLbl release];
	[joinNowBtn release];
	[logInBtn release];
	[okBtn release];
    [super dealloc];
}


@end