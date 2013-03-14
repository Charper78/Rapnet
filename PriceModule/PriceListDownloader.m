//
//  PriceListDownloader.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriceListDownloader.h"


@implementation PriceListDownloader

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [arrPriceCalc release];
    [arrPriceList release];
    [arrColors release];
    [arrClarity release];
    [arrShape release];
    [arrTradeScreen release];
    
    [objGridSizeParser release];
    [objTradeScreenParser release];
    //[objPriceListParser release];
    [objPriceCalcParser release];
    [objClarityParser release];
    [objColorParser release];
    [objShapeParser release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"PLD viewDidAppear");
     [self initReachability];
}

- (void)viewDidLoad
{
    NSLog(@"PLD viewDidLoad");
    [super viewDidLoad];
    //[self startDownload];
    [self initReachability];
    // Do any additional setup after loading the view from its nib.
    
    //appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
 //   Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
//	NetworkStatus internetStatus = [reach currentReachabilityStatus];
	
   // NSLog(@"load");
    
	/*if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[myAlert show];
		
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [myAlert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [myAlert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[myAlert layer] setContents:(id)theImage.CGImage];
		[myAlert release];
	}*/
    //if (isReachable == NO) {
    //    [Functions NoInternetAlert];
   // }
    //else{
      //  [self startDownload];        
    //}
}

-(void)download:(PricesDownload)pd
{
    [self startDownload:pd];
}

-(void)startDownload:(PricesDownload)pd
{
    //   [appDelegate showActivityIndicator:self]; 
    
    //act.hidden = YES;
    //bg.hidden = YES;
    
    NSLog(@"starting download");
    
    [pvProgress setProgress:0.0];
    //text.hidden = YES;
    
    [act startAnimating];
    
    for (int i = 0; i<4; i++) {
        webCallEndFlag[i] = FALSE;
    }
    
    pricelistCount = 0;
    
    if(pd == PD_All || pd == PD_Prices)
    {
        if ([Functions canView:L_Prices])
        {
            GetPriceList *l = [[GetPriceList alloc] init];
            l.delegate = self;
            [l download];
        }
    }
    
    // NSLog(@"hdkdk");
    
    if(pd == PD_All || pd == PD_Lists)
    {
        objShapeParser=[[GetShapeParser alloc]init];
        arrShape = [objShapeParser GetShapeList];
        [Database deleteAllShapes:[Database getDBPath]];
        for (int i = 0; i<[arrShape count]; i++) {
            NSDictionary *dic = [arrShape objectAtIndex:i];
            [Database insertShapesWithID:[dic objectForKey:@"ShapeID"] Title:[dic objectForKey:@"ShapeTitle"] shortTitle:[dic objectForKey:@"ShapeShortTitle"]];
        }
        
        [StoredData sharedData].arrShape = arrShape;
        
    
        objColorParser=[[GetColorsParser alloc]init];
        arrColors = [objColorParser GetColorList];
        [Database deleteAllColor:[Database getDBPath]];
        for (int i = 0; i<[arrColors count]; i++) {
            NSDictionary *dic = [arrColors objectAtIndex:i];
            [Database insertColorsWithID:[dic objectForKey:@"ColorID"] Title:[dic objectForKey:@"ColorTitle"]];
        }        
        [StoredData sharedData].arrColors = arrColors;

        
        objClarityParser=[[GetClarityParser alloc]init];
        arrClarity = [objClarityParser GetClarityList];
        [Database deleteAllClarity:[Database getDBPath]];
        for (int i = 0; i<[arrClarity count]; i++) {
            NSDictionary *dic = [arrClarity objectAtIndex:i];
            [Database insertClarityWithID:[dic objectForKey:@"ClarityID"] Title:[dic objectForKey:@"ClarityTitle"]];
        }
        
        [StoredData sharedData].arrClarity = arrClarity;

    }
    /* objGridSizeParser=[[GetGridSizeParser alloc]init];
     objGridSizeParser.delegate = self;
     [objGridSizeParser GetGridSize];
     */
    /*
     objLoginParser=[[LoginPriceParser alloc]init];
     objLoginParser.delegate = self;
     [objLoginParser authenticateWithUserName:NewsUserName password:NewsPassword];
     */
    
    

}

-(void)initReachability
{
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
                break;
            }
                
            case ReachableViaWWAN:
            {
                isReachable = YES;
                @try {
                    //if ([Functions isLogedIn] == NO) {
                    //    [Functions loginAll];
                    //}

                    //[self startDownload];
                    
                }
                @catch (NSException * e) {
                    [Functions NoInternetAlert];
                }
                
                
                break;
            }
            case ReachableViaWiFi:
            {
                isReachable = YES;
                @try {
                    //if ([Functions isLogedIn] == NO) {
                    //    [Functions loginAll];
                   // }

                   // [self startDownload];
                    
                }
                @catch (NSException * e) {
                    [Functions NoInternetAlert];
                }
                
                break;
            }
        }
        
    }
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

-(BOOL)checkAllWebSrviceEnded{
    BOOL flag = TRUE;
    for (int i = 0; i<3; i++) {
        if (!webCallEndFlag[i]) {
            flag = FALSE;
        }
    }
    
    if (!flag){// || pricelistCount!=TOTALPRICE-5) {
        return FALSE;
    }
    
    return TRUE;
}

/*
-(void)webserviceCallShapeFinished{
    webCallEndFlag[0] = TRUE;
    arrShape = [objShapeParser getResults];
   // NSLog(@"%@",arrShape);
    [Database deleteAllShapes:[Database getDBPath]];
    for (int i = 0; i<[arrShape count]; i++) {
        NSDictionary *dic = [arrShape objectAtIndex:i];
        [Database insertShapesWithID:[dic objectForKey:@"ShapeID"] Title:[dic objectForKey:@"ShapeTitle"] shortTitle:[dic objectForKey:@"ShapeShortTitle"]];
    }
    
    [StoredData sharedData].arrShape = arrShape;
    
    [self increaseProgress];
    
    if ([self checkAllWebSrviceEnded]) {
        [act stopAnimating];
        //  [appDelegate stopActivityIndicator:self];
        [delegate priceListDownloadFinished:1];
    }
}
*/
-(void)webserviceCallColorsFinished{
    webCallEndFlag[1] = TRUE;
    arrColors = [objColorParser getResults];
  //  NSLog(@"%@",arrColors);
  /*  [Database deleteAllColor:[Database getDBPath]];
    for (int i = 0; i<[arrColors count]; i++) {
        NSDictionary *dic = [arrColors objectAtIndex:i];
        [Database insertColorsWithID:[dic objectForKey:@"ColorID"] Title:[dic objectForKey:@"ColorTitle"]];
    }
    
    [StoredData sharedData].arrColors = arrColors;
    [self increaseProgress];
    
    if ([self checkAllWebSrviceEnded]) {
        [act stopAnimating];
        // [appDelegate stopActivityIndicator:self];
        [delegate priceListDownloadFinished:1];
    }
    
    
    if ([[StoredData sharedData].arrClarity count]>0 && [[StoredData sharedData].arrColors count]>0) {
        
        [PriceListData download];
       */ 
        
       /* if (objPriceListParser==nil) {
           [Database deleteAllPriceList];
            objPriceListParser=[[GetPriceListParser alloc]init];
            
            
            pricelistWebCount = 100;
            shapeType = @"ROUND";
            
            
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }*/
        
        
    //}
}

-(void)webserviceCallClarityFinished{
   // webCallEndFlag[2] = TRUE;
 //   arrClarity = [objClarityParser getResults];
  //  NSLog(@"%@",arrClarity);
  /*  [Database deleteAllClarity:[Database getDBPath]];
    for (int i = 0; i<[arrClarity count]; i++) {
        NSDictionary *dic = [arrClarity objectAtIndex:i];
        [Database insertClarityWithID:[dic objectForKey:@"ClarityID"] Title:[dic objectForKey:@"ClarityTitle"]];
    }

    [StoredData sharedData].arrClarity = arrClarity;
    [self increaseProgress];
    
    if ([self checkAllWebSrviceEnded]) {
        [act stopAnimating];
        // [appDelegate stopActivityIndicator:self];
        [delegate priceListDownloadFinished:1];
    }
    
    if ([[StoredData sharedData].arrClarity count]>0 && [[StoredData sharedData].arrColors count]>0) {
        
   */     
        
       /* if (objPriceListParser==nil) {
            [Database deleteAllPriceList];
            objPriceListParser=[[GetPriceListParser alloc]init];
            objPriceListParser.delegate = self;
            
            pricelistWebCount = 100;
            shapeType = @"ROUND";
            
            
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
           
        }*/
  //      [PriceListData download];
   // }
    
}


-(void)webserviceCallLoginFinished:(NSMutableArray *)results{
    webCallEndFlag[3] = TRUE;
    NSString *ticketAuth = [[results objectAtIndex:0]objectForKey:@"Ticket"];
    
    ticket = ticketAuth;
    
    //  [StoredData sharedData].strTicket = ticket;
    
    //[Database deleteAllPriceList];
    
    //objPriceListParser=[[GetPriceListParser alloc]init];
    //objPriceListParser.delegate = self;
    
    [PriceListData download];
    
    pricelistWebCount = 100;
    shapeType = @"ROUND";
    
    //[self download:ticketAuth];
    //[objPriceListParser GetPriceList:ticketAuth ShapeType:shapeType GridSizeID:pricelistWebCount];
      
        
    if ([self checkAllWebSrviceEnded]) {
        [act stopAnimating];
        // [appDelegate stopActivityIndicator:self];
        [delegate priceListDownloadFinished:1];
    }
}



-(void)increaseProgress
{
    float curProgress = pvProgress.progress + 1.0 / ((3520) * 2);
    if ([Functions getSystemVersionAsAnInteger] >= __IPHONE_5_0) {
        [pvProgress setProgress: curProgress animated:TRUE];
    }
    else
        pvProgress.progress = curProgress;
    
}
-(void)webserviceCallGridSizeFinished{
    
}

-(void)finishedDownloading
{
  /*  numDownloadsActual ++;
    [self increaseProgress];
    if(numDownloadsActual == numDownloadsRequierd)
    {
        [act stopAnimating];
        [delegate priceListDownloadFinished:1];
    }*/
}

-(void)webserviceCallPriceListFinished:(NSMutableArray *)results{
    arrPriceList = results;//[objPriceListParser getResults];
    //NSLog(@"%@",arrPriceList);
    
    @try {
    
    
    if ([arrPriceList count]>0) {
        bg.hidden = NO;
        act.hidden = NO;
        text.hidden = NO;
        [act startAnimating];
        NSLog(@"pricelistWebCount = %d",pricelistWebCount);
        pricelistCount++;
        float curProgress = pvProgress.progress + 1.0 / (TOTALPRICE-5);
        [pvProgress setProgress: curProgress animated:TRUE];
        
        /*if (pricelistCount<TOTALPRICE/2-1) {
            pricelistWebCount+=10;
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }else if(pricelistCount==TOTALPRICE/2-1){
            pricelistWebCount=300;
            [objPriceCalcParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }else if(pricelistCount==TOTALPRICE/2){
            pricelistWebCount=140;
            shapeType = @"PEAR";
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }else if(pricelistCount>TOTALPRICE/2 && pricelistCount<TOTALPRICE-5){
            pricelistWebCount+=10;
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }else if(pricelistCount==TOTALPRICE-5){
            pricelistWebCount=300;     
            [objPriceListParser GetPriceList:[StoredData sharedData].strPriceTicket ShapeType:shapeType GridSizeID:pricelistWebCount];
        }*/
        
        if ([self checkAllWebSrviceEnded]) {
            // [appDelegate stopActivityIndicator:self];
            [act stopAnimating];
            [delegate priceListDownloadFinished:1];
        }
    }else{
        
        
        [act stopAnimating];
        [delegate priceListDownloadFinished:2];
    }
        
               
    }
    @catch (NSException * e) {
        [Functions NoInternetAlert];
    }
    
    
}

-(void)webserviceCallPriceCalcFinished{
    
}

-(void)webserviceCallTradeScreenFinished{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
