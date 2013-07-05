//
//  CustomAlertViewCOntroller.m
//  Rapnet
//
//  Created by Richa on 6/8/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import "CustomAlertViewCOntroller.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"


@implementation CustomAlertViewController
@synthesize msgLbl,joinNowBtn,logInBtn,okBtn,popUpImage;

-(void)viewDidLoad 
{
    [super viewDidLoad];
    
    UITabBarController *tabController = [AppDelegate getAppDelegate].tabBarController;
    
    NSInteger JoinType = [tabController selectedIndex];
    //NSLog(@"type=======%d",JoinType);
    
    if ([StoredData sharedData].priceAlertFlag) {
        
        popUpImage.image = [UIImage imageNamed:@"price_login_register_popup2X.png"];
        joinNowBtn.hidden = YES;
        logInBtn.center = CGPointMake(logInBtn.center.x+30, logInBtn.center.y);
        okBtn.center = CGPointMake(okBtn.center.x-30, okBtn.center.y);
    }else if ([StoredData sharedData].rapnetAlertFlag || [StoredData sharedData].newsAlertFlag) {
            
            popUpImage.image = [UIImage imageNamed:@"price_login_register_popup2X.png"];
            joinNowBtn.hidden = YES;
            logInBtn.center = CGPointMake(logInBtn.center.x+30, logInBtn.center.y);
            okBtn.center = CGPointMake(okBtn.center.x-30, okBtn.center.y);
        
    }else{
        if (JoinType==0) {
            
        }else if(JoinType==1){
            popUpImage.image = [UIImage imageNamed:@"price_login_membership_popup2X.png"];
            //joinNowBtn.hidden = YES;
            logInBtn.center = CGPointMake(logInBtn.center.x+30, logInBtn.center.y);
            okBtn.center = CGPointMake(okBtn.center.x-30, okBtn.center.y);
        }else if(JoinType==3){
            popUpImage.image = [UIImage imageNamed:@"price_login_membership_popup_RapNet2X.png"];
            //joinNowBtn.hidden = YES;
            logInBtn.center = CGPointMake(logInBtn.center.x+30, logInBtn.center.y);
            okBtn.center = CGPointMake(okBtn.center.x-30, okBtn.center.y);
        } 
    }
    
    
}

/*
-(IBAction)joinNowBtn:(id)sender
{
	
    
    self.view.hidden =YES;     
    
    UITabBarController *tabController = [AppDelegate getAppDelegate].tabBarController;
    
    NSInteger JoinType = [tabController selectedIndex];
    
    if ([StoredData sharedData].priceAlertFlag) {
        [StoredData sharedData].priceAlertFlag = FALSE;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.diamonds.net/product-info.aspx?category=PRICE_SHEET"]];
    }else{
        if (JoinType==0) {
            [tabController setSelectedIndex:2];
        }else if(JoinType==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.diamonds.net/product-info.aspx?category=PRICE_SHEET"]];
        }else if(JoinType==3){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.diamonds.net/product-info.aspx?category=RAPNET"]];
        }
    }
    
    
    
    
    
}*/

-(IBAction)logInBtn:(id)sender
{	
	/*UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
	[navC pushViewController:login animated:YES];
	[login release];
	login=nil;*/
    [StoredData sharedData].priceAlertFlag = FALSE;
    [StoredData sharedData].rapnetAlertFlag = FALSE;
    [StoredData sharedData].newsAlertFlag = FALSE;
    self.view.hidden =YES;
    UITabBarController *tabController = [AppDelegate getAppDelegate].tabBarController;
    [StoredData sharedData].selectedTabBfrLogin = [tabController selectedIndex];
    [tabController setSelectedIndex:3];
    [[StoredData sharedData].blackScreen removeFromSuperview];
}


-(IBAction)okBtn:(id)sender
{
    
    
    /*if(![[AppDelegate getAppDelegate] downloadPriceIfNeeded]){
        [[StoredData sharedData].blackScreen removeFromSuperview];
    }*/
    
    [[StoredData sharedData].blackScreen removeFromSuperview];
    
    MainTabIndexes selectedTabIndex = MTI_News;
    
    UITabBarController *tabController = [AppDelegate getAppDelegate].tabBarController;
    if ([StoredData sharedData].priceAlertFlag) {
        selectedTabIndex = MTI_Prices;
    }
    if ([StoredData sharedData].rapnetAlertFlag) {
        selectedTabIndex = MTI_Rapnet;
    }

    [tabController setSelectedIndex:selectedTabIndex];
    [StoredData sharedData].rapnetAlertFlag = FALSE;
    [StoredData sharedData].priceAlertFlag = FALSE;
    [StoredData sharedData].newsAlertFlag = FALSE;
	self.view.hidden =YES;
}

-(void)didReceiveMemoryWarning 
{    
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }*/

-(void)dealloc 
{
    [popUpImage release];
	[msgLbl release];
	[joinNowBtn release];
	[logInBtn release];
	[okBtn release];
    [super dealloc];
}


@end
