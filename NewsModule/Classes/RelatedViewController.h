//
//  RelatedViewController.h
//  Rapnet
//
//  Created by NEHA SINGH on 31/05/11.
//  Copyright 2011 Tech. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RelatedArticleParser.h"
#import "AppDelegate.h"
#import "NewsCustomCell.h"
#import <MediaPlayer/MediaPlayer.h>
@class CustomAlertViewController;


@interface RelatedViewController : UIViewController <getRelArticleDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
	IBOutlet UITableView *myTable;
	IBOutlet UILabel *lblTitle;
	IBOutlet UIView *savedView;
	IBOutlet UILabel *alertLAbel;
	
	
	NSMutableArray *arrRelVideoDetail;
	NSMutableArray *imagesArray;
	NSDateFormatter *inputFormatter;
	NSDateFormatter *outputFormatter;
	NSString *topicID;
	NSString *strVideo;
	CustomAlertViewController *customAlert;
	
	RelatedArticleParser *objArticleParser;
	NewsCustomCell* customCell;
	AppDelegate*appDelegate;
}

-(void)showAlertView;
-(void)initialDelayEnded;
-(void)webserviceCallStart;
-(IBAction)backButtonClicked;
-(NSString*)convertDateFormat:(NSString*)dateString;

@property(nonatomic,retain)IBOutlet NSString *topicID;
@property(nonatomic,retain)IBOutlet NSString *strVideo;
@property(nonatomic,retain)IBOutlet NewsCustomCell* customCell;

@end
