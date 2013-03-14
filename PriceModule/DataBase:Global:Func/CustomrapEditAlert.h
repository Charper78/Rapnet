//
//  CustomrapEditAlert.h
//  RapnetPriceModule
//
//  Created by EM Mlab on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomrapEditAlertDelegate
-(void)alertrapEditFinished:(int)index:(int)value;
@end

@interface CustomrapEditAlert : UIViewController{
    id<CustomrapEditAlertDelegate> delegate;
    IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn,*plusBtn,*minusBtn;
    IBOutlet UILabel *valText;
    int value;
}

@property(retain, nonatomic) id<CustomrapEditAlertDelegate> delegate;
@property(nonatomic,retain)IBOutlet UIButton *addBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UIButton *plusBtn;
@property(nonatomic,retain)IBOutlet UIButton *minusBtn;
@property(nonatomic,retain)IBOutlet UILabel *valText;

-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
-(IBAction)plusBtn:(id)sender;
-(IBAction)minusBtn:(id)sender;

@end
