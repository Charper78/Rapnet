//
//  OAuthTwitterDemoViewController.m
//  OAuthTwitterDemo
//
//  Created by Ben Gottlieb on 7/24/09.
//  Copyright Stand Alone, Inc. 2009. All rights reserved.
//

#import "OAuthTwitterDemoViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import <QuartzCore/QuartzCore.h>


#define kOAuthConsumerKey				@"cjbvhIcGGa3xLsjxQocQ"		//REPLACE ME
#define kOAuthConsumerSecret			@"ZS0yvKOhavMpW3U4bGZR76XXqvS1OYcakLG52LhU8Q"		//REPLACE ME


@implementation OAuthTwitterDemoViewController
@synthesize aMsg;


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];

	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	//NSLog(@"Authenicated for %@", username);
	//[_engine sendUpdate: [NSString stringWithFormat: @" Updated. %@", [NSDate date]]];
	[_engine sendUpdate:aMsg];//[[NSString stringWithFormat:@"Foodcaching for %@ at %@ %@ come and join me!!",[FoodCashingAppDelegate getAppdelegate].nuggetName,[FoodCashingAppDelegate getAppdelegate].restName,[FoodCashingAppDelegate getAppdelegate].restAddress]];
	
	//[obj release];
	UIAlertView* aAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You successfully tweeted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aAlert show];
	UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
	theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	CGSize theSize = [aAlert frame].size;
	
	UIGraphicsBeginImageContext(theSize);    
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
	theImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	for (UIView *sub in [aAlert subviews])
	{
		if ([sub class] == [UIImageView class] && sub.tag == 0) {
			[sub removeFromSuperview];
			break;
		}
	}
	[[aAlert layer] setContents:(id)theImage.CGImage];
	[aAlert release];

}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//=============================================================================================================================
#pragma mark ViewController Stuff
- (void)dealloc {
	[_engine release];
    [super dealloc];
}

- (void) authenticate:(id)viewC 
{
	if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	//[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	UIViewController*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[viewC presentModalViewController: controller animated: YES];
	
	else {
		//[_engine sendUpdate:aMsg];
		[_engine sendUpdate:aMsg];
	
		UIAlertView* aAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You successfully tweeted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[aAlert show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [aAlert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [aAlert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[aAlert layer] setContents:(id)theImage.CGImage];
		[aAlert release];
	 }
}
- (void) viewDidAppear: (BOOL)animated {
	if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	//[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	//if (controller) 
		[self presentModalViewController: controller animated: YES];
	//
//	else {
//		[_engine sendUpdate: [NSString stringWithFormat:@"Hey I am Foodcaching for %@ at restaurant %@ %@. Come and join me!",[FoodCashingAppDelegate getAppdelegate].nuggetName,[FoodCashingAppDelegate getAppdelegate].restName,[FoodCashingAppDelegate getAppdelegate].restAddress]];
//		NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Twitter",kEvent, [NSNumber numberWithInt:kIncreasePoint], keyRequestType, nil];
//		Server *obj = [[Server alloc] init];
//		[obj sendRequestToServer:aDic];
//		
//	}
	

}


@end
