//
//  CustomAlertViewCOntroller.h
//  Rapnet
//
//  Created by Nikhil Bansal on 6/8/11.
//  Copyright 2011 Emantras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredData.h"
#import "CustomSameNameDiamondAlert.h"
#import "Database.h"

@protocol CustomALertAddDiamondDelegate
-(void)alertAddDiamondFinished:(int)type;
@end

@interface CustomAlertAddDiamondViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,CustomSameNameDiamondAlertDelegate>
{
    id<CustomALertAddDiamondDelegate> delegate;
	IBOutlet UILabel *msgLbl;
	IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn;
	IBOutlet UITextField *idDiamond;
    IBOutlet UIImageView *popUPView;
    
    float bestPrice,bestDiscount,avgPrice,avgDiscount,pricePerCarat,priceTotal,discount,rapPriceList,size,totalRapPrice;
    NSString *shape,*clarity,*color;
    
    NSString *idName;
    
    CustomSameNameDiamondAlert *alertSameName;
}

@property(retain, nonatomic) id<CustomALertAddDiamondDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *addBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UITextField *idDiamond;
@property(nonatomic,retain)IBOutlet UIImageView *popUPView;

@property(nonatomic,retain)NSString *shape;
@property(nonatomic,retain)NSString *clarity;
@property(nonatomic,retain)NSString *color;
@property(nonatomic)float bestPrice;
@property(nonatomic)float bestDiscount;
@property(nonatomic)float avgPrice;
@property(nonatomic)float avgDiscount;
@property(nonatomic)float pricePerCarat;
@property(nonatomic)float priceTotal;
@property(nonatomic)float discount;
@property(nonatomic)float rapPriceList;
@property(nonatomic)float size;
@property(nonatomic)float totalRapPrice;


-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

-(void)alertSameNameDiamondFinished:(int)type;
-(void)initialDelayEnded;
-(BOOL)checkSameName:(NSString *)str;

@end
