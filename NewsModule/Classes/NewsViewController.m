//
//  NewsViewController.m
//  Rapnet
//
//  Created by Saurabh Verma on 12/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import "Reachability.h"
#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "CustomAlertViewController.h"
#import "funcClass.h"
#import "AppDelegate.h"
#import "ObjSavedArticles.h"
#import "ActivityAlertView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NewsCustomCell.h"
#import "Database.h"
#import "MoreViewC.h"
#import "Constants.h"


@interface MyMovieViewController : MPMoviePlayerViewController
@end

@implementation MyMovieViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
@end


@implementation NewsViewController
@synthesize  myTableView,activitiesArray,customCell,strSearch,mySavedArticles,strVideo,swipeLeftRecognizer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"News", @"News");
        self.tabBarItem.image = [UIImage imageNamed:@"news.png"];
    }
    
    [AnalyticHelper sendView:@"News"];
    
    isFirstTime = YES;
    return self;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES];
	[super viewDidLoad];
	[self initReachability];
    
	myTableView.bounces=YES;
	rightHide=NO;
	leftHide=YES;
	isTrue=YES;
	count=1;
	ALTERNATE=TRUE;
	myTableView.hidden=NO;
	
	tabNews.hidden=NO;
	tabVideos.hidden=YES;
	tabSaved.hidden=YES;
	tabSearch.hidden=YES;
	tabPopular.hidden=YES;
	tabMore.hidden=YES;
	
	[self.view addSubview:rightArrowImageView]; 
	
	imagesArray = [[NSMutableArray alloc] init];
	videoImagesArray = [[NSMutableArray alloc] init];
	searchImagesArray = [[NSMutableArray alloc] init];
	savedImagesArray = [[NSMutableArray alloc] init];
	viewedImagesArray= [[NSMutableArray alloc] init];
	editorImagesArray=[[NSMutableArray alloc]init];
	arrpageNo = [[NSMutableArray alloc]init];
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[StoredData sharedData].isNews=TRUE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[self createScreenComponents];
	
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

                [self webserviceCallStart];
                break;
            }
        }
        
    }
    isFirstTime = NO;
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


#pragma mark createScreenComponents
-(void)createScreenComponents
{
	[myScrollView setShowsHorizontalScrollIndicator:NO];
	[myScrollView setShowsVerticalScrollIndicator:NO];
	
    [self.view addSubview:myScrollView];
    myScrollView.frame = CGRectMake(0, 35, 320, 35);
    myScrollView.contentSize = CGSizeMake(360, 35);
   
    
    leftArrowImageView.frame = CGRectMake(0, 35, 20, 35);
    rightArrowImageView.frame = CGRectMake(300, 35, 20, 35);
    [self.view addSubview:rightArrowImageView];

    if (_refreshHeaderView == nil)
	{
		EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
		view1.delegate = self;
		[self.myTableView addSubview:view1];
		_refreshHeaderView = view1;
		[view1 release];
	}
	[_refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark showPageNumber
-(void)showPageNumber
{
	txtPageNo= 1;
	NSString* abc=[[[NSString alloc]init]autorelease];
	if([StoredData sharedData].isNews){
	    abc= [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:0]objectForKey:@"TotalCount"]];
	}
	if([StoredData sharedData].isVideo){
		abc= [NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:0]objectForKey:@"TotalCount"]];
	}
	if([StoredData sharedData].isSearch){
		abc= [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:0]objectForKey:@"TotalCount"]];
	}
	totalPages =  [abc intValue]/10;
	for (int i=0 ; i<totalPages; i++){
		[arrpageNo addObject:[NSNumber numberWithInt:count++]];
	}
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if([StoredData sharedData].isViewed){
		if(section==0){
			return 30;
		}
		
		if(section==1){
            return 30;
		}
	}
	
	return 0;
}


#pragma mark view for header methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if([StoredData sharedData].isViewed){
		if(section==0){
			UIView* headerView = [[[UIView alloc] initWithFrame: CGRectMake(0.0,0.0,320.0,27.0)]autorelease];
			headerView.backgroundColor=[UIColor blackColor];
			headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mostViewed.png"]];
			return headerView;
            
		}
		if(section==1){
			
			UIView* headerView = [[[UIView alloc] initWithFrame: CGRectMake(0.0,0.0,320.0,27.0)]autorelease];
			headerView.backgroundColor=[UIColor blackColor];
			headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"editorPick.png"]];
			return headerView;
	        }
	}
	
	return 0;
}




#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//for pull to refresh
	if (indexPath.row==0){
        return 0;
	}
	//for news
	if([StoredData sharedData].isNews){
		if(indexPath.row-1==[arrAllArticles count]){
			 return 60;
		}
	}

	//for video
	if([StoredData sharedData].isVideo){
		if(indexPath.row-1==[arrAllVideos count]){
			return 60;
		}
	}
	
	//for search
	if([StoredData sharedData].isSearch){
		if(indexPath.row-1==[arrSearchResults count]){
			return 60;
		}
		else{
			 return 90;
		}
	}
	
	//for other
	 else{
		 return 90;
	 }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if([StoredData sharedData].isViewed){
		return 2;
	}
	else{
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{	
	
	//for News Tab
	if([StoredData sharedData].isNews)
	{
       // NSLog(@"[arrAllArticles count] %d",[arrAllArticles count]);
        
		if([arrAllArticles count]>0){
			if ( [arrAllArticles count] < 10){
                
				return [arrAllArticles count]+1;
                
			}
			else{
				return [arrAllArticles count]+2;
			}
		}
	}
	
	//for search Tab
	if([StoredData sharedData].isSearch)
	{
		if([arrSearchResults count]>0){
			if ( [arrSearchResults count] < 10 ){
				return [arrSearchResults count]+1;
			}
			else{
				return [arrSearchResults count]+2;
			}
		}
		
		if([arrSearchResults count]==1){
			return [arrSearchResults count]+1;
		}
	}
	
	//for video tab
	if([StoredData sharedData].isVideo)
	{
		if([arrAllVideos count]>0){
			if ( [arrAllVideos count] < 10 ){
				return [arrAllVideos count]+1;
			}
			else{
				return [arrAllVideos count]+2;
			}
		}
	}
	
	//for most popular tab
	if([StoredData sharedData].isViewed)
	{
		if(section==0){
			if([arrMostViewed count]>0){
			return [arrMostViewed count];
                
			}
		}
		if(section==1){
			if([arrEditorArticle count]>0){
			return [arrEditorArticle count];
                return 10;
                
			}
		}
		
	}
	//for saved tab
	if([StoredData sharedData].isSaved){
		if([[StoredData sharedData].arrSavedArticle count] > 0 )
	   { return [[StoredData sharedData].arrSavedArticle count]+1;}
	}

	return 0;	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"ApplicationCell";
	cell = (NewsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil){
		[[NSBundle mainBundle] loadNibNamed:@"NewsCustomTableCell" owner:self options:nil];
		cell = customCell;
		self.customCell = nil;
	}

	if(indexPath.row==0){
		UITableViewCell *zeroCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"none"];
		return zeroCell;
	}
	
    //for News Tab 
	if([StoredData sharedData].isNews)
	{
		if([arrAllArticles count]>0)
		{
		    cell.videoView.hidden=YES;	
		    if (indexPath.row-1 != [arrAllArticles count])
		   {

		  cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"Title"]];
		  cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"Author"]];
		  cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"ArticleTypeText"]];
		  NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
		  NSString *isImage = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"ImageURL"]];
		  NSString *getDate = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"DatePosted"]];
		  NSString *videoURL = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"VideoURL"]];
		
		  NSString *newDateString=[self convertDateFormat:getDate];
	
		  cell.lblDesc.text=newDateString;
			
			if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"ArticleID"]]])
			{
				cell.lblTitle.textColor=[UIColor grayColor];
			}
			
			if(![videoURL isEqual:@""]){
				cell.videoView.hidden=NO;
				[cell.videoView addTarget:self action:@selector(playVideo:)forControlEvents:UIControlEventTouchUpInside];
				[cell.videoView setTag:indexPath.row-1];
			}
			
			
			//if([StoredData sharedData].isUserAuthenticated==FALSE)
            if([[[StoredData sharedData] loginData] canView:L_News] == NO)
			{
				if([isAuth isEqual:@"true"]){
					cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
				}
				else{
					cell.lockImg.image=[UIImage imageNamed:@".png"];
				}
			}
		
			if([isImage isEqual:@"no image"])
			{
				cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
				cell.frameImage.hidden=YES;
				//cell.lockImg.frame=CGRectMake(296,64,16,18);
			}
			else
			{			
				if([imagesArray objectAtIndex:indexPath.row-1] != [NSNull null]){
					cell.mImageView.image  = [imagesArray objectAtIndex:indexPath.row-1];
				}
				else{
					NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
					[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowVal"];
					[data setObject: cell.mImageView forKey: @"imageView"];
					[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
					[data release];
				}
			}
		}
	    else if (indexPath.row-1 == [arrAllArticles count] ){
			 cell.lblTitle.frame=CGRectMake(17, 22,145, 35);
			 cell.lblTitle.text=@"More News...";
			 cell.mImageView.image=nil;
			 cell.frameImage.hidden=YES;
			 cell.videoView.hidden=YES;
			 cell.accessoryType=UITableViewCellAccessoryNone;
		  }
	   
	   }
	}
	
	
	//For Videos Tab
	if([StoredData sharedData].isVideo)
	{
	   if([arrAllVideos count]>0)
	   {
		if (indexPath.row-1 != [arrAllVideos count])
	    {
		cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"Title"]];
		NSString *getDate=[NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"DatePosted"]];
		NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
		cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"ArticleTypeText"]];
		cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"Author"]];
		NSString *newDateString=[self convertDateFormat:getDate];
		cell.lblDesc.text=newDateString;
		cell.videoView.hidden=NO;
			
		[cell.videoView addTarget:self action:@selector(playVideo:)forControlEvents:UIControlEventTouchUpInside];	
		[cell.videoView setTag:indexPath.row-1];
			
		if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"ArticleID"]]])
		{
			cell.lblTitle.textColor=[UIColor grayColor];
			
		}
			
		//if([StoredData sharedData].isUserAuthenticated==FALSE)
        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
		{
			if([isAuth isEqual:@"true"]){
				cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
			}
			else{
				cell.lockImg.image=[UIImage imageNamed:@".png"];
			}
		}
	
		if([videoImagesArray objectAtIndex:indexPath.row-1] != [NSNull null])
		{
			cell.mImageView.image  = [videoImagesArray objectAtIndex:indexPath.row-1];
		}
		else{
			NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
			[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowVal"];
			[data setObject: cell.mImageView forKey: @"imageView"];
			[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
			[data release];
		     }
		}
		else if (indexPath.row-1 == [arrAllVideos count] )
		{
			cell.lblTitle.frame=CGRectMake(17, 22,145, 35);
			cell.lblTitle.text=@"More Videos...";
			cell.mImageView.image=nil;
			cell.videoView.hidden=YES;
			cell.frameImage.hidden=YES;
			cell.accessoryType=UITableViewCellAccessoryNone;
		}
	  }	   
	}
	
	//for search Tab
	if([StoredData sharedData].isSearch)
	{
		if([arrSearchResults count]>0)
		{
			if (indexPath.row-1 != [arrSearchResults count])
			{
			cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"Title"]];
			cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"ArticleTypeText"]];
			NSString *getDate=[NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"DatePosted"]];
			NSString *isImage = [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"ImageURL"]];
			NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
			cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"Author"]];
			cell.videoView.hidden=YES;
			
			NSString *newDateString=[self convertDateFormat:getDate];
			cell.lblDesc.text=newDateString;
				
			if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"ArticleID"]]])
			{
				cell.lblTitle.textColor=[UIColor grayColor];
				
			}
				
			//if([StoredData sharedData].isUserAuthenticated==FALSE)
            if([[[StoredData sharedData] loginData] canView:L_News] == NO)
			{
				if([isAuth isEqual:@"true"]){
					cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
				}
				else{
					cell.lockImg.image=[UIImage imageNamed:@".png"];
				}
			}	
				
				
			if([isImage isEqual:@"no image"]){
				cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
				cell.frameImage.hidden=YES;
			}
			else
			{	
				if([searchImagesArray objectAtIndex:indexPath.row-1] != [NSNull null]){
					cell.mImageView.image  = [searchImagesArray objectAtIndex:indexPath.row-1];
				}
				else{
					NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
					[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowVal"];
					[data setObject: cell.mImageView forKey: @"imageView"];
					[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
					[data release];
				}
			  }
		    }
			else if ([arrSearchResults count]>1)
			{
				if(indexPath.row-1 == [arrSearchResults count] )
				{
				cell.lblTitle.frame=CGRectMake(17, 22,145, 35);
				cell.lblTitle.text=@"More Results...";
				cell.mImageView.image=nil;
				cell.videoView.hidden=YES;
				cell.frameImage.hidden=YES;
				cell.accessoryType=UITableViewCellAccessoryNone;
				}
			}
		}
	}
	
    //for most popular tab
	if([StoredData sharedData].isViewed)
	{
		if(indexPath.section==0)
		{
			if([arrMostViewed count]>0)
			{
				cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"Title"]];
				cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"Author"]];
				cell.lblDesc.text=[NSString stringWithFormat:@"Views:%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"Viewings"]];
				cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"ArticleTypeText"]];
				NSString *isImage = [NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"ImageURL"]];
				NSString *videoURL = [NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"VideoURL"]];
				NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
				cell.videoView.hidden=YES;
			
				if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"ArticleID"]]])
				{
					cell.lblTitle.textColor=[UIColor grayColor];
				}
				
				if(![videoURL isEqual:@""]){
					cell.videoView.hidden=NO;
					[cell.videoView addTarget:self action:@selector(playVideo:)forControlEvents:UIControlEventTouchUpInside];
					[cell.videoView setTag:indexPath.row-1];
				}
			
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([[[StoredData sharedData] loginData] canView:L_News] == NO)
				{
					if([isAuth isEqual:@"true"]){
						cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
					}
					else{
						cell.lockImg.image=[UIImage imageNamed:@".png"];
					}
				}
			
				if([isImage isEqual:@"no image"]){
					cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
					cell.frameImage.hidden=YES;
				}
				else
				{	
					if([viewedImagesArray objectAtIndex:indexPath.row-1] != [NSNull null])
					{
						cell.mImageView.image  = [viewedImagesArray objectAtIndex:indexPath.row-1];
					}
					else
					{
						NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
						[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowValue"];
						[data setObject: cell.mImageView forKey: @"imageView"];
						[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
						[data release];
					}
			   }
		   }
	   }
		
		
		if(indexPath.section==1)
		{
			if([arrEditorArticle count]>0)
			{
				cell.lblTitle.text=[NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"Title"]];
				cell.lblAuth.text=[NSString stringWithFormat:@"-%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"Author"]];
				cell.lblType.text=[NSString stringWithFormat:@"| %@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"ArticleTypeText"]];
				NSString *isImage = [NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"ImageURL"]];
				NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
				NSString *getDate=[NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"DatePosted"]];
				NSString *newDateString=[self convertDateFormat:getDate];
				cell.lblDesc.text=newDateString;
				cell.videoView.hidden=YES;
			
				if ([[StoredData sharedData].arrReadArticle containsObject:[NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"ArticleID"]]])
				{
					cell.lblTitle.textColor=[UIColor grayColor];
					
				}
				
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([[[StoredData sharedData] loginData] canView:L_News] == NO)
				{
					if([isAuth isEqual:@"true"]){
						cell.lockImg.image=[UIImage imageNamed:@"lock.png"];
					}
					else{
						cell.lockImg.image=[UIImage imageNamed:@".png"];
					}
				}
				
				if([isImage isEqual:@"no image"]){
					cell.frameImage.hidden=YES;
					cell.lblTitle.frame=CGRectMake(17, 13,295, 37);
				}
				else
				{	
					if([editorImagesArray objectAtIndex:indexPath.row-1] != [NSNull null]){
						cell.mImageView.image  = [editorImagesArray objectAtIndex:indexPath.row-1];
					}
					else{
						NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
						[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowVal"];
						[data setObject: cell.mImageView forKey: @"imageView"];
						[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
						[data release];
					}
				}
				
			}
		}
	}
	
	//for Saved Tab
	if([StoredData sharedData].isSaved)
	{
		cell.videoView.hidden=YES;
		if([[StoredData sharedData].arrSavedArticle count] > 0 ){
		self.mySavedArticles = [[StoredData sharedData].arrSavedArticle objectAtIndex:indexPath.row-1];
		NSString *isImage = [NSString stringWithFormat:@"%@",self.mySavedArticles.imageURL];
		cell.lblTitle.text = self.mySavedArticles.title;
		cell.lblAuth.text=self.mySavedArticles.author;
		cell.lblType.text=self.mySavedArticles.articleType;
			if(![self.mySavedArticles.videoURL isEqual:@""]){
		       cell.videoView.hidden=NO;
			   [cell.videoView addTarget:self action:@selector(playVideo:)forControlEvents:UIControlEventTouchUpInside];
			   [cell.videoView setTag:indexPath.row-1];
			}
			
		NSString *getDate =self.mySavedArticles.date; 
		NSString *newDateString=[self convertDateFormat:getDate];
		cell.lblDesc.text=newDateString;
		if ([[StoredData sharedData].arrReadArticle containsObject:self.mySavedArticles.articleID])
		{
			cell.lblTitle.textColor=[UIColor grayColor];
		}	
		if([isImage isEqual:@"no image"])
		{
		   cell.lblTitle.frame=CGRectMake(17, 13,295, 35);
		   cell.frameImage.hidden=YES;

		}	
		else
		{	
			if(savedImagesArray.count > 0 && [savedImagesArray objectAtIndex:indexPath.row-1] != [NSNull null]){
				cell.mImageView.image  = [savedImagesArray objectAtIndex:indexPath.row-1];
			}
			else{
				NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
				[data setObject:[NSString stringWithFormat:@"%i",indexPath.row-1] forKey: @"rowVal"];
				[data setObject: cell.mImageView forKey: @"imageView"];
				[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data]; 
				[data release];
			}
		  }
		}
	}

	return cell;	
}


-(void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(editingStyle == UITableViewCellEditingStyleDelete) 
	{
		ObjSavedArticles *aSavedObj=[[StoredData sharedData].arrSavedArticle objectAtIndex:indexPath.row-1];
		[Database deleteArticle:[Database getDBPath] arg2:[aSavedObj.articleID intValue]];
		[[StoredData sharedData].arrSavedArticle removeObjectAtIndex:indexPath.row-1];
		[savedImagesArray removeObjectAtIndex:indexPath.row-1];
		[myTableView reloadData];
	}
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([StoredData sharedData].isSaved)
	{
		return YES;
	}
	else
	{
	   return NO;
	}
}


- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NewsCustomCell *currentCell =(NewsCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	currentCell.mImageView.frame=CGRectMake(165, 10, 83, 72);
	currentCell.frameImage.frame=CGRectMake(163, 8, 87, 76);
	currentCell.lblTitle.frame=CGRectMake(17, 13,145, 35);
	currentCell.lblType.frame=CGRectMake(93,47,60,14);
	currentCell.videoView.frame=CGRectMake(170,50,30,30);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	[UIView commitAnimations];

}


- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NewsCustomCell *currentCell =(NewsCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
	currentCell.mImageView.frame=CGRectMake(225, 10, 83, 72);
	currentCell.frameImage.frame=CGRectMake(223, 8, 87, 76);
	currentCell.lblTitle.frame=CGRectMake(17, 13,195, 35);
	currentCell.lblType.frame=CGRectMake(93,47,120,14);
	currentCell.videoView.frame=CGRectMake(230,50,30,30);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	[UIView commitAnimations];	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[myTableView reloadData];
	UIView *cellBackGroundView = [[[UIView alloc] initWithFrame:CGRectMake(15, 8, 295,75)]autorelease];
	cellBackGroundView.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:cellBackGroundView];
	//[cellBackGroundView release];
	
	newsDetailViewController = [[NewsDetailViewController alloc] init];
	//for news tab
	if([StoredData sharedData].isNews)
	{
		if([arrAllArticles count]>0)
		{
			if ( [arrAllArticles count] == 10 )
			{ 
				if (indexPath.row-1 == [arrAllArticles count]){
					[self callMoreService];
				} 
				else
				{
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];
				
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrAllArticles objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrAllArticles];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}
					else{
						
							[newsDetailViewController setDataForDetailsView:[arrAllArticles objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrAllArticles];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
					    }
				     }
			    }
			
			else if([arrAllArticles count]> 10)
			{
				if (indexPath.row-1 == [arrAllArticles count] ){
					[self callMoreService];
				}
				else{
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrAllArticles objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrAllArticles];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}	
					else
					{   
						[newsDetailViewController setDataForDetailsView:[arrAllArticles objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrAllArticles];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
			}
		}
	}

	//for video tab
   if([StoredData sharedData].isVideo)
	{
		if([arrAllVideos count]>0)
		{
			if ( [arrAllVideos count] == 10 )
			{ 
				if (indexPath.row-1 == [arrAllVideos count]) {
					[self callMoreService];
				} 
				else
				{   
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];	
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrAllVideos objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrAllVideos];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}
					else{
						[newsDetailViewController setDataForDetailsView:[arrAllVideos objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrAllVideos];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
			}
			
			else if([arrAllVideos count]> 10)
			{
				if (indexPath.row-1 == [arrAllVideos count]){
					[self callMoreService];
				}
				else
				{
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrAllVideos objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrAllVideos];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}
					else
					{
						[newsDetailViewController setDataForDetailsView:[arrAllVideos objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrAllVideos];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
			}
		}
	}	
	
	
	//for search tab
	if([StoredData sharedData].isSearch)
	{
		if([arrSearchResults count]>0)
	   {
			if ([arrSearchResults count] == 10)
			{ 
				if (indexPath.row-1 == [arrSearchResults count]){
					[self callMoreService];
				} 
				else
				{  
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];	
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrSearchResults];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}
					else{
						[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrSearchResults];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
			}
		   
			else if([arrSearchResults count]<10)
			{
				NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
				if([isAuth isEqual:@"true"])
				{
					//if([StoredData sharedData].isUserAuthenticated==FALSE)
                    if([[[StoredData sharedData] loginData] canView:L_News] == NO)
					{
						[self showAlertView];;	
					}
					else
					{
						[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrSearchResults];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
				else{
					[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
					[newsDetailViewController setArray:arrSearchResults];
					newsDetailViewController.selectedRowint = indexPath.row-1;
					[self navigateDetailScreen];
				}

			}
			
			else if([arrSearchResults count]> 10)
			{
				if (indexPath.row-1 == [arrSearchResults count] ){
					[self callMoreService];
				}
				else
				{
					NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrSearchResults objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
					if([isAuth isEqual:@"true"])
					{
						//if([StoredData sharedData].isUserAuthenticated==FALSE)
                        if([[[StoredData sharedData] loginData] canView:L_News] == NO)
						{
							[self showAlertView];	
						}
						else
						{
							[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
							[newsDetailViewController setArray:arrSearchResults];
							newsDetailViewController.selectedRowint = indexPath.row-1;
							[self navigateDetailScreen];
						}
					}
					else{
						[newsDetailViewController setDataForDetailsView:[arrSearchResults objectAtIndex:indexPath.row-1]];
						[newsDetailViewController setArray:arrSearchResults];
						newsDetailViewController.selectedRowint = indexPath.row-1;
						[self navigateDetailScreen];
					}
				}
			}
	    }
	}
	
	
	//for Most Popular tab
	if([StoredData sharedData].isViewed)
	{	
		if(indexPath.section==0){
			NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
			if([isAuth isEqual:@"true"])
			{
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([[[StoredData sharedData] loginData] canView:L_News] == NO)
				{
					[self showAlertView];	
				}
				else
				{
					[newsDetailViewController setDataForDetailsView:[arrMostViewed objectAtIndex:indexPath.row-1]];
					[newsDetailViewController setArray:arrMostViewed];
					newsDetailViewController.selectedRowint = indexPath.row-1;
					[self navigateDetailScreen];
				}
			}
			else{
				[newsDetailViewController setDataForDetailsView:[arrMostViewed objectAtIndex:indexPath.row-1]];
				[newsDetailViewController setArray:arrMostViewed];
				newsDetailViewController.selectedRowint = indexPath.row-1;
				[self navigateDetailScreen];
			}
		}
		if(indexPath.section==1){
			
			
			NSString *isAuth = [NSString stringWithFormat:@"%@",[[arrEditorArticle objectAtIndex:indexPath.row-1]objectForKey:@"IsAuthenticated"]];
			if([isAuth isEqual:@"true"])
			{
				//if([StoredData sharedData].isUserAuthenticated==FALSE)
                if([[[StoredData sharedData] loginData] canView:L_News] == NO)
				{
					[self showAlertView];	
				}
				else
				{
					[newsDetailViewController setDataForDetailsView:[arrEditorArticle objectAtIndex:indexPath.row-1]];
					[newsDetailViewController setArray:arrEditorArticle];
					newsDetailViewController.selectedRowint = indexPath.row-1;
					[self navigateDetailScreen];
				}
			}
			else{
			
			[newsDetailViewController setDataForDetailsView:[arrEditorArticle objectAtIndex:indexPath.row-1]];
			[newsDetailViewController setArray:arrEditorArticle];
			newsDetailViewController.selectedRowint = indexPath.row-1;
			[self navigateDetailScreen];
		}
		}
	}

	
	//for Saved Section
	if([StoredData sharedData].isSaved)
	{
		if([[StoredData sharedData].arrSavedArticle count] > 0 )
		{
			self.mySavedArticles=[[StoredData sharedData].arrSavedArticle objectAtIndex:indexPath.row-1];
			newsDetailViewController.objSaved=mySavedArticles;
			[newsDetailViewController setArray:[StoredData sharedData].arrSavedArticle];
			newsDetailViewController.selectedRowint = indexPath.row-1;
			[self navigateDetailScreen];
		}
	}
}


-(void)resizeCell{
	cell.mImageView.frame=CGRectMake(185, 10, 83, 72);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	[UIView commitAnimations];
}


#pragma mark dateformatter
-(NSString*)convertDateFormat:(NSString*)dateString
{
	ReleaseObject(inputFormatter);
	ReleaseObject(outputFormatter);
	inputFormatter= [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	
	NSDate *formatterDate = [inputFormatter dateFromString:dateString];
	outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"dd-MMM-yyyy"];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSString *newDate = [outputFormatter stringFromDate:formatterDate];
	return newDate;
	[newDate release];
}


-(void)callMoreService
{
	int pageNo = txtPageNo;
	if ((pageNo+1) <= totalPages)
	{
		//NSLog(@"txtPageNo %d",txtPageNo);
		//NSLog(@"txtPageNo %d",totalPages);
		
		txtPageNo = (pageNo + 1); 
		int startNode = ((pageNo + 1) * 10) - 9;
		int endNode = (pageNo + 1) * 10;
		
		if([StoredData sharedData].isNews){
		[objArticleParser getNewsWithSearchString:startNode endRow:endNode languageId:1];
		}
		
		if([StoredData sharedData].isVideo){
			[objVideoParser getNewsWithSearchString:startNode endRow:endNode articleType:8 languageId:1];
		}

		if([StoredData sharedData].isSearch){
			[objSearchParser getNewsWithSearchString:searchBar.text startRow:startNode endRow:endNode articleType:2 languageId:1];
		}
		[appDelegate showActivityIndicator:self];
	}
	
	AppDelegate *getDelegate = [UIApplication sharedApplication].delegate;
	getDelegate.activityView.frame = CGRectMake(260, 420, 20, 20);
}


-(void)navigateDetailScreen{
	[[self navigationController] pushViewController:newsDetailViewController animated:YES];

}

#pragma mark fetchImage
-(void)fetchImage:(NSDictionary *)obj 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	if([StoredData sharedData].isNews)
	{
		int photoId = [[obj objectForKey:@"rowVal"] intValue];
		NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrAllArticles objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
		UIImage *myImage;
		if(mydata)
		{
			myImage = [[UIImage alloc] initWithData:mydata];
			if(!([imagesArray count]==0)){
				[imagesArray replaceObjectAtIndex:photoId withObject:myImage];}
			[(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
			
			[myImage release];
			[mydata release];
		}
		else{
			
		}
	}
	if([StoredData sharedData].isVideo)
	{
		int photoId = [[obj objectForKey:@"rowVal"] intValue];
		NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrAllVideos objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
		UIImage *myImage;
		if(mydata)
		{
			myImage = [[UIImage alloc] initWithData:mydata];
			if(!([videoImagesArray count]==0)){
				[videoImagesArray replaceObjectAtIndex:photoId withObject:myImage];}
			[(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
			
			[myImage release];
			[mydata release];
		}
	}

	if([StoredData sharedData].isSearch)
	{
		int photoId = [[obj objectForKey:@"rowVal"] intValue];
		NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrSearchResults objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
		UIImage *myImage;
		if(mydata)
		{
			myImage = [[UIImage alloc] initWithData:mydata];
			if(!([searchImagesArray count]==0)){
				[searchImagesArray replaceObjectAtIndex:photoId withObject:myImage];}
			[(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
			
			[myImage release];
			[mydata release];
		}
	}
    
    
    if([StoredData sharedData].isEditor)
	{
        if([arrEditorArticle count]>0)
        {
            int photoId = [[obj objectForKey:@"rowVal"] intValue];
            NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrEditorArticle objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
            UIImage *myImage;
            if(mydata)
            {
                myImage = [[UIImage alloc] initWithData:mydata];
                if(!([editorImagesArray count]==0)){
                    [editorImagesArray replaceObjectAtIndex:photoId withObject:myImage];}
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
                
                [myImage release];
                [mydata release];
            }
        }
	}

	
	if([StoredData sharedData].isViewed)
	{
       if([arrMostViewed count]>0)
       {
            int photoId =[[obj objectForKey:@"rowValue"]intValue];
            NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[arrMostViewed objectAtIndex:photoId]objectForKey:@"ImageURL"]]];
            UIImage *myImage;
            if(mydata)
            {
                myImage = [[UIImage alloc] initWithData:mydata];
                if(!([viewedImagesArray count]==0)){
                    [viewedImagesArray replaceObjectAtIndex:photoId withObject:myImage];}
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
                
                [myImage release];
                [mydata release];
            }
       }
	}
	
	
	
	if([StoredData sharedData].isSaved)
	{
		int photoId = [[obj objectForKey:@"rowVal"] intValue];
		
		if([[StoredData sharedData].arrSavedArticle count] > 0 ){
			self.mySavedArticles = [[StoredData sharedData].arrSavedArticle objectAtIndex:photoId];}
		NSData *mydata= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.mySavedArticles.imageURL]];
		UIImage *myImage;
		if(mydata)
		{
			myImage = [[UIImage alloc] initWithData:mydata];
			if(!([savedImagesArray count]==0)){
				[savedImagesArray replaceObjectAtIndex:photoId withObject:myImage];}
			[(UIImageView *)[obj objectForKey:@"imageView"] setImage:myImage];
			[myImage release];
			[mydata release];
		}
	}
	
	[appDelegate stopActivityIndicator:self];
	[pool release];
}



#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
 	_reloading = YES;
}

- (void)doneLoadingTableViewData
{    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[appDelegate stopActivityIndicator:self];
	 if (scrollView.contentOffset.x >=40.0){
		 rightHide=YES;
		 leftHide=NO;
		 [self.view addSubview:leftArrowImageView];
		 [rightArrowImageView removeFromSuperview];
	  }
	
	 else if (scrollView.contentOffset.x<=20.0){
		rightHide=NO;
		leftHide=YES;
		[self.view addSubview:rightArrowImageView];
		[leftArrowImageView removeFromSuperview];
	  }
	
	else if(scrollView.contentOffset.x<42||scrollView.contentOffset.x>21 )
	{
		rightHide=NO;
		leftHide=NO;
		[self.view addSubview:rightArrowImageView];
		[self.view addSubview:leftArrowImageView];
	}

    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self webserviceCallStart];
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; 
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; 
	
}

#pragma mark - Recieved actions
- (void)playVideo:(id)sender
{
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 32000
		UIButton *button = (UIButton *)sender;
		int row = button.tag;
	
	if([StoredData sharedData].isNews){
		self.strVideo=[NSString stringWithFormat:@"%@",[[arrAllArticles objectAtIndex:row]objectForKey:@"VideoURL"]];
	}
	if([StoredData sharedData].isVideo){
		self.strVideo=[NSString stringWithFormat:@"%@",[[arrAllVideos objectAtIndex:row]objectForKey:@"VideoURL"]];
	}
	else if([StoredData sharedData].isViewed){
		self.strVideo=[NSString stringWithFormat:@"%@",[[arrMostViewed objectAtIndex:row]objectForKey:@"VideoURL"]];
	}
	else if([StoredData sharedData].isSaved){
		self.strVideo=self.mySavedArticles.videoURL;
	}
    NSLog(@"video play");
		MyMovieViewController *mp = [[MyMovieViewController alloc] initWithContentURL:[NSURL URLWithString:self.strVideo]];
	    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		[[mp moviePlayer] prepareToPlay];
		[[mp moviePlayer] setShouldAutoplay:YES];
		[[mp moviePlayer] setControlStyle:MPMovieControlStyleFullscreen];
    // [[mp moviePlayer] setMovieSourceType:MPMovieSourceTypeStreaming];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		[self presentMoviePlayerViewControllerAnimated:mp];
		[mp release];
		
	#else
		NSLog(@"video play1");
		movPlay = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:self.strVideo]];
		[self presentModalViewController:movPlay animated:YES];
		[movPlay readyPlayer]; 
		
	#endif
}

- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	[[NSNotificationCenter 	defaultCenter] removeObserver:self name:MPMoviePlayerContentPreloadDidFinishNotification object:nil];
 	[movPlay play];
}

-(void)videoPlayBackDidFinish:(NSNotification*)notification
{  
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
	[self dismissMoviePlayerViewControllerAnimated];
}

-(IBAction)newsCategoryButtonClicked:(id)sender
{
	txtPageNo=1;
	myTableView.bounces=YES;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[moreViewC.view removeFromSuperview];
	ReleaseObject(moreViewC);
	[searchView removeFromSuperview];
	myTableView.hidden=NO;
	[self.view addSubview:myTableView];
	myTableView.backgroundColor=[UIColor whiteColor];
		
	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[StoredData sharedData].isNews=TRUE;
	
	
	tabNews.hidden=NO;
	tabVideos.hidden=YES;
	tabSaved.hidden=YES;
	tabSearch.hidden=YES;
	tabPopular.hidden=YES;
	tabMore.hidden=YES;
	
	[self.view addSubview:myScrollView];
    [self.view addSubview:rightArrowImageView];
	[self webserviceCallStart];
	
    UIButton* button = (UIButton*)sender;
    CGRect frame = tabNews.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabNews.frame = frame;
	
	myScrollView.frame = CGRectMake(0, 35, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+10, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
    
    [AnalyticHelper sendView:@"News - Most Popular"];
	
}

-(IBAction)videoButtonClick:(id)sender
{
	txtPageNo=1;
	myTableView.bounces=YES;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[moreViewC.view removeFromSuperview];
	ReleaseObject(moreViewC);
	[searchView removeFromSuperview];
	[savedView removeFromSuperview];
	myTableView.hidden=NO;
	myTableView.backgroundColor=[UIColor whiteColor];
	
	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[StoredData sharedData].isVideo=TRUE;

	if(rightHide||!leftHide){
		myScrollView.frame = CGRectMake(0, 35, 330, 35);
	}
	else{
		myScrollView.frame = CGRectMake(0, 35, 330, 35);
	}

	tabNews.hidden=YES;
	tabVideos.hidden=NO;
	tabSaved.hidden=YES;
	tabSearch.hidden=YES;
	tabPopular.hidden=YES;
	tabMore.hidden=YES;
	
	UIButton* button = (UIButton*)sender;
	CGRect frame = tabVideos.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabVideos.frame = frame;
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+20, aRect.size.height);
	[myScrollView scrollRectToVisible:ar animated:YES];
	[self webserviceCallStart];
	[AnalyticHelper sendView:@"News - Videos"];
}


-(IBAction)mostViewedButtonClick:(id)sender
{
	txtPageNo=1;
	myTableView.bounces=YES;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[moreViewC.view removeFromSuperview];
	//ReleaseObject(moreViewC);
	[searchView removeFromSuperview];
	[savedView removeFromSuperview];
	myTableView.hidden=NO;
	myTableView.backgroundColor=[UIColor whiteColor];

	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isEditor=TRUE;
	[StoredData sharedData].isViewed=TRUE;
	
	tabNews.hidden=YES;
	tabVideos.hidden=YES;
	tabSaved.hidden=YES;
	tabSearch.hidden=YES;
	tabPopular.hidden=NO;
	tabMore.hidden=YES;
	
	UIButton* button = (UIButton*)sender;
	CGRect frame = tabPopular.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabPopular.frame = frame;
	myScrollView.frame = CGRectMake(0, 35, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+20, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
	[self webserviceCallStart];
    [AnalyticHelper sendView:@"News - Most Popular"];
}



-(IBAction)moreButtonClick:(id)sender
{
	NSLog(@"more");
    txtPageNo=1;
	myTableView.bounces=YES;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	//[rightArrowImageView removeFromSuperview];
	myTableView.hidden=YES;
	myTableView.backgroundColor=[UIColor whiteColor];
	[searchView removeFromSuperview];
	[savedView removeFromSuperview];
	rightHide=YES;
	leftHide=NO;
	[self.view addSubview:leftArrowImageView];
	
	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[StoredData sharedData].isMore=TRUE;

	tabNews.hidden=YES;
	tabVideos.hidden=YES;
	tabSaved.hidden=YES;
	tabSearch.hidden=YES;
	tabPopular.hidden=YES;
	tabMore.hidden=NO;
	
	UIButton* button = (UIButton*)sender;
	CGRect frame = tabMore.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabMore.frame = frame;
	
	if(moreViewC == nil){
	    moreViewC = [[MoreViewC alloc]initWithNibName:@"MoreViewC" bundle:nil];
		[self.view addSubview:moreViewC.view];}
	
	myScrollView.frame = CGRectMake(0, 35, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+20, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
	[AnalyticHelper sendView:@"News - More"];
}

-(IBAction)searchButtonClick:(id)sender
{
	txtPageNo=1;
	myTableView.bounces=YES;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[moreViewC.view removeFromSuperview];
	ReleaseObject(moreViewC);
	searchView.frame=CGRectMake(0,71, 320, 425);
	[self.view addSubview:searchView];
	[savedView removeFromSuperview];
	myTableView.hidden=NO;
	myTableView.backgroundColor=[UIColor darkGrayColor];
	
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isSaved=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[StoredData sharedData].isSearch=TRUE;

	tabNews.hidden=YES;
	tabVideos.hidden=YES;
	tabSaved.hidden=YES;
	tabSearch.hidden=NO;
	tabPopular.hidden=YES;
	tabMore.hidden=YES;

	UIButton* button = (UIButton*)sender;
	CGRect frame = tabSearch.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabSearch.frame = frame;
	
	myScrollView.frame = CGRectMake(0, 35, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+20, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
	[AnalyticHelper sendView:@"News - Search"];
}

-(IBAction)savedButtonClick:(id)sender
{
	txtPageNo=1;
	myTableView.bounces=NO;
	[myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[moreViewC.view removeFromSuperview];
	ReleaseObject(moreViewC);
	[searchView removeFromSuperview];
	myTableView.hidden=NO;
	myTableView.backgroundColor=[UIColor whiteColor];

	[StoredData sharedData].isSearch=FALSE;
	[StoredData sharedData].isMore=FALSE;
	[StoredData sharedData].isNews=FALSE;
	[StoredData sharedData].isViewed=FALSE;
	[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isEditor=FALSE;
	[StoredData sharedData].isSaved=TRUE;
	
	tabNews.hidden=YES;
	tabVideos.hidden=YES;
	tabSaved.hidden=NO;
	tabSearch.hidden=YES;
	tabPopular.hidden=YES;
	tabMore.hidden=YES;

	UIButton* button = (UIButton*)sender;
	CGRect frame = tabSaved.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabSaved.frame = frame;
	
	if([StoredData sharedData].arrSavedArticle){
		[[StoredData sharedData].arrSavedArticle removeAllObjects];
	}
	[Database fetchArticles:[Database getDBPath]];
	
	
	if([[StoredData sharedData].arrSavedArticle count]==0 ){
		savedView.frame=CGRectMake(0,200, 320, 225);
		[self.view addSubview:savedView];
	}
	
	if([[StoredData sharedData].arrSavedArticle count] > 0 ){
        
		[self downloadImages];

	}
	[myTableView reloadData];
	myScrollView.frame = CGRectMake(0, 35, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+20, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
    [AnalyticHelper sendView:@"News - Saved"];
}


-(IBAction)scrollForward:(id)sender{
    NSLog(@"scroll");
	
}

-(IBAction)scrollBackward:(id)sender{
}


-(IBAction)goToSetting
{
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
	[navC pushViewController:login animated:YES];
	[login release];
	login=nil;
}


#pragma mark webserviceCallStart
-(void)webserviceCallStart
{
    if (isReachable == NO) {
        [Functions NoInternetAlert];
        return;
    }
    [appDelegate showActivityIndicator:self];
	if([StoredData sharedData].isNews)
	{
		objArticleParser=[[ArticlesParser alloc]init];
		objArticleParser.delegate = self;
		[appDelegate showActivityIndicator:self];
		[objArticleParser getNewsWithSearchString:1 endRow:10 articleType:2 languageId:1];
		
	}	
	
	if([StoredData sharedData].isVideo)
	{
		objVideoParser=[[VideosParser alloc]init];
		objVideoParser.delegate = self;
		[appDelegate showActivityIndicator:self];
		[objVideoParser getNewsWithSearchString:1 endRow:10 articleType:8 languageId:1];
	}
    if([StoredData sharedData].isViewed)
	{
		objViewedParser=[[MostViewedParser alloc]init];
		objViewedParser.delegate = self;
		[appDelegate showActivityIndicator:self];
		[objViewedParser  GetMostViewedArticles];
	}
    
	if([StoredData sharedData].isEditor)
	{
		objEditorParser=[[GetEditorParser alloc]init];
		objEditorParser.delegate = self;
		[appDelegate showActivityIndicator:self];
		[objEditorParser  GetEditorsChoiceArticles];
	}	
	
    
}	


#pragma mark webserviceCallFinished
-(void)webserviceCallFinished
{
	if([StoredData sharedData].isNews)
	{
		arrAllArticles = [objArticleParser getResults];
		[myTableView reloadData];
		[self downloadImages];

		/*if (arrAllArticles.count == 0){
			totalPages = 0;
			txtPageNo=0;
		}*/
		if (arrAllArticles.count > 0){
			[myTableView reloadData];
			if (isTrue){
				[self showPageNumber];
				isTrue = FALSE;
			}
		}
	}
	
	if([StoredData sharedData].isVideo)
	{
		arrAllVideos = [objVideoParser getResults];
		[myTableView reloadData];
		[appDelegate stopActivityIndicator:self];
		[self downloadImages];
		/*if (arrAllVideos.count == 0){
			totalPages = 0;
			txtPageNo=0;
		}*/
		if (arrAllVideos.count > 0){
			[myTableView reloadData];
			if (isTrue){
				[self showPageNumber];
				isTrue = FALSE;
			}
		}
	}
	
	if([StoredData sharedData].isViewed)
	{
        
		arrMostViewed = [objViewedParser getResults];
		[myTableView reloadData];
		[self downloadImages];
		[searchView removeFromSuperview];
		[appDelegate stopActivityIndicator:self];
	}

	if([StoredData sharedData].isEditor)
	{
       
		arrEditorArticle = [objEditorParser getResults];
		[myTableView reloadData];
		[self downloadImages];
		[searchView removeFromSuperview];
		[appDelegate stopActivityIndicator:self];

	}
	
	[appDelegate stopActivityIndicator:self];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}


-(void)downloadImages
{
    //if([Reachability reachableAndAlert] == NO)
    //    return;
    
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
	if([StoredData sharedData].isNews)
	{
		for(int i=0;i<[arrAllArticles count];i++)
			[imagesArray addObject:[NSNull null]];
		[appDelegate stopActivityIndicator:self];
	}
	
	if([StoredData sharedData].isVideo)
	{
		for(int i=0;i<[arrAllVideos count];i++)
			[videoImagesArray addObject:[NSNull null]];
		[appDelegate stopActivityIndicator:self];
	}
			
	if([StoredData sharedData].isSearch)
	{
		for(int i=0;i<[arrSearchResults count];i++)
			[searchImagesArray addObject:[NSNull null]];
	}
	
	if([StoredData sharedData].isViewed)
	{
         [viewedImagesArray removeAllObjects];
		for(int i=0;i<[arrMostViewed count];i++)
			[viewedImagesArray addObject:[NSNull null]];
	}
	
	if([StoredData sharedData].isEditor)
	{
         [editorImagesArray removeAllObjects];
		for(int i=0;i<[arrEditorArticle count];i++)
			[editorImagesArray addObject:[NSNull null]];

	}
	
	if([StoredData sharedData].isSaved)
	{	
		if([[StoredData sharedData].arrSavedArticle count] > 0 ){
		for(int i=0;i<[[StoredData sharedData].arrSavedArticle count];i++)
			[savedImagesArray addObject:[NSNull null]];}
        if(appDelegate !=nil)
		[appDelegate stopActivityIndicator:self];
	}

}


-(void)viewWillAppear:(BOOL)animated
{
	if(moreViewC){
		[moreViewC.view removeFromSuperview];
	    moreViewC = [[MoreViewC alloc]initWithNibName:@"MoreViewC" bundle:nil];
		[self.view addSubview:moreViewC.view];}
	
	[customAlert.view removeFromSuperview];
	
	if([StoredData sharedData].isSaved)
	{
		if([[StoredData sharedData].arrSavedArticle count]>0)
		 {
		 [[StoredData sharedData].arrSavedArticle removeAllObjects];
		 }
		[Database fetchArticles:[Database getDBPath]];
		[self downloadImages];
		[myTableView reloadData];
	}
	[myTableView reloadData];
}


#pragma mark showLoginAlertView
-(void)showAlertView
{
	customAlert=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
    [StoredData sharedData].newsAlertFlag = true;
	[self.view addSubview:customAlert.view];
	[self initialDelayEnded];
}


#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)	
   {
    switch (alertView.tag)
    {
        case 5:
		      {
				 myTableView.backgroundColor=[UIColor darkGrayColor];
				 [StoredData sharedData].isSearch=TRUE;
				 [StoredData sharedData].isNews=FALSE;
				 [StoredData sharedData].isViewed=FALSE;
				 [StoredData sharedData].isSaved=FALSE;
				 [StoredData sharedData].isVideo=FALSE;
				 [StoredData sharedData].isMore=FALSE;
				 [StoredData sharedData].isEditor=FALSE;
				 
				 [moreViewC.view removeFromSuperview];
				 searchView.frame=CGRectMake(0,71, 320, 425);
				 [self.view addSubview:searchView];
				 myTableView.hidden=NO;
		     }
            break;
            
        default:{
            break;
		}
    }
   }
}


#pragma mark -
#pragma mark Search Bar 

-(void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	if([searchText length] > 0) {
	}
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchView resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchTab
{
    if (isReachable == NO) {
        [searchTab resignFirstResponder];
        [Functions NoInternetAlert];
        return;
    }

    
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140,240, 30, 30)];
	[self.view addSubview:activityView];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[activityView startAnimating];
	[searchTab resignFirstResponder];
	objSearchParser=[[SearchParser alloc]init];
	objSearchParser.delegate = self;
	[objSearchParser getNewsWithSearchString:searchBar.text startRow:1 endRow:10 articleType:2 languageId:1];
}

-(void)searchServiceCallFinished
{
	arrSearchResults = [objSearchParser getResults];
	[myTableView reloadData];
	[self downloadImages];
	if (arrSearchResults.count==0)
	{
		//totalPages = 0;
		//txtPageNo= 0;
		[funcClass showAlertViewWithTag:5 title:@"No Search Result Found" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok"];
	}
	
	if (arrSearchResults.count > 0)
	{
		[myTableView reloadData];
		if (isTrue){
			[self showPageNumber];
			isTrue = FALSE;
		}
	}
	[activityView stopAnimating];
	myTableView.backgroundColor=[UIColor clearColor];
	[searchView removeFromSuperview];
	[appDelegate stopActivityIndicator:self];
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

-(void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	customAlert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

-(void)bounce2AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	customAlert.view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)startActivity
{
  if(!activityAlert)
	activityAlert = [[ActivityAlertView alloc] initWithTitle:@""  message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] ;
	[activityAlert show];
}

-(void)stopActivity
{
	[activityAlert close];
}


/*-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
      return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
	//return YES;
}*/


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)dealloc
{
	[inputFormatter release];
	[outputFormatter release];
    [moreViewC release];
	[customCell release];
	[strVideo release];
	[strSearch release];
	[swipeLeftRecognizer release];
	[newsDetailViewController release];
	[appDelegate release];
	[activityAlert release];
	[activityView release];
	[myTableView release];
	[objArticleParser release];
	[objVideoParser release];
	[objViewedParser release];
	[objSearchParser release];
	[objEditorParser release];
	[mySavedArticles release];
	[arrAllArticles release];
	[arrAllVideos release];
	[arrMostViewed release];
	[arrSearchResults release];
	[arrEditorArticle release];
	[videoImagesArray release];
	[savedImagesArray release];
	[editorImagesArray release];
	[viewedImagesArray release];
	[searchImagesArray release];
	[imagesArray release];
	[super dealloc];
}

@end




