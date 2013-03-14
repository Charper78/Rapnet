//
//  RelatedViewController.m
//  Rapnet
//
//  Created by NEHA SINGH on 31/05/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "RelatedViewController.h"
#import "MoreViewC.h"
#import "NewsDetailViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NewsViewController.h"
#import "CustomAlertViewController.h"
#import "funcClass.h"

@interface MyMovViewController : MPMoviePlayerViewController
@end

@implementation MyMovViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	//return YES;
}

@end

@implementation RelatedViewController
@synthesize topicID,customCell,strVideo;


- (void)viewDidLoad
{
	[self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
	
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
	imagesArray = [[NSMutableArray alloc] init];
	
	[self webserviceCallStart];
	if([StoredData sharedData].isRelatedArticle){
		lblTitle.text=@"Related Articles";}
	if([StoredData sharedData].isRelatedVideo){
		lblTitle.text=@"Related Videos";}
}

-(void)webserviceCallStart
{	
    if([Reachability reachableAndAlert] == NO)
        return;
    
	objArticleParser=[[RelatedArticleParser alloc]init];
	objArticleParser.delegate = self;
	[appDelegate showActivityIndicator:self];
	
	if([StoredData sharedData].isRelatedArticle){
		[objArticleParser getRelatedArticle:[[StoredData sharedData].relatedArticleID intValue]];}
	if([StoredData sharedData].isRelatedVideo){
		[objArticleParser getRelatedVideos:[[StoredData sharedData].relatedArticleID intValue]];}
}


-(void)webserviceCallFinished
{
	arrRelVideoDetail = [objArticleParser getResults];
	[myTable reloadData];
	for(int i=0;i<[arrRelVideoDetail count];i++)
		[imagesArray addObject:[NSNull null]];
	[appDelegate stopActivityIndicator:self];
	
	if([arrRelVideoDetail count]==0){
		
		if([StoredData sharedData].isRelatedVideo){
			alertLAbel.text=@"No Related Video Found.";
		    savedView.frame=CGRectMake(0,150, 320, 225);
		    [self.view addSubview:savedView];
		}
		
		
		else if([StoredData sharedData].isRelatedArticle){
			alertLAbel.text=@"No Related Article Found.";
		    savedView.frame=CGRectMake(0,150, 320, 225);
		    [self.view addSubview:savedView];
		}
	}

}


-(IBAction)backButtonClicked{
    
    
    if([StoredData sharedData].isRelatedArticle && [StoredData sharedData].isVideo)
    {
        
        [StoredData sharedData].isVideo=TRUE; 
        
    }

	[StoredData sharedData].isRelatedVideo=FALSE;
	[StoredData sharedData].isRelatedArticle=FALSE;
	[[self navigationController] popViewControllerAnimated:YES];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrRelVideoDetail count];
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
	
	cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"Title"]];
	NSString *getDate=[NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"DatePosted"]];
	cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"Author"]];
	cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"ArticleTypeText"]];
    cell.videoView.hidden=YES;
	NSString *newDateString=[self convertDateFormat:getDate];
	cell.lblDesc.text=newDateString;
	
	if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"ArticleID"]]])
	{
		cell.lblTitle.textColor=[UIColor grayColor];
		
	}
	NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"IsAuthenticated"]];
	//if([StoredData sharedData].isUserAuthenticated==FALSE)
    if([Functions canView:L_News] == NO)
	{
		if([isAuth isEqual:@"true"]){
			cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
		}
		else{
			cell.lockImg.image=[UIImage imageNamed:@".png"];
		}
	}
	
	
	NSString *isImage = [NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"ImageURL"]];
	if([isImage isEqual:@"no image"])
	{
		cell.frameImage.hidden=YES;
		if([StoredData sharedData].isRelatedArticle){
		    cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
			cell.lockImg.frame=CGRectMake(296,64,16,18);}
		
		else{
		}
		
		
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
	
	if([StoredData sharedData].isRelatedVideo){
		cell.videoView.hidden=NO;
		[cell.videoView addTarget:self action:@selector(playVideo:)forControlEvents:UIControlEventTouchUpInside];
		[cell.videoView setTag:indexPath.row];
	}
	
	return cell;	
	
}

-(void)fetchImage:(NSDictionary *)obj 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	int photoId = [[obj objectForKey:@"rowVal"] intValue];
	
	NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrRelVideoDetail objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
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
   	UIView*  cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(15, 8, 295,75)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	
	
	
	NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:indexPath.row]objectForKey:@"IsAuthenticated"]];
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
			[objArticle setDataForDetailsView:[arrRelVideoDetail objectAtIndex:indexPath.row]];
			[objArticle setArray:arrRelVideoDetail];
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
		[objArticle setDataForDetailsView:[arrRelVideoDetail objectAtIndex:indexPath.row]];
		[objArticle setArray:arrRelVideoDetail];
		objArticle.selectedRowint = indexPath.row;
		[navC pushViewController:objArticle animated:YES];
		[objArticle release];
		objArticle=nil;
	}	
}



#pragma mark playVideo
- (void)playVideo:(id)sender
{
	UIButton *button = (UIButton *)sender;
    int row = button.tag;
	//NSLog(@"self.strVideo %@",self.strVideo);
	self.strVideo=[NSString stringWithFormat:@"%@",[[arrRelVideoDetail objectAtIndex:row]objectForKey:@"VideoURL"]];
	MyMovViewController *mp = [[MyMovViewController alloc] initWithContentURL:[NSURL URLWithString:self.strVideo]];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	[[mp moviePlayer] prepareToPlay];
	[[mp moviePlayer] setShouldAutoplay:YES];
	[[mp moviePlayer] setControlStyle:MPMovieControlStyleFullscreen];
    // [[mp moviePlayer] setMovieSourceType:MPMovieSourceTypeStreaming];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[self presentMoviePlayerViewControllerAnimated:mp];
	[mp release];
}

-(void)videoPlayBackDidFinish:(NSNotification*)notification
{   
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
	[self dismissMoviePlayerViewControllerAnimated];
}





#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)	
	{
		UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
		LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
		[navC pushViewController:login animated:YES];
		[login release];
		login=nil;
	}
    else if(buttonIndex == 1) 
    {
		RegisterViewController *signUp =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
		[[self navigationController] pushViewController:signUp animated:YES];
		[signUp release];
		signUp=nil;
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

-(void)viewWillAppear:(BOOL)animated{
	
	[customAlert.view removeFromSuperview];
	[myTable reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
}

- (void)dealloc{
	[strVideo release];
	[customCell release];
	[topicID release];
	[strVideo release];
	[objArticleParser release];
	[appDelegate release];
	[arrRelVideoDetail release];
	[imagesArray release];
	[inputFormatter release];
	[outputFormatter release];
    [super dealloc];
}


@end
