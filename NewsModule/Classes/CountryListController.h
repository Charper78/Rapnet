//
//  CountryListController.h
//  Rapnet
//
//  Created by NEHA SINGH on 27/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCountriesParser.h"
#import "AppDelegate.h"

@interface CountryListController : UIViewController<getCountryDelegate> {
	
	IBOutlet UITableView *myTable;
	GetCountriesParser *objCountryParser;
	NSMutableArray *arrCountry;
	UITableViewCell *cell;
	NSInteger   _checkboxSelections;
	AppDelegate *appDelegate;

}

-(IBAction)backBtn;
-(void)webserviceCallStart;
-(void)webserviceCallFinished;

@end
