//
//  NewsDetailViewController.h
//  Rapnet
//
//  Created by Saurabh Verma on 12/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GetArticleParser.h"
#import "GetAuthArticleParser.h"
#import "RelatedViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MediaPlayer/MediaPlayer.h>


@class ObjSavedArticles;
@class OAuthTwitterDemoViewController;
@class InnerAlertView;

@interface NewsDetailViewController : UIViewController<getArticleDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIAlertViewDelegate,getAuthArticleDelegate>
{
	
	InnerAlertView *customAlert;
	IBOutlet UIScrollView *objScrollV;
	IBOutlet UIImageView *imgMain;
	IBOutlet UIImageView *tabBar;
	IBOutlet UIImageView *navBar;
	IBOutlet UIImageView *dotUp;
	IBOutlet UIImageView *dotDown;
	IBOutlet UIImageView *dotBottom;
	IBOutlet UIWebView *descView;
	IBOutlet UIButton *videoView;
	MPMoviePlayerController *movPlay;
	
	IBOutlet UIView *tabView;
	IBOutlet UIView *navView;
	IBOutlet UIView *upGestureView;
	

	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblType;
	IBOutlet UILabel *lblDate;
	IBOutlet UILabel *lblAuthor;
	IBOutlet UILabel *lblDesc;
	IBOutlet UILabel *lblFrmPage;
	IBOutlet UILabel *lblToPage;
	
	IBOutlet UIButton *incfontBttn;
	IBOutlet UIButton *decfontBttn;
	IBOutlet UIButton *goBckBttn;
	IBOutlet UIButton *goFwdBttn;
	IBOutlet UIButton *saveBttn;
	IBOutlet UIButton *deleteBttn;
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *shareButton;
	IBOutlet UIButton *relVideoButton;
	IBOutlet UIButton *relArticleButton;
	
	NSDateFormatter *inputFormatter;
	NSDateFormatter *outputFormatter;
	NSTimer *theTimer;
	NSTimer *aTimer;
	UIAlertView *alert;
	NSInteger chkActnSheet;
	
	NSString *strTitle; 
	NSString *strSubtitle;
	NSString *strType;
	NSString *strDate;
	NSString *strAuthor;
	NSString *strDesc;
	NSString *strImage;
	NSString *strArtileID;
	NSString *strVideo;
	NSString *strhtml;
	NSString *strArticleURL;
	NSString *isAuth;
	
	NSUInteger minFontSize;
	NSUInteger maxFontSize;
	NSMutableArray *arrgetArticle;
	NSMutableArray *arr;
	
	AppDelegate *appDelegate;
	GetArticleParser *getArticleParser;
	OAuthTwitterDemoViewController *tweetViewC;
	RelatedViewController *objRelArticle;
	ObjSavedArticles *objSaved;
	GetAuthArticleParser *getAuthParser;
	UIWindow *window;
	
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	UITapGestureRecognizer *tapRecognizer;

	int selectedRowint;
	BOOL isAlreadySaved;
	BOOL isViewHide;
	BOOL isViewVisible;
	BOOL isCustomAlertVisible;
	CGAffineTransform t;
	CGSize fittingSize;
	
}

-(void)showAlertView;
-(void)initialDelayEnded;
-(void)email;
-(void)setContentView;
-(void)setGestureContent;
-(void)webServiceStart;
-(void)openDialogBox;
-(void)sendInAppSMS;
-(void)displayComposerSheet;
-(void)tweet;
-(void)faceBookClicked;
-(void)positionBackButton;
-(void)slideForward;
-(void)slideBackward;
-(void)fetchSavedDB;
-(void)setDynamicContent;
-(void)removeHTMLTags;
-(void)shareMore;


-(NSString*)convertDateFormat:(NSString*)dateString;
-(IBAction)playVideo:(id)sender;
-(IBAction)videoButtonClicked;
-(IBAction)articleButtonClicked;
-(IBAction)backButtonClicked;
-(IBAction)saveButtonClicked;
-(IBAction)deleteButtonClicked;
-(IBAction)incFontSize:(id)sender;
-(IBAction)decFontSize:(id)sender;
-(IBAction)goBckBttn:(id)sender;
-(IBAction)goFwdBttn:(id)sender;
-(IBAction)shareButtonClick:(id)sender;
-(void)setDataForDetailsView:(NSDictionary*)data;
-(void)setArray:(NSMutableArray *)dataArray;

@property(nonatomic)int selectedRowint;
@property(nonatomic, retain)NSString *strhtml;
@property(nonatomic, retain)NSString *strTitle; 
@property(nonatomic, retain)NSString *strSubtitle;
@property(nonatomic, retain)NSString *strType;
@property(nonatomic, retain)NSString *strDate;
@property(nonatomic, retain)NSString *strAuthor;
@property(nonatomic, retain)NSString *strDesc;
@property(nonatomic, retain)NSString *strImage;
@property(nonatomic, retain)NSString *strArtileID;
@property(nonatomic, retain)NSString *strVideo;
@property(nonatomic, retain)NSString *strArticleURL;
@property(nonatomic, retain)NSString *isAuth;
@property(nonatomic, retain)ObjSavedArticles *objSaved;
@property(nonatomic, retain)UISwipeGestureRecognizer *swipeLeftRecognizer;
@property(nonatomic, retain)UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)UIWindow *window;

@end
