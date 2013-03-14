//
//  PriceListDownloader.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GetShapeParser.h"
#import "GetColorsParser.h"
#import "GetClarityParser.h"
#import "LoginPriceParser.h"
#import "GetPricecalcParser.h"
#import "GetTradeScreenParser.h"
#import "Database.h"
//#import "GetPriceListParser.h"
#import "GetPriceList.h"
#import "GetGridSizeParser.h"
#import "StoredData.h"
#import "Functions.h"
#import "Enums.h"
#define TOTALWEBSERVICE 4
#define TOTALPRICE 36

@protocol PriceListDownloaderDelegate
-(void)priceListDownloadFinished:(NSInteger)type;

@end

@interface PriceListDownloader : UIViewController<getAuthTicketDelegate,getPricecalcDelegate,getTradeScreenDelegate,getGridSizeDelegate, getPriceListDelegate> {
//@interface PriceListDownloader : UIViewController<getShapeDelegate,getColorDelegate,getClarityDelegate,getAuthTicketDelegate,getPricecalcDelegate,getTradeScreenDelegate,getPriceListDelegate,getGridSizeDelegate> {
    //AppDelegate *appDelegate;
    
    GetShapeParser *objShapeParser; 
    GetColorsParser *objColorParser;
    GetClarityParser *objClarityParser;
    LoginPriceParser *objLoginParser;
    GetPricecalcParser *objPriceCalcParser;
    GetTradeScreenParser *objTradeScreenParser;
    //GetPriceListParser *objPriceListParser;
    //GetPriceList *objPriceListParser;
    GetGridSizeParser *objGridSizeParser;
    
    id<PriceListDownloaderDelegate> delegate;
    BOOL webCallEndFlag[TOTALWEBSERVICE],webCallEndFlag1[2];
    NSMutableArray *arrShape,*arrColors,*arrClarity,*arrPriceCalc,*arrTradeScreen,*arrPriceList;
    
    int pricelistCount;
    NSString *ticket;
    int pricelistWebCount;
    NSString *shapeType;
    IBOutlet UIActivityIndicatorView *act;
    IBOutlet UIImageView *bg;
    IBOutlet UILabel *text;
    IBOutlet UIProgressView *pvProgress;
    Reachability *hostReach;
    BOOL isReachable;
    
    int numDownloadsRequierd;
    int numDownloadsActual;
    
    
}

@property(retain,nonatomic)id<PriceListDownloaderDelegate> delegate;

-(void)webserviceCallShapeFinished;
-(void)webserviceCallColorsFinished;
-(void)webserviceCallClarityFinished;
-(void)webserviceCallLoginFinished:(NSMutableArray *)results;
-(void)webserviceCallPriceCalcFinished;
-(void)webserviceCallTradeScreenFinished;
-(void)webserviceCallPriceListFinished:(NSMutableArray *)results;
-(void)webserviceCallGridSizeFinished;
-(void)download:(PricesDownload)pd;
@end
