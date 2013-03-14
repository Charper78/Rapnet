//
//  BusinessPickerList.m
//  Rapnet
//
//  Created by NEHA SINGH on 27/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "BusinessPickerList.h"
#import "StoredData.h"

@implementation BusinessPickerList
@synthesize selectBusinessLbl,strBusiness;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	_checkboxSelections=-1;
	
	arrBusiness = [[NSMutableArray alloc] init];
	[arrBusiness addObject:@"APPRAISER"];
	[arrBusiness addObject:@"DIAMOND CUTTER"];
	[arrBusiness addObject:@"DIAMOND DEALER"];
	[arrBusiness addObject:@"DIAMOND MANUFACTURER"];
	[arrBusiness addObject:@"FINDINGS"];
	[arrBusiness addObject:@"INVESTMENT"];
	[arrBusiness addObject:@"JEWELRY MANUFACTURER"];
	[arrBusiness addObject:@"MAGAZINE"];
	[arrBusiness addObject:@"MINING COMPANY"];
	[arrBusiness addObject:@"OTHER"];
	[arrBusiness addObject:@"PRIVATE"];
	[arrBusiness addObject:@"REFINER"];
	[arrBusiness addObject:@"RETAILER"];
	[arrBusiness addObject:@"ROUGH DEALER"];
	[arrBusiness addObject:@"SERVICES"];
	[arrBusiness addObject:@"WATCH DEALER"];
	[arrBusiness addObject:@"WHOLESALER"];
    
    
    for (NSInteger i =0; i<[arrBusiness count]; i++) {
        NSString *cid = [arrBusiness objectAtIndex:i];
        NSLog(@"%@",cid);
        NSLog(@"%@",[StoredData sharedData].strName);
        if ([cid isEqual:[StoredData sharedData].strName]) {
            _checkboxSelections = i;
        }
    }
    
    NSLog(@"%d",_checkboxSelections);
    
    [myTable reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_checkboxSelections inSection:0];
    
    UIView *cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310,42)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[myTable cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
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
	return [arrBusiness count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];	
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size: 16];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *businessLbl=[[UILabel alloc]init];
    businessLbl.frame=CGRectMake(10.0, 10.0, 300.0, 30.0);
	businessLbl.font=[UIFont fontWithName:@"Georgia" size:14];
	businessLbl.backgroundColor=[UIColor clearColor]; 
	businessLbl.textColor=[UIColor colorWithRed:101/255.f
										 green:101/255.f
										  blue:101/255.f    
										 alpha:1];
	//businessLbl.textColor=[UIColor grayColor];
	businessLbl.text=[NSString stringWithFormat:@"%@",[arrBusiness objectAtIndex:indexPath.row]];
	businessLbl.opaque = NO;
	[cell.contentView addSubview:businessLbl];
    [businessLbl release];
	
	
	if (indexPath.row == _checkboxSelections) cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	UIImageView *divImage=[[UIImageView alloc]initWithFrame:CGRectMake(5.0,0.0,310,1)];
	[divImage setImage:[UIImage imageNamed:@"divider.png"]];
	[cell.contentView addSubview:divImage];
    [divImage release];
	
	return cell;
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	
} 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	_checkboxSelections = indexPath.row;
	[tableView reloadData];
	
	UIView *cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310,42)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	
	
	[StoredData sharedData].strName=[NSString stringWithFormat:@"%@",[arrBusiness objectAtIndex:indexPath.row]];
	if([[StoredData sharedData].strName isEqual:@"APPRAISER"]){
		[StoredData sharedData].strBusinessName =@"APPRAISER";}
	else if([[StoredData sharedData].strName isEqual:@"DIAMOND CUTTER"]){
	    [StoredData sharedData].strBusinessName =@"DIAMOND_CUTTER";}
	else if ([[StoredData sharedData].strName isEqual:@"DIAMOND DEALER"]){
	    [StoredData sharedData].strBusinessName =@"DIAMOND_DEALER";}
	else if ([[StoredData sharedData].strName isEqual:@"DIAMOND MANUFACTURER"]){
	    [StoredData sharedData].strBusinessName =@"DIAMOND_MANUFACTURER";}
	else if ([[StoredData sharedData].strName isEqual:@"FINDINGS"]){
	    [StoredData sharedData].strBusinessName =@"FINDINGS";}
	else if ([[StoredData sharedData].strName isEqual:@"INVESTMENT"]){
	    [StoredData sharedData].strBusinessName =@"INVESTMENT";}
	else if ([[StoredData sharedData].strName isEqual:@"JEWELRY MANUFACTURER"]){
	    [StoredData sharedData].strBusinessName =@"JEWELRY_MANUFACTURER";}
	else if ([[StoredData sharedData].strName isEqual:@"MAGAZINE"]){
	    [StoredData sharedData].strBusinessName =@"MAGAZINE";}
	else if ([[StoredData sharedData].strName isEqual:@"MINING COMPANY"]){
	    [StoredData sharedData].strBusinessName =@"MINING_COMPANY";}
	else if ([[StoredData sharedData].strName isEqual:@"OTHER"]){
	    [StoredData sharedData].strBusinessName =@"OTHER";}
	else if ([[StoredData sharedData].strName isEqual:@"PRIVATE"]){
	    [StoredData sharedData].strBusinessName =@"PRIVATE";}
	else if ([[StoredData sharedData].strName isEqual:@"REFINER"]){
	    [StoredData sharedData].strBusinessName =@"REFINER";}
	else if ([[StoredData sharedData].strName isEqual:@"RETAILER"]){
	    [StoredData sharedData].strBusinessName =@"RETAILER";}
	else if ([[StoredData sharedData].strName isEqual:@"ROUGH DEALER"]){
	    [StoredData sharedData].strBusinessName =@"ROUGH_DEALER";}
	else if ([[StoredData sharedData].strName isEqual:@"SERVICES"]){
	    [StoredData sharedData].strBusinessName =@"SERVICES";}
	else if ([[StoredData sharedData].strName isEqual:@"WATCH DEALER"]){
	    [StoredData sharedData].strBusinessName =@"WATCH_DEALER";}
	else if ([[StoredData sharedData].strName isEqual:@"WHOLESALER"]){
	    [StoredData sharedData].strBusinessName =@"WHOLESALER";}
	
	//NSLog(@"strBusinessName%@",[StoredData sharedData].strBusinessName);
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[arrBusiness release];
	[selectBusinessLbl release];
	[strBusiness release];

}


@end
