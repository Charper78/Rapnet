//
//  LoginViewController.h
//  Rapnet
//
//  Created by Richa on 6/6/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginParser.h"
#import "ForgotPasswordParser.h"
#import "LoginPriceParser.h"
#import "LT_Clarity.h"
#import "LT_Cut.h"
#import "LT_Color.h"
#import "LT_FancyColor.h"
#import "LT_FancyColorIntensity.h"
#import "LT_FancyColorOvertone.h"
#import "lT_Polish.h"
#import "LT_Sym.h"
#import "LT_Fluor.h"
#import "LT_Lab.h"
#import "Database.h"
#import "Functions.h"
#import "CustomUpdatePriceListALert.h"
#import "PriceListDownloader.h"
#import "CustomAlertViewController.h"
#import "GetPriceListDateParser.h"
#import "GetPriceList.h"
#import "LoginHelper.h"
#import "AnalyticHelper.h"
#import "CustomBadge.h"
#import "NotificationsViewController.h"
#import "RegisterDevice.h"
#import "NotificationsHelper.h"

@interface LoginViewController : UIViewController<getAuthTicketDelegate,getPasswordDelegate,PriceListDownloaderDelegate,CustomUpdatePriceListAlertDelegate, getPriceListDateDelegate, getPriceListDelegate,notificationsViewControllerDelegate> {

	IBOutlet UIScrollView *loginScroll;
	IBOutlet UIButton *btnRememPwd;
	IBOutlet UIButton *btnForgotPwd;
	IBOutlet UIButton *logOutBttn;
	IBOutlet UIButton *logInBttn;
	IBOutlet UIButton *btnNotifications;
    IBOutlet UIButton *chkNotifyPriceListChange;
    IBOutlet UIButton *chkAutoUpdatePriceList;
    
	IBOutlet UITextField *objUserName;
	IBOutlet UITextField *objPassword;
	IBOutlet UITextField *objForgotPw;
	IBOutlet UISwitch *priceSwitch;
	IBOutlet UISwitch *newsSwitch;
	IBOutlet UILabel *lblPricesUpdated; 
    IBOutlet UIView *vDownload;
    IBOutlet UISwitch *sUse10crts;
	NSMutableArray *arrLogin,*arrPriceLogin;
	NSMutableArray *arrForgotService;
	LoginParser *loginParser;
    LoginPriceParser *objLoginParser;
	ForgotPasswordParser *objForgot;
	NSString *strSucceed;
	NSTimer *theTimer;
	NSTimer *aTimer;
    NSTimer *updatePricesTimer;
	UIAlertView *alert;
    BOOL isKeyBoardDown;
    
    BOOL webCallEndFlag[2];
    CustomAlertViewController *customAlert1;
    CustomUpdatePriceListALert *customAlert2;
    UIView *view;
    PriceListDownloader *priceDownloader;
    AppDelegate *appDelegate;
    GetPriceListDateParser *priceListDate;
    Reachability *hostReach;
    BOOL isReachable;
    bool IsDownloadViewVisible;
    IBOutlet UIProgressView *pvProgress;
    CustomBadge *badge;
    
}

@property(nonatomic,retain)NSString *strSucceed;
//@property(nonatomic, retain) IBOutlet UIProgressView *pvProgress;

-(IBAction)chkBtn:(id)sender;
-(IBAction)newsToggleBtn:(id)sender;
-(IBAction)priceToggleBtn:(id)sender;
-(IBAction)logOutBttn:(id)sender;
-(IBAction)sendBtn;
-(IBAction)signupBtn;
-(IBAction)loginBtn:(id)sender;
-(IBAction)resetBtn;
-(IBAction)cancelBtn;
-(IBAction)privacyPolicyLink;
-(IBAction)termsOfUseLink;
-(IBAction)btnUpdatePrices_Clicked;
-(IBAction)sUse10crts_toggle:(id)sender;
-(IBAction)btnNotifications_Clicked:(id)sender;
-(void)setViewMovedUp:(BOOL)movedUp coordinateY:(NSInteger)coordinateY;
-(void)startUpdatePriceList;
-(void)setBadgeCount;
-(BOOL)checkAllWebSrviceEnded;
-(IBAction)chkAutoUpdatePriceList_Click:(id)sender;
-(IBAction)chkNotifyPriceListChange_Click:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;
@end
