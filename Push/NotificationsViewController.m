//
//  NotificationsViewController.m
//  Rapnet
//
//  Created by Home on 3/15/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end


@implementation NotificationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

        
    [self loadData];
    [tblNotifications reloadData];
    
    
    
    
 CGRect ff = self.view.frame;
    ff.size.height = [Functions getScreenHeight];
    self.view.frame = ff;
   // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NotificationParser *parser = [[NotificationParser alloc] init];
    [parser getNotifications:[NotificationSettings getDeviceToken]];
    parser.delegate = self;
    [parser release];
    parser = nil;
}

id mySort = ^(Notification * obj1, Notification * obj2){
    
    if(obj1.notificationID == obj2.notificationID)
        return NSOrderedSame;
    
    if(obj1.notificationID < obj2.notificationID)
        return NSOrderedAscending;
    
    
    return NSOrderedDescending;
};

-(void)loadData {
    notificatios = [Functions readObjectFromFile:kNotificationsFile];
    
    NSArray *a = [notificatios allValues];
    sortedNotifications = [[a sortedArrayUsingComparator:mySort] retain];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnBack_Clicked:(id)sender
{
    [self.view removeFromSuperview];
    [_delegate onCloseNotificationsViewController];
    //[self.parentViewController
    // dismissModalViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [notificatios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    //NSDictionary *curNotification = [notificatios valueForKey:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    //NSDictionary *curNotification = [notificatios objectAtIndex:[notificatios count] - indexPath.row - 1];
    
    NSInteger index = [sortedNotifications count] - indexPath.row - 1;
    Notification *curNotification = [sortedNotifications objectAtIndex: index];
    
    //Notification *curNotification = [[notificatios allValues] objectAtIndex:[[notificatios allValues] count] - indexPath.row - 1 ];
    
    //NSDictionary *apsInfo = [curNotification valueForKey:kNotificationApsKey];
    //NSDate *notificationDate = [curNotification valueForKey:kNotificationDateKey];
    //NSString *alert = [apsInfo valueForKey:kNotificationAlertKey];
    NSDate *notificationDate = curNotification.messageDate;
    NSString *alert = curNotification.messageData;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %@", curNotification.notificationID, alert];
    cell.detailTextLabel.text = [Functions dateFormatFromDate:notificationDate format:@"yyyy-MM-dd HH:mm:ss"];
    
 
        
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        [self setReadMessages];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - setReadMessagesReadDelegate delegate

-(void)setReadMessagesReadFinished:(NSArray *)ids{
    Notification *n;
    
    for (NSInteger i=0; i<ids.count; i++) {
        n = [notificatios objectForKey:[ids objectAtIndex:i]];
        n.readMessage = true;
        [n save];
    }
    
    [self loadData];
   // [UIApplication sharedApplication].applicationIconBadgeNumber -= [ids count];
   // [(AppDelegate *)[[UIApplication sharedApplication] delegate] setBadgeCount];
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //[categoryArray objectAtIndex:indexPath.row];
        //NSString *key = [NSString stringWithFormat:@"%d", [notificatios count] - indexPath.row];
        //[NotificationsHelper removeNotification:key];
        Notification *curNotification = [sortedNotifications objectAtIndex:[sortedNotifications count] - indexPath.row - 1 ];
        [NotificationsHelper removeNotification:curNotification.notificationID];
       // [NotificationsHelper removeNotification:curNotification.notificationID];
        
        //NSInteger index = [notificatios count] - indexPath.row - 1;
        //[NotificationsHelper removeNotification:index];
        notificatios = [NotificationsHelper getNotifications];
        [self loadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setReadMessages];
}

-(void) setReadMessages {
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    Notification *n;
    
    NSArray *indexes = [tblNotifications indexPathsForVisibleRows];
    for (NSIndexPath *index in indexes) {
        n = [sortedNotifications objectAtIndex:index.row];
        if (n.readMessage == NO) {
            [ids addObject:[NSString stringWithFormat:@"%d", n.notificationID]];
        }
    }
    
    if(ids.count > 0)
    {
        SetReadMessagesRead *r = [[SetReadMessagesRead alloc] init];
        r.delegate = self;
        [r setReadMessagesRead:[NotificationSettings getDeviceToken] ids:ids];
    }
}

-(void)getNotificationsFinished:(NSMutableArray *)res total:(NSInteger)total{
    [self loadData];
    [tblNotifications reloadData];
}

/*-(BOOL)isRowVisible :  {
    NSArray *indexes = [tblNotifications indexPathsForVisibleRows];
    for (NSIndexPath *index in indexes) {
        if (index.row == 0) {
            return YES;
        }
    }
    
    return NO;
}*/
@end
