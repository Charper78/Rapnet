//
//  StoredData.m
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "StoredData.h"
@implementation StoredData

@synthesize isVideo;
@synthesize isSaved;
@synthesize isMore;
@synthesize isNews;
@synthesize isViewed;
@synthesize isSearch;
@synthesize isEditor;
@synthesize isRelatedVideo;
@synthesize isRelatedArticle;
//@synthesize isUserAuthenticated;

@synthesize Analysis;
@synthesize Features;
@synthesize TradeAlerts;
@synthesize Statistics;
@synthesize PressRelease;

@synthesize topicName;
@synthesize countryID;
@synthesize countryPhoneCode;
@synthesize relatedArticleID;

@synthesize arrDuplicateChk;
@synthesize arrReadArticle;
@synthesize arrSavedArticle;

//@synthesize strTicket,strPriceTicket,strRapnetTicket;
@synthesize strName;
@synthesize strBusinessName;
@synthesize strCountryName;
@synthesize strWebURL;

@synthesize savedDiamondsArr;
@synthesize dbSavedDiamondsArr;

@synthesize calcFromWAFlag,saveCalcFlag,updateFileFlag,saveToExistFileFlag,openFileAlertFlag;
@synthesize WAEditRowIndex,updateDiamondIndex,updateWADiamondIndex,openFileAlertType,openFileIndex;

@synthesize openFileName,openDiamondName,openFileTime,savedDiamondToupdate;

@synthesize workABtnGlobal;

//@synthesize loginPriceFlag,loginRapnetFlag,selectedTabBfrLogin,priceAlertFlag,blackScreen,rapnetAlertFlag;
@synthesize selectedTabBfrLogin,priceAlertFlag,blackScreen,rapnetAlertFlag, newsAlertFlag;

@synthesize arrShape,arrClarity,arrColors;
@synthesize loginData,use10crts;

static StoredData*	singleton;


+(StoredData*) sharedData
{
	if (!singleton) 
	{
		singleton = [[StoredData alloc] init];
	}
	return singleton;
}

#pragma mark init method
- (id)init 
{
	if (self = [super init]) 
	{
		strBusinessName=[[NSString alloc]init];
		strCountryName=[[NSString alloc]init];
		strName=[[NSString alloc]init];
		strWebURL=[[NSString alloc]init];
		//strTicket=[[NSMutableString alloc]init];
        //strPriceTicket=[[NSMutableString alloc]init];
		topicName=[[NSMutableString alloc]init];
		countryID=[[NSMutableString alloc]init];
		countryPhoneCode=[[NSMutableString alloc]init];
		relatedArticleID=[[NSMutableString alloc]init];
		arrSavedArticle=[[NSMutableArray alloc]init];
		arrDuplicateChk=[[NSMutableArray alloc]init];
		arrReadArticle=[[NSMutableArray alloc]init];
        
        
        savedDiamondsArr=[[NSMutableArray alloc]init];
        dbSavedDiamondsArr=[[NSMutableArray alloc]init];
        savedDiamondToupdate = [[NSMutableDictionary alloc]init];
        
        blackScreen = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        blackScreen.alpha = 0.699999988079071;
        blackScreen.backgroundColor = [UIColor blackColor];
        
        arrShape=[[NSMutableArray alloc]init];
		arrClarity=[[NSMutableArray alloc]init];
		arrColors=[[NSMutableArray alloc]init];
        
        use10crts = [Functions getBoolData:kUse10crts defalutVal:YES];
	}
	return self;
}

-(void) dealloc;
{    
	[super dealloc];
    
    [arrShape release];
    [arrColors release];
    [arrClarity release];
    
    [blackScreen release];
    [savedDiamondToupdate release];
    [openFileTime release];
    [openDiamondName release];
    [openFileName release];
    [dbSavedDiamondsArr release];
    [savedDiamondsArr release];
	[strWebURL release];
	[topicName release];
	[strCountryName release];
	[strName release];
	//[strTicket release];
    //[strPriceTicket release];
    //[strRapnetTicket release];
	[countryID release];
	[strBusinessName release];
	[countryPhoneCode release];
	[arrDuplicateChk release];
	[arrSavedArticle release];
	[arrReadArticle release];
}
@end

