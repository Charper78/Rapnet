//
//  FirstPriceModuleScreen.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstPriceModuleScreen.h"
#import "CustomAlertAddDiamondViewController.h"


@implementation FirstPriceModuleScreen


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Price", @"Price");
        self.tabBarItem.image = [UIImage imageNamed:@"price.png"];
        isReachable = NO;
        didInitializeScreen = NO;
    }
    pvProgress.progress = 0.0f;
    lblMsg.text = @"Loading Screen...";

    IsDownloadViewVisible = NO;
    isDownloadingLists = NO;
    isDownloadingPrices = NO;
    
    [AnalyticHelper sendView:@"Price - Calculator"];
    
    return self;
}

- (void)dealloc
{
    [discountValuesArr release];
    [myPickerView release];
    [arrTradeScreen release];
    [arrPriceCalc release];
    [arrClarity release];
    [arrColors release];
    [arrShape release];
    
    [objPriceCalcParser release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [self initReachability];
    
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initializeScreen];
    [self showLoadingScreen];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self initScreen];
    [self loadAllDataFromDatabase];
}

-(void)viewWillAppear:(BOOL)animated
{      
    [workABtn setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
    
   // [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    
    diamondName.text = @"Diamond Details";
    
    if (/*[StoredData sharedData].loginPriceFlag*/ true) {
        
    }else{
        [self.view addSubview:[StoredData sharedData].blackScreen];
        
        //  NSLog(@"price not downloafing");
        
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
        [self.view addSubview:customAlert1.view];        
        view = customAlert1.view;
        [self initialDelayEnded];
    }
}


-(void)initReachability
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
    //remoteHostLabel.text = [NSString stringWithFormat: @"Remote Host: %@", @"www.apple.com"];
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifier];
	//[self updateInterfaceWithReachability: hostReach];

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
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }

                [self initScreen];
                break;
            }
            case ReachableViaWiFi:
            {
                isReachable = YES;
                
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }

                [self initScreen];
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

-(void)downloadCalcLists
{
    if(isReachable == NO)
        return;
    
    pvProgress.progress = 0.0f;
    
    lblMsg.text = @"Updating Calculator Lists...";
    [self showLoadingScreen];
    
    
    [self performSelectorInBackground:@selector(startDownloadCalcLists) withObject:nil];
    //[self startDownloadCalcLists];
}

-(void)startDownloadCalcLists
{
    
    if ([NSThread isMainThread] == NO) {
        [self performSelectorOnMainThread:@selector(startDownloadCalcLists) withObject:nil waitUntilDone:TRUE];
        return;
    }

    isDownloadingLists = YES;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    GetPriceListLists *lists = [[GetPriceListLists alloc] init];
    [lists downloadClarity];
    [self setLoaderProgress:[NSNumber numberWithInt:6]];
    //[self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:[NSNumber numberWithInt:6] waitUntilDone:YES];
    
    [lists downloadColor];
    [self setLoaderProgress:[NSNumber numberWithInt:6]];
    //[self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:[NSNumber numberWithInt:6] waitUntilDone:YES];
    
    [lists downloadShape];
    [self setLoaderProgress:[NSNumber numberWithInt:6]];
    //[self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:[NSNumber numberWithInt:6] waitUntilDone:YES];
    
    //[self performSelectorOnMainThread:@selector(loadPickerView) withObject:nil waitUntilDone:YES];
    [self loadPickerView];
    
    isDownloadingLists = NO;
    
    [self hideLoadingScreen];

    
    [pool release];
}

-(void)loadPickerView
{
    [self loadAllDataFromDatabase];
    [self setPriceListLastUpdated];
    [myPickerView reloadAllComponents];
}

-(void)downloadPrices
{
   if(isReachable == NO)
        return;
    
    if ([Functions canView:L_Prices])
    {
        pvProgress.progress = 0.0f;
        lblMsg.text = @"Updating Rapaport Price Lists...";
        [self showLoadingScreen];
//[self startDownloadPrices];
        [self performSelectorInBackground:@selector(startDownloadPrices) withObject:nil];
    }
}

-(void)startDownloadPrices
{
 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    isDownloadingPrices = YES;
    
    GetPriceList *l = [[GetPriceList alloc] init];
    l.delegate = self;
    [l download];
    
    int count = 0;
    while ([self downloadPriceIfNeeded] && count < 5)
    {
        NSLog(@"retry download %d" , count);
            sleep(2);
            [l download];
        count ++;
    }
    
    isDownloadingPrices = NO;
    
    [self hideLoadingScreen];
    
    if(isReachable)
    {
        [self performSelectorOnMainThread:@selector(callGetPriceListDate) withObject:nil waitUntilDone:TRUE];
        //[self callGetPriceListDate];
    }
    
    [pool release];
}

-(void)callGetPriceListDate
{
    [self callGetPriceListDate:YES];
    [self callGetPriceListDate:NO];

}

-(void)setLoaderProgress:(NSNumber*)maxVal
{
    if([NSThread isMainThread] == NO)
    {
        [self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:maxVal waitUntilDone:YES];
        return;
    }
    
    NSLog(@"maxVal = %d",[maxVal integerValue]);
    NSLog(@"Cur Progress = %f", pvProgress.progress);
    
    float curProgress = pvProgress.progress + (1.0f / (float)[maxVal integerValue]);
    if ([Functions getSystemVersionAsAnInteger] >= __IPHONE_5_0) {
        [pvProgress setProgress: curProgress animated:TRUE];
        NSLog(@"New Progress = %f", curProgress);
    }
    else
        pvProgress.progress = curProgress;
    
}

-(void)increaseProgress
{
    [self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:[NSNumber numberWithInt:3800] waitUntilDone:YES];
    //[self setLoaderProgress:3800];
}

-(void)increaseProgress:(NSNumber*)amount
{
    [self performSelectorOnMainThread:@selector(setLoaderProgress:) withObject:amount waitUntilDone:YES];
}
//[delegate increaseProgress:[[NSNumber alloc] initWithFloat:1800.0]];

-(void)showLoadingScreen
{
    if(IsDownloadViewVisible == NO)
    {
        [self.view.window addSubview:vDownload];
        IsDownloadViewVisible = YES;
    }
}

-(void)hideLoadingScreen
{
    if(IsDownloadViewVisible && isDownloadingLists == NO && isDownloadingPrices == NO)
    {
        [vDownload removeFromSuperview];
        IsDownloadViewVisible = NO;
    }
}

-(void)initScreen
{
    if ([NSThread isMainThread] == NO) {
        [self performSelectorOnMainThread:@selector(initScreen) withObject:nil waitUntilDone:TRUE];
        return;
    }
    
    if(didInitializeScreen == NO)
        [self initializeScreen];
    
    if(initScreenStarted)
        return;
    initScreenStarted = YES;
    NSLog(@"initScreen");
    
    [self loadAllDataFromDatabase];
    NSLog(@"loadAllDataFromDatabase");
    
    bool downloadingAll = false;
    
    if(isReachable && ((arrClarity == nil || [arrClarity count] == 0) || (arrColors == nil || [arrColors count] == 0) || (arrShape == nil || [arrShape count] == 0)))
    {
        /*priceDownloader=[[PriceListDownloader alloc]initWithNibName:@"PriceListDownloader" bundle:nil];
        priceDownloader.delegate = self;
        [self.view addSubview:[StoredData sharedData].blackScreen];
        [self.view.window addSubview:priceDownloader.view];
        */
        
        if ([Functions canView:L_Prices] == NO) {
            [self downloadCalcLists];
        }
        else
        {
            downloadingAll = YES;
            if ([self downloadPriceIfNeeded]) {
                 NSLog(@"initScreen (downloadPrices) line 307");
                [self downloadPrices];
            }
            [self downloadCalcLists];
        }
    }
    else
        [self loadAllDataFromDatabase];
    
    if (downloadingAll == false && [self downloadPriceIfNeeded])
    {
        if([Functions canView:L_Prices] == NO)
        {
            [self.view addSubview:[StoredData sharedData].blackScreen];
            if (customAlert1)
            {
                [customAlert1.view removeFromSuperview];
                [customAlert1 release];
                customAlert1 = nil;
            }
            
            // NSLog(@"price not ");
            
            [StoredData sharedData].priceAlertFlag = TRUE;
            
            customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
            [self.view addSubview:customAlert1.view];        
            view = customAlert1.view;
            
   //         NSLog(@"line 349");
            [self initialDelayEnded];
            

        }
        else
        {
    //        NSLog(@"line 354");
            [self downloadPrices];
     //       NSLog(@"line 356");
        }
            //[self downloadPrices:PD_Prices];
    }
    else
    {
   //     NSLog(@"line 362");
        [self loadAllDataFromDatabase];
   //     NSLog(@"line 364");
        [[StoredData sharedData].blackScreen removeFromSuperview];
    }
    
    NSLog(@"line 371");
    initScreenStarted = NO;
    [self hideLoadingScreen];
}


-(void)setCalc:(int)shapeID size:(float)size colorID:(int)colorID clarityID:(int)clarityID
{
    
    [raportPriceListObj.view removeFromSuperview];
	ReleaseObject(raportPriceListObj);
    
    sizeTF.text = [Functions getFractionDisplay:size format:@"%.2f"]; //[NSString stringWithFormat:@"%.2f", size];
    
    int index = 0;
    
    for (index = 0; index < arrShape.count; index ++) {
        if ([[[arrShape objectAtIndex:index] objectForKey:@"ShapeID"] intValue] == shapeID) {
            [myPickerView selectRow:index inComponent:0 animated:YES];
            break;
        }
    }
    
    for (index = 0; index < arrColors.count; index ++) {
        if ([[[arrColors objectAtIndex:index] objectForKey:@"ColorID"] intValue] == colorID) {
            [myPickerView selectRow:index inComponent:1 animated:YES];
            break;
        }
    }
    
    for (index = 0; index < arrClarity.count; index ++) {
        if ([[[arrClarity objectAtIndex:index] objectForKey:@"ClarityID"] intValue] == clarityID) {
            [myPickerView selectRow:index inComponent:2 animated:YES];
            break;
        }
    }
    
    [myPickerView selectRow:80 inComponent:3 animated:YES];
    
    [self setCalcButton];
    [self setAllPrices];
    /*int sID = [[[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeID"]intValue];
    int CLID = [[[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityID"]intValue];
    int CID = [[[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorID"]intValue];    
*/
}

-(void)loadAllDataFromDatabase{
    arrShape = [Database fetchShapes];
    arrColors = [Database fetchColors];
    arrClarity = [Database fetchClaritys];
    [myPickerView reloadAllComponents];
    
    //[myPickerView reloadComponent:0];
    //[myPickerView reloadComponent:1];
    //[myPickerView reloadComponent:2];
    [self setPriceListLastUpdated];
}

-(BOOL)downloadPriceIfNeeded{
    /*if ([Database checkForUpdates])
    {
        return YES;
    }*/
    //return NO;
    return [PriceListData isDownloadRequired];
}
-(void)callGetPriceListDate:(bool)isRound
{
    if(isReachable)
    {
        GetPriceListDateParser *roundDateParser = [[GetPriceListDateParser alloc] init];
        roundDateParser.delegate = self;
        [roundDateParser getDate:isRound];
        [roundDateParser release];
        roundDateParser = nil;
    }
}

-(void)priceListDownloadFinished:(NSInteger)type{
    
    [priceDownloader.view removeFromSuperview];
    //[vDownload removeFromSuperview];
    [priceDownloader release];
    [appDelegate showTabBar];
    
    NSLog(@"priceListDownloadFinished");
    
    if (type==1) {
        
         
        
        [[StoredData sharedData].blackScreen removeFromSuperview];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        
        NSString *date = [NSString stringWithFormat:@"%d-%d-%d",[components month],[components day],[components year]];    
        NSString *ctime = [NSString stringWithFormat:@"%d:%d:%d",[components hour],[components minute],[components second]];
        
        
        NSString *time = [NSString stringWithFormat:@"%@ %@",date,ctime];
        
        [Database updateCheckerTable:[Database getDBPath] arg2:time updateFlag:@"YES"];
       // [self callGetPriceListDate:YES];
        //[self callGetPriceListDate:NO];
        
        [self loadAllDataFromDatabase];
    }else{
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
       // NSLog(@"price not ");
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
        [self.view addSubview:customAlert1.view];        
        view = customAlert1.view;
        [self initialDelayEnded];
    }
    
    
}

-(void)PriceListDateResult:(NSString*)date isRound:(BOOL)isRound
{
    if (date != nil && date.length > 4)
    {
        NSString *field = isRound ? kRoundPriceListDate : kPearPriceListDate;
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:date forKey:field]; 
        [prefs synchronize];
        [self setPriceListLastUpdated];
    }
}



-(void)initializeScreen{
    
    if(didInitializeScreen)
        return;
    
    sizeTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    textFieldToEdit = 1;
    [self.view addSubview:toolBar];
    toolBar.userInteractionEnabled = NO;    
    
    RADiscL.text = @"0%";
    RBDiscL.text = @"0%";
   
    
    [workABtn setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
    
   
    [showRapBtn setBackgroundImage:[UIImage imageNamed:@"Show-Hide-Rapnet-Price_1X.png"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"Save_1X.png"] forState:UIControlStateNormal];
    
    
    //showRapBtn.frame = CGRectMake(showRapBtn.frame.origin.x+1, showRapBtn.frame.origin.y, 128, 31);
    //saveBtn.frame = CGRectMake(saveBtn.frame.origin.x, saveBtn.frame.origin.y, 66, 31);
    
  //  CTTF.textAlignment = UITextAlignmentRight;
  //  TPTF.textAlignment = UITextAlignmentRight;
    sizeTF.textAlignment = UITextAlignmentRight;
    
    CTTF.frame = CGRectMake(CTTF.frame.origin.x, CTTF.frame.origin.y+4, CTTF.frame.size.width, 24);
    TPTF.frame = CGRectMake(TPTF.frame.origin.x, TPTF.frame.origin.y+4, TPTF.frame.size.width+10, 24);
    sizeTF.frame = CGRectMake(sizeTF.frame.origin.x, sizeTF.frame.origin.y+3, sizeTF.frame.size.width-20, 24);
    sizeL.frame = CGRectMake(sizeL.frame.origin.x-6, sizeL.frame.origin.y-1, sizeL.frame.size.width, sizeL.frame.size.height);
    //resetBtn.frame = CGRectMake(resetBtn.frame.origin.x, resetBtn.frame.origin.y, resetBtn.frame.size.width, resetBtn.frame.size.height);
    RPTPL.frame = CGRectMake(RPTPL.frame.origin.x+6, RPTPL.frame.origin.y, RPTPL.frame.size.width, RPTPL.frame.size.height);
    
    [sizeL setBackgroundColor:[UIColor clearColor]];
    
    //  sizeTF.alpha = 0.6;
    //  CTTF.alpha = 0.6;
    //  TPTF.alpha = 0.6;
    
    
    discountValuesArr = [[NSMutableArray alloc]init ];
    
    for (int i = 0; i<161; i++) {
        [discountValuesArr addObject:[NSNumber numberWithInt:i-80]];
    }
    
    
    UIImageView *img;    
    myPickerView.showsSelectionIndicator = YES;    
    myPickerView.tag = 30;
    myPickerView.frame = CGRectMake(0, 0,320, 162);
    myPickerView.transform=CGAffineTransformMakeScale(0.67, 0.67);
    myPickerView.center = CGPointMake(204, 121);
    
    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border1.png"]];
    img.frame = CGRectMake(94, 66, 225, 8);
    [self.view addSubview:img];
    img.contentMode = UIViewContentModeScaleToFill;
    img.alpha = 1.0;
    [img release];
    img = nil;
    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border3.png"]];
    img.frame = CGRectMake(94, 167, 225, 8);
    [self.view addSubview:img];
    img.contentMode = UIViewContentModeScaleToFill;
    img.alpha = 1.0;
    [img release];
    img = nil;
    
    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border2.png"]];
    img.frame = CGRectMake(96, 70, 8, 100);
    [self.view addSubview:img];
    img.contentMode = UIViewContentModeScaleToFill;
    img.alpha = 1.0;
    [img release];
    img = nil;
    
    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border2.png"]];
    img.frame = CGRectMake(306, 70, 8, 100);
    [self.view addSubview:img];
    img.contentMode = UIViewContentModeScaleToFill;
    img.alpha = 1.0;
    [img release];
    img = nil;
    
    [self.view bringSubviewToFront:TPPL];
    [self.view bringSubviewToFront:TPTF];
    [self.view bringSubviewToFront:RPTPL];
    //[self.view bringSubviewToFront:TPPL];
    
    for (int i = 0; i<12; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(180 + (43/1.0+1)*(i%3), 266 + (45/1.3+1)*(i/3), 43/1.0, 45/1.3)];
        [btn setBackgroundImage:[UIImage imageNamed:@"Keypad_button_1X.png"] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //   btn.alpha = 0.6;
        
        if(i==9){
            [btn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }else if(i==10){
            [btn setTitle:[NSString stringWithFormat:@"%@", [Functions getFractionSeparator]] forState:UIControlStateNormal];
        }else if(i==11){
            [btn setTitle:[NSString stringWithFormat:@"<"] forState:UIControlStateNormal];
        }
        btn.font = [UIFont fontWithName:@"Helvetica 75 Bold" size:15];
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateNormal];
        
        btn.tag = i+1;
        
        [btn addTarget:self action:@selector(NumPadTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    
    
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Selected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
	
	
	
	[self.view addSubview:rightArrowImageView];
    
    [self createScreenComponents];
    
    
    
    /*RADPL.hidden = YES;
    RATPL.hidden = YES;
    RapAvgBPL.hidden = YES;
    RapAvgPL.hidden = YES;
    RapBestBPL.hidden = YES;
    RapBestPL.hidden = YES;
    RBDPL.hidden = YES;
    RBTPL.hidden = YES;
    RADiscL.hidden = YES;
    RBDiscL.hidden = YES;
    rapnetL.hidden = YES;
    DPL.hidden = YES;
    DiscL.hidden = YES;
    
    [showRapBtn setTitle:@"Show RapNet Prices" forState:UIControlStateNormal];
    */
    showRapPrice = TRUE;
    [self.view bringSubviewToFront:showRapBtn];
    
    [self.view bringSubviewToFront:saveBtn];
    
    [self.view bringSubviewToFront:CTTF];
    [self.view bringSubviewToFront:TPTF];
    [self.view bringSubviewToFront:sizeTF];
    [self.view bringSubviewToFront:resetBtn];
    
    
    RADiscL.text = @"0%";
    RBDiscL.text = @"0%";
    RBTPL.text = @"";
    RBDPL.text = @"0";
    RADPL.text = @"0";
    RATPL.text = @"";
    RPDPL.text = @"0";
    RPTPL.text = @"0";
    CTTF.text = @"0";
    TPTF.text = @"0";
    sizeTF.text = @"0";
    RapBestBPL.text = @"";
    RapAvgBPL.text = @"";
    RapPercent.text = @"-30%";
    
    sizeTF.delegate = self;
    CTTF.delegate = self;
    TPTF.delegate = self;
    
    
    totalPriceEditFlag = FALSE;
    pricePerCaratFlag = FALSE;
    sizeEditFlag = FALSE;
    
    [myPickerView selectRow:50 inComponent:3 animated:YES];
    [myPickerView selectRow:0 inComponent:1 animated:YES];
    [myPickerView selectRow:0 inComponent:2 animated:YES];
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    
    [StoredData sharedData].workABtnGlobal = workABtn;
    
    NSLog(@"line 697");
    [myPickerView reloadAllComponents];
    [self setPriceListLastUpdated];
    didInitializeScreen = YES;
    NSLog(@"line 700");
    //[self.view addSubview:blackscreen];
}

-(void)setPriceListLastUpdated
{
    NSLog(@"line 706");
    if(arrShape == nil || arrShape.count == 0)
        return;
    
    NSInteger ShapeID = [[[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeID"] intValue]; 
    //NSString *field = ShapeID == 2 ? kPearPriceListDate : kRoundPriceListDate;
    NSLog(@"line 709");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
    NSString *str = @"";
    
    if (ShapeID == kPearShapeID)// && isRound == NO) {
    {
        str = [prefs stringForKey:kPearPriceListDate];
        lblPricesUpdated.text = [Functions dateFormat:str format:@"MMM dd, yyyy"];
    }
    else if (ShapeID != kPearShapeID) 
    {
        str = [prefs stringForKey:kRoundPriceListDate];
        lblPricesUpdated.text = [Functions dateFormat:str format:@"MMM dd, yyyy"];
    }
    
    NSTimeInterval i = 0;
    if(str.length > 0)
        i = [Functions dateDiff:[Functions getDate:str] endDate:[NSDate date]];
    float f = ((i / 60) / 60) / 24;
    NSInteger days = round(f);
    
    NSInteger numDaysInMonth = [Functions numDaysInMonth:[Functions getDate:str format:@"MMMM dd, yyyy"]];
    if(([Functions canView:L_PricesWeekly] && days > 7) || ([Functions canView:L_PricesMonthly] && days > numDaysInMonth))
        lblPricesUpdated.textColor = [UIColor redColor];
    else if(str.length > 0)
        lblPricesUpdated.textColor = [UIColor lightGrayColor];


}

-(void)resetAll{
    RADiscL.text = @"0%";
    RBDiscL.text = @"0%";
    RBTPL.text = @"";
    RBDPL.text = @"0";
    RADPL.text = @"0";
    RATPL.text = @"";
    RPDPL.text = @"0";
    RPTPL.text = @"0";
    CTTF.text = @"0";
    TPTF.text = @"0";
    sizeTF.text = @"0";
    RapBestBPL.text = @"";
    RapAvgBPL.text = @"";
    RapPercent.text = @"-30%";
    
    /*RADPL.hidden = YES;
    RATPL.hidden = YES;
    RapAvgBPL.hidden = YES;
    RapAvgPL.hidden = YES;
    RapBestBPL.hidden = YES;
    RapBestPL.hidden = YES;
    RBDPL.hidden = YES;
    RBTPL.hidden = YES;
    RADiscL.hidden = YES;
    RBDiscL.hidden = YES;
    rapnetL.hidden = YES;
    DPL.hidden = YES;
    DiscL.hidden = YES;
    
    showRapPrice=FALSE;*/
    [showRapBtn setTitle:@"Show RapNet Prices" forState:UIControlStateNormal];
    [workABtn setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    diamondName.text = @"Diamond Details";
    
    sizeTF.backgroundColor = [UIColor clearColor];
    CTTF.backgroundColor = [UIColor clearColor];
    TPTF.backgroundColor = [UIColor clearColor];
    
    
    if ([discountValuesArr count]>161) {
        [discountValuesArr removeObjectAtIndex:discountAddIndex];
        [myPickerView reloadComponent:3];
    }    
    
    [myPickerView selectRow:50 inComponent:3 animated:YES];
    [myPickerView selectRow:0 inComponent:1 animated:YES];
    [myPickerView selectRow:0 inComponent:2 animated:YES];
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    
    sizeTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    textFieldToEdit = 1;
}

-(NSMutableDictionary*)getSearchObject:(NSString*)val desc:(NSString*)desc order:(NSString*)order
{
    NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
    [diamonds setObject:val forKey:kValueElementName];
    [diamonds setObject:desc forKey:kDescriptionElementName];
    [diamonds setObject:order forKey:kListOrderElementName]; 
    
    return diamonds;
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self downloadPrices];
        //[self downloadPrices:PD_Prices];
    }
}
-(IBAction)btnDownloadPriceListClicked:(id)sender
{
    //+(NSString*) dateFormat:(NSString*)str format:(NSString*)format fromFormat:(NSString*)fromFormat
    NSString* lastUpdated = [Database getLastUpdateDate];
    NSString *formatedDate = [Functions dateFormat:lastUpdated format:@"MMMM dd, yyyy" fromFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSString *title = [NSString stringWithFormat:@"Your Rapaport prices were last updated on %@.  Do you want to update now?", formatedDate];
    UIActionSheet* actionSheet = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil ];
    //chkActnSheet=0;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //[actionSheet showInView:self.view];
    
    // [actionSheet showInView:self.tabBarController.view];
    [actionSheet showInView:[self.view window]];
    [actionSheet release];
    
    
}

-(IBAction)btnSearchRapNetClicked:(id)sender
{
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
    
    if([Functions canView:L_Rapnet] == NO)
    {
        [self.view addSubview:[StoredData sharedData].blackScreen];
        [appDelegate stopActivityIndicator:self];
        
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
        [self.view addSubview:customAlert1.view];
        view = customAlert1.view;
        [self initialDelayEnded];
        return;
    }
    
    NSString *shapeID = [[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeID"];
    NSString *colorID = [[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorID"];
    NSString *clarityID = [[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityID"];
    
    float discountFrom = [[discountValuesArr objectAtIndex:[myPickerView selectedRowInComponent:3]] floatValue];
    NSString *strDiscount = [NSString stringWithFormat:@"%.1f", discountFrom];
    DiamondResultsVC *objDiamondResult = [[DiamondResultsVC alloc]initWithNibName:@"DiamondResultsVC" bundle:nil];
    
    [objDiamondResult changeTableHeight:375];
    
    [self.view addSubview:objDiamondResult.view];
    
    DiamondSearchParams *p = [[DiamondSearchParams alloc] init];
    p.searchType = @"REGULAR";
    p.firstRowNum = @"0";
    p.toRowNum = @"20";
    p.weightFrom = [Functions fixNumberFormat: sizeTF.text];
    //p.weightTo = sizeTF.text;
    
    p.shapes = [[NSMutableArray alloc] init];
    [p.shapes addObject:[self getSearchObject:shapeID desc:@"" order:@"0"]];
    
    p.clarities = [[NSMutableArray alloc] init];
    [p.clarities addObject:[self getSearchObject:clarityID desc:@"" order:@"0"]];
    
    p.colors = [[NSMutableArray alloc] init];
    [p.colors addObject:[self getSearchObject:colorID desc:@"" order:@"0"]];
    
    p.discountFrom = strDiscount;
    //p.discountTo = strDiscount;
    
    [objDiamondResult search:p];
    [objDiamondResult release];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{     
    TPTF.backgroundColor = [UIColor clearColor];
    CTTF.backgroundColor = [UIColor clearColor];
    sizeTF.backgroundColor = [UIColor clearColor];
    
    if ([discountValuesArr count]>161) {
        [discountValuesArr removeObjectAtIndex:discountAddIndex];
        [myPickerView reloadComponent:3];
    }
    
    if (textField==sizeTF) {
        sizeTF.text = @"";
        TPTF.text = @"";
        CTTF.text = @"";
       
        sizeTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        textFieldToEdit = 1;
        
    }else if (textField==TPTF) {
        TPTF.text = @"";
       
        TPTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        textFieldToEdit = 3;
    }else if (textField==CTTF) {
        CTTF.text = @"";
      
        CTTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        textFieldToEdit = 2;
    }else{        
        textFieldToEdit = 0;
    }
    
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    return NO;
}

-(void)slideAnim:(UIView *)image:(CGPoint)center{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];		
	[UIView setAnimationDidStopSelector:@selector(show:)];
	image.center = center;
    image.frame = CGRectIntegral(image.frame);
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

-(void)show:(bool)context{    
    
}

-(IBAction)refreshPriceBtnTapped:(id)sender{
    customAlert2=[[CustomUpdatePriceListALert alloc]initWithNibName:@"CustomUpdatePriceListALert" bundle:nil];          
    [self.view addSubview:customAlert2.view];        
    view = customAlert2.view;
    customAlert2.delegate = self;
    [self initialDelayEnded];
}

-(IBAction)showRapButtonClick:(id)sender{
    
    if (showRapPrice) {
        RADPL.hidden = YES;
        RATPL.hidden = YES;
        RapAvgBPL.hidden = YES;
        RapAvgPL.hidden = YES;
        RapBestBPL.hidden = YES;
        RapBestPL.hidden = YES;
        RBDPL.hidden = YES;
        RBTPL.hidden = YES;
        RADiscL.hidden = YES;
        RBDiscL.hidden = YES;
        rapnetL.hidden = YES;
        DPL.hidden = YES;
        DiscL.hidden = YES;
        
        [showRapBtn setTitle:@"Show RapNet Prices" forState:UIControlStateNormal];
        showRapPrice = FALSE;
        
    }else{      
        
        [self getAvgBestprice];        
    }
    
    
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
}



-(IBAction)savedButtonClick:(id)sender{
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
    
    [self showAlertView];
}

-(IBAction)resetButtonClick:(id)sender{
    
    RADiscL.text = @"0%";
    RBDiscL.text = @"0%";
    RBTPL.text = @"";
    RBDPL.text = @"0";
    RADPL.text = @"0";
    RATPL.text = @"";
    RPDPL.text = @"0";
    RPTPL.text = @"0";
    CTTF.text = @"0";
    TPTF.text = @"0";
    sizeTF.text = @"0";
    RapBestBPL.text = @"";
    RapAvgBPL.text = @"";
    RapPercent.text = @"-30%";
    
    /*RADPL.hidden = YES;
    RATPL.hidden = YES;
    RapAvgBPL.hidden = YES;
    RapAvgPL.hidden = YES;
    RapBestBPL.hidden = YES;
    RapBestPL.hidden = YES;
    RBDPL.hidden = YES;
    RBTPL.hidden = YES;
    RADiscL.hidden = YES;
    RBDiscL.hidden = YES;
    rapnetL.hidden = YES;
    DPL.hidden = YES;
    DiscL.hidden = YES;
    
    showRapPrice=FALSE;
    [showRapBtn setTitle:@"Show RapNet Prices" forState:UIControlStateNormal];
    */
    
    sizeTF.backgroundColor = [UIColor clearColor];
    CTTF.backgroundColor = [UIColor clearColor];
    TPTF.backgroundColor = [UIColor clearColor];
    
    
    if ([discountValuesArr count]>161) {
        [discountValuesArr removeObjectAtIndex:discountAddIndex];
        [myPickerView reloadComponent:3];
    }    
    
    [myPickerView selectRow:50 inComponent:3 animated:YES];
    [myPickerView selectRow:0 inComponent:1 animated:YES];
    [myPickerView selectRow:0 inComponent:2 animated:YES];
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    
    sizeTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    textFieldToEdit = 1;
}

-(BOOL)checkValidNumber:(NSString*)s:(NSString *)v{
    NSString *p = [s stringByAppendingString:v];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:[self convertToNumberFromString:p]];
    [f release];
    
    if (myNumber==NULL) {
        return NO;
    }
    
    return YES;
}

-(void)NumPadTapped:(id)sender{
    
    int tag = [sender tag];
    //NSString* tmp;
    
    NSString *t;
    
    if (tag!=12 && tag!=11 && tag!=10) {
        t = [NSString stringWithFormat:@"%d",tag];
    }else if(tag==10){
        t = [NSString stringWithFormat:@"%d",0];
    }else if(tag==11){
        t = [NSString stringWithFormat:@"%@", [Functions getFractionSeparator]];
    }else if(tag==11){
        // t = [NSString stringWithFormat:@"%d",0];
    }
   
    
    switch (textFieldToEdit) {
        case 1: 
            
            if ([sizeTF.text isEqual: @"0"]) {
                sizeTF.text = @"";
            }
            
            
            BOOL flag;
            if (tag!=12) {
                flag = [self checkValidNumber:sizeTF.text :t];
            }
            
            if (tag==11 && [sizeTF.text isEqual:@""]) {
                flag = TRUE;
            }

            if ([sizeTF.text length]>=6) {
                flag = FALSE;
            }
            
            if (tag!=12 && flag) {
                sizeTF.text = [sizeTF.text stringByAppendingString:t];
                if (sizeTF.text.length == 1 && [sizeTF.text isEqualToString:[Functions getFractionSeparator]]) {
                    sizeTF.text = [NSString stringWithFormat:@"0%@", [Functions getFractionSeparator]];
                }
                sizeEditFlag = TRUE;
                [self setAllPrices];
            }else if(tag==12){
                int length = [sizeTF.text length];
                if (length!=0) {
                    sizeTF.text = [sizeTF.text substringToIndex:length-1];
                    sizeEditFlag = TRUE;
                    [self setAllPrices];
                }
                
            }
            
            
            break;
            
        case 2: 
            
            if ([CTTF.text isEqual: @"0"]) {
                
                CTTF.text = @"";
            }
            
            BOOL flag1;
            if (tag!=12) {
                flag1 = [self checkValidNumber:CTTF.text :t];
            }
            
            if ([CTTF.text length]>=7) {
                flag1 = FALSE;
            }
            
            if (tag!=12 && flag1) {
                NSString *str = [self convertToNumberFromString:[CTTF.text stringByAppendingString:t]];
                CTTF.text = [self convertNumberToCommaSeparatedString:[str floatValue]];
                pricePerCaratFlag = TRUE;
                int total = ([sizeTF.text floatValue])*([[self convertToNumberFromString:CTTF.text]floatValue]);
                TPTF.text = [self convertNumberToCommaSeparatedString:total];
                
                float d;
                
                float rpl = [[self convertToNumberFromString:RPDPL.text]floatValue];
                float y = [[self convertToNumberFromString:CTTF.text]floatValue];
                
                d = ((y-rpl)*100)/rpl;                                
                
                
                RapPercent.text = [Functions getFractionDisplay:d];
                
                if ([self checkDiscountExist:d]) {
                    [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
                }else{
                    discountEditFlag = TRUE;
                    discountAddValue = d;
                    
                    if ([discountValuesArr count]>161) {
                        [discountValuesArr removeObjectAtIndex:discountAddIndex];
                        [myPickerView reloadComponent:3];
                    }
                    /*
                    if (d>0) {
                        discountAddIndex = 161;
                    }else{
                        discountAddIndex = 0;
                    }
                    */
                    
                    discountAddIndex = [self searchIndexForDiscount:d];
                    
                    
                    [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
                    [myPickerView reloadComponent:3];
                    [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
                }
                
                
            }else if(tag==12){
                int length = [CTTF.text length];
                if (length!=0) {
                    NSString *str = [self convertToNumberFromString:[CTTF.text substringToIndex:length-1]];
                    CTTF.text = [self convertNumberToCommaSeparatedString:[str floatValue]];                   
                    
                   
                    pricePerCaratFlag = TRUE;
                    int total = ([sizeTF.text floatValue])*([[self convertToNumberFromString:CTTF.text] floatValue]);                    
                    TPTF.text = [self convertNumberToCommaSeparatedString:total];
                    
                    
                    
                    float d;
                    
                    float rpl = [[self convertToNumberFromString:RPDPL.text]floatValue];
                    float y = [[self convertToNumberFromString:CTTF.text]floatValue];
                    
                    d = ((y-rpl)*100)/rpl;                                
                    
                    RapPercent.text = [Functions getFractionDisplay:d];
                    
                    if ([self checkDiscountExist:d]) {
                        [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
                    }else{
                        discountEditFlag = TRUE;
                        discountAddValue = d;
                        
                        if ([discountValuesArr count]>161) {
                            [discountValuesArr removeObjectAtIndex:discountAddIndex];
                            [myPickerView reloadComponent:3];
                        }
                        /*
                        if (d>0) {
                            discountAddIndex = 161;
                        }else{
                            discountAddIndex = 0;
                        }
                        */
                        
                        discountAddIndex = [self searchIndexForDiscount:d];
                        
                        
                        [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
                        [myPickerView reloadComponent:3];
                        [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
                    }
                    
                    
                }
            }
            
            
            
            break;
            
        case 3:   
            
            if ([TPTF.text isEqual: @"0"]) {
                TPTF.text = @"";
            }
            
            
            BOOL flag2;
            if (tag!=12) {
                flag2 = [self checkValidNumber:TPTF.text :t];
            }
            
            if ([TPTF.text length]>=7) {
                flag2 = FALSE;
            }
            
            if (tag!=12 && flag2) {
                NSString *str = [self convertToNumberFromString:[TPTF.text stringByAppendingString:t]];
                TPTF.text = [self convertNumberToCommaSeparatedString:[str floatValue]] ;
                totalPriceEditFlag = TRUE;
                int total = ([[self convertToNumberFromString:TPTF.text] floatValue])/([sizeTF.text floatValue]);
                
                if ([sizeTF.text floatValue]==0) {
                    total = 0;
                }
                
                
                CTTF.text = [self convertNumberToCommaSeparatedString:total];
                
                
                float d;
                
                float rpl = [[self convertToNumberFromString:RPDPL.text]floatValue];
                float y = [[self convertToNumberFromString:CTTF.text]floatValue];
                
                d = ((y-rpl)*100)/rpl;                                
                
                RapPercent.text = [Functions getFractionDisplay:d];
                
                if ([self checkDiscountExist:d]) {
                    [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
                }else{
                    discountEditFlag = TRUE;
                    discountAddValue = d;
                    
                    if ([discountValuesArr count]>161) {
                        [discountValuesArr removeObjectAtIndex:discountAddIndex];
                        [myPickerView reloadComponent:3];
                    }
                    
                    /*
                     if (d>0) {
                     discountAddIndex = 161;
                     }else{
                     discountAddIndex = 0;
                     }
                     */
                    
                    discountAddIndex = [self searchIndexForDiscount:d];
                    
                    
                    
                    [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
                    [myPickerView reloadComponent:3];
                    [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
                }
                
                
            }else if(tag==12){
                int length = [TPTF.text length];
                if (length!=0) {
                    
                    NSString *str = [self convertToNumberFromString:[TPTF.text substringToIndex:length-1]];
                    TPTF.text = [self convertNumberToCommaSeparatedString:[str floatValue]] ;
                    
                    
                    totalPriceEditFlag = TRUE;
                    int total = ([[self convertToNumberFromString:TPTF.text] floatValue])/([sizeTF.text floatValue]);
                    
                    CTTF.text = [self convertNumberToCommaSeparatedString:total];
                    
                    
                    
                    float d;
                    
                    float rpl = [[self convertToNumberFromString:RPDPL.text]floatValue];
                    float y = [[self convertToNumberFromString:CTTF.text]floatValue];
                    
                    d = ((y-rpl)*100)/rpl;                                
                    
                    RapPercent.text = [Functions getFractionDisplay:d];
                    
                    if ([self checkDiscountExist:d]) {
                        [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
                    }else{
                        discountEditFlag = TRUE;
                        discountAddValue = d;
                        
                        if ([discountValuesArr count]>161) {
                            [discountValuesArr removeObjectAtIndex:discountAddIndex];
                            [myPickerView reloadComponent:3];
                        }
                        
                        /*
                         if (d>0) {
                         discountAddIndex = 161;
                         }else{
                         discountAddIndex = 0;
                         }
                         */
                        
                        discountAddIndex = [self searchIndexForDiscount:d];
                        
                        
                        
                        [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
                        [myPickerView reloadComponent:3];
                        [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
                    }
                    
                }
            }
            
            
            break;
            
        default:
            break;
    }
}


#pragma mark createScreenComponents
-(void)createScreenComponents
{
	[myScrollView setShowsHorizontalScrollIndicator:NO];
	[myScrollView setShowsVerticalScrollIndicator:NO];
	
    //myScrollView.frame = CGRectMake(29, 0, 320-29, 35);
    myScrollView.frame = CGRectMake(0, 0, 320, 35);
    myScrollView.contentSize = CGSizeMake(589, 35);
    [self.view addSubview:myScrollView];
    
    //leftArrowImageView.frame = CGRectMake(29, 0, 20, 35);
    leftArrowImageView.frame = CGRectMake(0, 0, 20, 35);
    
    rightArrowImageView.frame = CGRectMake(300, 0, 20, 35);
    [self.view addSubview:rightArrowImageView];    
   
    //refreshPriceBtn.frame = CGRectMake(0, 0, 29, 35);
    //[self.view addSubview:refreshPriceBtn];
}



-(IBAction)calcButtonClick:(id)sender
{	//NSLog(@"Calc");
    
	
    [self setCalcButton];
    
    [self resetAll];
    
    
}

-(void)setCalcButton
{
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
	
    [workAreaObj.view removeFromSuperview];
	ReleaseObject(workAreaObj);
    
    [saveCalcObj.view removeFromSuperview];
	ReleaseObject(saveCalcObj);
    
    [raportPriceChangeObj.view removeFromSuperview];
	ReleaseObject(raportPriceChangeObj);
    
    [raportPriceListObj.view removeFromSuperview];
	ReleaseObject(raportPriceListObj);
    
	[self.view addSubview:myScrollView];
    [self.view addSubview:rightArrowImageView];
	
    
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Selected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    
	
    //UIButton* button = (UIButton*)sender;
    UIButton* button = calcBtn;
    CGRect frame = tabCalc.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabCalc.frame = frame;
	
	//myScrollView.frame = CGRectMake(29, 0, 320-29, 35);
    myScrollView.frame = CGRectMake(0, 0, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width+10, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
}

-(IBAction)workAButtonClick:(id)sender{
    //[self saveButtonClick:sender];
  //  return;
    
    [StoredData sharedData].calcFromWAFlag = FALSE;
    
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
    
	[saveCalcObj.view removeFromSuperview];
	ReleaseObject(saveCalcObj);
    
    [raportPriceChangeObj.view removeFromSuperview];
	ReleaseObject(raportPriceChangeObj);
    
    [raportPriceListObj.view removeFromSuperview];
	ReleaseObject(raportPriceListObj);
    
    if(rightHide||!leftHide){
		myScrollView.frame = CGRectMake(0, 0, 330, 35);
	}
	else{
		myScrollView.frame = CGRectMake(0, 0, 330, 35);
	}
	
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X_Selected.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
    
    
    
    if(workAreaObj == nil){
	    workAreaObj = [[WorkAreaModuleScreen alloc]initWithNibName:@"WorkAreaModuleScreen" bundle:nil];
        workAreaObj.view.frame = CGRectMake(0, -2, 320, 424);    
        workAreaObj.delegate = self;
		[self.view addSubview:workAreaObj.view];
    }
    
    [self.view bringSubviewToFront:myScrollView];
    [self.view bringSubviewToFront:rightArrowImageView];
    [self.view bringSubviewToFront:leftArrowImageView];
    //[self.view bringSubviewToFront:refreshPriceBtn];
    
	UIButton* button = (UIButton*)sender;
	CGRect frame = tabWorkArea.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabWorkArea.frame = frame;
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x-20, aRect.origin.y, aRect.size.width, aRect.size.height);
	[myScrollView scrollRectToVisible:ar animated:YES];
}
-(void)clickedButton:(BOOL)hidden{
    myScrollView.hidden = hidden;
    rightArrowImageView.hidden = hidden;
    leftArrowImageView.hidden = hidden;
}

-(IBAction)saveButtonClick:(id)sender{
   // [self workAButtonClick:sender];
   // return;
    
    
    
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
   
    [workAreaObj.view removeFromSuperview];
	ReleaseObject(workAreaObj);
	
    [raportPriceChangeObj.view removeFromSuperview];
	ReleaseObject(raportPriceChangeObj);
       
    [raportPriceListObj.view removeFromSuperview];
	ReleaseObject(raportPriceListObj);
    
    if(rightHide||!leftHide){
		myScrollView.frame = CGRectMake(0, 0, 330, 35);
	}
	else{
		myScrollView.frame = CGRectMake(0, 0, 330, 35);
	}
	
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X_Selected.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    
    
    if(saveCalcObj == nil){
	    saveCalcObj = [[SavedCalculations alloc]initWithNibName:@"SavedCalculations" bundle:nil];
        saveCalcObj.view.frame = CGRectMake(0, 35, 320, 424);
        saveCalcObj.delegate = self;
		[self.view addSubview:saveCalcObj.view];
    }
    
    
    	
	UIButton* button = (UIButton*)sender;
	CGRect frame = tabSaved.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabSaved.frame = frame;
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x-20, aRect.origin.y, aRect.size.width, aRect.size.height);
	[myScrollView scrollRectToVisible:ar animated:YES];
}


-(IBAction)rarportPriceListButtonClick:(id)sender{
    //  [self.view addSubview:myScrollView];
    //  [self.view addSubview:rightArrowImageView];
    
   /* if ([StoredData sharedData].loginPriceFlag)*/ {
       NSLog(@"rarportPriceListButtonClick");
       if([NSThread isMainThread] == NO)
           return;
       NSLog(@"line 1661");
        [workAreaObj.view removeFromSuperview];
        ReleaseObject(workAreaObj);
        
        [saveCalcObj.view removeFromSuperview];
        ReleaseObject(saveCalcObj);
        
        [raportPriceChangeObj.view removeFromSuperview];
        ReleaseObject(raportPriceChangeObj);
        
        sizeTF.borderStyle = UITextBorderStyleRoundedRect;
        TPTF.borderStyle = UITextBorderStyleRoundedRect;
        CTTF.borderStyle = UITextBorderStyleRoundedRect;
        
        [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
        [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X_Selected.png"]];
        [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
        [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
        [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
        
        if(raportPriceListObj == nil){
            raportPriceListObj = [[RaportPriceList alloc]initWithNibName:@"RaportPriceList" bundle:nil];
            raportPriceListObj.delegate = self;
            raportPriceListObj.view.frame = CGRectMake(0, 36, 320, 424);        
            [self.view addSubview:raportPriceListObj.view];
        }
        
        UIButton* button = (UIButton*)sender;
        CGRect frame = tabRaportPriceList.frame;
        frame.origin.x = button.frame.origin.x;
        frame.size.width = button.frame.size.width;
        tabRaportPriceList.frame = frame;
        
        myScrollView.frame = CGRectMake(0, 0, 320, 35);
        CGRect aRect = button.frame; 
        CGRect ar = CGRectMake(aRect.origin.x-20, aRect.origin.y, aRect.size.width+40, aRect.size.height);
        [myScrollView scrollRectToVisible:ar animated:YES];
    }/*else{
        if (customAlert) {
            [customAlert.view removeFromSuperview];
            [customAlert release];
            customAlert = nil;
        }
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
        [self.view addSubview:customAlert1.view];        
        view = customAlert1.view;
        [self initialDelayEnded];
    }*/
    NSLog(@"line 1710");
}

-(IBAction)rarportPriceChangeButtonClick:(id)sender{
    
     
     [workAreaObj.view removeFromSuperview];
     ReleaseObject(workAreaObj);
     
    [saveCalcObj.view removeFromSuperview];
	ReleaseObject(saveCalcObj);
    
    [raportPriceListObj.view removeFromSuperview];
	ReleaseObject(raportPriceListObj);
    
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:myScrollView];    
    rightHide=YES;
	leftHide=NO;
	[self.view addSubview:leftArrowImageView];
	
    
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X_Selected.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
     
    if(raportPriceChangeObj == nil){
	    raportPriceChangeObj = [[RaportPriceChange alloc]initWithNibName:@"RaportPriceChange" bundle:nil];
        raportPriceChangeObj.view.frame = CGRectMake(0, 36, 320, 424);
        //raportPriceChangeObj.delegate = self;
		[self.view addSubview:raportPriceChangeObj.view];
    }
	
    UIButton* button = (UIButton*)sender;
    CGRect frame = tabRaportPriceChange.frame;
    frame.origin.x = button.frame.origin.x;
    frame.size.width = button.frame.size.width;
    tabRaportPriceChange.frame = frame;
	
	myScrollView.frame = CGRectMake(0, 0, 320, 35);
	CGRect aRect = button.frame; 
	CGRect ar = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
    [myScrollView scrollRectToVisible:ar animated:YES];
     
}

-(IBAction)scrollForward:(id)sender{  
    
    
}

-(IBAction)scrollBackward:(id)sender{
 
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
	
    if (scrollView.contentOffset.x >=140.0){
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
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	
}

#pragma mark -
#pragma mark UIPickerView Methods

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *retval = (id)view;
    NSString *discountStr;
    
    switch (component) {
        case 3:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
             discountStr = [@"" stringByAppendingFormat:@"%0.1f%%",[[discountValuesArr objectAtIndex:row] floatValue]];
            
            //if([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"])
            if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]])
                discountStr = [discountStr stringByReplacingOccurrencesOfString:@"." withString:@","];
            
            retval.text = discountStr;
            
            
            
            break;
            
        case 2:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
            retval.text = [@"" stringByAppendingFormat:@"%@",[[arrClarity objectAtIndex:row] objectForKey:@"ClarityTitle"]];
            
            
            
            break;
        case 1:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
            retval.text = [@"" stringByAppendingFormat:@"%@",[[arrColors objectAtIndex:row] objectForKey:@"ColorTitle"]];
            
            
            break;
        case 0:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
            retval.text = [@"" stringByAppendingFormat:@"%@",[[arrShape objectAtIndex:row] objectForKey:@"ShapeShortTitle"]];
            
            
            break;
            
        default:
            break;
    }   
        
    retval.font = [UIFont fontWithName:@"Helvetica" size:20];    
    retval.frame = CGRectIntegral(retval.frame);
    retval.backgroundColor = [UIColor clearColor];
    retval.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    retval.textAlignment = UITextAlignmentCenter;
    
    
    return retval;

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    sizeTF.borderStyle = UITextBorderStyleRoundedRect;
    TPTF.borderStyle = UITextBorderStyleRoundedRect;
    CTTF.borderStyle = UITextBorderStyleRoundedRect;
    NSString *weight = sizeTF.text;
    weight = [self fixNumberFormat:weight];
    double w = [[self convertToNumberFromString:weight]  doubleValue];

    switch (component) {
        case 3:
            if ([discountValuesArr count]>161) {
                [discountValuesArr removeObjectAtIndex:discountAddIndex];
                [myPickerView reloadComponent:3];
            }
            
            
            float d = [self getDiscountAtIndex:[myPickerView selectedRowInComponent:3]];
            float rpl = [[self convertToNumberFromString:[self fixNumberFormat:RPDPL.text]]  floatValue];
            
            pricePerCarat = rpl + ((rpl*d)/100);
            priceTotal = pricePerCarat*w;
            
            CTTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:pricePerCarat]];   
            TPTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:priceTotal]];
            
            RapPercent.text = [Functions getFractionDisplay:d];
            break;
            
        default:
            [self setAllPrices];
            break;
    }
        
      
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 5;
   switch (component) {
        case 0:
           numRows = [arrShape count];
           break;
       case 1:
           numRows = [arrColors count];
           break;
       case 2:
           numRows = [arrClarity count];
           break;
       case 3:
           numRows = [discountValuesArr count];
           break;   
       default:
           break;     
    }
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 55;
  
}



 
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 30;
  
    switch (component) {
        case 0:
            sectionWidth = 65;            
            break;
        case 1:
            sectionWidth = 45;            
            break;
        case 2:
            sectionWidth = 85;            
            break;
        case 3:
            sectionWidth = 100;
        default:
            break;
    }  
    
    return sectionWidth;
}

-(void)setAllPrices{
    NSString *sID = [[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeShortTitle"];
    NSString *CLID = [[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityTitle"];
    NSString *CID = [[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorTitle"];
    
    
    float d = [self getDiscountAtIndex:[myPickerView selectedRowInComponent:3]];
    NSString *weight = sizeTF.text;
    weight = [self fixNumberFormat:weight];
    double w = [[self convertToNumberFromString:weight]  doubleValue];
    
    [self setPriceListLastUpdated];
    if (w>0) {
        shapeType = [self GetShapeType:sID];
        double weightForPriceList = [StoredData sharedData].use10crts || w < 10.0 ? w : 5.0;
        
        int ID = [self getGridSizeID:weightForPriceList];
        //int ID = [self getGridSizeID:w];
        
        //rapPriceList = [Database fetchPriceWithGridID:[NSString stringWithFormat:@"%d",ID] Shape:shapeType Color:CID Clarity:CLID];
        rapPriceList = [PriceListData getPrice:[NSString stringWithFormat:@"%d",ID] shape:shapeType color:CID clarity:CLID];
        
        // NSLog(@"price = = %f", price);
        
        discount = d;
        
        RapPercent.text = [Functions getFractionDisplay:d];
        
        float rpl = rapPriceList;
        
        pricePerCarat = rpl + ((rpl*d)/100);
        priceTotal = pricePerCarat*w;
        
        CTTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:pricePerCarat]];
        TPTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:priceTotal]];
        RPTPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList*w]];
        RPDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList]];
        if (showRapPrice) {
            [self getAvgBestprice];
        }
        
        
    }else{
        CTTF.text = @"0";
        TPTF.text = @"0";
        RPTPL.text = @"0";
        RPDPL.text = @"0";
        RADPL.text  = @"";
        RBDPL.text = @"";
        RADiscL.text = @"";
        RBDiscL.text = @"";
        RapAvgBPL.text = @"";
        RapBestBPL.text = @"";
        RapPercent.text = @"-30%";
    }
    
    
    
}

-(int)getGridSizeID:(double)size{
    if ([shapeType isEqualToString:@"PEAR"] && (size>0.00 && size<0.18)) {
        return 140;
    }
    
    if (size>0.00 && size<0.04) {
        return 100;
    }else if (size>=0.04 && size<0.08) {
        return 110;
    }else if (size>=0.08 && size<0.15) {
        return 120;
    }else if (size>=0.15 && size<0.18) {
        return 130;
    }else if (size>=0.18 && size<0.23) {
        return 140;
    }else if (size>=0.23 && size<0.30) {
        return 150;
    }else if (size>=0.30 && size<0.40) {
        return 160;
    }else if (size>=0.40 && size<0.50) {
        return 170;
    }else if (size>=0.50 && size<0.70) {
        return 180;
    }else if (size>=0.70 && size<0.90) {
        return 190;
    }else if (size>=0.90 && size<1.0) {
        return 200;
    }else if (size>=1.0 && size<1.50) {
        return 210;
    }else if (size>=1.50 && size<2.0) {
        return 220;
    }else if (size>=2.0 && size<3.0) {
        return 230;
    }else if (size>=3.0 && size<4.0) {
        return 240;
    }else if (size>=4.0 && size<5.0) {
        return 250;
    }else if (size>=5.0 && size<10.0) {
        return 260;
    }else{
        return 300;
    }
    
}

-(NSString *)GetShapeType:(NSString *)title{
    NSString *str = @"";
    
    if ([title isEqualToString:@"B"] || [title isEqualToString:@"EU"]) {
        str = @"ROUND";
    }else{
        str = @"PEAR";
    }
    
    return  str;
}

-(void)getAvgBestprice{   
    
    double w = [[self convertToNumberFromString: [self fixNumberFormat:sizeTF.text]]  doubleValue];
    
    if (w>=1000) {
        RADPL.text  = @"0";
        RBDPL.text = @"0";
        RADiscL.text = @"0";
        RBDiscL.text = @"0";
        RapAvgBPL.text = @"0";
        RapBestBPL.text = @"0";
    }else{
        
        //Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
        //NetworkStatus internetStatus = [reach currentReachabilityStatus];
        
        //if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        if (showRapPrice)
        {
            if (isReachable) {
                                //NSLog(@"t===%@",[StoredData sharedData].strPriceTicket);
                //if ([[StoredData sharedData].strPriceTicket length]==0)
                if([Functions canView:L_Prices] == NO)
                {
                    /*[self.view addSubview:[StoredData sharedData].blackScreen];
                    [appDelegate stopActivityIndicator:self];
                    
                    if (customAlert1) {
                        [customAlert1.view removeFromSuperview];
                        [customAlert1 release];
                        customAlert1 = nil;
                    }
                    
                    [StoredData sharedData].priceAlertFlag = TRUE;
                    
                    customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
                    [self.view addSubview:customAlert1.view];        
                    view = customAlert1.view;
                    [self initialDelayEnded];
                    
                    */
                    
                    
                }else{
                    [appDelegate showActivityIndicator:self];

                    int sID = [[[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeID"]intValue];
                    int CLID = [[[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityID"]intValue];
                    int CID = [[[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorID"]intValue];    
                    //float w = [[self convertToNumberFromString:sizeTF.text]  floatValue];
                    
                    ReleaseObject(objPriceCalcParser);
                    
                    objPriceCalcParser=[[GetPricecalcParser alloc]init];
                    objPriceCalcParser.delegate = self;
                    /*[objPriceCalcParser GetPriceCalcWithTicket:[StoredData sharedData].strPriceTicket PricePerCarat:pricePerCarat PriceTotal:priceTotal Discount:discount RapPriceList:rapPriceList Weight:w ShapeID:sID ClarityID:CLID ColorID:CID UsePear:FALSE];*/
                    [objPriceCalcParser GetPriceCalcWithTicket:[Functions getTicket:L_Prices] PricePerCarat:pricePerCarat PriceTotal:priceTotal Discount:discount RapPriceList:rapPriceList Weight:w ShapeID:sID ClarityID:CLID ColorID:CID UsePear:FALSE];
                }
                
                
            }else{
                RADPL.text  = @"";
                RBDPL.text = @"";
                RADiscL.text = @"";
                RBDiscL.text = @"";
                RapAvgBPL.text = @"";
                RapBestBPL.text = @"";
            }
        }
            }
    
    
    
    
    
    
}

-(void)webserviceCallPriceCalcFinished:(NSMutableArray *)results{
    arrPriceCalc = results;//[objPriceCalcParser getResults];
                           //NSLog(@"xml ended cjdhjhj= %@",arrPriceCalc);
    if ([arrPriceCalc count]>0) {
        
        NSDictionary *temp = [arrPriceCalc objectAtIndex:0];
        
        bestPrice = [[temp objectForKey:@"BestPrice"]intValue];
        avgPrice = [[temp objectForKey:@"AvgPrice"]intValue];
        bestDiscount = [[temp objectForKey:@"BestDiscount"]floatValue];
        avgDiscount = [[temp objectForKey:@"AvgDiscount"]floatValue];
        diamondCount = [[temp objectForKey:@"BestAvgDiamondCount"]intValue];
        
        avgDiscount*=100;
        bestDiscount*=100;
        
        
        
        RADiscL.text = [NSString stringWithFormat:@"%0.2d%%",(int)avgDiscount];
        RBDiscL.text = [NSString stringWithFormat:@"%0.2d%%",(int)bestDiscount];
        RADPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:avgPrice]];
        RBDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:bestPrice]];
        RapAvgBPL.text = [NSString stringWithFormat:@"(%d)",diamondCount];
        RapBestBPL.text = [NSString stringWithFormat:@"(%d)",diamondCount];
        
        RADPL.hidden = NO;
        RATPL.hidden = NO;
        RapAvgBPL.hidden = NO;
        RapAvgPL.hidden = NO;
        RapBestBPL.hidden = NO;
        RapBestPL.hidden = NO;
        RBDPL.hidden = NO;
        RBTPL.hidden = NO;
        RADiscL.hidden = NO;
        RBDiscL.hidden = NO;
        rapnetL.hidden = NO;
        DPL.hidden = NO;
        DiscL.hidden = NO;
        /*
        RADPL.center = CGPointMake(129, 155);
        [self slideAnim:RADPL :CGPointMake(129, 213)];
        
        RBDPL.center = CGPointMake(129, 190);
        [self slideAnim:RBDPL :CGPointMake(129, 243)];
        
        RBDiscL.center = CGPointMake(290, 190);
        [self slideAnim:RBDiscL :CGPointMake(290, 243)];
        
        RADiscL.center = CGPointMake(290, 155);
        [self slideAnim:RADiscL :CGPointMake(290, 213)];
        
        RapAvgPL.center = CGPointMake(32, 155);
        [self slideAnim:RapAvgPL :CGPointMake(32, 213)];
        
        RapAvgBPL.center = CGPointMake(72, 156);
        [self slideAnim:RapAvgBPL :CGPointMake(72, 214)];
        
        RapBestPL.center = CGPointMake(32, 190);
        [self slideAnim:RapBestPL :CGPointMake(32, 243)];
        
        RapBestBPL.center = CGPointMake(72, 191);
        [self slideAnim:RapBestBPL :CGPointMake(72, 244)];
        */
        
        [showRapBtn setTitle:@"Hide RapNet Prices" forState:UIControlStateNormal];
        showRapPrice = TRUE;
    }else{
        [self.view addSubview:[StoredData sharedData].blackScreen];
        
        //[appDelegate stopActivityIndicator:self];
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        [StoredData sharedData].priceAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
        [self.view addSubview:customAlert1.view];        
        view = customAlert1.view;
        [self initialDelayEnded];
    }
    
    [appDelegate stopActivityIndicator:self];
}

-(void)webserviceCallLoginFinished{    
    ticketAuth = [[[objLoginParser getResults]objectAtIndex:0]objectForKey:@"Ticket"];
    int sID = [[[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeID"]intValue];
    int CLID = [[[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityID"]intValue];
    int CID = [[[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorID"]intValue];    
    float w = [[self convertToNumberFromString:sizeTF.text]  floatValue];
    
    ReleaseObject(objPriceCalcParser);
    
    objPriceCalcParser=[[GetPricecalcParser alloc]init];
    objPriceCalcParser.delegate = self;
    //[objPriceCalcParser GetPriceCalcWithTicket:[StoredData sharedData].strPriceTicket PricePerCarat:pricePerCarat PriceTotal:priceTotal Discount:discount RapPriceList:rapPriceList Weight:w ShapeID:sID ClarityID:CLID ColorID:CID UsePear:TRUE];
    [objPriceCalcParser GetPriceCalcWithTicket:[Functions getTicket:L_Prices] PricePerCarat:pricePerCarat PriceTotal:priceTotal Discount:discount RapPriceList:rapPriceList Weight:w ShapeID:sID ClarityID:CLID ColorID:CID UsePear:TRUE];

}



-(void)savedCalcFinished:(int)type index:(int)index{
    [saveCalcObj.view removeFromSuperview];
	ReleaseObject(saveCalcObj);
    
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Selected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    
    [StoredData sharedData].saveCalcFlag = TRUE;
    
    if([StoredData sharedData].updateFileFlag){
        NSLog(@"update diamond");
        diamondName.text = [NSString stringWithFormat:@"%@ - %@",[StoredData sharedData].openFileName,[StoredData sharedData].openDiamondName];
        [saveBtn setTitle:@"Update" forState:UIControlStateNormal];
        
        
        NSDictionary *temp = [StoredData sharedData].savedDiamondToupdate;
        
        
        shape = [temp objectForKey:@"Shape"];
        color = [temp objectForKey:@"Color"];
        clarity = [temp objectForKey:@"Clarity"];
        rapPriceList = [[temp objectForKey:@"RapPriceList"] floatValue];
        discount = [[temp objectForKey:@"rapPercent"] floatValue];
        priceTotal = [[temp objectForKey:@"PriceTotal"] floatValue];
        pricePerCarat = [[temp objectForKey:@"PricePerCarat"] floatValue];
        avgDiscount = [[temp objectForKey:@"AvgDiscount"] floatValue];
        avgPrice = [[temp objectForKey:@"AvgPrice"] intValue];
        bestDiscount = [[temp objectForKey:@"BestDiscount"] floatValue];
        bestPrice = [[temp objectForKey:@"BestPrice"] intValue];
        
        float size = priceTotal/pricePerCarat;
        //  NSLog(@"p===%f",size);
        if (pricePerCarat==0) {
            size = 0;
            //  NSLog(@"p===%f",priceTotal);
        }
        
        // avgDiscount*=100;
        // bestDiscount*=100;
        
        RADiscL.text = [NSString stringWithFormat:@"%0.0f%%",avgDiscount];
        RBDiscL.text = [NSString stringWithFormat:@"%0.0f%%",bestDiscount];
        RBTPL.text = [NSString stringWithFormat:@"%d",bestPrice];
        RATPL.text = [NSString stringWithFormat:@"%d",avgPrice];
        RADPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:avgPrice]];
        RBDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:bestPrice]];
        RPDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList]];
        RPTPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList*size]];
        
        CTTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:pricePerCarat]];        
        TPTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:priceTotal]];        
        //sizeTF.text = [NSString stringWithFormat:@"%0.2f",size];
        
        sizeTF.text = [Functions getFractionDisplay:size format:@"%.2f"]; 
        
        float d = discount;
        
        RapPercent.text = [Functions getFractionDisplay:d];
        
        NSInteger shapeIndex = [self getShapeIndex:shape];
        NSInteger colorIndex = [self getColorIndex:color];
        NSInteger clarityIndex = [self getClarityIndex:clarity];
        
        if(shapeIndex > -1)
            [myPickerView selectRow:shapeIndex inComponent:0 animated:YES];
        
        if(colorIndex > -1)
            [myPickerView selectRow:colorIndex inComponent:1 animated:YES];
        
        if(clarityIndex > -1)
            [myPickerView selectRow:clarityIndex inComponent:2 animated:YES];
        
        
        if ([self checkDiscountExist:d]) {            
            [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
        }else{
            discountEditFlag = TRUE;
            discountAddValue = d;
            
            if ([discountValuesArr count]>161) {
                [discountValuesArr removeObjectAtIndex:discountAddIndex];
                [myPickerView reloadComponent:3];
            }
            
            /*
             if (d>0) {
             discountAddIndex = 161;
             }else{
             discountAddIndex = 0;
             }
             */
            
            discountAddIndex = [self searchIndexForDiscount:d];
            
            [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
            [myPickerView reloadComponent:3];
            [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
        }
        
        
        
    }else if([StoredData sharedData].saveCalcFlag){
        NSLog(@"add diamond");
        diamondName.text = [NSString stringWithFormat:@"%@",[StoredData sharedData].openFileName];
        [saveBtn setTitle:@"Add" forState:UIControlStateNormal];
    }    
}


#pragma mark showLoginAlertView

-(void)showAlertView
{
    pricePerCarat = [[self convertToNumberFromString:[self fixNumberFormat:CTTF.text]] floatValue];
    priceTotal = [ [self convertToNumberFromString:[self fixNumberFormat:TPTF.text]]  floatValue];
    discount = [self getDiscountAtIndex:[myPickerView selectedRowInComponent:3]];
    rapPriceList = [[self convertToNumberFromString:[self fixNumberFormat: RPDPL.text]] floatValue];
    float size = [[self convertToNumberFromString:[self fixNumberFormat: sizeTF.text]] floatValue];
    shape = [[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]] objectForKey:@"ShapeShortTitle"];
    clarity = [[arrClarity objectAtIndex:[myPickerView selectedRowInComponent:2]] objectForKey:@"ClarityTitle"];
    color = [[arrColors objectAtIndex:[myPickerView selectedRowInComponent:1]] objectForKey:@"ColorTitle"];
    avgPrice = [[self convertToNumberFromString:[self fixNumberFormat:RADPL.text]] floatValue];
    avgDiscount = [[self convertToNumberFromString:[self fixNumberFormat: RADiscL.text]] floatValue];
    bestPrice = [[self convertToNumberFromString:[self fixNumberFormat: RBDPL.text]] floatValue];
    bestDiscount = [[self convertToNumberFromString: [self fixNumberFormat: RBDiscL.text]] floatValue];
    
    
    if ([StoredData sharedData].updateFileFlag) {
        
        [Database updateDiamond:[Database getDBPath] fileName:[StoredData sharedData].openFileName time:[StoredData sharedData].openFileTime ID:[StoredData sharedData].openDiamondName shape:shape size:[NSString stringWithFormat:@"%0.2f",size] color:color clarity:clarity rapPercent:[NSString stringWithFormat:@"%0.2f",discount] perCarat:[NSString stringWithFormat:@"%0.0f",pricePerCarat] totalPrice:[NSString stringWithFormat:@"%0.0f",priceTotal] rapPriceList:[NSString stringWithFormat:@"%0.0f",rapPriceList] totalRapPrice:[NSString stringWithFormat:@"%0.0f",rapPriceList*size] avgPrice:[NSString stringWithFormat:@"%0.0f",avgPrice] avgDiscount:[NSString stringWithFormat:@"%0.0f",avgDiscount] bestPrice:[NSString stringWithFormat:@"%0.0d",bestPrice] bestDiscount:[NSString stringWithFormat:@"%0.0f",bestDiscount] diamondIndex:[StoredData sharedData].updateDiamondIndex];
        [self alertAddDiamondFinished:1];
    }else if ([StoredData sharedData].calcFromWAFlag) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:shape forKey:@"Shape"];
        [dic setObject:clarity forKey:@"Clarity"];
        [dic setObject:color forKey:@"Color"];
        [dic setObject:[[[StoredData sharedData].savedDiamondsArr objectAtIndex:[StoredData sharedData].WAEditRowIndex]objectForKey:@"ID"] forKey:@"ID"];
        [dic setObject:[NSNumber numberWithFloat:rapPriceList] forKey:@"RapPriceList"];
        [dic setObject:[NSNumber numberWithFloat:rapPriceList*size] forKey:@"TotalRapPriceList"];
        [dic setObject:[NSNumber numberWithFloat:discount] forKey:@"rapPercent"];
        [dic setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
        [dic setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
        [dic setObject:[NSNumber numberWithFloat:avgDiscount] forKey:@"AvgDiscount"];
        [dic setObject:[NSNumber numberWithFloat:avgPrice] forKey:@"AvgPrice"];
        [dic setObject:[NSNumber numberWithFloat:bestDiscount] forKey:@"BestDiscount"];
        [dic setObject:[NSNumber numberWithFloat:bestPrice] forKey:@"BestPrice"];
        [dic setObject:[NSNumber numberWithFloat:size] forKey:@"Size"];
        
        
        
        [Database updateWorkAreaDiamond:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]] diamondIndex:[StoredData sharedData].updateWADiamondIndex];
        
        //  NSLog(@"Dic = %@",dic);
        
        [[StoredData sharedData].savedDiamondsArr replaceObjectAtIndex:[StoredData sharedData].WAEditRowIndex withObject:dic];
        
         [self alertAddDiamondFinished:1];
        
    }else{
        customAlert=[[CustomAlertAddDiamondViewController alloc]initWithNibName:@"CustomAlertAddDiamondViewController" bundle:nil];
        customAlert.delegate = self;
        customAlert.shape = shape;
        customAlert.color = color;
        customAlert.clarity = clarity;
        customAlert.avgDiscount = avgDiscount;
        customAlert.avgPrice = avgPrice;
        customAlert.bestDiscount = bestDiscount;
        customAlert.bestPrice = bestPrice;
        customAlert.priceTotal = priceTotal;
        customAlert.pricePerCarat = pricePerCarat;
        customAlert.size = priceTotal/pricePerCarat;
        
        if (pricePerCarat==0) {
            customAlert.size = 0;
        }
        
        customAlert.rapPriceList = rapPriceList;
        customAlert.discount = discount;
        customAlert.totalRapPrice = rapPriceList*customAlert.size;
             
        [self.view addSubview:customAlert.view];
        view = customAlert.view;
        [self initialDelayEnded]; 
    }
    
    
    
	
}


/*
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)	
	{
		UINavigationController *navC = [RapnetAppDelegate getAppDelegate].navigationController;
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
*/
#pragma mark  Animate a Custome Alert View
-(void)initialDelayEnded
{
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
	view.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)alertAddDiamondFinished:(int)type{ 
    if (customAlert!=nil) {
        [customAlert.view removeFromSuperview];		
        [customAlert release];
        customAlert = nil;
    }
        
    
    
    if (type==1) {
        if ([StoredData sharedData].saveCalcFlag) {
            sizeTF.borderStyle = UITextBorderStyleRoundedRect;
            TPTF.borderStyle = UITextBorderStyleRoundedRect;
            CTTF.borderStyle = UITextBorderStyleRoundedRect;
            //  NSLog(@"saved");
            
            // [self.view addSubview:myScrollView];
            // [self.view addSubview:rightArrowImageView];
            
            [raportPriceChangeObj.view removeFromSuperview];
            ReleaseObject(raportPriceChangeObj);
            
            [raportPriceListObj.view removeFromSuperview];
            ReleaseObject(raportPriceListObj);
            
            if(rightHide||!leftHide){
                myScrollView.frame = CGRectMake(0, 0, 330, 35);
            }
            else{
                myScrollView.frame = CGRectMake(0, 0, 330, 35);
            }
            
            [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
            [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
            [tabSaved setImage:[UIImage imageNamed:@"Saved_1X_Selected.png"]];
            [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
            [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
            
            
            if(saveCalcObj == nil){
                saveCalcObj = [[SavedCalculations alloc]initWithNibName:@"SavedCalculations" bundle:nil];
                saveCalcObj.view.frame = CGRectMake(0, 36, 320, 424);
                saveCalcObj.delegate = self;
                [self.view addSubview:saveCalcObj.view];
            }
            
            CGRect aRect = tabSaved.frame; 
            CGRect ar = CGRectMake(aRect.origin.x-20, aRect.origin.y, aRect.size.width, aRect.size.height);
            [myScrollView scrollRectToVisible:ar animated:YES];
            
            [saveCalcObj alertOpenFinished:[StoredData sharedData].openFileAlertType];
            
        }else{
            [StoredData sharedData].calcFromWAFlag = FALSE;
            
            sizeTF.borderStyle = UITextBorderStyleRoundedRect;
            TPTF.borderStyle = UITextBorderStyleRoundedRect;
            CTTF.borderStyle = UITextBorderStyleRoundedRect;
            
            [saveCalcObj.view removeFromSuperview];
            ReleaseObject(saveCalcObj);
            
            [raportPriceChangeObj.view removeFromSuperview];
            ReleaseObject(raportPriceChangeObj);
            
            [raportPriceListObj.view removeFromSuperview];
            ReleaseObject(raportPriceListObj);
            
            if(rightHide||!leftHide){
                myScrollView.frame = CGRectMake(0, 0, 330, 35);
            }
            else{
                myScrollView.frame = CGRectMake(0, 0, 330, 35);
            }
            
            [tabCalc setImage:[UIImage imageNamed:@"Calculator_Unselected.png"]];
            [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
            [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
            [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X_Selected.png"]];
            [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
            
            
            
            if(workAreaObj == nil){
                workAreaObj = [[WorkAreaModuleScreen alloc]initWithNibName:@"WorkAreaModuleScreen" bundle:nil];
                workAreaObj.view.frame = CGRectMake(0, 0, 320, 424);    
                workAreaObj.delegate = self;
                [self.view addSubview:workAreaObj.view];
            }
            
            [self.view bringSubviewToFront:myScrollView];
            [self.view bringSubviewToFront:rightArrowImageView];
            [self.view bringSubviewToFront:leftArrowImageView];
            
            
            CGRect aRect = tabWorkArea.frame;
            CGRect ar = CGRectMake(aRect.origin.x-20, aRect.origin.y, aRect.size.width, aRect.size.height);
            [myScrollView scrollRectToVisible:ar animated:YES];
        }
        
        
        [workABtn setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
        
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        diamondName.text = @"Diamond Details";
        
        [StoredData sharedData].calcFromWAFlag = FALSE;
        sizeTF.backgroundColor =[UIColor clearColor];
        CTTF.backgroundColor =[UIColor clearColor];
        TPTF.backgroundColor =[UIColor clearColor];
        sizeTF.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        textFieldToEdit = 1;
        RADiscL.text = @"0";
        RBDiscL.text = @"0";
        RBTPL.text = @"";
        RBDPL.text = @"0";
        RADPL.text = @"0";
        RATPL.text = @"";
        RPDPL.text = @"0";
        RPTPL.text = @"0";
        CTTF.text = @"0";
        TPTF.text = @"0";
        sizeTF.text = @"0";
        RapBestBPL.text = @"";
        RapAvgBPL.text = @"";
        RapPercent.text = @"-30%";
        
        /*RADPL.hidden = YES;
        RATPL.hidden = YES;
        RapAvgBPL.hidden = YES;
        RapAvgPL.hidden = YES;
        RapBestBPL.hidden = YES;
        RapBestPL.hidden = YES;
        RBDPL.hidden = YES;
        RBTPL.hidden = YES;
        RADiscL.hidden = YES;
        RBDiscL.hidden = YES;
        
        showRapPrice=FALSE;
        [showRapBtn setTitle:@"Show RapNet Prices" forState:UIControlStateNormal];
        */
        sizeTF.backgroundColor = [UIColor clearColor];
        CTTF.backgroundColor = [UIColor clearColor];
        TPTF.backgroundColor = [UIColor clearColor];
        
        
        if ([discountValuesArr count]>161) {
            [discountValuesArr removeObjectAtIndex:discountAddIndex];
            [myPickerView reloadComponent:3];
        }    
        
        [myPickerView selectRow:50 inComponent:3 animated:YES];
        [myPickerView selectRow:0 inComponent:1 animated:YES];
        [myPickerView selectRow:0 inComponent:2 animated:YES];
        [myPickerView selectRow:0 inComponent:0 animated:YES];
    }
    
    
}


-(void)alertUpdatePriceListFinished:(int)type{
    if (customAlert2) {
        [customAlert2.view removeFromSuperview];
        [customAlert2 release];
        customAlert2 = nil;
    }
    
    if (type==1) {
        
        BOOL internetFlag = TRUE;
        //Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
        //NetworkStatus internetStatus = [reach currentReachabilityStatus];
        
        //if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        if(isReachable == NO)
        {
            internetFlag = FALSE;
            
        }
        
        
        if (internetFlag) {
            //[appDelegate showActivityIndicator:self];
            
            //if ([[StoredData sharedData].strPriceTicket length]==0)
            if ([Functions canView:L_Prices] == NO)
            {
                [self.view addSubview:[StoredData sharedData].blackScreen];
                [appDelegate stopActivityIndicator:self];
                
                if (customAlert1) {
                    [customAlert1.view removeFromSuperview];
                    [customAlert1 release];
                    customAlert1 = nil;
                }
                
                [StoredData sharedData].priceAlertFlag = TRUE;
                
                customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
                [self.view addSubview:customAlert1.view];        
                view = customAlert1.view;
                [self initialDelayEnded];
                
                
                
                
            }else{
                /*[self.view addSubview:[StoredData sharedData].blackScreen];
                
                priceDownloader=[[PriceListDownloader alloc]initWithNibName:@"PriceListDownloader" bundle:nil];
                priceDownloader.delegate = self;
                [[[UIApplication sharedApplication] keyWindow] addSubview:priceDownloader.view];
                [priceDownloader download:PD_All];*/
                //[self downloadPrices:PD_All];
                [self downloadPrices];
                [self downloadCalcLists];
                //[self.view addSubview:priceDownloader.view];
              //  [self.view.window addSubview:priceDownloader.view];
               // [[[UIApplication sharedApplication] keyWindow] addSubview:vDownload];
            }
            
            
        }else{
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
        }    
        
        
        
        
        
    }
}

-(NSInteger)getShapeIndex:(NSString*)s
{
    NSInteger index;
    for (index = 0; index < arrShape.count; index ++) {
        if ([[[arrShape objectAtIndex:index] objectForKey:@"ShapeShortTitle"] isEqualToString:s]) {
            return index;
        }
    }
    return -1;
}

-(NSInteger)getColorIndex:(NSString*)s
{
    NSInteger index;
    for (index = 0; index < arrColors.count; index ++) {
        if ([[[arrColors objectAtIndex:index] objectForKey:@"ColorTitle"] isEqualToString:s]) {
            return index;
        }
    }
    return -1;
}

-(NSInteger)getClarityIndex:(NSString*)s
{
    NSInteger index;
    for (index = 0; index < arrClarity.count; index ++) {
        if ([[[arrClarity objectAtIndex:index] objectForKey:@"ClarityTitle"] isEqualToString:s]) {
            return index;
        }
    }
    return -1;
}

-(void)workAreaFinished:(int)type{
    [workAreaObj.view removeFromSuperview];
	ReleaseObject(workAreaObj);
    
    [tabCalc setImage:[UIImage imageNamed:@"Calculator_Selected.png"]];
    [tabRaportPriceList setImage:[UIImage imageNamed:@"RapaPort-Price-List_1X.png"]];
    [tabSaved setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    [tabRaportPriceChange setImage:[UIImage imageNamed:@"RapNet-Price-List_1X.png"]];
    [tabWorkArea setImage:[UIImage imageNamed:@"Saved_1X.png"]];
    
    switch (type) {
        case 1:
            [workABtn setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
            
            if ([StoredData sharedData].calcFromWAFlag) {
                
                [saveBtn setTitle:@"Update" forState:UIControlStateNormal];
                
                
                NSDictionary *temp = [[StoredData sharedData].savedDiamondsArr objectAtIndex:[StoredData sharedData].WAEditRowIndex];
                
                diamondName.text = [temp objectForKey:@"ID"];
                shape = [temp objectForKey:@"Shape"];
                color = [temp objectForKey:@"Color"];
                clarity = [temp objectForKey:@"Clarity"];
                rapPriceList = [[temp objectForKey:@"RapPriceList"] floatValue];
                discount = [[temp objectForKey:@"rapPercent"] floatValue];
                priceTotal = [[temp objectForKey:@"PriceTotal"] floatValue];
                pricePerCarat = [[temp objectForKey:@"PricePerCarat"] floatValue];
                avgDiscount = [[temp objectForKey:@"AvgDiscount"] floatValue];
                avgPrice = [[temp objectForKey:@"AvgPrice"] intValue];
                bestDiscount = [[temp objectForKey:@"BestDiscount"] floatValue];
                bestPrice = [[temp objectForKey:@"BestPrice"] intValue];
                
                float size = priceTotal/pricePerCarat;
                //  NSLog(@"p===%f",size);
                if (pricePerCarat==0) {
                    size = 0;
                    //  NSLog(@"p===%f",priceTotal);
                }
                
                // avgDiscount*=100;
                // bestDiscount*=100;
                
                RADiscL.text = [NSString stringWithFormat:@"%0.0f%%",avgDiscount];
                RBDiscL.text = [NSString stringWithFormat:@"%0.0f%%",bestDiscount];
                RBTPL.text = [NSString stringWithFormat:@"%d",bestPrice];
                RATPL.text = [NSString stringWithFormat:@"%d",avgPrice];
                RADPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:avgPrice]];
                RBDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:bestPrice]];
                RPDPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList]];
                RPTPL.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:rapPriceList*size]];
                
                CTTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:pricePerCarat]];        
                TPTF.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:priceTotal]];        
                //sizeTF.text = [NSString stringWithFormat:@"%0.2f",size];
                sizeTF.text = [Functions getFractionDisplay:size format:@"%.2f"];
                
                NSInteger shapeIndex = [self getShapeIndex:shape];
                NSInteger colorIndex = [self getColorIndex:color];
                NSInteger clarityIndex = [self getClarityIndex:clarity];
                
                if(shapeIndex > -1)
                    [myPickerView selectRow:shapeIndex inComponent:0 animated:YES];
                
                if(colorIndex > -1)
                    [myPickerView selectRow:colorIndex inComponent:1 animated:YES];
                
                if(clarityIndex > -1)
                    [myPickerView selectRow:clarityIndex inComponent:2 animated:YES];
                
                float d = discount;
                
                RapPercent.text = [Functions getFractionDisplay:d];
                
                if ([self checkDiscountExist:d]) {           
                    [myPickerView selectRow:finalDiscountIndex inComponent:3 animated:YES];
                }else{
                    discountEditFlag = TRUE;
                    discountAddValue = d;
                    
                    if ([discountValuesArr count]>161) {
                        [discountValuesArr removeObjectAtIndex:discountAddIndex];
                        [myPickerView reloadComponent:3];
                    }
                    
                    /*
                     if (d>0) {
                     discountAddIndex = 161;
                     }else{
                     discountAddIndex = 0;
                     }
                     */
                    
                    discountAddIndex = [self searchIndexForDiscount:d];
                    
                    
                    
                    [discountValuesArr insertObject:[NSNumber numberWithFloat:d] atIndex:discountAddIndex];
                    [myPickerView reloadComponent:3];
                    [myPickerView selectRow:discountAddIndex inComponent:3 animated:YES];
                }
                
            }
            
            break;
            
        default:
            break;
    }
}




-(void)backToOpenFile{   
    
}


-(NSString *)convertNumberToCommaSeparatedString:(float)num{
    NSNumber *number = [NSNumber numberWithFloat:num];
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:[Functions getThousandSeparator]];
    [frmtr setUsesGroupingSeparator:YES];
    NSString *commaString = [frmtr stringFromNumber:number];
    [frmtr release];
    frmtr = nil;
    return commaString;
}



-(NSString*)fixNumberFormat:(NSString*)str
{
    return [Functions fixNumberFormat:str];
}

-(NSString *)convertToNumberFromString:(NSString *)str{
    
    NSString *stringWithoutSpaces = [str stringByReplacingOccurrencesOfString:@"," withString:@""];    
    return stringWithoutSpaces;
}


-(BOOL)checkDiscountExist:(float)d{
    for (int i = 0; i<[discountValuesArr count]; i++) {
        if ([[discountValuesArr objectAtIndex:i]floatValue]==d) {
            finalDiscountIndex = i;
            return TRUE;
        }
    }
    
    return FALSE;
}

-(float)getDiscountAtIndex:(int)index{
    float d = 0;
    
    //NSString *discountStr = [self fixNumberFormat:[discountValuesArr objectAtIndex:index]];
    //discountStr = [self fixNumberFormat:discountStr];
    d = [[discountValuesArr objectAtIndex:index] floatValue];
    
    return d;
}

-(NSInteger)searchIndexForDiscount:(float)d{
    NSInteger index = -1;
    
    for (NSInteger i = 0; i<[discountValuesArr count]; i++) {
        if ([[discountValuesArr objectAtIndex:i]floatValue]<d) {
            index = i;
        }
    }
    
    NSLog(@"INd = %d",index);
    
    index++;
    
    return index;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
