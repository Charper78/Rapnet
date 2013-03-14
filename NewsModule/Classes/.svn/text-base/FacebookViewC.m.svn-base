//
//  FacebookViewC.m
//  FoodCashing
//
//  Created by Chandu on 11/16/10.
//  Copyright 2010 TechAhead. All rights reserved.
//

#import "FacebookViewC.h"

#import "FBConnect.h"
#import "FBRequest.h"

#define kAppId @"d21dbad11790c3e69fdd22fb97f71173"
@implementation FacebookViewC

@synthesize loginDelegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_permissions =  [[NSArray arrayWithObjects: 
						  @"read_stream", @"offline_access",@"email",nil] retain];
		_facebook = [[Facebook alloc] init];
		_fbButton = [[FBLoginButton alloc] init];
		_fbButton.isLoggedIn   = NO;
		emailBool = NO;
		friendsBool = NO;
	}
    return self;
}


- (void) callLoginGo
{
	//[loginDelegate GO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
}

#pragma mark Facebook

- (void) login 
{
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
}

- (void) logout 
{
	[_facebook logout:self]; 
}

-(void) facebookButtonClicked
{
	
	if (_fbButton.isLoggedIn) 
	{
		[self logout];
	} 
	else 
	{
		[self login];
	}
	
	
}

-(void) fbDidLogin 
{
	_fbButton.isLoggedIn         = YES;
	//[_fbButton updateImage];
	[self getUserInfo];
	
}
- (void)fbDidNotLogin:(BOOL)cancelled 
{
	//NSLog(@"did not login");
}

-(void) fbDidLogout 
{
	_fbButton.isLoggedIn         = NO;
	//[_fbButton updateImage];
}

#pragma mark Facebook delegate
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	//NSLog(@"received response");
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
}

- (void)request:(FBRequest*)request didLoad:(id)result 
{
	if ([result isKindOfClass:[NSArray class]])
	{
		result = [result objectAtIndex:0]; 
	}
	if ([result objectForKey:@"owner"]) 
	{
	} 
	else 
	{
		//[self.label setText:[result objectForKey:@"name"]];
		
		if(emailBool == YES)
		{
			
			
			[self getFriends];
			//[loginDelegate GO];

		}
		if(friendsBool == YES)
		{
			//([FoodCashingAppDelegate getAppdelegate]).fbFriendArray = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
			////NSLog(@"%@",([FoodCashingAppDelegate getAppdelegate]).fbFriendArray);
			
			_userInfo = [[UserInfo alloc] initializeWithFacebook:_facebook andDelegate:self];
			[_userInfo requestAllInfo];
			
		}
	}
}

- (void)dialogDidComplete:(FBDialog*)dialog
{
	
}
- (void) getUserInfo
{
	emailBool = YES;
	friendsBool = NO;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
	//[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(getFriends) userInfo:nil repeats:NO];
}

-(void) getFriends
{
	friendsBool = YES;
	emailBool = NO;
	[_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}


#pragma mark post to wall

- (void) publish:(NSString *)str
{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   @"Rapnet",@"text",@"http://www.rapnet.com/",@"href", nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"Rapnet", @"name",
								@"Rapnet", @"caption",
								str, @"description",
								@"http://www.rapnet.com/", @"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"Share on Facebook",  @"user_message_prompt",
								   actionLinksStr, @"action_links",
								   attachmentStr, @"attachment",
								   nil];
	
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
	
	
}

- (void)userInfoDidLoad{}
- (void)userInfoFailToLoad{}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[_fbButton release];
	[_facebook release];
	[_permissions release];
	[_userInfo release];
    [super dealloc];
}


@end
