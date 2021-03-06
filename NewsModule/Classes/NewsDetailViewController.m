//
//  NewsDetailViewController.m
//  Rapnet
//
//  Created by Saurabh Verma on 12/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#define kAnimationKey @"animationKey"
#import <QuartzCore/QuartzCore.h>
#include "AddThis.h"
#import "NewsDetailViewController.h"
#import "FacebookViewC.h"
#import "OAuthTwitterDemoViewController.h"
#import "funcClass.h"
#import "ObjSavedArticles.h"
#import "Database.h"
#import "ATNetworkActivity.h"
#import "InnerAlertView.h"
#import "ATNConstants.h"
#import "WebLinkController.h"

#define MOVE_ANIMATION_DURATION_SECONDS_FOR_C1 0.3

#define YimgMain 6.0
#define YlblTitle 147.0 
#define YlblDate 160.0
#define YlblAuthor 205.0
#define YdescView 223.0
#define YrelVideoButton 326.0
#define YrelArticleButton 366.0
#define YdotUp 326.0
#define YdotDown 366.0
#define YdotBottom 406.0
#define YupGestureView -33.0
#define YobjScrollV 33.0

#define HgtimgMain 128.0
#define HgtlblTitle 30.0
#define HgtlblDate 23.0
#define HgtlblAuthor 14.0
#define HgtdescView 87.0
#define HgtrelVideoButton 40.0
#define HgtrelArticleButton 40.0
#define HgtdotUp 1.0
#define HgtdotDown 1.0
#define HgtdotBottom 1.0
#define HgtupGestureView 349.0
#define HgtobjScrollView 428.0



@interface MovViewController : MPMoviePlayerViewController
@end 

@implementation MovViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
	
}
/*
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
*/

@end

@implementation NewsDetailViewController
@synthesize selectedRowint,strTitle,strSubtitle,strType,strDate,strAuthor,strDesc,strImage,strArticleURL;
@synthesize strArtileID,strVideo,objSaved,strhtml,isAuth,swipeLeftRecognizer,imageView,tapRecognizer,window;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
		t = CGAffineTransformMakeTranslation(0.0, 0.0);}
    
    [AnalyticHelper sendView:@"News Article"];
    
    return self;
}


#pragma mark - View lifecycle
-(void)viewDidLoad
{
	[self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
	
    
    tabView.frame = CGRectMake(0, 370, 320, 50);
	videoView.hidden=YES;
	isCustomAlertVisible=NO;
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	isViewHide=FALSE;isViewVisible=TRUE;
	
	descView.backgroundColor=[UIColor clearColor];
	
	if(selectedRowint==0)
	{
		goBckBttn.enabled=NO;
		[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
	}
	
	if(selectedRowint==[arr count]-1)
	{
		goFwdBttn.enabled=NO;
		[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
	}

	getAuthParser=[[GetAuthArticleParser alloc]init];
	getArticleParser=[[GetArticleParser alloc]init];
	
	if([StoredData sharedData].isRelatedVideo){
	    relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	}
	if([StoredData sharedData].isRelatedArticle){
		imgMain.hidden=YES;relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
		videoView.hidden=YES;}
	
	appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[relVideoButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [relArticleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	
	
	minFontSize=16.0;maxFontSize=19.0;
	[self setGestureContent];
    
    objScrollV.frame = CGRectMake(0, 33, 320, 428);
}


#pragma mark setGestureContent
-(void)setGestureContent
{
	isViewHide=FALSE;isViewVisible=TRUE;
	isAlreadySaved=FALSE;deleteBttn.hidden=YES;saveBttn.hidden=NO;incfontBttn.enabled=YES;
	
	UIGestureRecognizer *recognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];//right swipe
	[objScrollV addGestureRecognizer:recognizer];
	[recognizer release];
	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];//left swipe
	self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[objScrollV addGestureRecognizer:swipeLeftRecognizer];
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
	[recognizer release];
	
	lblToPage.text=[NSString stringWithFormat:@"%d",[arr count]];
	lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
	
	[self positionBackButton];
	
	 if([StoredData sharedData].isViewed){
		[self webServiceStart];
		 if(![self.strVideo isEqual:@""]){
		     videoView.hidden=NO;
			 if(![self.strImage isEqual:@"no image"]){
				 [NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
			 }
		}
	 }
	
	if([StoredData sharedData].isNews){
		[self webServiceStart];
		if(![self.strVideo isEqual:@""]){
			videoView.hidden=NO;
			if(![self.strImage isEqual:@"no image"]){
				[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
			}
		}
	}
	
	else if([StoredData sharedData].isSaved){
		[self fetchSavedDB];
		NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
		self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
		[[StoredData sharedData].arrReadArticle addObject:self.strArtileID];
		[self setContentView];
		
		if(![self.strVideo isEqual:@""]){
			videoView.hidden=NO;
			if(![self.strImage isEqual:@"no image"]){
				[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
			}
			
		}
		[fontSize release];
	}

	else if([StoredData sharedData].isVideo||[StoredData sharedData].isRelatedVideo){
		if(![self.strImage isEqual:@"no image"]){
			[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
		}
		[self webServiceStart];
	}
    
    else{
		if(![self.strImage isEqual:@"no image"]){
			[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
		}
		[self webServiceStart];
	}
}



#pragma mark Responding to gestures
- (void)handleViewShowFrom:(UITapGestureRecognizer *)recognizer
{
	if(isViewVisible){
		isViewVisible=FALSE;
		
		objScrollV.frame=CGRectMake(0,0,320,428+33);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform=CGAffineTransformTranslate(t, 0, 50);
		navView.transform=CGAffineTransformTranslate(t, 0, -33);
	}
	else{
		isViewVisible=TRUE;
		objScrollV.frame=CGRectMake(0,33,320,428);
		[self.view addSubview:tabView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform = CGAffineTransformTranslate(t, 0,0);
		navView.transform=CGAffineTransformTranslate(t, 0, -1);
	}
	[UIView commitAnimations];
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
	[objScrollV setContentOffset:CGPointMake(0, 0) animated:NO];
	
	if(!isViewVisible){
		isViewVisible=TRUE;
		objScrollV.frame=CGRectMake(0,33,320,428);
		[self.view addSubview:tabView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform = CGAffineTransformTranslate(t, 0,0);
		navView.transform=CGAffineTransformTranslate(t, 0, -1);
	}
	
	[UIView commitAnimations];
	[arrgetArticle removeAllObjects];
	
	if([StoredData sharedData].isSaved){
		if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
			if(selectedRowint<[arr count]-1){
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				goBckBttn.enabled=YES;
				[goBckBttn setImage:[UIImage imageNamed:@"Left_Normal.png"] forState:UIControlStateNormal];
				selectedRowint++;
				self.objSaved=[[StoredData sharedData].arrSavedArticle objectAtIndex:selectedRowint];
				[self fetchSavedDB];
				NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
				self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
				[self setContentView];
				
				if(selectedRowint==[[StoredData sharedData].arrSavedArticle count]-1)
				{
					goFwdBttn.enabled=NO;
					[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
				}

				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
					
				}
				[self slideForward];
				goBckBttn.enabled=YES;
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
		else{
			if(selectedRowint>0){
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				selectedRowint--;
				self.objSaved=[[StoredData sharedData].arrSavedArticle objectAtIndex:selectedRowint];
				[self fetchSavedDB];
				
				goFwdBttn.enabled=YES;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Normal.png"] forState:UIControlStateNormal];
				
				NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
				self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
				[self setContentView];
				
				if(selectedRowint==0)
				{
					goBckBttn.enabled=NO;
					[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
				}
			
				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
				}
			    [self slideBackward];	
			    lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
	}
	
	else if([StoredData sharedData].isViewed){
		if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
			
			if(selectedRowint<[arr count]-1){
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				goBckBttn.enabled=YES;
				isCustomAlertVisible=NO;
				[goBckBttn setImage:[UIImage imageNamed:@"Left_Normal.png"] forState:UIControlStateNormal];
				selectedRowint++;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==[arr count]-1)
				{
					goFwdBttn.enabled=NO;
					[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
				}
				[self webServiceStart];
				
				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
					
				}
				
				[self slideForward];
			    goBckBttn.enabled=YES;
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
		else{
			if(selectedRowint>0){
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				selectedRowint--;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				isCustomAlertVisible=NO;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==0)
				{
					goBckBttn.enabled=NO;
					[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
				}
				
				goFwdBttn.enabled=YES;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Normal.png"] forState:UIControlStateNormal];
				
				[self webServiceStart];
				
				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
				}
				[self slideBackward];
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
	}
	
	
	else if([StoredData sharedData].isNews){
		if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
			
			if(selectedRowint<[arr count]-1){
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				goBckBttn.enabled=YES;
				isCustomAlertVisible=NO;
				[goBckBttn setImage:[UIImage imageNamed:@"Left_Normal.png"] forState:UIControlStateNormal];
				selectedRowint++;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==[arr count]-1)
				{
					goFwdBttn.enabled=NO;
					[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
				}
				[self webServiceStart];
				
				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
					
				}
				
				[self slideForward];
			    goBckBttn.enabled=YES;
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
		else{
			if(selectedRowint>0){
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				selectedRowint--;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				isCustomAlertVisible=NO;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==0)
				{
					goBckBttn.enabled=NO;
					[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
				}
				
				goFwdBttn.enabled=YES;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Normal.png"] forState:UIControlStateNormal];
				
				[self webServiceStart];
				
				if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
					if(![self.strVideo isEqual:@""]){
						videoView.hidden=NO;
						if(![self.strImage isEqual:@"no image"]){
							[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
						}
					}
				}
				[self slideBackward];
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
	}
	else{
		if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
			
			if(selectedRowint<[arr count]-1){
				
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				isCustomAlertVisible=NO;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				
				goBckBttn.enabled=YES;
				[goBckBttn setImage:[UIImage imageNamed:@"Left_Normal.png"] forState:UIControlStateNormal];
				
				selectedRowint++;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==[arr count]-1)
				  {
					goFwdBttn.enabled=NO;
					[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
				  }
				[self webServiceStart];
				if(![self.strImage isEqual:@"no image"]){
					[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
				}
				
				[self slideForward];
			    goBckBttn.enabled=YES;
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
		else{
			if(selectedRowint>0){
				deleteBttn.hidden=YES;
				saveBttn.hidden=NO;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				videoView.hidden=YES;
				selectedRowint--;
				
				goFwdBttn.enabled=YES;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Normal.png"] forState:UIControlStateNormal];
				
				isCustomAlertVisible=NO;
				[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
				
				if(selectedRowint==0)
				{
					goBckBttn.enabled=NO;
					[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
				}
				[self webServiceStart];
				
				if(![self.strImage isEqual:@"no image"]){
					[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
				}
				[self slideBackward];
				lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			}
		}
		
	}
}



#pragma mark webServiceStart
-(void)webServiceStart
{
	//if([StoredData sharedData].isUserAuthenticated)
    if([Functions canView:L_News])
    {
        getAuthParser.delegate = self;
        [appDelegate showActivityIndicator:self];
        [getAuthParser getAuthNews:[self.strArtileID intValue]];
	}
	
	else
    {
        getArticleParser.delegate = self;
        [appDelegate showActivityIndicator:self];
        [getArticleParser getNewsWithArticleId:[self.strArtileID intValue]];
	}
	
	[self webserviceCallFinished];

}	


#pragma mark webServiceFinished
-(void)webserviceCallFinished
{
    
	//if([StoredData sharedData].isUserAuthenticated)
    if([Functions canView:L_News])
    {
		arrgetArticle = [getAuthParser getResults];	
	}
	else{
		arrgetArticle = [getArticleParser getResults];	
	}
	
	if(!([arrgetArticle count]==0)){
		imgMain.hidden=NO;descView.hidden=NO;lblDate.hidden=NO;lblTitle.hidden=NO;lblType.hidden=NO;lblAuthor.hidden=NO;
		self.strTitle=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"Title"]];
		self.strType=[NSString stringWithFormat:@"| %@",[[arrgetArticle objectAtIndex:0]objectForKey:@"ArticleTypeText"]];
		self.strDate=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"DatePosted"]];
		self.strAuthor=[NSString stringWithFormat:@"By-%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"Author"]];
		self.strArticleURL=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"ArticleURL"]];
		self.strDesc=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"ArticleText"]];
        //	NSLog(@"text = %@",self.strDesc);
        self.isAuth=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"IsAuthenticated"]];
		self.strVideo=[NSString stringWithFormat:@"%@",[[arrgetArticle objectAtIndex:0]objectForKey:@"VideoURL"]];
		[self removeHTMLTags];
        //   NSLog(@"\n\n\ntexteee = %@",self.strDesc);
	
		NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
		self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
		
		if([StoredData sharedData].isVideo||[StoredData sharedData].isRelatedVideo){
			
			videoView.hidden=NO;
		}
		
		if([StoredData sharedData].isVideo && [StoredData sharedData].isRelatedArticle)
		{
			relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
			videoView.hidden=YES;
		}
		[self setContentView];
		[appDelegate stopActivityIndicator:self];
	}
	
	else if(arrgetArticle.count==0)
	{
		imgMain.hidden=YES;
		self.strTitle=@"";self.strSubtitle=@"";self.strDate=@"";
		self.strAuthor=@"";self.strArticleURL=@"";self.strDesc=@"";self.strhtml=@"";
		descView.hidden=YES;relVideoButton.hidden=YES;relArticleButton.hidden=YES;videoView.hidden=YES;
		dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;lblDate.hidden=YES;lblTitle.hidden=YES;
		lblType.hidden=YES;lblAuthor.hidden=YES;
		[appDelegate stopActivityIndicator:self];
	}
}

#pragma mark setImageView
-(void)setImageView 
{
	goBckBttn.enabled=NO;
	goFwdBttn.enabled=NO;
	
	if([StoredData sharedData].isRelatedVideo||[StoredData sharedData].isVideo||[StoredData sharedData].isSaved||[StoredData sharedData].isNews)
	{
			
			if([self.strImage isEqual:@"no image"])
			{  
				imgMain.hidden=YES;
				videoView.hidden=YES;
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
				lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
				lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
				lblAuthor.frame=CGRectMake(8, 25+lblDate.frame.size.height+lblTitle.frame.size.height,304,lblAuthor.frame.size.height);
			}
            else if([StoredData sharedData].isVideo || [StoredData sharedData].isRelatedVideo){
                imgMain.hidden=YES;				
				[imgMain setImage:[UIImage imageNamed:@".png"]];
				lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
				lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
				lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
				lblAuthor.frame=CGRectMake(8, 25+lblDate.frame.size.height+lblTitle.frame.size.height,304,lblAuthor.frame.size.height);
                videoView.center = CGPointMake(250, 33);
            }
        
            else
			{
				imgMain.hidden=NO;
				lblTitle.frame=CGRectMake(8,20+HgtimgMain, 220, lblTitle.frame.size.height);
				lblDate.frame=CGRectMake(8,23+HgtimgMain+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
				lblType.frame=CGRectMake(100,23+HgtimgMain+lblTitle.frame.size.height, 152, lblType.frame.size.height);
				lblAuthor.frame=CGRectMake(8,25+HgtimgMain+lblTitle.frame.size.height+lblDate.frame.size.height,304,lblAuthor.frame.size.height);
				
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
				NSData *mydata;
				if([StoredData sharedData].isSaved){
					mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.objSaved.imageURL]];
				}
				else {
					mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.strImage]];
				}
				
				UIImage *myImage;
				if(mydata)
				{
					myImage = [[UIImage alloc] initWithData:mydata];
					[imgMain setImage:myImage];
					[myImage release];
					[mydata release];
				}
				[pool release];
			}
	}
    
    if([StoredData sharedData].isRelatedArticle && [StoredData sharedData].isVideo)
    {
        imgMain.hidden=YES;
        videoView.hidden=YES;
        [imgMain setImage:[UIImage imageNamed:@".png"]];
        lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
        lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
        lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
        lblAuthor.frame=CGRectMake(8, 25+lblDate.frame.size.height+lblTitle.frame.size.height,304,lblAuthor.frame.size.height);
        
    }

	goBckBttn.enabled=YES;
	goFwdBttn.enabled=YES;
	
	if(selectedRowint==0)
	{
		goBckBttn.enabled=NO;
		[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateSelected];
	}
	
	if(selectedRowint==[arr count]-1)
	{
		goFwdBttn.enabled=NO;
		[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
	}
	
}

#pragma mark setDataForDetailsView
-(void)setDataForDetailsView:(NSDictionary*)data
{
    videoView.hidden=YES;
	lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
	self.strArtileID=[NSString stringWithFormat:@"%@",[data objectForKey:@"ArticleID"]];
	self.strImage=[NSString stringWithFormat:@"%@",[data objectForKey:@"ImageURL"]];
	self.strVideo=[NSString stringWithFormat:@"%@",[data objectForKey:@"VideoURL"]];
	[[StoredData sharedData].arrReadArticle addObject:self.strArtileID];
    
    NSNumber *ArticleID = [[NSNumber alloc] initWithInteger:[[data objectForKey:@"ArticleID"] integerValue]];
    
    [AnalyticHelper sendEventWithCategory:@"News Article" withAction:@"Article Selected" withLabel:@"Article ID" withValue:ArticleID];
}


#pragma mark setContentView
-(void)setContentView
{
	[self setDynamicContent];
	[descView loadHTMLString:self.strhtml baseURL:nil];
	
	float sizeOfContent = 0;
	int i;
	for (i = 0; i < [objScrollV.subviews count]-1; i++){
		UIView *view =[objScrollV.subviews objectAtIndex:i];
		sizeOfContent += view.frame.size.height;
	}
	if([StoredData sharedData].isVideo || [StoredData sharedData].isRelatedVideo){
        videoView.center = CGPointMake(280, 33);
        lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
        lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
        lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
        lblAuthor.frame=CGRectMake(8,25+lblTitle.frame.size.height+lblDate.frame.size.height, 304,lblAuthor.frame.size.height);
        relVideoButton.frame=CGRectMake(3, 326-HgtimgMain, 325, 40);
        relArticleButton.frame=CGRectMake(2, 366-HgtimgMain, 325, 40);
        dotUp.frame=CGRectMake(0, 326-HgtimgMain, 320, 1);
        dotDown.frame=CGRectMake(0, 366-HgtimgMain, 320, 1);
        dotBottom.frame=CGRectMake(0, 406-HgtimgMain, 320, 1);
        upGestureView.frame=CGRectMake(8, -33, 304, 349);
        objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height-128+lblTitle.frame.size.height-30.0-100); 
    }
	
	else if([StoredData sharedData].isViewed||[StoredData sharedData].isSaved||[StoredData sharedData].isNews)
	{
		if(![self.strVideo isEqual:@""])
        {
			lblTitle.frame=CGRectMake(8, 20+HgtimgMain, 220, lblTitle.frame.size.height);
			lblDate.frame=CGRectMake(8, 23+HgtimgMain+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
			lblType.frame=CGRectMake(100, 23+HgtimgMain+lblTitle.frame.size.height, 152, lblType.frame.size.height);
			lblAuthor.frame=CGRectMake(8,25+HgtimgMain+lblTitle.frame.size.height+lblDate.frame.size.height, 304,lblAuthor.frame.size.height);
			relVideoButton.frame=CGRectMake(3, 326, 325, 40);
			relArticleButton.frame=CGRectMake(2, 366, 325, 40);
			dotUp.frame=CGRectMake(0, 326, 320, 1);
			dotDown.frame=CGRectMake(0, 366, 320, 1);
			dotBottom.frame=CGRectMake(0, 406, 320, 1);
			upGestureView.frame=CGRectMake(8, -33, 304, 349);
			objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height+130);
		}

		else{
			videoView.hidden=YES;
			lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
			lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
			lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
			lblAuthor.frame=CGRectMake(8,25+lblTitle.frame.size.height+lblDate.frame.size.height, 304,lblAuthor.frame.size.height);
			relVideoButton.frame=CGRectMake(3, 326-HgtimgMain, 325, 40);
			relArticleButton.frame=CGRectMake(2, 366-HgtimgMain, 325, 40);
			dotUp.frame=CGRectMake(0, 326-HgtimgMain, 320, 1);
			dotDown.frame=CGRectMake(0, 366-HgtimgMain, 320, 1);
			dotBottom.frame=CGRectMake(0, 406-HgtimgMain, 320, 1);
			upGestureView.frame=CGRectMake(8, -33, 304, 349);
			objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height-128+lblTitle.frame.size.height-30.0-100);
		}
	}
	
	else {
		
		videoView.hidden=YES;
		lblTitle.frame=CGRectMake(8, 20, 220, lblTitle.frame.size.height);
		lblDate.frame=CGRectMake(8, 23+lblTitle.frame.size.height, 95, lblDate.frame.size.height);
		lblType.frame=CGRectMake(100, 23+lblTitle.frame.size.height, 152, lblType.frame.size.height);
		lblAuthor.frame=CGRectMake(8,25+lblTitle.frame.size.height+lblDate.frame.size.height, 304,lblAuthor.frame.size.height);
		relVideoButton.frame=CGRectMake(3, 326-HgtimgMain, 325, 40);
		relArticleButton.frame=CGRectMake(2, 366-HgtimgMain, 325, 40);
		dotUp.frame=CGRectMake(0, 326-HgtimgMain, 320, 1);
		dotDown.frame=CGRectMake(0, 366-HgtimgMain, 320, 1);
		dotBottom.frame=CGRectMake(0, 406-HgtimgMain, 320, 1);
		upGestureView.frame=CGRectMake(8, -33, 304, 349);
		objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height-128+lblTitle.frame.size.height-30.0-100);
		
	}
	if([StoredData sharedData].isRelatedVideo){
		
		objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height-100);
	}
}



#pragma mark webViewDidFinishLoad
- (void)webViewDidStartLoad:(UIWebView *)aWebView 
{
	descView.backgroundColor=[UIColor clearColor];
	
    for (UIView* subView in [descView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }

	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
    [appDelegate showActivityIndicator:self];
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	[appDelegate stopActivityIndicator:self];
	saveBttn.enabled=YES;
	
	if([StoredData sharedData].arrDuplicateChk)
	{
		[[StoredData sharedData].arrDuplicateChk removeAllObjects];
		//[StoredData sharedData].arrDuplicateChk=[[NSMutableArray alloc]init];
	}
	
	[Database fetchArticles:[Database getDBPath]];
	if([StoredData sharedData].arrSavedArticle.count>0)
	{
		[Database checkDuplicateArticle:[Database getDBPath] arg2:self.strArtileID];
	}
	
	if([StoredData sharedData].arrDuplicateChk.count==1)
	{
		saveBttn.hidden=YES;
		deleteBttn.hidden=NO;
	}
	
	if([StoredData sharedData].isRelatedVideo||[StoredData sharedData].isRelatedArticle){
		
		relVideoButton.hidden=YES;relArticleButton.hidden=YES;
		dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	}
	
	if([self.isAuth isEqual:@"true"]){
		//if([StoredData sharedData].isUserAuthenticated==FALSE)
        if([Functions canView:L_News] == NO)
        {
			relVideoButton.hidden=YES;relArticleButton.hidden=YES;videoView.hidden=YES;
			dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
			saveBttn.enabled=NO;
			
			
			if(isCustomAlertVisible==NO){
				[self showAlertView];}
		}
		//if([StoredData sharedData].isUserAuthenticated==TRUE)
        if([Functions canView:L_News])
        {
			relVideoButton.hidden=NO;relArticleButton.hidden=NO;videoView.hidden=NO;
			dotUp.hidden=NO;dotDown.hidden=NO;dotBottom.hidden=NO;
		}
	}
	
	else if([StoredData sharedData].isRelatedArticle)
	{
		videoView.hidden=YES;
	}
	
	else if([StoredData sharedData].isRelatedVideo)
	{
		relVideoButton.hidden=YES;relArticleButton.hidden=YES;
		dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	}
	
	else{
		relVideoButton.hidden=NO;relArticleButton.hidden=NO;
		dotUp.hidden=NO;dotDown.hidden=NO;dotBottom.hidden=NO;
	}
	
	CGRect frame = aWebView.frame;
	frame.size.height = 1;
	aWebView.frame = frame;
	fittingSize = [aWebView sizeThatFits:CGSizeZero];
	frame.size = fittingSize;
	aWebView.frame = frame;
	
	
	if([StoredData sharedData].isRelatedVideo||[StoredData sharedData].isVideo)
	{
        if([StoredData sharedData].isRelatedArticle && [StoredData sharedData].isVideo)
        {
            videoView.hidden=YES;
			descView.frame = CGRectMake(0, 223-HgtimgMain+lblTitle.frame.size.height-20, fittingSize.width,fittingSize.height);
			relArticleButton.frame =CGRectMake(2,310+fittingSize.height-HgtimgMain,325,60);
			relVideoButton.frame =CGRectMake(3,246+fittingSize.height-HgtimgMain,325,60);
			dotUp.frame=CGRectMake(0,246+fittingSize.height-HgtimgMain,320,1);
			dotDown.frame=CGRectMake(0,310+fittingSize.height-HgtimgMain,320,1);
			dotBottom.frame=CGRectMake(0,373+fittingSize.height-HgtimgMain,320,1);
			upGestureView.frame=CGRectMake(8,-33,304,fittingSize.height+239+33-HgtimgMain);
        }
        else /*if(![StoredData sharedData].isRelatedVideo && [StoredData sharedData].isVideo)*/
            
        {
            descView.frame = CGRectMake(0, 223-HgtimgMain+lblTitle.frame.size.height-20, fittingSize.width,fittingSize.height);
			relArticleButton.frame =CGRectMake(2,310+fittingSize.height-HgtimgMain,325,60);
			relVideoButton.frame =CGRectMake(3,246+fittingSize.height-HgtimgMain,325,60);
			dotUp.frame=CGRectMake(0,246+fittingSize.height-HgtimgMain,320,1);
			dotDown.frame=CGRectMake(0,310+fittingSize.height-HgtimgMain,320,1);
			dotBottom.frame=CGRectMake(0,373+fittingSize.height-HgtimgMain,320,1);
			upGestureView.frame=CGRectMake(8,-33,304,fittingSize.height+239+33-HgtimgMain);
            
        }
        	}
	
	
	else if([StoredData sharedData].isViewed||[StoredData sharedData].isSaved||[StoredData sharedData].isNews)
	{
		if(![self.strVideo isEqual:@""]){
			
			descView.frame = CGRectMake(0, 223+lblTitle.frame.size.height-20, fittingSize.width,fittingSize.height);
			relArticleButton.frame =CGRectMake(2,310+fittingSize.height,325,60);
			relVideoButton.frame =CGRectMake(3,246+fittingSize.height,325,60);
			dotUp.frame=CGRectMake(0,246+fittingSize.height,320,1);
			dotDown.frame=CGRectMake(0,310+fittingSize.height,320,1);
			dotBottom.frame=CGRectMake(0,373+fittingSize.height,320,1);
			upGestureView.frame=CGRectMake(8,-33,304,fittingSize.height+239+33);
		}
			
		else {
			
			videoView.hidden=YES;
			descView.frame = CGRectMake(0, 223-HgtimgMain+lblTitle.frame.size.height-20, fittingSize.width,fittingSize.height);
            //descView.frame = CGRectMake(0, lblTitle.frame.size.height - 20, fittingSize.width,fittingSize.height);
			relArticleButton.frame =CGRectMake(2,310+fittingSize.height-HgtimgMain,325,60);
			relVideoButton.frame =CGRectMake(3,246+fittingSize.height-HgtimgMain,325,60);
			dotUp.frame=CGRectMake(0,246+fittingSize.height-HgtimgMain,320,1);
			dotDown.frame=CGRectMake(0,310+fittingSize.height-HgtimgMain,320,1);
			dotBottom.frame=CGRectMake(0,373+fittingSize.height-HgtimgMain,320,1);
			upGestureView.frame=CGRectMake(8,-33,304,fittingSize.height+239+33-HgtimgMain);
			
		}
			
	}
    
	else {
		
		videoView.hidden=YES;
		descView.frame = CGRectMake(0, 223-HgtimgMain+lblTitle.frame.size.height-20, fittingSize.width,fittingSize.height);
		relArticleButton.frame =CGRectMake(2,310+fittingSize.height-HgtimgMain,325,60);
		relVideoButton.frame =CGRectMake(3,246+fittingSize.height-HgtimgMain,325,60);
		dotUp.frame=CGRectMake(0,246+fittingSize.height-HgtimgMain,320,1);
		dotDown.frame=CGRectMake(0,310+fittingSize.height-HgtimgMain,320,1);
		dotBottom.frame=CGRectMake(0,373+fittingSize.height-HgtimgMain,320,1);
		upGestureView.frame=CGRectMake(8,-33,304,fittingSize.height+239+33-HgtimgMain);
		
	}
	
	UIGestureRecognizer *recognizer;
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewShowFrom:)];
	[upGestureView addGestureRecognizer:recognizer];
    self.tapRecognizer = (UITapGestureRecognizer *)recognizer;
    recognizer.delegate = self;
	[recognizer release];
	
	UIGestureRecognizer *recognizerVideo;
	recognizerVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
	[videoView addGestureRecognizer:recognizerVideo];
    self.tapRecognizer = (UITapGestureRecognizer *)recognizerVideo;
    recognizerVideo.delegate = self;
	[recognizerVideo release];
	

	[self setDynamicContent];
	
	float sizeOfContent = 0;
	int i;
	for (i = 0; i < [objScrollV.subviews count]-1; i++){
		UIView *view =[objScrollV.subviews objectAtIndex:i];
		sizeOfContent += view.frame.size.height;
	}

	if([StoredData sharedData].isVideo){
	 objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height+lblTitle.frame.size.height-100);
	}
	
	else if([StoredData sharedData].isViewed||[StoredData sharedData].isSaved||[StoredData sharedData].isNews)
	{
		if(![self.strVideo isEqual:@""]){
			objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120.0-upGestureView.frame.size.height+lblTitle.frame.size.height);
		}
		else{
			
			objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120.0-upGestureView.frame.size.height-100);
		}
	}
	
	else if([StoredData sharedData].isRelatedVideo){
		
		objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120-upGestureView.frame.size.height+lblTitle.frame.size.height-100);
	}
    
    /*else if([StoredData sharedData].isRelatedArticle && [StoredData sharedData].isVideo)
    {
        
       objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120.0-upGestureView.frame.size.height+lblTitle.frame.size.height); 
    }
    */
	else{
		objScrollV.contentSize = CGSizeMake(objScrollV.frame.size.width, sizeOfContent+120.0-upGestureView.frame.size.height-100);
	}
}



- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
    // Determine if we want the system to handle it.
	
    NSURL *url = request.URL;
	[StoredData sharedData].strWebURL =[url absoluteString];
	
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
			WebLinkController *website=[[WebLinkController alloc]initWithNibName:@"WebLinkController" bundle:nil];
			[[self navigationController] pushViewController:website animated:YES];
			[website release];
            return NO;
        }
    return YES;
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if(isViewVisible){
		isViewVisible=FALSE;
		
		objScrollV.frame=CGRectMake(0,0,320,428+33);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform=CGAffineTransformTranslate(t, 0, 50);
		navView.transform=CGAffineTransformTranslate(t, 0, -33);
	}
	
	[UIView commitAnimations];	   
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if(!isViewVisible){
		isViewVisible=TRUE;
	
		objScrollV.frame=CGRectMake(0,33,320,428);
		[self.view addSubview:tabView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform = CGAffineTransformTranslate(t, 0,0);
		navView.transform=CGAffineTransformTranslate(t, 0, -1);
		
	}
	
	[UIView commitAnimations];
}

#pragma mark - Received Actions



- (void)playVideo:(UITapGestureRecognizer *)recognizer
{
	    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 32000
    // NSLog(@"moview1");
		MovViewController *mp = [[MovViewController alloc] initWithContentURL:[NSURL URLWithString:self.strVideo]];
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		[[mp moviePlayer] prepareToPlay];
		[[mp moviePlayer] setShouldAutoplay:YES];
    [[mp moviePlayer] setControlStyle:MPMovieControlStyleFullscreen];
    // [[mp moviePlayer] setMovieSourceType:MPMovieSourceTypeStreaming];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	    [self presentMoviePlayerViewControllerAnimated:mp];
	   
		[mp release];
		
	#else
    //  NSLog(@"moview");
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


- (void)playbackStateDidChange:(NSNotification *)notification
{

}


-(IBAction)backButtonClicked
{
    [[self navigationController] popViewControllerAnimated:YES];
    [AnalyticHelper sendView:@"News"];
}

-(IBAction)bigbackButtonClicked
{
	[[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)incFontSize:(id)sender
{
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;
	dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	
	UIFont *titFont = [lblTitle font];
	UIFont *subFont = [lblType font];
	UIFont *dateFont = [lblDate font];
	UIFont *authFont = [lblAuthor font];
	
	if(minFontSize <= 18){
		minFontSize = (minFontSize < 20) ? minFontSize +1 : minFontSize;
		
		NSString *fontSize =[[NSString alloc] initWithFormat:@"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:%d\">",minFontSize];
		self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
		[fontSize release];
		
		if(titFont.pointSize<21.0){
			[lblTitle setFont:[titFont fontWithSize:titFont.pointSize+1]];}
		if(subFont.pointSize<17.0){
			[lblType setFont:[subFont fontWithSize:subFont.pointSize+1]];}
		if(dateFont.pointSize<17.0){
			[lblDate setFont:[dateFont fontWithSize:dateFont.pointSize+1]];}
		if(authFont.pointSize<17.0){
			[lblAuthor setFont:[authFont fontWithSize:authFont.pointSize+1]];}
		
		[self setContentView];
	}
	
	if(titFont.pointSize==21.0)
	{
		maxFontSize=17.0;
		incfontBttn.enabled=NO;
		decfontBttn.enabled=YES;
	}
	
	if(minFontSize==19.0)
	{
		maxFontSize=19.0;
		incfontBttn.enabled=NO;
		decfontBttn.enabled=YES;
	}
}

-(IBAction)decFontSize:(id)sender
{
	minFontSize=16;
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;
	dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	
	UIFont *titFont = [lblTitle font];
	UIFont *subFont = [lblType font];
	UIFont *dateFont = [lblDate font];
	UIFont *authFont = [lblAuthor font];
	
	[lblTitle setFont:[titFont fontWithSize:16]];
	[lblType setFont:[subFont fontWithSize:12]];
	[lblDate setFont:[dateFont fontWithSize:12]];
	[lblAuthor setFont:[authFont fontWithSize:12]];
	
	NSString *fontSize =[[NSString alloc] initWithFormat:@"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:%d\">",minFontSize];
	self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
    [self setContentView];
	
	incfontBttn.enabled=YES;
	decfontBttn.enabled=NO;
    [fontSize release];
}

-(IBAction)saveButtonClicked
{
		
	if([StoredData sharedData].isSaved){
		saveBttn.hidden=YES;
		deleteBttn.hidden=NO;
	}
	else
	{
		if(!([arrgetArticle count]==0))
		{
			deleteBttn.hidden=NO;
			saveBttn.hidden=YES;
			if(self.strArtileID==nil){
				self.strArtileID=@"";
            }
			if(self.strTitle==nil){
				self.strTitle=@"";
			}
			if(self.strSubtitle==nil){
				self.strSubtitle=@"";
			}
			if(self.strDesc==nil){
				self.strDesc=@"";
			}
			if(self.strDate==nil){
				self.strDate=@"";
			}
			if(self.strImage==nil){
				self.strImage=@"";
			}
			if(self.strArticleURL==nil){
				self.strArticleURL=@"";
			}
			if(self.strVideo==nil){
				self.strVideo=@"";
            }
			if(self.strAuthor==nil){
				self.strAuthor=@"";
            }
			
			if([StoredData sharedData].arrDuplicateChk)
			{
				[[StoredData sharedData].arrDuplicateChk removeAllObjects];
				//[StoredData sharedData].arrDuplicateChk=[[NSMutableArray alloc]init];
			}
			
			[Database fetchArticles:[Database getDBPath]];
			if([StoredData sharedData].arrSavedArticle.count>0)
			{
				[Database checkDuplicateArticle:[Database getDBPath] arg2:self.strArtileID];
			}
			
			if([StoredData sharedData].arrDuplicateChk.count==1)
			{
				saveBttn.hidden=NO;
				deleteBttn.hidden=YES;
				alert = [[UIAlertView alloc] initWithTitle:@"\n\nArticle Already Exists in Database" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
				[alert show];
				
				UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
				theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
				CGSize theSize = [alert frame].size;
				
				UIGraphicsBeginImageContext(theSize);    
				[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
				theImage = UIGraphicsGetImageFromCurrentImageContext();    
				UIGraphicsEndImageContext();
				
				for (UIView *sub in [alert subviews])
				{
					if ([sub class] == [UIImageView class] && sub.tag == 0) {
						[sub removeFromSuperview];
						break;
					}
				}
				[[alert layer] setContents:(id)theImage.CGImage];
				
				[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo:nil repeats:NO];
			}
			else
			{
				[Database insertArticles:[Database getDBPath] articleID:self.strArtileID thumbID:@"N/A" title:self.strTitle subTitle:self.strSubtitle articleTxt:self.strDesc author:self.strAuthor date:self.strDate articleTyp:self.strType imageURL:self.strImage videoURL:self.strVideo articleURL:self.strArticleURL];	
				alert = [[UIAlertView alloc] initWithTitle:@"\n\nArticle Saved Successfully" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
				[alert show];
				UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
				theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
				CGSize theSize = [alert frame].size;
				
				UIGraphicsBeginImageContext(theSize);    
				[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
				theImage = UIGraphicsGetImageFromCurrentImageContext();    
				UIGraphicsEndImageContext();
				for (UIView *sub in [alert subviews])
				{
					if ([sub class] == [UIImageView class] && sub.tag == 0) {
						[sub removeFromSuperview];
						break;
					}
				}
				[[alert layer] setContents:(id)theImage.CGImage];
				[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo: nil repeats:NO];
			}
		}
	}
}

-(IBAction)deleteButtonClicked
{
	if([StoredData sharedData].isSaved){
		deleteBttn.hidden=NO;
		saveBttn.hidden=YES;
	}
	else{
		deleteBttn.hidden=YES;
		saveBttn.hidden=NO;
	}
	[Database deleteArticle:[Database getDBPath] arg2:[self.strArtileID intValue]];
	alert = [[UIAlertView alloc] initWithTitle:@"\n\nArticle Deleted Successfully" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
	theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	CGSize theSize = [alert frame].size;
	
	UIGraphicsBeginImageContext(theSize);    
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
	theImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	for (UIView *sub in [alert subviews])
	{
		if ([sub class] == [UIImageView class] && sub.tag == 0) {
			[sub removeFromSuperview];
			break;
		}
	}
	[[alert layer] setContents:(id)theImage.CGImage];

	[NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(aTimer:)userInfo: nil repeats:NO];

}

-(IBAction)shareButtonClick:(id)sender
{
	
	[self openDialogBox];
}

-(IBAction)goBckBttn:(id)sender
{
	[objScrollV setContentOffset:CGPointMake(0, 0) animated:NO];
	
	deleteBttn.hidden=YES;
	saveBttn.hidden=NO;
	goFwdBttn.enabled=YES;
	[imgMain setImage:[UIImage imageNamed:@".png"]];
	[customAlert.view removeFromSuperview];
	isCustomAlertVisible=NO;
	[goBckBttn setImage:[UIImage imageNamed:@"Left_Faded.png"] forState:UIControlStateHighlighted];
	videoView.hidden=YES;
	[arrgetArticle removeAllObjects];
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	if([StoredData sharedData].isSaved)
	{
		if(selectedRowint>0)
		{
			selectedRowint--;
			self.objSaved=[[StoredData sharedData].arrSavedArticle objectAtIndex:selectedRowint];
			[self fetchSavedDB];
			
			NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
			self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
			
			[self setContentView];
			
			if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
				if(![self.strVideo isEqual:@""]){
					videoView.hidden=NO;
					if(![self.strImage isEqual:@"no image"]){
						[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
					}
				}
			}
			[self slideBackward];
			
			goFwdBttn.enabled=YES;
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==0)
			{
				goBckBttn.enabled=NO;
			}
		}		
	}
	
	else if([StoredData sharedData].isViewed)
     {
		if(selectedRowint>0)
		{
			UIButton *butt=(UIButton *)sender;
			selectedRowint--;
			
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
			[self webServiceStart];
		
			if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
				if(![self.strVideo isEqual:@""]){
					videoView.hidden=NO;
					if(![self.strImage isEqual:@"no image"]){
						[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
					}
				}
			}
			
			[self slideBackward];
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==0)
			{
				butt.enabled=NO;
			}
		}
	}
	
	
	else if([StoredData sharedData].isNews)
	{
		if(selectedRowint>0)
		{
			UIButton *butt=(UIButton *)sender;
			selectedRowint--;
			
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
			[self webServiceStart];
			
			if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
				if(![self.strVideo isEqual:@""]){
					videoView.hidden=NO;
					if(![self.strImage isEqual:@"no image"]){
						[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
					}
				}
			}
			
			[self slideBackward];
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==0)
			{
				butt.enabled=NO;
			}
		}
	}
	
	
	else
	{
		if(selectedRowint>0)
		{
			UIButton *butt=(UIButton *)sender;
			selectedRowint--;
			
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
			[self webServiceStart];
			
			if(![self.strImage isEqual:@"no image"]){
				[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
			}
			[self slideBackward];
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==0)
			{
				butt.enabled=NO;
			}
		}
	}
	
	if(!isViewVisible){
		isViewVisible=TRUE;
		
		objScrollV.frame=CGRectMake(0,33,320,428);
		[self.view addSubview:tabView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform = CGAffineTransformTranslate(t, 0,0);
		navView.transform=CGAffineTransformTranslate(t, 0, -1);
		
	}
	
	[UIView commitAnimations];
}

-(IBAction)goFwdBttn:(id)sender
{
	[objScrollV setContentOffset:CGPointMake(0, 0) animated:NO];
	deleteBttn.hidden=YES;
	saveBttn.hidden=NO;
	[imgMain setImage:[UIImage imageNamed:@".png"]];
	[customAlert.view removeFromSuperview];
	isCustomAlertVisible=NO;
	goBckBttn.enabled=YES;
	[goBckBttn setImage:[UIImage imageNamed:@"Left_Normal.png"] forState:UIControlStateNormal];
	[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateHighlighted];
	videoView.hidden=YES;
	[arrgetArticle removeAllObjects];
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	
	if([StoredData sharedData].isSaved)
	{
		selectedRowint++;
		if(selectedRowint<=[arr count]-1)
		{
			self.objSaved=[[StoredData sharedData].arrSavedArticle objectAtIndex:selectedRowint];
			[self fetchSavedDB];
			
			NSString *fontSize = @"<body style=\"background-color: rgb(255,255,255)\"><font style=\"font-family:georgia; font-size:16px\">";
			self.strhtml = [NSString stringWithFormat:@"<html><body>%@%@</body></html>",fontSize,self.strDesc];
			
			[self setContentView];
			
			if([StoredData sharedData].isSaved||[StoredData sharedData].isViewed||[StoredData sharedData].isNews){
				if(![self.strVideo isEqual:@""]){
					videoView.hidden=NO;
					if(![self.strImage isEqual:@"no image"]){
						[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
					}
				}
			}
			
			[self slideForward];
			
			goBckBttn.enabled=YES;
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==[arr count]-1)
			{
				goFwdBttn.enabled=NO;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
			}
		}
	}
	
	else if([StoredData sharedData].isViewed)
	{
		if(selectedRowint<[arr count]-1)
		{
			selectedRowint++;
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
			
			[self webServiceStart];
           
			if(![self.strVideo isEqual:@""]){
				videoView.hidden=NO;
				if(![self.strImage isEqual:@"no image"]){
					[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
				}
			}
			[self slideForward];
			goBckBttn.enabled=YES;
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==[arr count]-1)
			{
				goFwdBttn.enabled=NO;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
			}
		}
	}
	
	
	else if([StoredData sharedData].isNews)
	{
		if(selectedRowint<[arr count]-1)
		{
			selectedRowint++;
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
			
			[self webServiceStart];
			
			if(![self.strVideo isEqual:@""]){
				videoView.hidden=NO;
				if(![self.strImage isEqual:@"no image"]){
					[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
				}
			}
			[self slideForward];
			goBckBttn.enabled=YES;
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==[arr count]-1)
			{
				goFwdBttn.enabled=NO;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
			}
		}
	}
	
	else
	{
		if(selectedRowint<[arr count]-1)
		{
			selectedRowint++;
			[self setDataForDetailsView:[arr objectAtIndex:selectedRowint]];
		
			[self webServiceStart];
            if(![self.strImage isEqual:@"no image"]){
				[NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
			}
			[self slideForward];
			goBckBttn.enabled=YES;
			lblFrmPage.text=[NSString stringWithFormat:@"%d",selectedRowint+1];
			if(selectedRowint==[arr count]-1)
			{
				goFwdBttn.enabled=NO;
				[goFwdBttn setImage:[UIImage imageNamed:@"Right_Faded.png"] forState:UIControlStateSelected];
			}
		}
	}
	
	if(!isViewVisible){
		isViewVisible=TRUE;
		
		objScrollV.frame=CGRectMake(0,33,320,428);
		[self.view addSubview:tabView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS_FOR_C1];
		[UIView setAnimationDelegate:self];
		tabView.transform = CGAffineTransformTranslate(t, 0,0);
		navView.transform=CGAffineTransformTranslate(t, 0, -1);
		
	}
	
	[UIView commitAnimations];
	
}

-(IBAction)videoButtonClicked
{
	//[StoredData sharedData].isVideo=TRUE;
	[StoredData sharedData].isRelatedVideo=TRUE;
	[StoredData sharedData].isRelatedArticle=FALSE;
	[StoredData sharedData].relatedArticleID=[NSString stringWithFormat:@"%@",self.strArtileID];
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	objRelArticle = [[RelatedViewController alloc]initWithNibName:@"RelatedViewController" bundle:nil];
	[navC pushViewController:objRelArticle animated:YES];
}

-(IBAction)articleButtonClicked
{
	//[StoredData sharedData].isVideo=FALSE;
	[StoredData sharedData].isRelatedArticle=TRUE;
	[StoredData sharedData].isRelatedVideo=FALSE;
	[StoredData sharedData].relatedArticleID=[NSString stringWithFormat:@"%@",self.strArtileID];
	UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
	objRelArticle = [[RelatedViewController alloc]initWithNibName:@"RelatedViewController" bundle:nil];
	[navC pushViewController:objRelArticle animated:YES];
}


#pragma mark timer
- (void)theTimer:(NSTimer*)timer 
{ 
	[alert dismissWithClickedButtonIndex:0 animated:YES];
	[theTimer invalidate];
	[theTimer release];
}

-(void)aTimer:(NSTimer*)timer 
{
	[alert dismissWithClickedButtonIndex:0 animated:YES];
    [[self navigationController] popViewControllerAnimated:YES];
	[aTimer invalidate];
	[aTimer release];
}


-(void)setArray:(NSMutableArray *)dataArray
{
	if(arr){
		[arr release];
		arr=nil;
	}
	arr=[[NSMutableArray alloc] initWithArray:dataArray];
}

-(void)openDialogBox{
	UIActionSheet* actionSheet = nil;
	actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"E-mail Link",@"Twitter",@"SMS Link",@"Share More",nil];
	chkActnSheet=0;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:[self.view window]];
	[actionSheet release];
}

#pragma mark fetchDB object
-(void)fetchSavedDB
{
	self.strTitle = self.objSaved.title;
	self.strSubtitle = self.objSaved.subTitle;
	self.strDate=self.objSaved.date;
	self.strAuthor=self.objSaved.author;
	self.strDesc=self.objSaved.articleTxt;
	self.strImage=self.objSaved.imageURL;
	self.strArtileID=self.objSaved.articleID;
	self.strArticleURL=self.objSaved.articleURL;
	self.strVideo=self.objSaved.videoURL;
}


#pragma mark removeunnesseary tags
-(void)removeHTMLTags
{
	if([StoredData sharedData].isVideo||[StoredData sharedData].isRelatedVideo)
	{
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download the MP3 audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download MP3 audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download the audio MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<strong></strong>." withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<strong>  .</strong>" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"portion ." withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  portion of this broadcast as an" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of this broadcast as ." withString:@""]; 
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of the broadcast as an" withString:@""]; 
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of the broadcast as ." withString:@""];
	}
	
	if([StoredData sharedData].isRelatedArticle||[StoredData sharedData].isViewed||[StoredData sharedData].isNews)
	{
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download the MP3 audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download MP3 audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download the audio MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"Download" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"MP3" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"audio" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<strong></strong>." withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"<strong>  .</strong>" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"portion ." withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  portion of this broadcast as an" withString:@""];
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of this broadcast as ." withString:@""]; 
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of the broadcast as an" withString:@""]; 
		self.strDesc=[self.strDesc stringByReplacingOccurrencesOfString:@"the  only portion of the broadcast as ." withString:@""];
		
	}
	
}

#pragma mark animation slideForward
-(void)slideForward
{
	[customAlert.view removeFromSuperview];
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setDuration:0.4f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[objScrollV exchangeSubviewAtIndex:0 withSubviewAtIndex:1]; 
	[[objScrollV layer] addAnimation:animation forKey:kAnimationKey];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	[UIView commitAnimations];
	
	
}

#pragma mark animation slidebackward
-(void)slideBackward
{
	[customAlert.view removeFromSuperview];
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setDuration:0.4f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[objScrollV exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
	[[objScrollV layer] addAnimation:animation forKey:kAnimationKey];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	[UIView commitAnimations];
	
}


-(void)positionBackButton
{
	backButton.hidden=NO;
	
	if([StoredData sharedData].isMore){
		
		if([StoredData sharedData].Analysis){
			[StoredData sharedData].topicName=nil;
			[backButton setImage:[UIImage imageNamed:@"bckAnalysis.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 62, 24);}
		
		else if([StoredData sharedData].Features){
			[StoredData sharedData].topicName=nil;
			[backButton setImage:[UIImage imageNamed:@"bckFeatures.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 65, 24);}
		
		else if([StoredData sharedData].TradeAlerts){
			[StoredData sharedData].topicName=nil;
			[backButton setImage:[UIImage imageNamed:@"bckTrade-Alerts.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 82, 24);}
		
		
		else if([StoredData sharedData].Statistics){
			[StoredData sharedData].topicName=nil;
			[backButton setImage:[UIImage imageNamed:@"bckStatistics.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 70, 24);}
		
		
		else if([StoredData sharedData].PressRelease){
			[StoredData sharedData].topicName=nil;
			[backButton setImage:[UIImage imageNamed:@"bckPress-Release.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 94, 24);}
		
		if([[StoredData sharedData].topicName isEqual:@"Mining"]){
			[backButton setImage:[UIImage imageNamed:@"bckMining.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 53, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Rough Markets"]){
			[backButton setImage:[UIImage imageNamed:@"bckRough-Markets.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 96, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Polished Markets"]){
			[backButton setImage:[UIImage imageNamed:@"bckPolished-Market.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 105, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Manufacturing"]){
			[backButton setImage:[UIImage imageNamed:@"bckManufacturing.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 94, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Retail"]){
			[backButton setImage:[UIImage imageNamed:@"bckRetail.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 53, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Financial/Legal"]){
			[backButton setImage:[UIImage imageNamed:@"bckFinancial-Legal.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 101, 24);
		}
		else if([[StoredData sharedData].topicName isEqual:@"Research"]){
			[backButton setImage:[UIImage imageNamed:@"bckResearch.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 70, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Marketing"]){
			[backButton setImage:[UIImage imageNamed:@"bckMarketing.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 72, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Technology"]){
			[backButton setImage:[UIImage imageNamed:@"bckTechnology.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 82, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Gemstones"]){
			[backButton setImage:[UIImage imageNamed:@"bckGemstones.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 78, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Watches"]){
			[backButton setImage:[UIImage imageNamed:@"bckWatches.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 62, 24);}
		
		else if([[StoredData sharedData].topicName isEqual:@"Fair Trade"]){
			[backButton setImage:[UIImage imageNamed:@"bckFair-Trade.png"] forState:UIControlStateNormal];
			backButton.frame = CGRectMake(14, 6, 71, 24);}
	}
	
	if([StoredData sharedData].isNews){
		[backButton setTitle:@" News" forState:UIControlStateNormal];
	}
	
	if([StoredData sharedData].isVideo){
		[backButton setTitle:@" Videos" forState:UIControlStateNormal];
	}
	if([StoredData sharedData].isViewed){
		[backButton setImage:[UIImage imageNamed:@"bckPopular.png"]forState:UIControlStateNormal];
		backButton.frame = CGRectMake(15, 6, 87, 24);
	}
	
	if([StoredData sharedData].isSearch){
		[backButton setTitle:@" Search" forState:UIControlStateNormal];
	}
	
	if([StoredData sharedData].isSaved){
		[backButton setTitle:@" Saved" forState:UIControlStateNormal];
		relVideoButton.hidden=YES;relArticleButton.hidden=YES;saveBttn.hidden=YES;deleteBttn.hidden=NO;
	}
}


#pragma mark setDynamicContent
-(void)setDynamicContent
{
	
	CGSize maxTitleSize = CGSizeMake(304,100);
	CGSize expectedTitleSize = [self.strTitle sizeWithFont:lblTitle.font constrainedToSize:maxTitleSize lineBreakMode:lblTitle.lineBreakMode]; 
	CGRect newTitleFrame = lblTitle.frame;
	newTitleFrame.size.height = expectedTitleSize.height;
	lblTitle.frame = newTitleFrame;
	lblTitle.text=self.strTitle;
	
	CGSize maxDateSize = CGSizeMake(200,100);
	CGSize expectedDateSize = [self.strDate sizeWithFont:lblDate.font constrainedToSize:maxDateSize lineBreakMode:lblDate.lineBreakMode]; 
	CGRect newDateFrame = lblDate.frame;
	newDateFrame.size.height = expectedDateSize.height;
	lblDate.frame = newDateFrame;
	NSString *newDateString=[self convertDateFormat:self.strDate];
	lblDate.text=newDateString;
	
	CGSize maxTypeSize = CGSizeMake(150,100);
	CGSize expectedTypeSize = [self.strType sizeWithFont:lblType.font constrainedToSize:maxTypeSize lineBreakMode:lblType.lineBreakMode]; 
	CGRect newTypeFrame = lblType.frame;
	newTypeFrame.size.height = expectedTypeSize.height;
	lblType.frame = newTypeFrame;
	lblType.text=self.strType;
	
	
	CGSize maxAuthorSize = CGSizeMake(304,50);
	CGSize expectedAuthorSize = [self.strAuthor sizeWithFont:lblAuthor.font constrainedToSize:maxAuthorSize lineBreakMode:lblAuthor.lineBreakMode]; 
	CGRect newAuthorFrame = lblAuthor.frame;
	newAuthorFrame.size.height = expectedAuthorSize.height;
	lblAuthor.frame = newAuthorFrame;
	lblAuthor.text=self.strAuthor;
		
}

#pragma mark convertDateFormat
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

#pragma mark actionSheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (chkActnSheet==0)
	{
		if (buttonIndex == 0){
			[self faceBookClicked];
		}
		else if(buttonIndex == 1){
			[self email];
		}
		else if(buttonIndex == 2){
			[self tweet];
		}
		else if(buttonIndex == 3){
			#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
						[self sendInAppSMS];
						
			#else
						
						NSURL *msgURL = [NSURL URLWithString:@"sms:"];
						[[UIApplication sharedApplication] openURL:msgURL];
						
			#endif
		}
		else if(buttonIndex == 4){
			[self shareMore];
		}
	}
	else if(chkActnSheet==1) {
		if (buttonIndex == 0){
			[AddThisSDK shareURL:self.strArticleURL withService:@"digg" title:self.strTitle description:self.strDesc];
		}
		else if (buttonIndex == 1)
		{
			[AddThisSDK shareURL:self.strArticleURL withService:@"reddit" title:self.strTitle description:self.strDesc];
		}
		else if (buttonIndex == 2) {
			[AddThisSDK shareURL:self.strArticleURL withService:@"delicious" title:self.strTitle description:self.strDesc];
		}
		else if (buttonIndex == 3){
			[AddThisSDK shareURL:self.strArticleURL withService:@"stumbleupon" title:self.strTitle description:self.strDesc];
		}
	}
}

#pragma mark shareMore
-(void)shareMore
{
	UIActionSheet* actionSheet = nil;
	chkActnSheet=1;
	actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Digg",@"Reddit",@"Delicious",@"StumbleUpon",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:[self.view window]];
	[actionSheet release];

}

#pragma mark Tweet
-(void)tweet
{
	
	window.hidden =YES;
	tweetViewC = [[OAuthTwitterDemoViewController alloc] init];
	tweetViewC.aMsg = self.strArticleURL;
	[tweetViewC authenticate:self];
}

#pragma mark faceBookClicked
-(void)faceBookClicked
{
	FacebookViewC *obj = [[FacebookViewC alloc] init];
	[obj publish:self.strArticleURL];
	[obj release];
}

#pragma mark Email
-(void)email{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		if ([mailClass canSendMail]){
			[self displayComposerSheet];
		}
		else{
			[funcClass showAlertView:@"No E-mail Set up!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		}
	}
	else{
		[funcClass showAlertView:@"No E-mail Set up!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
}

#pragma mark displayComposerSheet
-(void)displayComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:[NSString stringWithFormat:@"Rapaport:%@",self.strTitle]];
	
	NSString *emailBody =[NSString stringWithFormat:@"%@",self.strArticleURL];
	[picker setMessageBody:emailBody isHTML:YES];
	[self presentModalViewController:picker animated:YES];
	[picker release];
	picker=nil;
}

#pragma mark mailComposeDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed) {
		[funcClass showAlertView:@"Mail sending failed." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	else if (result == MFMailComposeResultCancelled) {
		[funcClass showAlertView:@"Mail sending cancelled." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	else if (result == MFMailComposeResultSent) {
		[funcClass showAlertView:@"Mail sent successfully" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	else if(result == MFMailComposeResultSaved) {
		[funcClass showAlertView:@"Mail saved as draft" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
}

#pragma mark sendInAppSMS
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
-(void)sendInAppSMS{
	
	Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (smsClass != nil && [MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *controller = smsClass ? [[smsClass alloc] init] : nil;
		controller.body = [NSString stringWithFormat:@"%@",self.strArticleURL];
		controller.recipients = [NSArray arrayWithObjects: nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
		[controller release];                
	}
	
	else{
		
		UIAlertView* aAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Messages cannot be send from this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[aAlert show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [aAlert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [aAlert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[aAlert layer] setContents:(id)theImage.CGImage];
		[aAlert release];
	}
}

#endif


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#pragma mark MessageComposeResult
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result){
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultFailed:{
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Unknown Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert1 show];
			UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
			theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
			CGSize theSize = [alert1 frame].size;
			
			UIGraphicsBeginImageContext(theSize);    
			[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
			theImage = UIGraphicsGetImageFromCurrentImageContext();    
			UIGraphicsEndImageContext();
			for (UIView *sub in [alert1 subviews])
			{
				if ([sub class] == [UIImageView class] && sub.tag == 0) {
					[sub removeFromSuperview];
					break;
				}
			}
			[[alert1 layer] setContents:(id)theImage.CGImage];
			[alert1 release];
			break;}
		case MessageComposeResultSent:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
#endif


#pragma mark showLoginAlertView
-(void)showAlertView
{   isCustomAlertVisible=YES;
	customAlert=[[InnerAlertView alloc]initWithNibName:@"InnerAlertView" bundle:nil];
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


-(void)viewWillAppear:(BOOL)animated
{	
	[self setGestureContent];
	[customAlert.view removeFromSuperview];
	customAlert.view.hidden =YES;
	relVideoButton.hidden=YES;relArticleButton.hidden=YES;dotUp.hidden=YES;dotDown.hidden=YES;dotBottom.hidden=YES;
	
	isViewVisible=TRUE;
    
    [objScrollV setContentOffset:CGPointMake(0, 0)];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
	self.tapRecognizer=nil;
	self.swipeLeftRecognizer = nil;
	self.strhtml= nil;
	self.strTitle= nil;
	self.strSubtitle= nil;
	self.strType=nil;
	self.strDate= nil;
	self.strAuthor= nil;
	self.strDesc= nil;
	self.strImage= nil;
	self.strArtileID= nil;
	self.strVideo= nil;
	self.strArticleURL= nil;
	self.isAuth= nil;
	self.imageView=nil;
}


/*-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
	//return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}*/

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
	[objRelArticle release];
	[getArticleParser release];
	[arrgetArticle release];
	
	[strImage release];
	[strTitle release]; 
	[strSubtitle release];
	[strType release];
	[strDate release];
    [strAuthor release];
	[strDesc release];
	[strArtileID release];
	[strhtml release];
	[strVideo release];
	[strArticleURL release];
	[objSaved release];
	[videoView release];
	
	[tweetViewC release];
	[tapRecognizer release];
	[swipeLeftRecognizer release];
	[imageView release];
	
	[inputFormatter release];
	[outputFormatter release];
	
	[isAuth release];
	[alert release];
    [super dealloc];
}

@end



