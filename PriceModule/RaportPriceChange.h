//
//  RaportPriceChange.h
//  RapnetPriceModule
//
//  Created by Deepak Pathak on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetPriceChangeParser.h"
#import "LoginPriceParser.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "CustomAlertViewController.h"
#import "GetPriceListChangeDate.h"

@interface RaportPriceChange : UIViewController<UITableViewDelegate,UITableViewDataSource,getPriceChangeDelegate,getAuthTicketDelegate> {
    IBOutlet UIButton *roundShapeBtn,*pearShapeBtn;
    UITableView *roundShapeTableView,*pearShapeTableView;
    IBOutlet UIImageView *toolBar;
    IBOutlet UILabel *caratLbl,*clrLbl,*clrtLbl,*dateFromLbl,*dateToLbl,*dollarLbl,*percLbl;
    IBOutlet UILabel *infoLbl;
   
    LoginPriceParser *objLoginParser;
    GetPriceChangeParser *objPriceChangeParser;
    
    AppDelegate *appDelegate;
    NSString *strTicket,*roundFromDate,*roundToDate, *pearFromDate, *pearToDate;
    
    NSMutableArray *arrPriceChange[2];
    
    NSInteger shapeTypeFlag;
    
    CustomAlertViewController *customAlert1;
    UIView *view;
    
    Reachability* hostReach;
    BOOL isReachable;
}

-(IBAction)roundShapeBtnClicked:(id)sender;
-(IBAction)pearShapeBtnClicked:(id)sender;

-(void)loadDataInTable;
-(void)webserviceCallPriceChangeFinished:(NSMutableArray *)results;
-(void)webserviceCallLoginFinished;

-(void)initialDelayEnded;

@end
