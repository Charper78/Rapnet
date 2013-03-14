//
//  SavedCalculations.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredData.h"
#import "Database.h"
#import "MsgAlertView.h"


@protocol SaveExistListDelegate
-(void)saveExistListFinished:(int)type;
@end


@interface SaveToExistFile : UIViewController<UITableViewDelegate,UITableViewDataSource,MsgAlertViewDelegate> {
    IBOutlet UIButton *saveBtn,*checkBoxSelAllBtn,*cancelBtn;
    UITableView *tableView;
    IBOutlet UIImageView *toolBar,*checkAllImage;
    
    BOOL checkAllFlag,diamondSavedMsgflag;
    NSMutableArray *fileNameArr;
    NSArray *dataArr;
    
    MsgAlertView *alertView;
    UIView *view;
    
    NSMutableArray *selectedRowArr;        
    
    id<SaveExistListDelegate> delegate;
}

@property(retain, nonatomic) id<SaveExistListDelegate> delegate;

@property(nonatomic,retain)NSArray *dataArr;

-(IBAction)saveBtnTapped:(id)sender;
-(IBAction)cancelBtnTapped:(id)sender;
-(IBAction)checkBoxSelAllBtnTapped:(id)sender;

-(void)loadDataInTable;
-(void)loadSavedDiamonds;
-(void)initialDelayEnded;
-(void)alertmsgFinished;

@end
