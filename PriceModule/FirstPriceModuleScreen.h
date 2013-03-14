//
//  FirstPriceModuleScreen.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WorkAreaModuleScreen.h"
#import "CustomAlertAddDiamondViewController.h"
#import "CustomAlertViewController.h"

#import "SavedCalculations.h"
#import "GetPricecalcParser.h"
#import "RaportPriceChange.h"
#import "RaportPriceList.h"
#import "MsgAlertView.h"
#import "OpenFileModuleScreen.h"

#import "CustomUpdatePriceListALert.h"

#import "PriceListDownloader.h"
#import "Functions.h"
#import "Constants.h"
#import "PriceListData.h"
#import "GetPriceListLists.h"
@interface FirstPriceModuleScreen : UIViewController<UIPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,CustomALertAddDiamondDelegate,SavedCalculationsDelegate,getPricecalcDelegate,getAuthTicketDelegate,MsgAlertViewDelegate,WorkAreaDelegate,PriceListDownloaderDelegate,CustomUpdatePriceListAlertDelegate,PriceListDelegate,getPriceListDateDelegate, getPriceListDelegate> {
    
    
    GetPricecalcParser *objPriceCalcParser;
    LoginPriceParser *objLoginParser;
    
    NSMutableArray *arrShape,*arrColors,*arrClarity,*arrPriceCalc,*arrTradeScreen;
    IBOutlet UIPickerView *discountPick,*myPickerView;
    IBOutlet UIView *vDownload;
    
    IBOutlet UIScrollView* myScrollView;
	IBOutlet UIButton* leftArrowImageView;
	IBOutlet UIButton* rightArrowImageView;
    
    IBOutlet UIImageView *tabCalc;
	IBOutlet UIImageView *tabSaved;
    IBOutlet UIImageView *tabWorkArea;
	IBOutlet UIImageView *tabRaportPriceList;
	IBOutlet UIImageView *tabRaportPriceChange,*toolBar;
    IBOutlet UIProgressView *pvProgress;
    
    BOOL rightHide;
	BOOL leftHide;
    BOOL showRapPrice;
    
    NSInteger textFieldToEdit;
    
    bool initScreenStarted;
    bool didInitializeScreen;
    bool isDownloadingLists;
    bool isDownloadingPrices;
    
    IBOutlet UILabel *diamondName,*yourPL,*RapPL,*RapAvgPL,*RapBestPL,*RapAvgBPL,*RapBestBPL,*RPDPL,*RADPL,*RBDPL,*RPTPL,*RATPL,*RBTPL,*CTPL,*TPPL,*sizeL,*RADiscL,*RBDiscL,*RapPercent,*rapnetL,*DPL,*DiscL, *lblPricesUpdated, *lblMsg;
    IBOutlet UIButton *showRapBtn,*workABtn,*saveBtn,*resetBtn,*refreshPriceBtn,*calcBtn, *btnSearchRapNet, *btnDownloadPriceList;
    IBOutlet UITextField *sizeTF,*CTTF,*TPTF;
    
    NSString *ticketAuth;
    bool IsDownloadViewVisible;
    
    
    float bestDiscount,avgDiscount,pricePerCarat,priceTotal,discount,rapPriceList;
    int bestPrice,avgPrice,diamondCount;
    NSString *shape,*clarity,*color;
    
    BOOL sizeEditFlag, pricePerCaratFlag, totalPriceEditFlag, isReachable;
    
    CustomAlertAddDiamondViewController *customAlert;
    
    BOOL discountEditFlag;
    int discountAddValue;
    
    AppDelegate *appDelegate;
    
    BOOL webCallEndFlag[4],webCallEndFlag1[2];
    
    SavedCalculations *saveCalcObj;
    WorkAreaModuleScreen *workAreaObj;
    
    int counter,actualCount;
    
    NSMutableArray *discountValuesArr;
    int discountAddIndex,finalDiscountIndex;
    NSString *shapeType;
    RaportPriceChange *raportPriceChangeObj;
    RaportPriceList *raportPriceListObj;
    
    CustomAlertViewController *customAlert1;
    CustomUpdatePriceListALert *customAlert2;
    UIView *view;
    
    PriceListDownloader *priceDownloader;
    
    Reachability* hostReach;
}

-(void)priceListDownloadFinished:(NSInteger)type;
-(BOOL)downloadPriceIfNeeded;


-(void)webserviceCallPriceCalcFinished:(NSMutableArray *)results;
-(void)webserviceCallTradeScreenFinished;
-(void)webserviceCallLoginFinished;

-(void)webserviceCallPriceCalcStart:(int)callType;
-(void)alertAddDiamondFinished:(int)type;
-(void)alertUpdatePriceListFinished:(int)type;
//-(void)setCalc:(int)shapeID size:(float)size colorID:(int)colorID clarityID:(int)clarityID;

-(IBAction)showRapButtonClick:(id)sender;
-(IBAction)savedButtonClick:(id)sender;
-(IBAction)resetButtonClick:(id)sender;

-(IBAction)calcButtonClick:(id)sender;
-(IBAction)workAButtonClick:(id)sender;
-(IBAction)saveButtonClick:(id)sender;
-(IBAction)rarportPriceListButtonClick:(id)sender;
-(IBAction)rarportPriceChangeButtonClick:(id)sender;
-(IBAction)scrollForward:(id)sender;
-(IBAction)scrollBackward:(id)sender;
-(IBAction)btnSearchRapNetClicked:(id)sender;
-(IBAction)btnDownloadPriceListClicked:(id)sender;
-(IBAction)refreshPriceBtnTapped:(id)sender;

-(void)initialDelayEnded;
-(void)showAlertView;
-(void)resetAll;

-(void)createScreenComponents;
-(BOOL)checkValidNumber:(NSString*)s:(NSString *)v;
-(NSString *)convertNumberToCommaSeparatedString:(float)num;
-(NSString *)convertToNumberFromString:(NSString *)str;
-(BOOL)checkAllWebSrviceEnded;
-(BOOL)checkAllWebSrviceEndedForPrice;

-(void)workAreaFinished:(int)type;
-(void)savedCalcFinished:(int)type index:(int)index;

-(void)initializeScreen;
-(void)setAllPrices;
-(void)loadAllDataFromDatabase;
-(int)getGridSizeID:(double)size;
-(NSString *)GetShapeType:(NSString *)title;
-(void)slideAnim:(UIView *)image:(CGPoint)center;
-(void)getAvgBestprice;
-(void)alertmsgFinished;
-(BOOL)checkDiscountExist:(float)d;
-(float)getDiscountAtIndex:(int)index;
-(NSInteger)searchIndexForDiscount:(float)d;
-(void)backToOpenFile;
-(void)callGetPriceListDate:(bool)isRound;
@end
