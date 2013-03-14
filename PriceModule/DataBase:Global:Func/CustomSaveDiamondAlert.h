//
//  CustomSaveDiamondAlert.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredData.h"
#import "Database.h"
#import "CustomSameNameDiamondAlert.h"

@protocol CustomSaveDiamondAlertDelegate
-(void)alertSaveDiamondFinished:(int)type;
@end

@interface CustomSaveDiamondAlert : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,CustomSameNameDiamondAlertDelegate>{
    id<CustomSaveDiamondAlertDelegate> delegate;
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn;
	IBOutlet UITextField *idDiamond;
    IBOutlet UIImageView *popUPView;
    
    NSArray *savedDiamonds;
    
    NSString *idName;
    CustomSameNameDiamondAlert *alertSameName;
}

@property(retain, nonatomic) id<CustomSaveDiamondAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *addBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UITextField *idDiamond;
@property(nonatomic,retain)IBOutlet UIImageView *popUPView;

@property(nonatomic,retain)NSArray *savedDiamonds;

-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

-(void)alertSameNameDiamondFinished:(int)type;
-(void)initialDelayEnded;
-(BOOL)checkSameName:(NSString *)str;

@end
