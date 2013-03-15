//
//  LoginViewController.m
//  Rapnet
//
//  Created by Richa on 6/6/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "WebSiteController.h"
#import "funcClass.h"

@implementation LoginViewController
@synthesize strSucceed;//, pvProgress;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
    }
    IsDownloadViewVisible = NO;
    
    [AnalyticHelper sendView:@"Settings"];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initReachability];
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	isKeyBoardDown = YES;
	/*if(![StoredData sharedData].isUserAuthenticated && ![StoredData sharedData].loginPriceFlag){
		logOutBttn.hidden =YES;
		logInBttn.hidden=NO;
	}
	
	else if([StoredData sharedData].isUserAuthenticated || [StoredData sharedData].loginPriceFlag){
		logOutBttn.hidden =NO;
		logInBttn.hidden=YES;
	}*/
    
    [sUse10crts setOn:[StoredData sharedData].use10crts animated:YES];
    
    if ([Functions isLogedIn]) {
        logOutBttn.hidden =NO;
		logInBttn.hidden=YES;
    }
    else
    {
        logOutBttn.hidden =YES;
		logInBttn.hidden=NO;
    }
		
	loginScroll.contentSize = CGSizeMake(0,350);
	[loginScroll setShowsHorizontalScrollIndicator:NO];
	[loginScroll setShowsVerticalScrollIndicator:NO];
    
    
    /*NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	objUserName.text = [prefs stringForKey:@"UserName"];
	objPassword.text = [prefs stringForKey:@"Password"]; */
    objUserName.text = [LoginHelper getUserName];
    objPassword.text = [LoginHelper getPassword];
    
	if (objUserName.text.length > 0) 
	{
		btnRememPwd.selected = YES;
		UIImage *btnImage = [UIImage imageNamed:@"check.png"];
		[btnRememPwd setImage:btnImage forState:UIControlStateNormal];
	}
    
    
    NSInteger badgeCount =  [UIApplication sharedApplication].applicationIconBadgeNumber;
    badgeCount = 20;
    CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", badgeCount]
                                                   withStringColor:[UIColor whiteColor]
                                                    withInsetColor:[UIColor redColor]
                                                    withBadgeFrame:YES
											   withBadgeFrameColor:[UIColor whiteColor]
														 withScale:0.8
													   withShining:YES];
    //float x = btnNotifications.frame.size.width - (badge.frame.size.width / 2);;
    //float y = btnNotifications.frame.origin.y - (badge.frame.size.height / 2);
    float x = btnNotifications.frame.origin.x + btnNotifications.frame.size.width - badge.frame.size.width + 10;
    float y = btnNotifications.frame.origin.y - (badge.frame.size.height / 2);
    
    [badge setFrame:CGRectMake(x, y, badge.frame.size.width, badge.frame.size.height)];
    //[badge setFrame:CGRectMake(self.view.frame.size.width/2-badge.frame.size.width/2+badge.frame.size.width/2, 110, badge.frame.size.width, badge.frame.size.height)];
    [loginScroll addSubview:badge];
    
    //[self.view addSubview:badge];

}

-(void)initReachability
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
    //remoteHostLabel.text = [NSString stringWithFormat: @"Remote Host: %@", @"www.apple.com"];
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifier];
	[self updateInterfaceWithReachability: hostReach];
    
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        //BOOL connectionRequired= [curReach connectionRequired];
        
        switch (netStatus)
        {
            case NotReachable:
            {
                isReachable = NO;
                break;
            }
                
            case ReachableViaWWAN:
            {
                isReachable = YES;
                
                break;
            }
            case ReachableViaWiFi:
            {
                isReachable = YES;
                break;
            }
        }
        
    }
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

-(void) viewDidAppear:(BOOL)animated
{
	//NSString *s = [Database getLastUpdateDate];
    //lblPricesUpdated.text = s;
    //lblPricesUpdated.text = [Functions dateFormat:s format:@"MM/dd/yyyy HH:mm"];;
    //
    webCallEndFlag[0] = FALSE;
    webCallEndFlag[1] = FALSE;
    
    [self setPriceListLastUpdated];
}



- (NSString*)validateTextFields
{
	if ([objUserName.text isEqualToString:@"(null)"] || objUserName.text == nil || [objUserName.text isEqualToString:@""] ) 
	{
		return @"Enter the user name";
	}
	else if([objPassword.text isEqualToString:@"(null)"] || objPassword.text == nil || [objPassword.text isEqualToString:@""] ) 
	{
		return @"Enter the password";
	}
	return nil;
}


-(IBAction)loginBtn:(id)sender
{
    webCallEndFlag[0] = FALSE;
    webCallEndFlag[1] = FALSE;
    
    //if([Reachability reachableAndAlert] == NO)
    //    return;
    
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
    
	//NSString *message = [[NSString alloc]init ];
	NSString *message = [self validateTextFields];
	if (message == nil)
	{
		UIButton*  aBtn = btnRememPwd;//(UIButton*)[self.view viewWithTag:55];
		if (aBtn.selected)
		{
            //NSLog(@"%@",objUserName.text);
			/*NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
			[SaveData setObject:objUserName.text forKey:@"UserName"];
			[SaveData setObject:objPassword.text forKey:@"Password"];
			[SaveData synchronize];*/
            
		}
        
    [LoginHelper setUserNameAndPassword:objUserName.text pass:objPassword.text save:aBtn.selected];
    
        [Functions loginAll];
        
        if ([Functions isLogedIn]) {
            alert = [[UIAlertView alloc] initWithTitle:@"\n\nLogin Successful" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];
            theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            CGSize theSize = [alert frame].size;
            
            UIGraphicsBeginImageContext(theSize);
            [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
            theImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            for (UIView *sub in [alert subviews])
            {
                if ([sub class] == [UIImageView class] && sub.tag == 0) {
                    [sub removeFromSuperview];
                    break;
                }
            }
            [[alert layer] setContents:(id)theImage.CGImage];
            
            [NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo:nil repeats:NO];
            
            logOutBttn.hidden =NO;
            logInBttn.hidden=YES;
            
            [objUserName resignFirstResponder];
            [objPassword resignFirstResponder];
            
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"\n\nYour login attempt was not successful." message:@"Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];
            theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            CGSize theSize = [alert frame].size;
            
            UIGraphicsBeginImageContext(theSize);
            [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
            theImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            for (UIView *sub in [alert subviews])
            {
                if ([sub class] == [UIImageView class] && sub.tag == 0) {
                    [sub removeFromSuperview];
                    break;
                }
            }
            [[alert layer] setContents:(id)theImage.CGImage];
            
            [NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(aTimer:)userInfo:nil repeats:NO];
        }
	}
	else
	{
		UIAlertView* warnMsg = [[UIAlertView alloc]initWithTitle:message message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[warnMsg show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [warnMsg frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [warnMsg subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[warnMsg layer] setContents:(id)theImage.CGImage];
		
		
		[warnMsg release];
	}
	
	//[message release];
}




-(BOOL)checkAllWebSrviceEnded{
    BOOL flag = TRUE;
    for (int i = 0; i<2; i++) {
        if (!webCallEndFlag[i]) {
            flag = FALSE;
        }
    }
    
    if (!flag) {
        return FALSE;
    }
    
    return TRUE;
}

-(void)serviceCallFinished
{	
	arrForgotService = [objForgot getResults];
	if(arrForgotService.count>0)
	{
		self.strSucceed=[NSString stringWithFormat:@"%@",[[arrForgotService objectAtIndex:0]objectForKey:@"Succeed"]];
	}
	
	if([self.strSucceed isEqual:@"true"])
	{
		alert = [[UIAlertView alloc] initWithTitle:@"\n\nYou will receive an email shortly with your password." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[alert show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [alert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [alert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[alert layer] setContents:(id)theImage.CGImage];
		
		[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo:nil repeats:NO];
	}
	else {
		alert = [[UIAlertView alloc] initWithTitle:@"\n\nYour email id is invaild" message:@"Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[alert show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [alert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [alert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[alert layer] setContents:(id)theImage.CGImage];
		
		[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(aTimer:)userInfo:nil repeats:NO];
	}
}


#pragma mark timer
- (void)theTimer:(NSTimer*)timer 
{ 
	[alert dismissWithClickedButtonIndex:0 animated:YES];
	//[[self navigationController] popViewControllerAnimated:YES];
    
    UITabBarController *tabController = [AppDelegate getAppDelegate].tabBarController;
    
    NSInteger tab = [StoredData sharedData].selectedTabBfrLogin;
    
    if (tab==0 || tab==1 || tab==3) {
        [StoredData sharedData].selectedTabBfrLogin = -1;
        //NSLog(@"typghwhe=======%d",tab);
        [tabController setSelectedIndex:tab];
    }
    
    
    
	[theTimer invalidate];
	[theTimer release];
	btnForgotPwd.enabled=YES;
    
    
}


- (void)aTimer:(NSTimer*)timer 
{ 
	[alert dismissWithClickedButtonIndex:0 animated:YES];
	[aTimer invalidate];
	[aTimer release];
	btnForgotPwd.enabled=YES;
}

-(IBAction)logOutBttn:(id)sender
{
	logOutBttn.hidden =YES;
	logInBttn.hidden=NO;
	
	//[StoredData sharedData].isUserAuthenticated=FALSE;
    //[StoredData sharedData].loginPriceFlag=FALSE;
    //[StoredData sharedData].loginRapnetFlag=FALSE;
    //[StoredData sharedData].strPriceTicket = [NSString stringWithFormat:@""];
    //[StoredData sharedData].strRapnetTicket = nil;
    [Functions logout];
    
    /*NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"UserName"];
    [prefs removeObjectForKey:@"Password"];
    [prefs synchronize];
    */
    
    objUserName.text = @"";
    objPassword.text = @"";
    
    btnRememPwd.selected = NO;
    UIImage *btnImage = [UIImage imageNamed:@"uncheck.png"];
    [btnRememPwd setImage:btnImage forState:UIControlStateNormal];
    
    alert = [[UIAlertView alloc] initWithTitle:@"\n\nLogout Successful" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
	theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	CGSize theSize = [alert frame].size;
	
	UIGraphicsBeginImageContext(theSize);    
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
	theImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	for (UIView *sub in [alert subviews])
	{
		if ([sub class] == [UIImageView class] && sub.tag == 0) {
			[sub removeFromSuperview];
			break;
		}
	}
	[[alert layer] setContents:(id)theImage.CGImage];
	
	[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo:nil repeats:NO];
}

-(IBAction)sendBtn
{
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
    
	btnForgotPwd.enabled=NO;
	objForgot=[[ForgotPasswordParser alloc]init];
	objForgot.delegate = self;
	[objForgot GetForgotPassword:objForgotPw.text];
}
-(IBAction)signupBtn
{
	RegisterViewController *signUp =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
	[[self navigationController] pushViewController:signUp animated:YES];
	[signUp release];
	signUp=nil;
	
}

-(IBAction)sUse10crts_toggle:(id)sender
{
    UISwitch *s = (UISwitch*)sender;
    [Functions saveBoolData:(id)s.isOn key:kUse10crts];
    [StoredData sharedData].use10crts = s.isOn;
}

-(IBAction)chkBtn:(id)sender
{
	UIButton *aBtn = (UIButton *)sender;
	aBtn.tag=55;
	BOOL isSel = aBtn.selected;
	if (isSel == YES)
	{ 
		aBtn.selected = NO;
		UIImage *btnImage = [UIImage imageNamed:@"uncheck.png"];
		[aBtn setImage:btnImage forState:UIControlStateNormal];
        [LoginHelper resetSavedUserNameAndPassword];
		//
	}
	else 
	{
		aBtn.selected = YES;
		UIImage *btnImage = [UIImage imageNamed:@"check.png"];
		[aBtn setImage:btnImage forState:UIControlStateNormal];
        if ([Functions isLogedIn]) {
            [LoginHelper saveUserNameAndPassword:objUserName.text pass:objPassword.text];
        }
        
        //
	}

}


-(IBAction)newsToggleBtn:(id)sender
{
	UIButton *toggle = (UIButton *)sender;
	BOOL isSelected = [toggle isSelected];
	toggle.selected = !isSelected;
	if( isSelected == TRUE)
	{
		UIImage *btnImage = [UIImage imageNamed:@"on.png"];
		[toggle setImage:btnImage forState:UIControlStateNormal];
	}
	else {
		UIImage *btnImage = [UIImage imageNamed:@"off.png"];
		[toggle setImage:btnImage forState:UIControlStateNormal];
		
	}
}


-(IBAction)priceToggleBtn:(id)sender
{
	UIButton *toggle = (UIButton *)sender;
	BOOL isSelected = [toggle isSelected];
	toggle.selected = !isSelected;
	if( isSelected == TRUE)
	{
		UIImage *btnImage = [UIImage imageNamed:@"off.png"];
		[toggle setImage:btnImage forState:UIControlStateNormal];
	}
	else {
		UIImage *btnImage = [UIImage imageNamed:@"on.png"];
		[toggle setImage:btnImage forState:UIControlStateNormal];
	}
	
}
-(IBAction)resetBtn
{
    [LT_Clarity deleteAll];
    [LT_Cut deleteAll];
    [LT_Color deleteAll];
    [LT_FancyColor deleteAll];
    [LT_FancyColorIntensity deleteAll];
    [LT_FancyColorOvertone deleteAll];
    [LT_Polish deleteAll];
    [LT_Sym deleteAll];
    [LT_Fluor deleteAll];
    [LT_Lab deleteAll];

     
	objUserName.text = nil;
	objPassword.text = nil;
	objForgotPw.text = nil;
	//[StoredData sharedData].isUserAuthenticated=FALSE;
    //[StoredData sharedData].loginPriceFlag=FALSE;
	//[StoredData sharedData].loginRapnetFlag=FALSE;
    //[StoredData sharedData].strPriceTicket = [NSString stringWithFormat:@""];
    //[StoredData sharedData].strRapnetTicket = nil;
    [Functions logout];
    
	[priceSwitch setOn:NO];
	[newsSwitch setOn:NO];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRoundPriceListDate];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:kPearPriceListDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	btnRememPwd.selected = NO;
	UIImage *btnImage = [UIImage imageNamed:@"uncheck.png"];
	[btnRememPwd setImage:btnImage forState:UIControlStateNormal];
	
	[funcClass showAlertView:@"Your settings have been reset" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    logInBttn.hidden =NO;
    logOutBttn.hidden=YES;
	
}

-(IBAction)cancelBtn
{
	[[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	loginScroll.frame = CGRectMake(0,35,320,350);
	
	
	if(textField.tag == 1)
	{
		loginScroll.contentSize = CGSizeMake(0,350);
		[self setViewMovedUp:NO coordinateY:0];
		
	}
	return YES;
}


#pragma mark textFieldDidBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	
	if(textField.tag == 1)
	{
		if(isKeyBoardDown)
		{
			loginScroll.contentSize = CGSizeMake(0,350);
			[self setViewMovedUp:YES coordinateY:100];
		}
	}
}

#pragma mark setViewMovedUp
-(void)setViewMovedUp:(BOOL)movedUp coordinateY:(NSInteger)coordinateY
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
	CGRect rect = loginScroll.frame;
	
	if(movedUp)
	{
		isKeyBoardDown = NO;
		
		rect.origin.y -= coordinateY;
		rect.size.height += coordinateY;
	}
	
	else
	{
		isKeyBoardDown = YES;
		rect.origin.y += coordinateY;
		rect.size.height -= coordinateY;
	}
	
	loginScroll.frame = rect;
	
	[UIView commitAnimations];
}

#pragma mark keyboardDidHide
-(void) keyboardDidHide:(NSNotification *) notification 
{
	
	loginScroll.frame = CGRectMake(0,35,320,350);
	if(!isKeyBoardDown)
	{
		isKeyBoardDown = YES;
	}
}

-(IBAction)privacyPolicyLink
{
	WebSiteController *website=[[WebSiteController alloc]initWithNibName:@"WebSiteController" bundle:nil];
	//website.chkUrl = YES;
    website.strUrl = @"http://www.diamonds.net/legal/PrivacyPolicy.aspx";
    
	//[[self navigationController] pushViewController:website animated:YES];
	[self.view addSubview: website.view];
    
	//[website release];
	//website = nil;
}
-(IBAction)termsOfUseLink
{
	WebSiteController *website=[[WebSiteController alloc]initWithNibName:@"WebSiteController" bundle:nil];
	//website.chkUrl = NO;
    website.strUrl = @"http://www.diamonds.net/legal/TermsOfUse.aspx";
    
	//[[self navigationController] pushViewController:website animated:YES];
	[self.view addSubview:website.view];
	//[website release];
	//website = nil;
}

/*-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}*/

-(void)showLoadingScreen
{
    if(IsDownloadViewVisible == NO)
    {
        [self.view.window addSubview:vDownload];
        IsDownloadViewVisible = YES;
    }
}

-(void)hideLoadingScreen
{
    if(IsDownloadViewVisible)
    {
        [vDownload removeFromSuperview];
        IsDownloadViewVisible = NO;
    }
}

-(IBAction)btnUpdatePrices_Clicked{
    
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
    
    //[Database deleteAllPriceList];
    
    if([Functions canView:L_Prices])
    {
        if ([Functions canView:L_Prices])
        {
            pvProgress.progress = 0.0f;
            [self showLoadingScreen];
            [self performSelectorInBackground:@selector(downloadPrices) withObject:nil];
        }
    }
    else
    {
        [self.view addSubview:[StoredData sharedData].blackScreen];
        
        //  NSLog(@"price not downloafing");
        
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
        [self.view addSubview:customAlert1.view];
        view = customAlert1.view;
        [self initialDelayEnded];
    }
}
-(void)downloadPrices
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    GetPriceList *l = [[GetPriceList alloc] init];
    l.delegate = self;
    [l download];
    
    [self hideLoadingScreen];
    
    if(isReachable)
    {
        
        [self performSelectorOnMainThread:@selector(callGetPriceListDate) withObject:nil waitUntilDone:YES];
        //[self performSelectorOnMainThread:@selector(callGetPriceListDate:) withObject:[NSNumber numberWithBool:FALSE] waitUntilDone:YES];
        //[self callGetPriceListDate:YES];
        //[self callGetPriceListDate:NO];
    }
    
    [pool release];
}

-(void)callGetPriceListDate
{
    [self callGetPriceListDate:YES];
    [self callGetPriceListDate:NO];
}

-(void)setLoaderProgress
{
    float curProgress = pvProgress.progress + 1.0 / ((1900) * 2);
    if ([Functions getSystemVersionAsAnInteger] >= __IPHONE_5_0) {
        [pvProgress setProgress: curProgress animated:TRUE];
        //NSLog(@"Cur Progress = %f", curProgress);
    }
    else
        pvProgress.progress = curProgress;

}

-(void)increaseProgress
{
    [self performSelectorOnMainThread:@selector(setLoaderProgress) withObject:nil waitUntilDone:YES];
}

-(void)setLoaderProgressWithAmount:(id)arg
{
    float curProgress = pvProgress.progress + [arg floatValue] / ((1900) * 2);
    if ([Functions getSystemVersionAsAnInteger] >= __IPHONE_5_0) {
        [pvProgress setProgress: curProgress animated:TRUE];
        //NSLog(@"Cur Progress = %f", curProgress);
    }
    else
        pvProgress.progress = curProgress;
    
}

-(void)increaseProgress:(NSNumber*)amount
{
    [self performSelectorOnMainThread:@selector(setLoaderProgressWithAmount:) withObject:amount waitUntilDone:YES];
}
-(void)initialDelayEnded
{
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
	view.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)alertUpdatePriceListFinished:(int)type{
    [[StoredData sharedData].blackScreen removeFromSuperview];
    if (customAlert2) {
        [customAlert2.view removeFromSuperview];
        [customAlert2 release];
        customAlert2 = nil;
    }
    
    if (type==1) {
        
        BOOL internetFlag = TRUE;
        //Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
        //NetworkStatus internetStatus = [reach currentReachabilityStatus];
        
        //if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        if(isReachable == NO)
        {
            internetFlag = FALSE;
            
        }
        
        
        if (internetFlag) {
            //[appDelegate showActivityIndicator:self];
            
            //if ([[StoredData sharedData].strPriceTicket length]==0) {
            if ([Functions canView:L_Prices] == NO) {
                [self.view addSubview:[StoredData sharedData].blackScreen];
                [appDelegate stopActivityIndicator:self];
                
                if (customAlert1) {
                    [customAlert1.view removeFromSuperview];
                    [customAlert1 release];
                    customAlert1 = nil;
                }
                
                [StoredData sharedData].priceAlertFlag = TRUE;
                
                customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
                [self.view addSubview:customAlert1.view];        
                view = customAlert1.view;
                [self initialDelayEnded];
                
                
                
                
            }else{
                [self.view addSubview:[StoredData sharedData].blackScreen];
                
                priceDownloader=[[PriceListDownloader alloc]initWithNibName:@"PriceListDownloader" bundle:nil];
                priceDownloader.delegate = self;
                [[[UIApplication sharedApplication] keyWindow] addSubview:priceDownloader.view];
                
                //[self.view addSubview:priceDownloader.view];
                //  [self.view.window addSubview:priceDownloader.view];
                // [[[UIApplication sharedApplication] keyWindow] addSubview:vDownload];
            }
            
            
        }else{
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [myAlert show];
            
            UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
            theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            CGSize theSize = [myAlert frame].size;
            
            UIGraphicsBeginImageContext(theSize);    
            [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
            theImage = UIGraphicsGetImageFromCurrentImageContext();    
            UIGraphicsEndImageContext();
            for (UIView *sub in [myAlert subviews])
            {
                if ([sub class] == [UIImageView class] && sub.tag == 0) {
                    [sub removeFromSuperview];
                    break;
                }
            }
            [[myAlert layer] setContents:(id)theImage.CGImage];
            [myAlert release];
        }    
        
        
        
        
        
    }
}

-(void)callGetPriceListDate:(bool)isRound
{
    if(isReachable)
    {
        GetPriceListDateParser *roundDateParser = [[GetPriceListDateParser alloc] init];
        roundDateParser.delegate = self;
        [roundDateParser getDate:isRound];
        [roundDateParser release];
        roundDateParser = nil;
    }
}

-(void)priceListDownloadFinished:(NSInteger)type{
    [priceDownloader.view removeFromSuperview];
    //[vDownload removeFromSuperview];
	[priceDownloader release]; 
    [appDelegate showTabBar];
    NSLog(@"removed priceListDownloader");
    if (type==1) {
        [[StoredData sharedData].blackScreen removeFromSuperview];
        if(isReachable)
        {
            [self callGetPriceListDate:YES];
            [self callGetPriceListDate:NO];

        }
        else {
            [Functions NoInternetAlert];
        }
        
        //NSString *s = [Database getLastUpdateDate];
        //lblPricesUpdated.text = s;
        //[self loadAllDataFromDatabase];
    }else{
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        // NSLog(@"price not ");
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
        [self.view addSubview:customAlert1.view];        
        view = customAlert1.view;
        [self initialDelayEnded];
    }
    
    
}

-(void)setPriceListLastUpdated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *str = @"";
    
    str = [prefs stringForKey:kRoundPriceListDate];
    lblPricesUpdated.text = [Functions dateFormat:str format:@"MMMM dd, yyyy"];
    
    NSTimeInterval i = 0;
    if(str.length > 0)
        i = [Functions dateDiff:[Functions getDate:str] endDate:[NSDate date]];
    float f = ((i / 60) / 60) / 24;
    NSInteger days = round(f);
    NSInteger numDaysInMonth = [Functions numDaysInMonth:[Functions getDate:str format:@"MMMM dd, yyyy"]];
    if(([Functions canView:L_PricesWeekly] && days > 7) || ([Functions canView:L_PricesMonthly] && days > numDaysInMonth))
        lblPricesUpdated.textColor = [UIColor redColor];
    else if(str.length > 0)
        lblPricesUpdated.textColor = [UIColor lightGrayColor];
    
}


-(void)PriceListDateResult:(NSString*)date isRound:(BOOL)isRound
{
    if (date != nil && date.length > 4)
    {
        NSString *field = isRound ? kRoundPriceListDate : kPearPriceListDate;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:date forKey:field];
        [prefs synchronize];
        [self setPriceListLastUpdated];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
}

- (void)dealloc {
	[strSucceed release];
    [arrPriceLogin release];
	[arrLogin release];
	[alert release];
    [super dealloc];
}


@end
