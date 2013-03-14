//
//  CustomAlertViewCOntroller.h
//  Rapnet
//
//  Created by Richa on 6/8/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Enums.h"

@interface CustomAlertViewController : UIViewController
{
    IBOutlet UIImageView *popUpImage;
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
@property(nonatomic,retain)IBOutlet UIImageView *popUpImage;

-(IBAction)joinNowBtn:(id)sender;
-(IBAction)logInBtn:(id)sender;
-(IBAction)okBtn:(id)sender;

@end
