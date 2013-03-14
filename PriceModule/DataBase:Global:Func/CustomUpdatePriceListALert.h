//
//  CustomUpdatePriceListALert.h
//  Rapnet
//
//  Created by Nikhil Bansal on 04/04/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomUpdatePriceListAlertDelegate
-(void)alertUpdatePriceListFinished:(int)type;
@end

@interface CustomUpdatePriceListALert : UIViewController{
    id<CustomUpdatePriceListAlertDelegate> delegate;
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *yesBtn;	
	IBOutlet UIButton *noBtn;
}

@property(retain, nonatomic) id<CustomUpdatePriceListAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *yesBtn;
@property(nonatomic,retain)IBOutlet UIButton *noBtn;

-(IBAction)yesBtn:(id)sender;
-(IBAction)noBtn:(id)sender;

@end
