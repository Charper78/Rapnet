//
//  WorkAreaModuleScreen.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredData.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Database.h"
#import "CustomSaveDiamondAlert.h"
#import "DeleteAllAlertView.h"
#import "DeleteSelectedAlertView.h"
#import "MsgAlertView.h"
#import "CustomSaveExistListAlert.h"
#import "SaveToExistFile.h"
#import "CustomrapEditAlert.h"

@protocol OpenFileModuleDelegate
-(void)openFileModuleFinished:(int)type;
@end

@interface OpenFileModuleScreen : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,CustomSaveDiamondAlertDelegate,deleteAllAlertDelegate,UIAlertViewDelegate,deleteSelectedAlertDelegate,MsgAlertViewDelegate,CustomSaveExistListAlertDelegate,CustomrapEditAlertDelegate> {
    IBOutlet UIButton *calcBtn,*deleteAllBtn,*emailBtn,*saveSelectedBtn,*deleteBtn,*checkBoxSelAllBtn;
    IBOutlet UILabel *avgDperC,*DperTtl,*rapPercentage,*rapPerC,*rapPerTtl,*workAreaText,*calcL;
    UITableView *tableView;
    IBOutlet UIImageView *toolBar,*checkAllImage;
    IBOutlet UIView *vButtom;
    BOOL deleteFlag,checkAllFlag,diamondSavedMsgflag;
    
    NSMutableArray *selectedRowArr,*allDiamondsArr;
    
    CustomrapEditAlert *customRapEditAlert;
    CustomSaveExistListAlert *customExistAlert;
    CustomSaveDiamondAlert *customAlert;
    DeleteAllAlertView *customAlert1;
    DeleteSelectedAlertView *customAlert2;
    MsgAlertView *alertView;
    UIView *view;
    
    id<OpenFileModuleDelegate> delegate;
}

@property(retain, nonatomic) id<OpenFileModuleDelegate> delegate;

@property(nonatomic,retain)NSMutableArray *allDiamondsArr;

-(IBAction)calcBtnTapped:(id)sender;
-(IBAction)deleteAllBtnTapped:(id)sender;
-(IBAction)emailBtnTapped:(id)sender;
-(IBAction)saveSelectedAllBtnTapped:(id)sender;
-(IBAction)deleteBtnTapped:(id)sender;
-(IBAction)checkBoxSelAllBtnTapped:(id)sender;

-(void)loadDataInTable;
-(void)updateLabels;

-(void)alertrapEditFinished:(int)index:(int)value;
-(void)alertmsgFinished;
-(void)alertSaveDiamondFinished:(int)type;
-(void)initialDelayEnded;
-(void)showAlertView;
-(void)alertDeleteFinished:(int)index;
-(void)alertDeleteSelectedFinished:(int)index;
-(void)alertSaveExistListFinished:(int)type;
-(NSString *)convertNumberToCommaSeparatedString:(float)num;
-(NSString *)convertToNumberFromString:(NSString *)str;
-(void)deleteSelectedDiamonds;

@end
