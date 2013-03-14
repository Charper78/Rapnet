//
//  CustomSameNameDiamondAlert.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSameNameDiamondAlertDelegate
-(void)alertSameNameDiamondFinished:(int)type;
@end

@interface CustomSameNameDiamondAlert : UIViewController {
    id<CustomSameNameDiamondAlertDelegate> delegate;
    
    IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *oldBtn;	
	IBOutlet UIButton *currentBtn;
}
@property(retain, nonatomic) id<CustomSameNameDiamondAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *oldBtn;
@property(nonatomic,retain)IBOutlet UIButton *currentBtn;

-(IBAction)oldBtn:(id)sender;
-(IBAction)currentBtn:(id)sender;

-(void)setMsg:(NSString *)str;

@end
