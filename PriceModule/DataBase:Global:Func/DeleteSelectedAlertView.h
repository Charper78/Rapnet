//
//  DeleteAllAlertView.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteSelectedAlertDelegate
-(void)alertDeleteSelectedFinished:(int)index;
@end

@interface DeleteSelectedAlertView : UIViewController {
    id<deleteSelectedAlertDelegate> delegate;
    IBOutlet UIButton *addBtn;	
	IBOutlet UIButton *cancelBtn;
}

@property(retain, nonatomic) id<deleteSelectedAlertDelegate> delegate;
-(IBAction)addBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
@end
