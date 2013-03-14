//
//  MainDiamondSearchVC.h
//  Rapnet
//
//  Created by Itzik on 03/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiamondResultsVC.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "ShapeParser.h"
#import "LT_Shape.h"

#import "ClarityParser.h"
#import "LT_Clarity.h"

#import "CutParser.h"
 #import "LT_Cut.h"
 
 #import "ColorParser.h"
 #import "LT_Color.h"

#import "FancyColorParser.h"
#import "LT_FancyColor.h"

#import "FancyColorIntesityParser.h"
#import "LT_FancyColorIntensity.h"

#import "FancyColorOvertoneParser.h"
#import "LT_FancyColorOvertone.h"

 #import "PolishParser.h"
 #import "lT_Polish.h"
 
 #import "SymParser.h"
 #import "LT_Sym.h"
 
 #import "FluorParser.h"
 #import "LT_Fluor.h"
 
 #import "CountryParser.h"
 #import "LT_Country.h"
#import "LT_City.h" 

 #import "LabParser.h"
 #import "LT_Lab.h"

#import "LT_Const.h"
#import "DiamondSearchParams.h"

#import "CustomAlertViewController.h"
#import "AnalyticHelper.h"
@interface MainDiamondSearchVC : UIViewController<ShapeDelegate, ClarityDelegate, CutDelegate, ColorDelegate, FancyColorDelegate, FancyColorIntesityDelegate, FancyColorOvertoneDelegate, PolishDelegate, SymDelegate, FluorDelegate, CountryDelegate, LabDelegate, 
    UITextFieldDelegate, UIScrollViewDelegate>
{
    NSInteger startRow;
    NSInteger endRow;
    NSInteger numIncrease;
    
    IBOutlet UISegmentedControl *sColorType;
    IBOutlet UISegmentedControl *sPriceType;
    IBOutlet UIView *vAfterColor;
    IBOutlet UIView *vFancy;
    IBOutlet UIScrollView* svMain;
    
    IBOutlet UITextField *txtWeightFrom;
    IBOutlet UITextField *txtWeightTo;
    
    IBOutlet UITextField *txtPriceTypeFrom;
    IBOutlet UITextField *txtPriceTypeTo;
    
    NSMutableArray* arrShapes;
    NSMutableArray* arrShapesButtons;
    IBOutlet UIScrollView* svShapes;
    IBOutlet UIButton *btnShapesRightScroll;
    IBOutlet UIButton *btnShapesLeftScroll;
    IBOutlet UIButton *btnShapesClear;
    
    NSMutableArray* arrColors;
    NSMutableArray* arrColorButtons;
    IBOutlet UIScrollView* svColors;
    IBOutlet UIButton *btnColorsRightScroll;
    IBOutlet UIButton *btnColorsLeftScroll;
    IBOutlet UIButton *btnColorsClear;
    
    NSMutableArray* arrFancyColor;
    NSMutableArray* arrFancyColorButtons;
    /*IBOutlet UIScrollView* svFancyColors;
    IBOutlet UIButton *btnFancyColorsRightScroll;
    IBOutlet UIButton *btnFancyColorsLeftScroll;*/
    
    NSMutableArray* arrFancyColorOvertone;
    NSMutableArray* arrFancyColorOvertoneButtons;
    IBOutlet UIScrollView* svFancyColorOvertone;
    IBOutlet UIButton *btnFancyColorsOvertoneRightScroll;
    IBOutlet UIButton *btnFancyColorsOvertoneLeftScroll;
    IBOutlet UIButton *btnFancyColorsOvertoneClear;
    
    NSMutableArray* arrFancyColorIntensity;
    NSMutableArray* arrFancyColorIntensityButtons;
    IBOutlet UIScrollView* svFancyColorIntensity;
    IBOutlet UIButton *btnFancyColorsIntensityRightScroll;
    IBOutlet UIButton *btnFancyColorsIntensityLeftScroll;
    IBOutlet UIButton *btnFancyColorsIntensityClear;
    
    NSMutableArray* arrClarities;
    NSMutableArray* arrClaritiesButtons;
    IBOutlet UIScrollView* svClarities;
    IBOutlet UIButton *btnClaritiesRightScroll;
    IBOutlet UIButton *btnClaritiesLeftScroll;
    IBOutlet UIButton *btnClaritiesClear;
    
    NSMutableArray* arrCut;
    NSMutableArray* arrCutButtons;
    IBOutlet UIScrollView* svCut;
    IBOutlet UIButton *btnCutRightScroll;
    IBOutlet UIButton *btnCutLeftScroll;
    IBOutlet UIButton *btnCutClear;
    
    NSMutableArray* arrPolish;
    NSMutableArray* arrPolishButtons;
    IBOutlet UIScrollView* svPolish;
    IBOutlet UIButton *btnPolishRightScroll;
    IBOutlet UIButton *btnPolishLeftScroll;
    IBOutlet UIButton *btnPolishClear;
    
    NSMutableArray* arrSym;
    NSMutableArray* arrSymButtons;
    IBOutlet UIScrollView* svSym;
    IBOutlet UIButton *btnSymRightScroll;
    IBOutlet UIButton *btnSymLeftScroll;
    IBOutlet UIButton *btnSymClear;
    
    NSMutableArray* arrFluor;
    NSMutableArray* arrFluorButtons;
    IBOutlet UIScrollView* svFluor;
    IBOutlet UIButton *btnFluorRightScroll;
    IBOutlet UIButton *btnFluorLeftScroll;
    IBOutlet UIButton *btnFluorClear;
    
    NSMutableArray* arrLab;
    NSMutableArray* arrLabButtons;
    IBOutlet UIScrollView* svLab;
    IBOutlet UIButton *btnLabRightScroll;
    IBOutlet UIButton *btnLabLeftScroll;
    IBOutlet UIButton *btnLabClear;
    
    NSMutableArray* arrCountry;
    NSMutableArray* arrCountryButtons;
    IBOutlet UIScrollView* svCountry;
    IBOutlet UIButton *btnCountryRightScroll;
    IBOutlet UIButton *btnCountryLeftScroll;
    IBOutlet UIButton *btnCountryClear;
    
    NSMutableArray* arrCity;
    NSMutableArray* arrCityButtons;
    IBOutlet UIScrollView* svCity;
    IBOutlet UIButton *btnCityRightScroll;
    IBOutlet UIButton *btnCityLeftScroll;
    IBOutlet UIButton *btnCityClear;
    
    PriceListDownloader *priceDownloader;
    DiamondResultsVC *diamondResults;
    
    IBOutlet UIView *vDownload;
    IBOutlet UILabel *lblLoading;
    CustomAlertViewController *customAlert1;
    UIView *view;
    IBOutlet UIView *vCity;
    IBOutlet UIView *vPrice;
    
    Reachability *hostReach;
    BOOL isReachable, viewLoaded;
    int countReach;
    bool IsDownloadViewVisible;
    AppDelegate *appDelegate;
    // IBOutlet UINavigationBar *navigationBar;
}

-(IBAction)btnShapeClicked:(id)sender;
-(IBAction)btnShapesClearClicked:(id)sender;

-(IBAction)btnClarityClicked:(id)sender;
-(IBAction)btnClarityClearClicked:(id)sender;

-(IBAction)btnCutClicked:(id)sender;
-(IBAction)btnCutClearClicked:(id)sender;

-(IBAction)btnColorClicked:(id)sender;
-(IBAction)btnColorClearClicked:(id)sender;

-(IBAction)btnFancyColorClicked:(id)sender;
-(IBAction)btnFancyColorClearClicked:(id)sender;

-(IBAction)btnFancyColorOvertoneClicked:(id)sender;
-(IBAction)btnFancyColorOvertoneClearClicked:(id)sender;

-(IBAction)btnFancyColorIntensityClicked:(id)sender;
-(IBAction)btnFancyColorIntensityClearClicked:(id)sender;

-(IBAction)btnPolishClicked:(id)sender;
-(IBAction)btnPolishClearClicked:(id)sender;

-(IBAction)btnSymClicked:(id)sender;
-(IBAction)btnSymClearClicked:(id)sender;

-(IBAction)btnFluorClicked:(id)sender;
-(IBAction)btnFlurClearClicked:(id)sender;

-(IBAction)btnCountryClicked:(id)sender;
-(IBAction)btnCountryClearClicked:(id)sender;

-(IBAction)btnCityClicked:(id)sender;
-(IBAction)btnCityClearClicked:(id)sender;

-(IBAction)btnLabClicked:(id)sender;
-(IBAction)btnLabClearClicked:(id)sender;

-(IBAction)btnColorsRightScrollClicked:(id)sender;
-(IBAction)btnColorsLeftScrollClicked:(id)sender;

-(IBAction)btnClarityRightScrollClicked:(id)sender;
-(IBAction)btnClarityLeftScrollClicked:(id)sender;

-(IBAction)btnCutRightScrollClicked:(id)sender;
-(IBAction)btnCutLeftScrollClicked:(id)sender;

-(IBAction)btnShapeRightScrollClicked:(id)sender;
-(IBAction)btnShapeLeftScrollClicked:(id)sender;

-(IBAction)btnFancyColorOvertoneRightScrollClicked:(id)sender;
-(IBAction)btnFancyColorOvertoneLeftScrollClicked:(id)sender;

-(IBAction)btnFancyColorIntensityRightScrollClicked:(id)sender;
-(IBAction)btnFancyColorIntensityLeftScrollClicked:(id)sender;

-(IBAction)btnPolishRightScrollClicked:(id)sender;
-(IBAction)btnPolishLeftScrollClicked:(id)sender;

-(IBAction)btnSymRightScrollClicked:(id)sender;
-(IBAction)btnSymLeftScrollClicked:(id)sender;

-(IBAction)btnFluorRightScrollClicked:(id)sender;
-(IBAction)btnFluorLeftScrollClicked:(id)sender;

-(IBAction)btnCountryRightScrollClicked:(id)sender;
-(IBAction)btnCountryLeftScrollClicked:(id)sender;

-(IBAction)btnCityRightScrollClicked:(id)sender;
-(IBAction)btnCityLeftScrollClicked:(id)sender;

-(IBAction)btnLabRightScrollClicked:(id)sender;
-(IBAction)btnLabLeftScrollClicked:(id)sender;

-(IBAction)btnSearchClicked:(id)sender;
-(IBAction)btnResetClicked:(id)sender;
-(IBAction)sColorTypeClicked:(id)sender;
-(IBAction)sColorTypeClicked:(id)sender;
-(IBAction)valueChanged:(id)sender;

-(UIButton*) getButton:(NSString*)title action:(SEL)action x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
-(void) loadToScrollView:(UIScrollView*)sv arrButtons:(NSMutableArray*)arrButtons arrData:(NSMutableArray*)arrData action:(SEL)action;
-(void) loadToScrollView:(UIScrollView*)sv arrButtons:(NSMutableArray*)arrButtons arrData:(NSMutableArray*)arrData action:(SEL)action numRows:(NSInteger)numRows;
//-(UIButton*) getButton:(NSString*)title action:(SEL)action;
@end
