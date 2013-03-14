//
//  BusinessPickerList.h
//  Rapnet
//
//  Created by NEHA SINGH on 27/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusinessPickerList : UIViewController {

	IBOutlet UITableView *myTable;
	NSMutableArray *arrBusiness;
	UILabel *selectBusinessLbl;
	NSString *strBusiness;
	UITableViewCell *cell;
	NSInteger   _checkboxSelections;
	
}

@property(nonatomic,retain)UILabel *selectBusinessLbl;
@property(nonatomic,retain)NSString *strBusiness;

-(IBAction)backBtn;
@end
