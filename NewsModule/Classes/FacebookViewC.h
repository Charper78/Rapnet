//
//  FacebookViewC.h
//  FoodCashing
//
//  Created by Chandu on 11/16/10.
//  Copyright 2010 TechAhead. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBLoginButton.h"
#import "UserInfo.h"

@interface FacebookViewC : UIViewController <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,UserInfoLoadDelegate>
{
	// Facebook
	IBOutlet FBLoginButton* _fbButton;
	Facebook* _facebook;
	NSArray* _permissions;
	BOOL emailBool;
	BOOL friendsBool;
	UserInfo *_userInfo;
	id loginDelegate;
	
}

@property (nonatomic, assign) 	id loginDelegate;

-(void) facebookButtonClicked;
-(void) publish:(NSString *)str;
-(void) getUserInfo;
-(void) getFriends;
-(void) callLoginGo;

@end
