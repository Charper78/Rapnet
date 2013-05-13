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
#import "CustomRenameAlert.h"
#import "CustomOpenAlertView.h"
#import "DeleteSelectedAlertView.h"
#import "MsgAlertView.h"
#import "OpenFileModuleScreen.h"
#import "PriceListData.h"
#import "AnalyticHelper.h"

@protocol SavedCalculationsDelegate
-(void)savedCalcFinished:(int)type index:(int)index;
@end

@interface SavedCalculations : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomRenameAlertDelegate,CustomOpenAlertDelegate,deleteSelectedAlertDelegate,MsgAlertViewDelegate,OpenFileModuleDelegate> {
    IBOutlet UIButton *openBtn,*deleteBtn,*renameBtn,*checkBoxSelAllBtn;
    UITableView *tableView;
    IBOutlet UIImageView *toolBar,*checkAllImage,*headerBG;
    IBOutlet UIView *vButtom;
    BOOL deleteFlag,checkAllFlag;
    NSMutableArray *fileNameArr;
    
    CustomRenameAlert *renameAlert;
    CustomOpenAlertView *openAlert;
    MsgAlertView *alertView;
    UIView *view;
    
    NSMutableArray *selectedRowArr;
    
    DeleteSelectedAlertView *customAlert2;
    
    id<SavedCalculationsDelegate> delegate;
    NSString *shapeType;
}

@property(retain, nonatomic) id<SavedCalculationsDelegate> delegate;

-(IBAction)openBtnTapped:(id)sender;
-(IBAction)deleteBtnTapped:(id)sender;
-(IBAction)renameBtnTapped:(id)sender;
-(IBAction)checkBoxSelAllBtnTapped:(id)sender;

-(void)loadDataInTable;
-(void)loadSavedDiamonds;
-(void)initialDelayEnded;
-(void)alertRenameFinished:(NSString *)name type:(int)type;
-(void)alertOpenFinished:(int)type;
-(void)alertDeleteSelectedFinished:(int)index;
-(void)alertmsgFinished;
-(int)getGridSizeID:(float)size;
-(NSString *)GetShapeType:(NSString *)title;

-(void)openFileModuleFinished:(int)type;

@end
