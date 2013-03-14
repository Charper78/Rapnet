//
//  CustomRenameAlert.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 03/12/11.
//  Copyright (c) 2011 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredData.h"
#import "Database.h"
#import "CustomSameNameDiamondAlert.h"

@protocol CustomRenameAlertDelegate
-(void)alertRenameFinished:(NSString *)name type:(int)type;
@end

@interface CustomRenameAlert : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,CustomSameNameDiamondAlertDelegate>{
    id<CustomRenameAlertDelegate> delegate;
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *renameBtn;	
	IBOutlet UIButton *cancelBtn;
	IBOutlet UITextField *idDiamond;
    IBOutlet UIImageView *popUPView;
    
    NSString *idName;
    NSString *time;
    CustomSameNameDiamondAlert *alertSameName;
}

@property(retain, nonatomic) id<CustomRenameAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *renameBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UITextField *idDiamond;
@property(nonatomic,retain)IBOutlet UIImageView *popUPView;
@property(nonatomic,retain)NSString *time;

-(IBAction)renameBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

-(void)alertSameNameDiamondFinished:(int)type;
-(void)initialDelayEnded;
-(BOOL)checkSameName:(NSString *)str;

@end
