//
//  MoreViewC.m
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "MoreViewC.h"
#import "MoreViewDetailC.h"
#import "StoredData.h"


@implementation MoreViewC
@synthesize objTable,customCell;

- (void)viewDidLoad 
{
	[super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES];
	self.view.frame=CGRectMake(0,82, 320, 320);
    //self.objTable.contentSize = CGSizeMake(320, 1500);
	self.view.backgroundColor=[UIColor grayColor];
	
    [self initReachability];
    
	[StoredData sharedData].Analysis=FALSE;
	[StoredData sharedData].Features=FALSE;
	[StoredData sharedData].TradeAlerts=FALSE;
	[StoredData sharedData].Statistics=FALSE;
	[StoredData sharedData].PressRelease=FALSE;
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showActivityIndicator:self];
    if (isReachable) {
        [self webserviceCallStart];
    }

    
}


-(void)initReachability
{
    countReachUpdate = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
    //remoteHostLabel.text = [NSString stringWithFormat: @"Remote Host: %@", @"www.apple.com"];
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifier];
	[self updateInterfaceWithReachability: hostReach];
    
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        //BOOL connectionRequired= [curReach connectionRequired];
        
        switch (netStatus)
        {
            case NotReachable:
            {
                isReachable = NO;
                countReachUpdate ++;
                if (countReachUpdate == 2) {
                    [Functions NoInternetAlert];
                }
                break;
            }
                
            case ReachableViaWWAN:
            {
                isReachable = YES;
                countReachUpdate ++;
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }
                [self webserviceCallStart];
                break;
            }
            case ReachableViaWiFi:
            {
                isReachable = YES;
                countReachUpdate ++;
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }
                if(isReachable)
                [self webserviceCallStart];
                break;
            }
        }
        
    }
    //isFirstTime = NO;
    if (countReachUpdate == 2) {
        countReachUpdate = 0;
    }
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}


-(void)webserviceCallStart
{	
    if(isReachable)
    {
        

	objTopicParser=[[NewsTopicParser alloc]init];
	objTopicParser.delegate = self;
	[objTopicParser getNewsTopics];
    }
    else {
        [Functions NoInternetAlert];
    }
}

-(void)webserviceCallFinished
{	
	arrNewsTopic = [objTopicParser getResults];
	[objTable reloadData];
	[appDelegate stopActivityIndicator:self];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(arrNewsTopic.count>0){
	return [arrNewsTopic count]+4;
	}
	else{
		return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"ApplicationCell";
	
    NewsCustomCell*cell = (NewsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"MoreTableCell" owner:self options:nil];
        cell = customCell;
        self.customCell = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

	if(indexPath.row<12){
		
	    cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrNewsTopic objectAtIndex:indexPath.row]objectForKey:@"Key"]];
	if([cell.lblTitle.text isEqual:@"Mining"])
		[cell.mImageView setImage:[UIImage imageNamed:@"mining.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Rough Markets"])
		[cell.mImageView setImage:[UIImage imageNamed:@"roughMarkets.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Polished Markets"])
		[cell.mImageView setImage:[UIImage imageNamed:@"polishedMarket.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Manufacturing"])
		[cell.mImageView setImage:[UIImage imageNamed:@"manufacturing.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Retail"])
		[cell.mImageView setImage:[UIImage imageNamed:@"retail.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Financial/Legal"])
		[cell.mImageView setImage:[UIImage imageNamed:@"financial.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Research"])
		[cell.mImageView setImage:[UIImage imageNamed:@"research.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Marketing"])
		[cell.mImageView setImage:[UIImage imageNamed:@"marketing.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Technology"])
		[cell.mImageView setImage:[UIImage imageNamed:@"technology.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Gemstones"])
		[cell.mImageView setImage:[UIImage imageNamed:@"gemstones.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Watches"])
		[cell.mImageView setImage:[UIImage imageNamed:@"watches.png"]];
	
	else if([cell.lblTitle.text isEqual:@"Fair Trade"])
		[cell.mImageView setImage:[UIImage imageNamed:@"fairTrade.png"]];
	}
	
	if(indexPath.row==12)
	{
		cell.lblTitle.text=@"Analysis";
		[cell.mImageView setImage:[UIImage imageNamed:@"analysis.png"]];
		
	}
	if(indexPath.row==13)
	{
		cell.lblTitle.text=@"Features";
		[cell.mImageView setImage:[UIImage imageNamed:@"features.png"]];
		
	}
	if(indexPath.row==14)
	{
		cell.lblTitle.text=@"Trade alerts";
		[cell.mImageView setImage:[UIImage imageNamed:@"tradeAlerts.png"]];
		
	}
	if(indexPath.row==15)
	{
		cell.lblTitle.text=@"Statistics";
		[cell.mImageView setImage:[UIImage imageNamed:@"statistics.png"]];
		
	}
	if(indexPath.row==16)
	{
		cell.lblTitle.text=@"Press Release";
		[cell.mImageView setImage:[UIImage imageNamed:@"pressRelease.png"]];
		
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UIView*  cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(10, 5, 300,44)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	
	
	[StoredData sharedData].Analysis=FALSE;
	[StoredData sharedData].Features=FALSE;
	[StoredData sharedData].TradeAlerts=FALSE;
	[StoredData sharedData].Statistics=FALSE;
	[StoredData sharedData].PressRelease=FALSE;	
	
	if(indexPath.row<12){
	
	[StoredData sharedData].Analysis=FALSE;
	[StoredData sharedData].Features=FALSE;
	[StoredData sharedData].TradeAlerts=FALSE;
	[StoredData sharedData].Statistics=FALSE;
	[StoredData sharedData].PressRelease=FALSE;
		
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
	[objMoreV setDataForDetailsView:[arrNewsTopic objectAtIndex:indexPath.row]];
	[navC pushViewController:objMoreV animated:YES];
	}

			else if(indexPath.row==12){
				[StoredData sharedData].Analysis=TRUE;
				[StoredData sharedData].Features=FALSE;
				[StoredData sharedData].TradeAlerts=FALSE;
				[StoredData sharedData].Statistics=FALSE;
				[StoredData sharedData].PressRelease=FALSE;
				
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
				[navC pushViewController:objMoreV animated:YES];
			}
			else if(indexPath.row==13){
				[StoredData sharedData].Analysis=FALSE;
				[StoredData sharedData].Features=TRUE;
				[StoredData sharedData].TradeAlerts=FALSE;
				[StoredData sharedData].Statistics=FALSE;
				[StoredData sharedData].PressRelease=FALSE;
				
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
				[navC pushViewController:objMoreV animated:YES];
			}

			else if(indexPath.row==14){
				[StoredData sharedData].Analysis=FALSE;
				[StoredData sharedData].Features=FALSE;
				[StoredData sharedData].TradeAlerts=TRUE;
				[StoredData sharedData].Statistics=FALSE;
				[StoredData sharedData].PressRelease=FALSE;
				
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
				[navC pushViewController:objMoreV animated:YES];
			}

			else if(indexPath.row==15){
				[StoredData sharedData].Analysis=FALSE;
				[StoredData sharedData].Features=FALSE;
				[StoredData sharedData].TradeAlerts=FALSE;
				[StoredData sharedData].Statistics=TRUE;
				[StoredData sharedData].PressRelease=FALSE;
								
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
				[navC pushViewController:objMoreV animated:YES];
			}

			else if(indexPath.row==16){
				[StoredData sharedData].Analysis=FALSE;
				[StoredData sharedData].Features=FALSE;
				[StoredData sharedData].TradeAlerts=FALSE;
				[StoredData sharedData].Statistics=FALSE;
				[StoredData sharedData].PressRelease=TRUE;
				
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				objMoreV = [[MoreViewDetailC alloc]initWithNibName:@"MoreViewDetailC" bundle:nil];
				[navC pushViewController:objMoreV animated:YES];
	
	}
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}*/


-(void)viewWillAppear:(BOOL)animated
{
	[StoredData sharedData].Analysis=FALSE;
	[StoredData sharedData].Features=FALSE;
	[StoredData sharedData].TradeAlerts=FALSE;
	[StoredData sharedData].Statistics=FALSE;
	[StoredData sharedData].PressRelease=FALSE;
	
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isMore=TRUE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[objTable reloadData];
	
}

-(void)viewDidAppear:(BOOL)animated

{
	
	
	
	
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}


- (void)dealloc{
	[objTable release];
	[arrNewsTopic release];
	[customCell release];
	[objMoreV release];
	[objTopicParser release];
	[appDelegate release];
    [super dealloc];
}


@end

