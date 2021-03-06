//
//  NewsViewController.h
//  Rapnet
//
//  Created by Saurabh Verma on 12/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "NewsDetailViewController.h"
#import "NewsCustomCell.h"
#import "MoreViewC.h"
#import "ArticlesParser.h"
#import "VideosParser.h"
#import "MostViewedParser.h"
#import "AppDelegate.h"
#import "SearchParser.h"
#import "GetEditorParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import "AnalyticHelper.h"

@class ActivityAlertView;
@class ObjSavedArticles;
@class CustomAlertViewController;

@interface NewsViewController : UIViewController<UITextFieldDelegate,EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource,getAllArticlesDelegate,getVideosDelegate,getEditorDelegate,mostViewedDelegate,searchDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
	CustomAlertViewController *customAlert;
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	EGORefreshTableHeaderView *_refreshHeaderView;
	NewsDetailViewController* newsDetailViewController;
	AppDelegate *appDelegate;
	ActivityAlertView* activityAlert;
	
	ArticlesParser *objArticleParser;
	VideosParser *objVideoParser;
	MostViewedParser *objViewedParser;
	SearchParser *objSearchParser;
	ObjSavedArticles *mySavedArticles;
	GetEditorParser *objEditorParser;
	NSIndexPath *selectedIndexPath;
	
	IBOutlet UITableView* myTableView;
	IBOutlet UIScrollView* myScrollView;
	IBOutlet UIImageView* leftArrowImageView;
	IBOutlet UIImageView* rightArrowImageView;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UIView *searchView;
	IBOutlet UIView *savedView;
	
	
	IBOutlet UIImageView *tabNews;
	IBOutlet UIImageView *tabVideos;
	IBOutlet UIImageView *tabSaved;
	IBOutlet UIImageView *tabSearch;
	IBOutlet UIImageView *tabPopular;
	IBOutlet UIImageView *tabMore;
	
	UIActivityIndicatorView *activityView;
	MPMoviePlayerController *movPlay;
	
	NSMutableArray *arrAllArticles;
	NSMutableArray *arrAllVideos;
	NSMutableArray *arrMostViewed;
	NSMutableArray *arrSearchResults;
	NSMutableArray *arrEditorArticle;
	
	NSMutableArray *imagesArray;
	NSMutableArray *videoImagesArray;
	NSMutableArray *searchImagesArray;
	NSMutableArray *savedImagesArray;
	NSMutableArray *viewedImagesArray;
	NSMutableArray *editorImagesArray;
	
	NSDateFormatter *inputFormatter;
	NSDateFormatter *outputFormatter;

	NSString *strSearch;
	NSString *strVideo;
	NewsCustomCell*cell;
	MoreViewC *moreViewC;
	NSInteger alertChk;

	BOOL _reloading;
	BOOL rightHide;
	BOOL leftHide;
	BOOL ALTERNATE;
	BOOL isTrue;
	
	//for pagination
	NSInteger txtPageNo;
	NSInteger totalPages;
	NSMutableArray* arrpageNo;
	int count;
    Reachability *hostReach;
    BOOL isReachable, isFirstTime;
    int countReachUpdate;
}

@property(nonatomic, retain)UITableView* myTableView;
@property(nonatomic, retain)NSArray *activitiesArray;
@property(nonatomic, retain)NSString *strSearch;
@property(nonatomic, retain)NSString *strVideo;
@property(nonatomic, retain)ObjSavedArticles *mySavedArticles;
@property(nonatomic, retain)IBOutlet NewsCustomCell* customCell;
@property(nonatomic, retain)UISwipeGestureRecognizer *swipeLeftRecognizer;

-(NSString*)convertDateFormat:(NSString*)dateString;
-(void)webserviceCallStart;
-(void)createScreenComponents;
-(void)downloadImages;
-(void)callMoreService;
-(void)navigateDetailScreen;
-(void)resizeCell;
-(void)showAlertView;
-(void)initialDelayEnded;

-(IBAction)goToSetting;
-(IBAction)moreButtonClick:(id)sender;
-(IBAction)videoButtonClick:(id)sender;
-(IBAction)mostViewedButtonClick:(id)sender;
-(IBAction)searchButtonClick:(id)sender;
-(IBAction)newsCategoryButtonClicked:(id)sender;
-(IBAction)savedButtonClick:(id)sender;
-(IBAction)scrollForward:(id)sender;
-(IBAction)scrollBackward:(id)sender;

@end


