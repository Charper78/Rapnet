//
//  AppDelegate.m
//  Rapnet
//
//  Created by Nikhil Bansal on 28/01/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"
#import "NewsViewController.h"
#import "Database.h"
#import "MoreViewC.h"
#import "LoginParser.h"
#import "SplashScreen.h"
#import "LoginViewController.h"
#import "MainDiamondSearchVC.h"
#import "FirstPriceModuleScreen.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize navigationController,activityView;

bool startUpdatePriceList = FALSE;

- (void)dealloc
{
    [activityView release];
	[arrLogin release];
    [arrPriceLogin release];
	[navigationController release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AnalyticHelper initAnalytic];
    
    [self copyDatabaseIfNeeded];
    [Database openDatabase];
    [Database fetchWorkAreaDiamonds];
    [StoredData sharedData].selectedTabBfrLogin = -1;
    [StoredData sharedData].priceAlertFlag = FALSE;
	
	NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
	[NSURLCache setSharedURLCache:sharedCache];
	[sharedCache release];
	
    if([Reachability reachable])
    {
        [Functions loginAll];
    }
    
    NewsViewController *newsView=[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:newsView];
    
    
    FirstPriceModuleScreen *priceScreen=[[FirstPriceModuleScreen alloc]initWithNibName:@"FirstPriceModuleScreen" bundle:nil];
    
    
    UINavigationController *navPriceC = [[[UINavigationController alloc] initWithRootViewController:priceScreen]autorelease];	
    
    [navPriceC setNavigationBarHidden:YES];
	[priceScreen release];
	priceScreen=nil;
    
    
    LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *navC = [[[UINavigationController alloc] initWithRootViewController:login]autorelease];	
    [navC setNavigationBarHidden:YES];
	[login release];
	login=nil;
    
    MainDiamondSearchVC *diamondSearch=[[MainDiamondSearchVC alloc]initWithNibName:@"MainDiamondSearchVC" bundle:nil];
    
    
    UINavigationController *navDiamondSearch = [[UINavigationController alloc] initWithRootViewController:diamondSearch];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController,navPriceC,navDiamondSearch,navC, nil];
    self.window.rootViewController = self.tabBarController;    
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
    if (launchOptions != nil)
	{
        NSLog(@"launchOptions: %@", launchOptions);
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self onReceiveRemoteNotification:dictionary];
            
            if([dictionary objectForKey:@"PriceListUpdate"])
            {
                startUpdatePriceList = TRUE;
            }
            else
                NSLog(@"Don't start price list update");
		}
	}
    
   // [Functions deleteFile:kNotificationsFile];
    
    NotificationParser *nParser = [[NotificationParser alloc] init];
    
   // NSString *deviceToken = [NotificationSettings getDeviceToken];
   NSString *deviceToken = @"c6aa4f184da5763a6194cd5acbe93a5136d1d66f6c70402645a6120cfdea1438";
    if(deviceToken != nil)
        [nParser getNotifications:deviceToken];
    
    [self setBadgeCount];
    return YES;
}

-(BOOL)downloadPriceIfNeeded{
    /*if ([Database checkForUpdates]) {
        return YES;
    }
    return NO;*/
    return [PriceListData isDownloadRequired];
}

-(void)priceListDownloadFinished:(NSInteger)type{
    [priceDownloader.view removeFromSuperview];		
	[priceDownloader release]; 
    
    if (type==1) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        
        NSString *date = [NSString stringWithFormat:@"%d-%d-%d",[components month],[components day],[components year]];    
        NSString *ctime = [NSString stringWithFormat:@"%d:%d:%d",[components hour],[components minute],[components second]];
        
        
        NSString *time = [NSString stringWithFormat:@"%@ %@",date,ctime];
        
        [Database updateCheckerTable:[Database getDBPath] arg2:time updateFlag:@"YES"];
    }
    
    
}

-(void)webserviceCallFinished
{	
	
}

-(void)webserviceCallLoginFinished:(NSMutableArray *)results{
}


+ (AppDelegate*) getAppDelegate
{
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}



-(void)showActivityIndicator:(UIViewController*)controller
{
	if (activityView ==nil)
	{
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	}
	[activityView setCenter:CGPointMake(controller.view.bounds.size.width/2.0, controller.view.bounds.size.height/2.0)]; 
	[controller.view addSubview:activityView]; 
	[activityView startAnimating];
}

-(void)stopActivityIndicator:(UIViewController*)controller
{
	if (activityView ==nil)
	{
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	}
	[activityView stopAnimating];
	[activityView removeFromSuperview];	
}	


- (void) showMoreViewC
{
	aMoreViewC = [[MoreViewC alloc] initWithNibName:@"MoreViewC" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:aMoreViewC];
	[self.window addSubview:navigationController.view];
}

-(void)hideTabBar
{
    [UITabBar beginAnimations:@"TabBarFade" context:nil];
    //self.tabBarController.tabBar.alpha = 1;
    [self.tabBarController.tabBar setHidden:YES];
    [UITabBar setAnimationCurve:UIViewAnimationCurveEaseIn]; 
    [UITabBar setAnimationDuration:1.5];
    //self.tabBarController.navigationBar.alpha = 0.1;
    [UITabBar commitAnimations];
}

-(void)showTabBar
{
    [UITabBar beginAnimations:@"TabBarFade" context:nil];
   // self.tabBarController.tabBar.alpha = 0;
    [self.tabBarController.tabBar setHidden:NO];
    [UITabBar setAnimationCurve:UIViewAnimationCurveEaseIn]; 
    [UITabBar setAnimationDuration:1.5];
    //self.tabBarController.navigationBar.alpha = 0.1;
    [UITabBar commitAnimations];
}

-(void)setBadgeCount
{
    NSInteger count = self.tabBarController.tabBar.items.count;
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badgeCount > 0)
        [[self.tabBarController.tabBar.items objectAtIndex:count - 1] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCount]];
    else
        [[self.tabBarController.tabBar.items objectAtIndex:count - 1] setBadgeValue:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if(startUpdatePriceList)
    {
        startUpdatePriceList = FALSE;
        NSLog(@"Start price list update");
        LoginViewController *l = [[LoginViewController alloc] init];
        [l startUpdatePriceList];
        [l release];
        l = NULL;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [Database closeDatabase];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


-(void)copyDatabaseIfNeeded
{
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	if(!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"RapnetDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		if (!success) 
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}


-(NSString *)getDBPath
{
	NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"RapnetDB.sqlite"];
}

-(void)onReceiveRemoteNotification:(NSDictionary*)userInfo
{
#if !TARGET_IPHONE_SIMULATOR
    
    //2[Functions deleteFile:kNotificationsFile];
    //NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary: [Functions readFromFile:kNotificationsFile] copyItems:YES];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:userInfo copyItems:TRUE];
    [tempDic setValue:[NSDate date] forKey:kNotificationDateKey];
    [NotificationsHelper addNotification:tempDic];
    //[curDic setValue:tempDic forKey:[NSString stringWithFormat:@"%d", [curDic count] + 1]];
    
    //  [Functions writeToFile:curDic fileName:kNotificationsFile];
    
    //NSMutableDictionary *curDic1 =  [[NSMutableDictionary alloc] initWithDictionary: [Functions readFromFile:kNotificationsFile] copyItems:YES];
    
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	
    if([userInfo objectForKey:@"PriceListUpdate"])
    {
        startUpdatePriceList = TRUE;
        
    }
    else
        NSLog(@"Don't start price list update");
    
    [UIApplication sharedApplication].applicationIconBadgeNumber += [[apsInfo objectForKey:@"badge"] integerValue];
	
    
    [self setBadgeCount];
    
    
    
    
    
#endif
    
}

-(void)registerDevice:(id)devToken
{
//#if !TARGET_IPHONE_SIMULATOR
    
	
    /*
     // Build URL String for Registration
     // !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
     // !!! SAMPLE: "secure.awesomeapp.com"
     NSString *host = @"server.local/apns";
     
     // !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED
     // !!! ( MUST START WITH / AND END WITH ? ).
     // !!! SAMPLE: "/path/to/apns.php?"
     NSString *urlString = [NSString stringWithFormat:@"/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@", @"register", appName,appVersion, deviceUuid, deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound];
     
     // Register the Device Data
     // !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
     NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSLog(@"Register URL: %@", url);
     NSLog(@"Return Data: %@", returnData);
     */
	
//#endif

}

#pragma mark - Show Screens
-(void)showNewsScreen
{
	[navigationController release];
	NewsViewController *newsView=[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:newsView];
	[self.window addSubview:navigationController.view];
	[newsView release];
}

/*
 * --------------------------------------------------------------------------------------------------------------
 *  BEGIN APNS CODE
 * --------------------------------------------------------------------------------------------------------------
 */

/**
 * Fetch and Format Device Token and Register Important Information to Remote Server
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [NotificationSettings setDeviceToken:deviceToken];
    [RegisterDevice registerDevice];
   // [self performSelectorInBackground:@selector(registerDevice:) withObject:devToken];
	//[NSThread detachNewThreadSelector:@selector(registerDevice) toTarget:nil withObject:devToken];
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
//#if !TARGET_IPHONE_SIMULATOR
	
	NSLog(@"Error in registration. Error: %@", error);
	
//#endif
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[self onReceiveRemoteNotification:userInfo];
}

/*
 * --------------------------------------------------------------------------------------------------------------
 *  END APNS CODE
 * --------------------------------------------------------------------------------------------------------------
 */


@end
