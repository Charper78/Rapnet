//
//  RegisterViewController.m
//  Rapnet
//
//  Created by Richa on 6/6/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterDetailsViewController.h"
#import "CountryListController.h"
#import "funcClass.h"

@implementation RegisterViewController

-(void)viewDidLoad 
{
    [super viewDidLoad];
	[imgCountry setImage:[UIImage imageNamed:@"countryDark.png"]];
	[StoredData sharedData].strCountryName=nil;
}

-(IBAction)bckBtn
{
  [[self navigationController] popViewControllerAnimated:YES];
		
}

-(IBAction)joinBtn
{
	if([lblCountry.text length]==0) 
	{
		[funcClass showAlertView:@"Please choose a country first " message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

	}
	else
	{
		RegisterDetailsViewController *details =[[RegisterDetailsViewController alloc]initWithNibName:@"RegisterDetailsViewController" bundle:nil];
		[[self navigationController] pushViewController:details animated:YES];
		[details release];
		details=nil;
	}
}


-(IBAction)countryList
{
	CountryListController *objCountryList =[[CountryListController alloc]initWithNibName:@"CountryListController" bundle:nil];
	[[self navigationController] pushViewController:objCountryList animated:YES];
	[objCountryList release];
	objCountryList=nil;
}


/*-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}*/

-(void)viewWillAppear:(BOOL)animated
{
	txtCountry.text=[StoredData sharedData].strCountryName;
	if(![[StoredData sharedData].strCountryName length]==0){
		[imgCountry setImage:[UIImage imageNamed:@"blankField.png"]];
		[imgSignUp setImage:[UIImage imageNamed:@"signUpDark.png"]];
		lblCountry.text=[StoredData sharedData].strCountryName;
		}
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)dealloc
{
    [super dealloc];
}


@end
