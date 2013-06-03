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
#import "Notification.h"
#import "SetReadMessagesRead.h"
#import "NotificationSettings.h"

@interface NotificationsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, setReadMessagesReadDelegate>
{
    NSDictionary *notificatios;
    NSArray *sortedNotifications;
    IBOutlet UITableView *tblNotifications;
}

-(IBAction)btnBack_Clicked:(id)sender;

@end
