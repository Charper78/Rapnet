//
//  MsgAlertView.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgAlertViewDelegate
-(void)alertmsgFinished;
@end

@interface MsgAlertView : UIViewController {
    id<MsgAlertViewDelegate> delegate;
    IBOutlet UIButton *OkBtn;	
    IBOutlet UILabel *msglbl;
    IBOutlet UIView *vDefault;
    IBOutlet UIView *loginFaild;
    IBOutlet UIView *vReciveEmailShortly;
    IBOutlet UIView *vInvalidEmail;
}

@property(nonatomic,retain)IBOutlet UILabel *msglbl;
@property(nonatomic,retain)IBOutlet UIButton *OkBtn;
@property(retain, nonatomic)id<MsgAlertViewDelegate> delegate;
@property(nonatomic)BOOL hideBtn;
-(IBAction)OkBtn:(id)sender;

-(void)showLoginFaild;
-(void)reciveEmailShortly;
-(void)invalidEmail;
@end
