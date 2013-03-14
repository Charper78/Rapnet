//
//  CountryListController.m
//  Rapnet
//
//  Created by NEHA SINGH on 27/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "CountryListController.h"
#import "StoredData.h"
@implementation CountryListController


-(void)viewDidLoad 
{
    [super viewDidLoad];
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate showActivityIndicator:self];
	[self webserviceCallStart];
	_checkboxSelections=-1;
	myTable.separatorColor=[UIColor clearColor];
}

-(IBAction)backBtn
{
	[[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrCountry count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];	
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size: 16];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	UILabel *countryLbl=[[UILabel alloc]init];
    countryLbl.frame=CGRectMake(10.0, 10.0, 300.0, 30.0);
	countryLbl.font=[UIFont fontWithName:@"Georgia" size:14];
	countryLbl.backgroundColor=[UIColor clearColor]; 
	countryLbl.textColor=[UIColor colorWithRed:101/255.f
										 green:101/255.f
										  blue:101/255.f    
										 alpha:1];
	countryLbl.text=[NSString stringWithFormat:@"%@",[[arrCountry objectAtIndex:indexPath.row]objectForKey:@"CountryName"]];
	countryLbl.opaque = NO;
	[cell.contentView addSubview:countryLbl];
    [countryLbl release];
	
	UIImageView *divImage=[[UIImageView alloc]initWithFrame:CGRectMake(5.0,0.0,310,1)];
	[divImage setImage:[UIImage imageNamed:@"divider.png"]];
	[cell.contentView addSubview:divImage];
    [divImage release];
	
	if (indexPath.row == _checkboxSelections) cell.accessoryType = UITableViewCellAccessoryCheckmark;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	_checkboxSelections = indexPath.row;
	[tableView reloadData];
	
	UIView *cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310,42)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	
	
	[StoredData sharedData].strCountryName= [NSString stringWithFormat:@"%@",[[arrCountry objectAtIndex:indexPath.row]objectForKey:@"CountryName"]];
	[StoredData sharedData].countryID = [NSString stringWithFormat:@"%@",[[arrCountry objectAtIndex:indexPath.row]objectForKey:@"CountryID"]];
	[StoredData sharedData].countryPhoneCode= [NSString stringWithFormat:@"%@",[[arrCountry objectAtIndex:indexPath.row]objectForKey:@"CountryPhoneCode"]];
}
	
-(void)webserviceCallStart
{	
	objCountryParser=[[GetCountriesParser alloc]init];
	objCountryParser.delegate = self;
	[objCountryParser GetCountryName];
}

-(void)webserviceCallFinished
{
	arrCountry = [objCountryParser getResults];
	[myTable reloadData];
	[appDelegate stopActivityIndicator:self];
    
    //NSLog(@"%@",arrCountry);
    
    for (NSInteger i =0; i<[arrCountry count]; i++) {
        NSInteger cid = [[[arrCountry objectAtIndex:i]objectForKey:@"CountryID"]intValue];
        //NSLog(@"C=%d",cid);
        //NSLog(@"Cjkk=%@",[StoredData sharedData].countryID);
        if (cid==[[StoredData sharedData].countryID intValue]) {
            _checkboxSelections = i;
        }
    }
    
    [myTable reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_checkboxSelections inSection:0];
    
    UIView *cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310,42)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[myTable cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
}


/*
//Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[arrCountry release];
	[objCountryParser release];
    [super dealloc];
}


@end
