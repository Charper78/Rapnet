//
//  MoreViewDetailC.m
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "MoreViewC.h"
#import "NewsDetailViewController.h"
#import "NewsViewController.h"
#import "MoreViewDetailC.h"
#import "funcClass.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CustomAlertViewController.h"

@implementation MoreViewDetailC
@synthesize topicID,customCell,strTitle;


- (void)viewDidLoad
{
	[self.navigationController setNavigationBarHidden:YES];
	[super viewDidLoad];
	
	arrpageNo = [[NSMutableArray alloc]init];
	imagesArray = [[NSMutableArray alloc] init];
	
	isTrue = YES;
	count = 1;
	ALTERNATE = TRUE;
	lblTitle.text=self.strTitle;
	
	if([StoredData sharedData].Analysis||[StoredData sharedData].Features||[StoredData sharedData].TradeAlerts||[StoredData sharedData].Statistics||[StoredData sharedData].PressRelease)
	{
		if([StoredData sharedData].Analysis){
			lblTitle.text=@"Analysis";
		}
		else if([StoredData sharedData].Features){
			lblTitle.text=@"Features";
		}
		else if([StoredData sharedData].TradeAlerts){
			lblTitle.text=@"Trade Alerts";
		}
		else if([StoredData sharedData].Statistics){
			lblTitle.text=@"Statistics";
		}
		else if([StoredData sharedData].PressRelease){
			lblTitle.text=@"Press Release";
		}
		[self webserviceCallStart];
	}
}

-(void)showPageNumber
{
	txtPageNo=1;
	NSString* abc = [NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:0]objectForKey:@"TotalCount"]];
	totalPages =  [abc intValue]/10;
	//NSLog(@"totalPages %d",totalPages);
	for (int i=0 ; i<totalPages; i++)
	{
	[arrpageNo addObject:[NSNumber numberWithInt:count++]];
	}
}

-(void)webserviceCallStart
{	
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	objArticleParser=[[ArticlesParser alloc]init];
	objArticleParser.delegate = self;
	[appDelegate showActivityIndicator:self];
	
	if([StoredData sharedData].Analysis){
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:4 languageId:1];}
	else if([StoredData sharedData].Features){
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:6 languageId:1];}
	else if([StoredData sharedData].TradeAlerts){
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:3 languageId:1];}
	else if([StoredData sharedData].Statistics){
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:5 languageId:1];}
	else if([StoredData sharedData].PressRelease){
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:7 languageId:1];}
	else{
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleTopic:[self.topicID intValue] languageId:1];
	}
}

-(void)webserviceCallFinished
{
	if(arrMoreTopicDetail){
		arrMoreTopicDetail= nil;}
	
	arrMoreTopicDetail = [objArticleParser getResults];
	[myTable reloadData];
	
	if (arrMoreTopicDetail.count == 0)
	{
		//totalPages = 0;
		//txtPageNo=0;
	}
	if (arrMoreTopicDetail.count > 0)
	{
		[myTable reloadData];
		if (isTrue)
		{
			[self showPageNumber];
			isTrue = FALSE;
		}
	}
	
	for(int i=0;i<[arrMoreTopicDetail count];i++)
		[imagesArray addObject:[NSNull null]];
	[appDelegate stopActivityIndicator:self];
	
}



-(void)setDataForDetailsView:(NSDictionary*)data
{
	self.topicID=[NSString stringWithFormat:@"%@",[data objectForKey:@"Value"]];
	self.strTitle=[NSString stringWithFormat:@"%@",[data objectForKey:@"Key"]];
	
	[StoredData sharedData].topicName=[self.strTitle retain];
	[self webserviceCallStart];
}


-(IBAction)backButtonClicked{
	
  [[self navigationController] popViewControllerAnimated:YES];
	
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row==[arrMoreTopicDetail count]){
		return 60;}
	else{
		return 90;}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( [arrMoreTopicDetail count] < 10 ) {
		return [arrMoreTopicDetail count];}
	else{
		return [arrMoreTopicDetail count]+1;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"ApplicationCell";
	
    NewsCustomCell*cell = (NewsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCustomTableCell" owner:self options:nil];
        cell = customCell;
        self.customCell = nil;
		
    }
	
	if (indexPath.row != [arrMoreTopicDetail count])
	{
	
		cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"Title"]];
		NSString *getDate=[NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"DatePosted"]];
		cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"ArticleTypeText"]];
		cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"Author"]];
		cell.videoView.hidden=YES;
		
		NSString *newDateString=[self convertDateFormat:getDate];
		cell.lblDesc.text=newDateString;
		
		if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"ArticleID"]]])
		{
			cell.lblTitle.textColor=[UIColor grayColor];
			
		}
		
		
		NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"IsAuthenticated"]];
		//if([StoredData sharedData].isUserAuthenticated==FALSE)
        if ([Functions canView:L_News] == NO)
		{
			if([isAuth isEqual:@"true"]){
				cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
			}
			else{
				cell.lockImg.image=[UIImage imageNamed:@".png"];
			}
		}
		
		NSString *isImage = [NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"ImageURL"]];
		if([isImage isEqual:@"no image"])
		{
			cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
			cell.frameImage.hidden=YES;
			//cell.lockImg.frame=CGRectMake(296,64,16,18);
		}
		else
		{	
			if([imagesArray objectAtIndex:indexPath.row] != [NSNull null])
			{
				cell.mImageView.image  = [imagesArray objectAtIndex:indexPath.row];
				
			}
			else
			{
				NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
				
				[data setObject:[NSString stringWithFormat:@"%i",indexPath.row] forKey: @"rowVal"];
				[data setObject: cell.mImageView forKey: @"imageView"];
				
				[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
				[data release];
			}
		}
			
	}
		   else if (indexPath.row == [arrMoreTopicDetail count] )
			{
				cell.lblTitle.frame=CGRectMake(17, 22,145, 35);
				cell.lblTitle.text=@"More News...";
				cell.mImageView.image=nil;
				cell.frameImage.hidden=YES;
				cell.videoView.hidden=YES;
				cell.accessoryType=UITableViewCellAccessoryNone;
				
			}
	return cell;	
	
}

-(void)fetchImage:(NSDictionary *)obj 
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	int photoId = [[obj objectForKey:@"rowVal"] intValue];
	NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrMoreTopicDetail objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
	UIImage *myImage;
	if(mydata)
	{
		myImage = [[UIImage alloc] initWithData:mydata];
		[imagesArray replaceObjectAtIndex:photoId withObject:myImage];
		[(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
		
		[myImage release];
		[mydata release];
	}
	[appDelegate stopActivityIndicator:self];
	[pool release];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[StoredData sharedData].isVideo=FALSE;
	
	UIView*  cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(15, 8, 295,75)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	//[cellBackGroundView release];
	
	if ( [arrMoreTopicDetail count] <= 10)
	{ 
		if (indexPath.row == [arrMoreTopicDetail count] ) 
		{
			int pageNo = txtPageNo;
			if ((pageNo+1) <= totalPages)
			{
				txtPageNo= (pageNo + 1); 
				int startNode = ((pageNo + 1) * 10) - 9;
				int endNode = (pageNo + 1) * 10;
				
				[appDelegate showActivityIndicator:self];
				AppDelegate *getDelegate = [UIApplication sharedApplication].delegate;
				getDelegate.activityView.frame = CGRectMake(260, 420, 20, 20);
			
				if([StoredData sharedData].Analysis){
					[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:4 languageId:1];}
				else if([StoredData sharedData].Features){
					[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:6 languageId:1];}
				else if([StoredData sharedData].TradeAlerts){
					[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:3 languageId:1];}
				else if([StoredData sharedData].Statistics){
					[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:5 languageId:1];}
				else if([StoredData sharedData].PressRelease){
					[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:7 languageId:1];}
				else{
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleTopic:[self.topicID intValue] languageId:1];
				}
			}
		} 
		else
		{
			NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"IsAuthenticated"]];
			if([isAuth isEqual:@"true"])
			{
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([Functions canView:L_News] == NO)
				{
					[self showAlertView];	
				}
				else
				{
					UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
					NewsDetailViewController *objArticle = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
					[objArticle setDataForDetailsView:[arrMoreTopicDetail objectAtIndex:indexPath.row]];
					[objArticle setArray:arrMoreTopicDetail];
					objArticle.selectedRowint = indexPath.row;
					[navC pushViewController:objArticle animated:YES];
					[objArticle release];
					objArticle=nil;
				}
			}
			else
			{
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				NewsDetailViewController *objArticle = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
				[objArticle setDataForDetailsView:[arrMoreTopicDetail objectAtIndex:indexPath.row]];
				[objArticle setArray:arrMoreTopicDetail];
				objArticle.selectedRowint = indexPath.row;
				[navC pushViewController:objArticle animated:YES];
				[objArticle release];
				objArticle=nil;
		
			}
		}
	}
	
	else if([arrMoreTopicDetail count]> 10)
	{
		if (indexPath.row == [arrMoreTopicDetail count] )
		{
		int pageNo = txtPageNo;
		if ((pageNo+1) <= totalPages)
		{
			txtPageNo=(pageNo + 1); 
			int startNode = ((pageNo + 1) * 10) - 9;
			int endNode = (pageNo + 1) * 10;
			
			[appDelegate showActivityIndicator:self];
			AppDelegate *getDelegate = [UIApplication sharedApplication].delegate;
			getDelegate.activityView.frame = CGRectMake(260, 420, 20, 20);
			
			if([StoredData sharedData].Analysis){
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:4 languageId:1];}
			else if([StoredData sharedData].Features){
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:6 languageId:1];}
			else if([StoredData sharedData].TradeAlerts){
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:3 languageId:1];}
			else if([StoredData sharedData].Statistics){
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:5 languageId:1];}
			else if([StoredData sharedData].PressRelease){
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleType:7 languageId:1];}
			else{
				[objArticleParser getNewsWithSearchString:startNode endRow:endNode articleTopic:[self.topicID intValue] languageId:1];
			}
			
		}
		}
			
		else
		{
			NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrMoreTopicDetail objectAtIndex:indexPath.row]objectForKey:@"IsAuthenticated"]];
			if([isAuth isEqual:@"true"])
			{
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([Functions canView:L_News] == NO)
				{
					[self showAlertView];	
				}
				else
				{
					UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
					NewsDetailViewController *objArticle = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
					[objArticle setDataForDetailsView:[arrMoreTopicDetail objectAtIndex:indexPath.row]];
					[objArticle setArray:arrMoreTopicDetail];
					objArticle.selectedRowint = indexPath.row;
					[navC pushViewController:objArticle animated:YES];
					[objArticle release];
					objArticle=nil;
				}
			}
			
			else
			{
			
				UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
				NewsDetailViewController *objArticle = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
				[objArticle setDataForDetailsView:[arrMoreTopicDetail objectAtIndex:indexPath.row]];
				[objArticle setArray:arrMoreTopicDetail];
				objArticle.selectedRowint = indexPath.row;
				[navC pushViewController:objArticle animated:YES];
				[objArticle release];
				objArticle=nil;
			
			}
		}
			
	}
}


-(NSString*)convertDateFormat:(NSString*)dateString
{
	ReleaseObject(inputFormatter);
	ReleaseObject(outputFormatter);
	inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	
	NSDate *formatterDate = [inputFormatter dateFromString:dateString];
	outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSString *newDate = [outputFormatter stringFromDate:formatterDate];
	return newDate;
}


#pragma mark showLoginAlertView

-(void)showAlertView
{
	customAlert=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
	[self.view addSubview:customAlert.view];
	customAlert.msgLbl.text = @"This article requires a free news login and password";
	[self initialDelayEnded];
}



#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)	
	{
		UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
		LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
		[navC pushViewController:login animated:YES];
		[login release];
		login=nil;
	}
    else if(buttonIndex == 2) 
    {
		RegisterViewController *signUp =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
		[[self navigationController] pushViewController:signUp animated:YES];
		[signUp release];
		signUp=nil;
	}
}

#pragma mark  Animate a Custome Alert View
-(void)initialDelayEnded
{
	customAlert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
	customAlert.view.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	customAlert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	customAlert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	customAlert.view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}




/*-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [customAlert.view removeFromSuperview];	
	[myTable reloadData];
	
}

- (void)viewDidUnload {
    [super viewDidUnload];

}

- (void)dealloc {
	
	[inputFormatter release];
	[outputFormatter release];
	[strTitle release];
	[customCell release];
	[topicID release];
	[objArticleParser release];
	[appDelegate release];
	[arrMoreTopicDetail release];
	[imagesArray release];
	[arrpageNo release];
	[super dealloc];
	
}


@end
