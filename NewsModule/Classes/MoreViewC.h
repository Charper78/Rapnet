//
//  MoreViewC.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MoreViewDetailC.h"
#import "NewsTopicParser.h"
#import "NewsCustomCell.h"
#import "Reachability.h"
#import "Functions.h"

@interface MoreViewC : UIViewController<UITableViewDelegate,UITableViewDataSource,getNewsTopicDelegate>
{
	IBOutlet UITableView *objTable;	
	NewsTopicParser *objTopicParser;
	NSMutableArray *arrNewsTopic;
	AppDelegate*appDelegate;
	MoreViewDetailC *objMoreV;
	NewsCustomCell* customCell;
    Reachability *hostReach;
    BOOL isReachable;
    int countReachUpdate;
}

-(void)webserviceCallStart;
@property(nonatomic,retain)IBOutlet UITableView *objTable;
@property(nonatomic,retain)IBOutlet NewsCustomCell* customCell;

@end

