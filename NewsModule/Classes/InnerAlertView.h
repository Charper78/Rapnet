//
//  InnerAlertView.h
//  Rapnet
//
//  Created by NEHA SINGH on 03/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InnerAlertView : UIViewController
{
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *logInBtn;
	IBOutlet UIButton *joinNowBtn;
	IBOutlet UIButton *okBtn;
	AppDelegate *appDelegate;
}

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *logInBtn;
@property(nonatomic,retain)IBOutlet UIButton *joinNowBtn;
@property(nonatomic,retain)IBOutlet UIButton *okBtn;

-(IBAction)joinNowBtn:(id)sender;
-(IBAction)logInBtn:(id)sender;
-(IBAction)okBtn:(id)sender;
@end