//
//  RegisterDetailsViewController.h
//  Rapnet
//
//  Created by Richa on 6/6/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "SignUpParser.h"
#import "AppDelegate.h"
#import "BusinessPickerList.h"

@interface RegisterDetailsViewController : UIViewController  <signUpDelegate,UIAlertViewDelegate>
{
	IBOutlet UIScrollView *registerScroll;
	IBOutlet UITextField *txtTitle,*txtFName,*txtLName,*txtEmail,*txtPass,*txtCnfrmPass,*txtbusinsType,*txtBusiness,*txtCmpny;
	NSMutableArray *arrSignUpResult;
	UIAlertView *alert;
	NSString *strResult;
	NSTimer *aTimer;
	
	SignUpParser *objSignUp;
	AppDelegate *appDelegate;
	BOOL isKeyBoardDown;
}


@property(nonatomic,retain)NSString *strResult;
@property(nonatomic,retain)UITextField *txtTitle,*txtFName,*txtLName,*txtEmail,*txtPass,*txtCnfrmPass,*txtbusinsType,*txtCmpny;
-(void)webServiceStart;
-(IBAction)cancelBtn;
-(IBAction)registerBtn;
-(IBAction)businessList;

//for Validation
-(BOOL)Validate;
-(BOOL)validateEmail;
-(BOOL)validateEmptyFields;
//-(BOOL)validateContactFields;
-(void)setViewMovedUp:(BOOL)movedUp coordinateY:(NSInteger)coordinateY;

@end
