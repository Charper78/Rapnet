//
//  StoredData.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginData.h"

@interface StoredData : NSObject
{
	//NSMutableString *strTicket,*strPriceTicket, *strRapnetTicket;
	NSMutableString *topicName;
	NSMutableString *countryID;
	NSMutableString *countryPhoneCode;
	NSMutableString *relatedArticleID;
	NSMutableArray *arrSavedArticle;
	NSMutableArray *arrDuplicateChk;
	NSMutableArray *arrReadArticle;
	
	NSString *strBusinessName;
	NSString *strName;
	NSString *strCountryName;
	NSString *strWebURL;
	
	BOOL isVideo;
	BOOL isSaved;
	BOOL isMore;
	BOOL isNews;
	BOOL isViewed;
	BOOL isSearch;
	BOOL isEditor;
	BOOL isRelatedVideo;
	BOOL isRelatedArticle;
    BOOL use10crts;
	//BOOL isUserAuthenticated;
	
	BOOL Analysis;
	BOOL Features;
	BOOL TradeAlerts;
	BOOL Statistics;
	BOOL PressRelease;
    
    
    /***** Price Module ********/
    NSMutableDictionary *savedDiamondToupdate;
    NSMutableArray *savedDiamondsArr,*dbSavedDiamondsArr;
    BOOL calcFromWAFlag,saveCalcFlag,updateFileFlag,saveToExistFileFlag;
    NSInteger WAEditRowIndex,updateDiamondIndex,updateWADiamondIndex;  
    // NSString *ticket;
    NSString *openFileName,*openDiamondName,*openFileTime;
    
    BOOL openFileAlertFlag;
    NSInteger openFileAlertType,openFileIndex;
    
    UIButton *workABtnGlobal;
    
    
    BOOL loginPriceFlag,loginRapnetFlag,priceAlertFlag, rapnetAlertFlag;
    
    NSInteger selectedTabBfrLogin;
    
    UIView *blackScreen;
    
    NSMutableArray *arrShape,*arrColors,*arrClarity;
    
    LoginData *loginData;
}

+ (StoredData*) sharedData;

//@property (nonatomic,retain) NSMutableString *strTicket;
//@property (nonatomic,retain) NSMutableString *strPriceTicket;
//@property (nonatomic, retain) NSMutableString *strRapnetTicket;
@property (nonatomic,retain) NSMutableString *topicName;
@property (nonatomic,retain) NSMutableString *countryID;
@property (nonatomic,retain) NSMutableString *countryPhoneCode;
@property (nonatomic,retain) NSMutableString *relatedArticleID;
@property (nonatomic,retain) NSString *strBusinessName;
@property (nonatomic,retain) NSString *strName;
@property (nonatomic,retain) NSString *strCountryName;
@property (nonatomic,retain) NSString *strWebURL;
@property (nonatomic,retain) NSMutableArray *arrSavedArticle;
@property (nonatomic,retain) NSMutableArray *arrDuplicateChk;
@property (nonatomic,retain) NSMutableArray *arrReadArticle;
@property (nonatomic,retain) NSMutableArray *savedDiamondsArr;
@property (nonatomic,retain) NSMutableArray *dbSavedDiamondsArr;
@property (nonatomic,retain) NSString *openFileName;
@property (nonatomic,retain) NSString *openDiamondName;
@property (nonatomic,retain) NSString *openFileTime;
@property (nonatomic,retain) NSMutableDictionary *savedDiamondToupdate;
@property (nonatomic,retain) LoginData *loginData;

@property (nonatomic,retain)UIView *blackScreen;

@property (nonatomic)BOOL isVideo;
@property (nonatomic)BOOL isSaved;
@property (nonatomic)BOOL isMore;
@property (nonatomic)BOOL isNews;
@property (nonatomic)BOOL isViewed;
@property (nonatomic)BOOL isSearch;
@property (nonatomic)BOOL isEditor;

@property (nonatomic)BOOL Analysis;
@property (nonatomic)BOOL Features;
@property (nonatomic)BOOL TradeAlerts;
@property (nonatomic)BOOL Statistics;
@property (nonatomic)BOOL PressRelease;

@property (nonatomic)BOOL isRelatedVideo;
@property (nonatomic)BOOL isRelatedArticle;
//@property (nonatomic)BOOL isUserAuthenticated;

@property (nonatomic)BOOL calcFromWAFlag;
@property (nonatomic)BOOL saveCalcFlag;
@property (nonatomic)BOOL updateFileFlag;
@property (nonatomic)BOOL saveToExistFileFlag;
@property (nonatomic)BOOL openFileAlertFlag;

//@property (nonatomic)BOOL loginPriceFlag;
//@property (nonatomic)BOOL loginRapnetFlag;
@property (nonatomic)BOOL priceAlertFlag;
@property (nonatomic)BOOL rapnetAlertFlag;
@property (nonatomic)BOOL use10crts;

@property (nonatomic)NSInteger WAEditRowIndex;
@property (nonatomic)NSInteger updateDiamondIndex;
@property (nonatomic)NSInteger updateWADiamondIndex;
@property (nonatomic)NSInteger openFileAlertType;
@property (nonatomic)NSInteger openFileIndex;
@property (nonatomic)NSInteger selectedTabBfrLogin;

@property (nonatomic,retain) UIButton *workABtnGlobal;

@property (nonatomic,retain)NSMutableArray *arrShape;
@property (nonatomic,retain)NSMutableArray *arrColors;
@property (nonatomic,retain)NSMutableArray *arrClarity;

@end
