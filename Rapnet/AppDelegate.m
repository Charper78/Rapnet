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
    
 //   [Functions deleteFile:kNotificationsFile];
    
    [self copyDatabaseIfNeeded];
    [Database openDatabase];
    [Database fetchWorkAreaDiamonds];
	//[StoredData sharedData].isUserAuthenticated=FALSE;
    //[StoredData sharedData].loginPriceFlag=FALSE;
    //[StoredData sharedData].loginRapnetFlag=FALSE;
    [StoredData sharedData].selectedTabBfrLogin = -1;
    [StoredData sharedData].priceAlertFlag = FALSE;
	
	NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
	[NSURLCache setSharedURLCache:sharedCache];
	[sharedCache release];
	
    if([Reachability reachable])
    {
        [Functions loginAll];
        /*NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *objUserName = [prefs stringForKey:@"UserName"];
        NSString *objPassword = [prefs stringForKey:@"Password"]; 
        if (objUserName.length > 0) 
        {
            //NSLog (@"objUserName %@",objUserName);
            //NSLog (@"objPassword %@",objPassword);
            loginParser=[[LoginParser alloc]init];
            loginParser.delegate = self;
            [loginParser authenticateWithUserName:objUserName password:objPassword];
        
            objLoginParser=[[LoginPriceParser alloc]init];
            objLoginParser.delegate = self;
            [objLoginParser authenticateWithUserName:objUserName password:objPassword];
        }*/
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
	
	// Clear application badge when app launches
	//application.applicationIconBadgeNumber = 0;
    
   /* NSInteger count = self.tabBarController.tabBar.items.count;
    
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badgeCount > 0)
        [[self.tabBarController.tabBar.items objectAtIndex:count - 1] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCount]];
    */
    if (launchOptions != nil)
	{
        NSLog(@"launchOptions: %@", launchOptions);
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self onReceiveRemoteNotification:dictionary];
		}
	}
    
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
	/*arrLogin = [loginParser getResults];
	if(arrLogin.count>0)
	{
		[StoredData sharedData].isUserAuthenticated=TRUE;
		[StoredData sharedData].strTicket=[NSString stringWithFormat:@"%@",[[arrLogin objectAtIndex:0]objectForKey:@"Ticket"]];
	}*/
}

-(void)webserviceCallLoginFinished:(NSMutableArray *)results{
    /*arrPriceLogin = results;//[objLoginParser getResults];
	if(arrPriceLogin.count>0)
	{
        NSString *priceTicket = [NSString stringWithFormat:@"%@",[[arrLogin objectAtIndex:0]objectForKey:@"Ticket"]];
        
        [StoredData sharedData].loginPriceFlag=TRUE;
        [StoredData sharedData].strPriceTicket= [NSString stringWithFormat:@"%@" ,priceTicket];
        [StoredData sharedData].strRapnetTicket =[NSString stringWithFormat:@"%@" ,priceTicket]; 
	}*/
    //if([Functions canView:L_Prices])
    //    [StoredData sharedData].loginPriceFlag=TRUE;
    
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
	
    [UIApplication sharedApplication].applicationIconBadgeNumber += [[apsInfo objectForKey:@"badge"] integerValue];
	
    
    [self setBadgeCount];
    
    
    
    
    
#endif
    
}

-(void)registerDevice:(id)devToken
{
#if !TARGET_IPHONE_SIMULATOR
    
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
	// Set the defaults to disabled unless we find otherwise...
	BOOL *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? TRUE : FALSE;
	BOOL *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? TRUE : FALSE;
	BOOL *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? TRUE : FALSE;
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid;
	if ([dev respondsToSelector:@selector(uniqueIdentifier)])
    {
        //identifierForVendor
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            deviceUuid = [dev.identifierForVendor UUIDString];
        }
        else
            deviceUuid = dev.uniqueIdentifier;
    }
	else {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		id uuid = [defaults objectForKey:@"deviceUuid"];
		if (uuid)
			deviceUuid = (NSString *)uuid;
		else {
			CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
			deviceUuid = (__bridge NSString *)cfUuid;
			CFRelease(cfUuid);
			[defaults setObject:deviceUuid forKey:@"deviceUuid"];
		}
	}
	NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
	
    RegisterDeviceParser *reg = [[RegisterDeviceParser alloc] init];
    BOOL r = [reg registerDevice:appName appVersion:appVersion clientID:nil deviceUid:deviceUuid deviceToken:deviceToken deviceName:deviceName deviceModel:deviceModel deviceVersion:deviceSystemVersion pushBadge:pushBadge pushAlert:pushAlert pushSound:pushSound];
    NSLog(@"Return Data: %@", [Functions boolToString: r]);
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
	
#endif

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
    [self performSelectorInBackground:@selector(registerDevice:) withObject:devToken];
	//[NSThread detachNewThreadSelector:@selector(registerDevice) toTarget:nil withObject:devToken];
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
#if !TARGET_IPHONE_SIMULATOR
	
	NSLog(@"Error in registration. Error: %@", error);
	
#endif
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
