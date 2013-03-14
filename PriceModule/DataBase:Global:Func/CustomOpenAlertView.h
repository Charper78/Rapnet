//
//  CustomOpenAlertView.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 04/12/11.
//  Copyright (c) 2011 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomOpenAlertDelegate
-(void)alertOpenFinished:(int)type;
@end

@interface CustomOpenAlertView : UIViewController{
    id<CustomOpenAlertDelegate> delegate;
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *oldBtn;	
	IBOutlet UIButton *currentBtn;
    IBOutlet UIButton *cancelBtn;
}

@property(retain, nonatomic) id<CustomOpenAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *oldBtn;
@property(nonatomic,retain)IBOutlet UIButton *currentBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;

-(IBAction)oldBtn:(id)sender;
-(IBAction)currentBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

@end
