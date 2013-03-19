//
//  AppDelegate.h
//  Rapnet
//
//  Created by Nikhil Bansal on 28/01/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LoginParser.h"
#import "PriceListDownloader.h"
#import "LoginPriceParser.h"
#import "GetPriceList.h"
#import "Enums.h"
#import "LoginData.h"
#import "Functions.h"
#import "AnalyticHelper.h"
#import "Constants.h"
#import "RegisterDeviceParser.h"

@class LoginParser, MoreViewC, LoginPriceParser;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,getAuthTicketDelegate,PriceListDownloaderDelegate>{
    
    IBOutlet UINavigationController* navigationController;
	UIActivityIndicatorView *activityView;
	NSMutableArray *arrLogin,*arrPriceLogin;
	LoginParser *loginParser;
	MoreViewC	*aMoreViewC; 
    PriceListDownloader *priceDownloader;
    LoginPriceParser *objLoginParser;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
-(void)showActivityIndicator:(UIViewController*)controller;
-(void)stopActivityIndicator:(UIViewController*)controller;
-(void)copyDatabaseIfNeeded;
-(NSString *)getDBPath;
-(void)showNewsScreen;
+(AppDelegate*) getAppDelegate;
-(void)priceListDownloadFinished:(NSInteger)type;
-(BOOL)downloadPriceIfNeeded;
-(void)hideTabBar;
-(void)showTabBar;
-(void)setBadgeCount;
@end
