//
//  DiamondDesultDetailsVC.h
//  Rapnet
//
//  Created by Itzik on 19/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiamondResultDetailCell.h"
#import "DiamondSearchResult.h"
#import "Enums.h"
#import "Functions.h"
#import "DiamondResultDetailsActions.h"
#import "WebSiteController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NotifySeller.h"
#import "Reachability.h"
#import "LoginHelper.h"
#import "AnalyticHelper.h"
@interface DiamondDesultDetailsVC : UIViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate>
{
    DiamondSearchResult *result;
    
    IBOutlet DiamondResultDetailCell *cell;
    IBOutlet DiamondResultDetailsActions *cellActions;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblValue;
    IBOutlet UITableView *tblDiamond;
    
    IBOutlet UIButton *btnBack;
    
    IBOutlet UIButton *btnTel;
    IBOutlet UIButton *btnSms;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnCert;
    IBOutlet UIButton *btnImage;
    IBOutlet UIButton *btnNotifySeller;
    IBOutlet UILabel *lblMainTitle;
    
    IBOutlet UIButton *btnOk;
    IBOutlet UIButton *btnCancel;
    IBOutlet UITextField *txtSubject;
    IBOutlet UITextView *txtMessage;
    IBOutlet UITextView *txtReference;
    IBOutlet UIView *vNotifySeller;
    IBOutlet UIScrollView *svNotifySellerContent;
    
    UITextField *lastTextField;
    UITextView *lastTextView;
    BOOL isKeyBoardDown;
    BOOL stopDismissTextFields;
    
    bool isSmsAction;
    NSTimer *theTimer;
	UIAlertView *alert;
    Reachability *hostReach;
    BOOL isReachable, viewLoaded;
    int countReach;
}

@property(nonatomic, retain)IBOutlet DiamondResultDetailCell* resultCell;
@property(nonatomic, retain)IBOutlet DiamondResultDetailsActions* resultCellActions;

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnTelClicked:(id)sender;
-(IBAction)btnSmsClicked:(id)sender;
-(IBAction)btnEmailClicked:(id)sender;
-(IBAction)btnCertClicked:(id)sender;
-(IBAction)btnNotifySellerClicked:(id)sender;
-(IBAction)btnImageClicked:(id)sender;
-(void)loadDiamond:(DiamondSearchResult*)res;
-(void)changeTableHeight:(CGFloat)height;

-(IBAction)btnOkClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
@end
