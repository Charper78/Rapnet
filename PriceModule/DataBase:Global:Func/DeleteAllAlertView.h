//
//  DeleteAllAlertView.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteAllAlertDelegate
-(void)alertDeleteFinished:(int)index;
@end

@interface DeleteAllAlertView : UIViewController {
    id<deleteAllAlertDelegate> delegate;
    IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn;
}

@property(retain, nonatomic) id<deleteAllAlertDelegate> delegate;
-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
@end
