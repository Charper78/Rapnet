//
//  NotificationsViewController.h
//  Rapnet
//
//  Created by Home on 3/15/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "NotificationsHelper.h"
@interface NotificationsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *notificatios;
    IBOutlet UITableView *tblNotifications;
}

-(IBAction)btnBack_Clicked:(id)sender;

@end
