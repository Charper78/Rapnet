//
//  CustomSaveExistListAlert.h
//  RapnetPriceModule
//
//  Created by EM Mlab on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "StoredData.h"
@protocol CustomSaveExistListAlertDelegate
-(void)alertSaveExistListFinished:(int)type;
@end

@interface CustomSaveExistListAlert : UIViewController{
    id<CustomSaveExistListAlertDelegate> delegate;
    IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *newBtn;
}

@property(retain, nonatomic) id<CustomSaveExistListAlertDelegate> delegate;

@property(nonatomic,retain)IBOutlet UIButton *addBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UIButton *newBtn;

-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
-(IBAction)newBtn:(id)sender;

@end
