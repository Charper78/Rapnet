//
//  MoreViewDetailC.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesParser.h"
#import "AppDelegate.h"
#import "NewsCustomCell.h"
@class CustomAlertViewController;


@interface MoreViewDetailC : UIViewController <UITableViewDelegate,UITableViewDataSource,getAllArticlesDelegate,UINavigationControllerDelegate>

{
	IBOutlet UITableView *myTable;
	IBOutlet UILabel *lblTitle;
	
	CustomAlertViewController *customAlert;
	NSMutableArray *arrMoreTopicDetail;
	NSMutableArray *imagesArray;
	NSString *topicID;
	NSString *strTitle;
	
	ArticlesParser *objArticleParser;
	NewsCustomCell* customCell;
	AppDelegate*appDelegate;
	
	NSDateFormatter *inputFormatter;
	NSDateFormatter *outputFormatter;
	
	//for pagination
	
	BOOL ALTERNATE;
	BOOL isTrue;
	int count;
	NSInteger totalPages;
	NSInteger txtPageNo;
	NSMutableArray* arrpageNo;
}

-(void)initialDelayEnded;
-(void)webserviceCallStart;
-(void)showAlertView;
-(IBAction)backButtonClicked;
-(void)setDataForDetailsView:(NSDictionary*)data;
-(NSString*)convertDateFormat:(NSString*)dateString;

@property(nonatomic,retain)IBOutlet NSString *topicID;
@property(nonatomic,retain)IBOutlet NSString *strTitle;
@property(nonatomic,retain)IBOutlet NewsCustomCell* customCell;

@end
