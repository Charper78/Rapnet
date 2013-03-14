//
//  CustomPriceListPopUp.h
//  Rapnet
//
//  Created by Nikhil Bansal on 04/03/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPriceListAlertDelegate
-(void)alertPriceListFinished:(int)type;
@end

@interface CustomPriceListPopUp : UIViewController{
    id<CustomPriceListAlertDelegate> delegate;
	IBOutlet UILabel *msgLbl,*rapListPlbl,*rapBestPLbl,*rapAvgPLbl,*rapListDLbl,*rapBestDLbl,*rapAvgDLbl,*rapBestDCLbl,*rapAvgDCLbl;
	IBOutlet UIButton *oldBtn;	
    IBOutlet UIButton *cancelBtn;
    
    NSString *shape,*color,*clarity,*size;
    NSInteger gridID,diamondCount;
    float rapPrice,rapBestprice,rapAvgPrice,discBest,discAvg;
}

@property(retain, nonatomic) id<CustomPriceListAlertDelegate> delegate;

@property(nonatomic,retain)UILabel *msgLbl;
@property(nonatomic,retain)IBOutlet UIButton *oldBtn;

@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;

@property(nonatomic,retain)UILabel *rapListPlbl;
@property(nonatomic,retain)UILabel *rapBestPLbl;
@property(nonatomic,retain)UILabel *rapAvgPLbll;
@property(nonatomic,retain)UILabel *rapListDLbl;
@property(nonatomic,retain)UILabel *rapBestDLbl;
@property(nonatomic,retain)UILabel *rapAvgDLbl;
@property(nonatomic,retain)UILabel *rapBestDCLbl;
@property(nonatomic,retain)UILabel *rapAvgDCLbl;

-(IBAction)oldBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

@end
