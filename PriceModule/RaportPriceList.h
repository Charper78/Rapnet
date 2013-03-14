//
//  RaportPriceList.h
//  RapnetPriceModule
//
//  Created by Mohit on 14/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPriceListPopUp.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "GetPricecalcParser.h"
#import "DiamondResultsVC.h"
#import "AppDelegate.h"
#import "GetPriceListDateParser.h"
#import "Functions.h"
#import "PriceListData.h"
#import "CustomAlertViewController.h"
@protocol PriceListDelegate

-(void)setCalc:(int)shapeID size:(float)size colorID:(int)colorID clarityID:(int)clarityID;

@end
@interface RaportPriceList : UIViewController<UIScrollViewDelegate,UIPickerViewDelegate,CustomPriceListAlertDelegate,getPricecalcDelegate, getPriceListDateDelegate,UIActionSheetDelegate> {
    IBOutlet UIImageView *toolBar;
    IBOutlet UIScrollView *columnScrollView,*rowScrollView,*dataScrollView;
    int xScroll,yScroll;
    IBOutlet UIButton *colRightBtn,*colLeftBtn,*rowDownBtn,*rowUpBtn;
    
    UILabel *pricesL[10][11],*clarityL[11],*colorL[10];
    UIButton *pricesBtn[10][11];
    NSMutableArray *arrSizeFrom, *arrSizeTo,*arrColors,*arrClarity,*arrShape,*arrGridID;
    IBOutlet UILabel *headingL;
    IBOutlet UIPickerView *myPickerView;
    
    CustomPriceListPopUp *customAlert;
    GetPricecalcParser *objPriceCalcParser;
    AppDelegate *appDelegate;
    id<PriceListDelegate> delegate;
    Reachability *hostReach;
    BOOL isReachable;
    CustomAlertViewController *customAlert1;
    UIView *view;
}
@property(retain, nonatomic) id<PriceListDelegate> delegate;
-(void)webserviceCallPriceCalcFinished;
-(void)alertPriceListFinished:(int)type;

-(IBAction)colArrowBtnClicked:(id)sender;
-(IBAction)rowArrowBtnClicked:(id)sender;
-(IBAction)colLeftArrowBtnClicked:(id)sender;
-(IBAction)rowUpArrowBtnClicked:(id)sender;
-(IBAction)pricesBtnTapped:(id)sender;

-(void)initialDelayEnded;
-(void)setAllPrices;
-(NSString *)convertNumberToCommaSeparatedString:(float)num;

-(float)getWieghtWithGridId:(NSInteger)ID;

@end
