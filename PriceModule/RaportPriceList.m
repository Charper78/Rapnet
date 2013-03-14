//
//  RaportPriceList.m
//  RapnetPriceModule
//
//  Created by Mohit on 14/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaportPriceList.h"

#import "Database.h"
#import "StoredData.h"

@implementation RaportPriceList
NSInteger priceListSelectedIndex;
NSString *shapeSelectedRowKey = @"shapeSelectedRowKey";
NSString *sizeSelectedRowKey = @"sizeSelectedRowKey";

@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [AnalyticHelper sendView:@"Price - RapaportPriceList"];
    
    return self;
}

- (void)dealloc
{
    for (int i = 0; i<[arrClarity count]; i++) {
        [clarityL[i] removeFromSuperview];
        [clarityL[i] release];
        clarityL[i] = nil;
    }
    
    for (int i = 0; i<[arrColors count]; i++) {
        [colorL[i] removeFromSuperview];
        [colorL[i] release];
        colorL[i] = nil;
    }
    
    [arrGridID release];
    [arrShape release];    
    [arrSizeFrom release];
    [arrSizeTo release];
    [arrColors release];
    [arrClarity release];
    [toolBar release];
    
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
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:toolBar];
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y-36, toolBar.frame.size.width, toolBar.frame.size.height);
    toolBar.userInteractionEnabled = NO;
    
    arrColors = [Database fetchColors];
    arrClarity = [Database fetchClaritys];
    
    arrShape = [[NSMutableArray alloc]init ];
    [arrShape addObject:@"PEAR"];
    [arrShape addObject:@"ROUND"];
    
    arrSizeFrom = [[NSMutableArray alloc]init ];
    [arrSizeFrom addObject:[Functions fixNumberFormat: @"0.01"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.04"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.08"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.15"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.18"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.23"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.30"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.40"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.50"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.70"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"0.90"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"1.00"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"1.50"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"2.00"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"3.00"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"4.00"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"5.00"]];
    [arrSizeFrom addObject:[Functions fixNumberFormat:@"10.00"]];
    
    arrSizeTo = [[NSMutableArray alloc]init ];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.03"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.07"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.14"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.17"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.22"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.29"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.39"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.49"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.69"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.89"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"0.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"1.49"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"1.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"2.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"3.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"4.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"9.99"]];
    [arrSizeTo addObject:[Functions fixNumberFormat:@"10.99"]];
    
    arrGridID = [[NSMutableArray alloc]init ];
    [arrGridID addObject:@"100"];
    [arrGridID addObject:@"110"];
    [arrGridID addObject:@"120"];
    [arrGridID addObject:@"130"];
    [arrGridID addObject:@"140"];
    [arrGridID addObject:@"150"];
    [arrGridID addObject:@"160"];
    [arrGridID addObject:@"170"];
    [arrGridID addObject:@"180"];
    [arrGridID addObject:@"190"];
    [arrGridID addObject:@"200"];
    [arrGridID addObject:@"210"];
    [arrGridID addObject:@"220"];
    [arrGridID addObject:@"230"];
    [arrGridID addObject:@"240"];
    [arrGridID addObject:@"250"];
    [arrGridID addObject:@"260"];
    [arrGridID addObject:@"300"];
        
    
    myPickerView.showsSelectionIndicator = YES;    
    myPickerView.tag = 30;
    myPickerView.frame = CGRectMake(0, 0,320, 162);
    myPickerView.transform=CGAffineTransformMakeScale(0.7, 0.7);
    myPickerView.center = CGPointMake(160, 90);
    [myPickerView removeFromSuperview];
    [self.view addSubview:myPickerView];
    
    NSNumber *shapeSelectedRow = [Functions getData:shapeSelectedRowKey];
    NSNumber *sizeSelectedRow = [Functions getData:sizeSelectedRowKey];
    
    [myPickerView selectRow:shapeSelectedRow != nil ? [shapeSelectedRow integerValue] : 1 inComponent:0 animated:YES];
    [myPickerView selectRow:sizeSelectedRow != nil ? [sizeSelectedRow integerValue] : 0 inComponent:1 animated:YES];
    
    
    //NSString *time;
   
    
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    
    /*NSString *date = [NSString stringWithFormat:@"%0.2d/%0.2d/%0.2d",[components month],[components day],[components year]];    
    
    
    time = [NSString stringWithFormat:@"%@",date];
    
    NSString *sizeFrom = [NSString stringWithFormat:@"%@", [arrSizeFrom objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    NSString *sizeTo = [NSString stringWithFormat:@"%@", [arrSizeTo objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    
    NSString *strSize = [NSString stringWithFormat:@"%@ - %@ Ct.", sizeFrom, sizeTo];
    headingL.text = [NSString stringWithFormat:@"%@ : %@ : %@",[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]],strSize,time];*/
    
 //   NSLog(@"%d",[arrClarity count]);
 //   NSLog(@"%d",[arrColors count]);
    
    for (int i = 0; i<[arrColors count]; i++) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Seperator-1X.png"]];
        img.frame = CGRectMake(0, 50+(25+10)*i, 730, 1);
        img.contentMode = UIViewContentModeScaleToFill;
        [dataScrollView addSubview:img];
        [img release];
        img = nil;
    }
    
    /*
    for (int i = 0; i<[arrClarity count]; i++) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vertical line.png"]];
        img.frame = CGRectMake(85+(50+10)*i, 0, 1, 500);
        img.contentMode = UIViewContentModeScaleToFill;
        [dataScrollView addSubview:img];
        [img release];
        img = nil;
    }
    */
    
    for (int i = 0; i<[arrClarity count]; i++) {
        clarityL[i] = [[UILabel alloc]initWithFrame:CGRectMake(30+(50+10)*i, 0, 50, 25)];
        clarityL[i].text = [[arrClarity objectAtIndex:i]objectForKey:@"ClarityTitle"];
        clarityL[i].backgroundColor = [UIColor clearColor];
        clarityL[i].font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        clarityL[i].textAlignment = UITextAlignmentCenter;
        [columnScrollView addSubview:clarityL[i]];
    }
    
    
    for (int i = 0; i<[arrColors count]; i++) {
        colorL[i] = [[UILabel alloc]initWithFrame:CGRectMake(0,20+(25+10)*i, 40, 25)];
        colorL[i].text = [[arrColors objectAtIndex:i]objectForKey:@"ColorTitle"];
        colorL[i].backgroundColor = [UIColor clearColor];
        colorL[i].font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        colorL[i].textAlignment = UITextAlignmentCenter;
        [rowScrollView addSubview:colorL[i]];
    }
    
    int colorCount = arrColors.count;
    int clarityCount = arrClarity.count;
   
    for (int i = 0; i<colorCount; i++) {
        for (int j = 0; j<clarityCount; j++) {
            pricesL[i][j] = [[UILabel alloc]initWithFrame:CGRectMake(30+(50+10)*j, 20+(25+10)*i, 50, 25)];
            pricesL[i][j].text = [Functions fixNumberFormat:@"10,000"];
            pricesL[i][j].backgroundColor = [UIColor clearColor];
            pricesL[i][j].font = [UIFont fontWithName:@"Helvetica" size:13];
            pricesL[i][j].textAlignment = UITextAlignmentCenter;
            [dataScrollView addSubview:pricesL[i][j]];
            
            
            pricesBtn[i][j] = [UIButton buttonWithType:UIButtonTypeCustom];
            pricesBtn[i][j].frame = pricesL[i][j].frame;
            pricesBtn[i][j].tag = i*[arrColors count] * 1000 + j;
            //pricesBtn[i][j].tag = (i * [arrColors count] * 1000) + (j * [arrClarity count] * 10);
            //pricesBtn[i][j].tag = [NSString stringWithFormat:@"", ];
            [dataScrollView addSubview:pricesBtn[i][j]];
            [pricesBtn[i][j] addTarget:self action:@selector(pricesBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    
    dataScrollView.center=CGPointMake(dataScrollView.center.x, dataScrollView.center.y+36);
    rowScrollView.center=CGPointMake(rowScrollView.center.x, rowScrollView.center.y+36);
    columnScrollView.center=CGPointMake(columnScrollView.center.x, columnScrollView.center.y+36);
    
    
    dataScrollView.contentSize=CGSizeMake(700, 400);
    rowScrollView.contentSize=CGSizeMake(42, 400);
    columnScrollView.contentSize=CGSizeMake(700, 30);
    
    
    dataScrollView.scrollEnabled=TRUE;
    xScroll=0;
    yScroll=0;
    [self.view addSubview:rowDownBtn];
    [self.view addSubview:rowUpBtn];
    [self.view addSubview:colRightBtn];
    [self.view addSubview:colLeftBtn];
    rowDownBtn.frame=CGRectMake(6+0, 177+175, 30, 23);
    rowUpBtn.frame=CGRectMake(6+0, 177+2, 30, 23);
    colRightBtn.frame=CGRectMake(42+251, 147, 23, 30);
    colLeftBtn.frame=CGRectMake(42+3, 147, 23, 30);
   
    
    rowDownBtn.hidden = YES;
    rowUpBtn.hidden = YES;
    colLeftBtn.hidden = YES;
    colRightBtn.hidden = YES;
    
    
    [self setAllPrices];
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
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }

                break;
            }
            case ReachableViaWiFi:
            {
                isReachable = YES;
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
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

-(void)setPriceListLastUpdated
{
    NSInteger shapeID = 1;
    if([myPickerView selectedRowInComponent:0] == 0)
        shapeID = 2;
    //NSString *field = ShapeID == 2 ? kPearPriceListDate : kRoundPriceListDate;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *str = @"";
    
    if (shapeID == kPearShapeID)// && isRound == NO) {
    {
        str = [prefs stringForKey:kPearPriceListDate];
        [self setTitle:[Functions dateFormat:str format:@"MMMM dd, yyyy"]];
    }
    else if (shapeID != kPearShapeID) 
    {
        str = [prefs stringForKey:kRoundPriceListDate];
        [self setTitle:[Functions dateFormat:str format:@"MMMM dd, yyyy"]];
    }
    
    NSTimeInterval i = 0;
    if(str.length > 0)
        i = [Functions dateDiff:[Functions getDate:str] endDate:[NSDate date]];
    float f = ((i / 60) / 60) / 24;
    NSInteger days = round(f);
    
    if(days > 7)
        headingL.textColor = [UIColor redColor];
    else if(str.length > 0)
        headingL.textColor = [UIColor whiteColor];
    
}

-(void)setTitle:(NSString*)date
{
    NSString *sizeFrom = [NSString stringWithFormat:@"%@", [arrSizeFrom objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    NSString *sizeTo = [NSString stringWithFormat:@"%@", [arrSizeTo objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    
    NSString *strSize = [NSString stringWithFormat:@"%@ - %@ Ct.", sizeFrom, sizeTo];
    headingL.text = [NSString stringWithFormat:@"%@ : %@ : %@",[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]],strSize,date];
}

-(void)setAllPrices{
    NSString *gridID = [arrGridID objectAtIndex:[myPickerView selectedRowInComponent:1]];
    NSString *shape = [arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]];
    
    for (int i = 0; i<[arrColors count]; i++) {
        for (int j = 0; j<[arrClarity count]; j++) {    
            //float price = [Database fetchPriceWithGridID:gridID Shape:shape Color:[[arrColors objectAtIndex:i]objectForKey:@"ColorTitle"] Clarity:[[arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
            float price = [PriceListData getPrice:gridID shape:shape color:[[arrColors objectAtIndex:i]objectForKey:@"ColorTitle"]  clarity:[[arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
            
            if (price<0) {
                price = 0;
            }
            
            //NSLog(@"pri===%0.1f",price/100.0);
            
            if ([gridID intValue]<=150) {
                pricesL[i][j].text = [Functions getFractionDisplay:price / 100.0 format:@"%0.1f"];
               // pricesL[i][j].text = [NSString stringWithFormat:@"%0.1f",price/100.0];
            }else{
                pricesL[i][j].text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:price/100.0]];
            }
            
                        
        }        
    }
    [self setPriceListLastUpdated];
   /* 
    NSString *time;
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    
    NSString *date = [NSString stringWithFormat:@"%0.2d/%0.2d/%0.2d",[components month],[components day],[components year]];    
    
    
    time = [NSString stringWithFormat:@"%@",date];
    
    NSString *sizeFrom = [NSString stringWithFormat:@"%@", [arrSizeFrom objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    NSString *sizeTo = [NSString stringWithFormat:@"%@", [arrSizeTo objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    
    NSString *strSize = [NSString stringWithFormat:@"%@ - %@ Ct.", sizeFrom, sizeTo];
    
    headingL.text = [NSString stringWithFormat:@"%@ : %@ : %@",[arrShape objectAtIndex:[myPickerView selectedRowInComponent:0]],strSize,time];
    */
    //[self callGetPriceListDate];
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


-(IBAction)colArrowBtnClicked:(id)sender{
   // colLeftBtn.hidden = NO;
    if (xScroll<420) {
        xScroll+=20;
        [dataScrollView setContentOffset:CGPointMake(xScroll, yScroll) animated:YES];
    }
    
    if (xScroll>400) {
       // colRightBtn.hidden = YES;
    }
}

-(IBAction)rowArrowBtnClicked:(id)sender{
  //  rowUpBtn.hidden = NO;
    if (yScroll<200) {
        yScroll+=20;
        [dataScrollView setContentOffset:CGPointMake(xScroll, yScroll) animated:YES];
    }
    
    if (yScroll>180) {
     //   rowDownBtn.hidden = YES;
    }
    
}

-(IBAction)colLeftArrowBtnClicked:(id)sender{
  //  colRightBtn.hidden = NO;
    if (xScroll>20) {
        xScroll-=20;
        [dataScrollView setContentOffset:CGPointMake(xScroll, yScroll) animated:YES];
    }
    
    if (xScroll<40) {
      //  colLeftBtn.hidden = YES;
    }
}
-(IBAction)rowUpArrowBtnClicked:(id)sender{
  //  rowDownBtn.hidden = NO;
    if (yScroll>10) {
        yScroll-=20;
        [dataScrollView setContentOffset:CGPointMake(xScroll, yScroll) animated:YES];
    }
    
    if (yScroll<40) {
      //  rowUpBtn.hidden = YES;
    }
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
    if(buttonIndex == 2)
        return;
    
    int colorIndex = priceListSelectedIndex / [arrColors count] / 1000;
    int clarityIndex = priceListSelectedIndex % 1000;
    
    
    //int j = index % [arrColors count];
    //int i = index / [arrColors count];
    
    //i*[arrColors count] + j;
    NSString *CLID = [[arrClarity objectAtIndex:clarityIndex] objectForKey:@"ClarityID"];
    NSString *CID = [[arrColors objectAtIndex:colorIndex] objectForKey:@"ColorID"]; 
    
    //NSString *CLTitle = [[arrClarity objectAtIndex:clarityIndex] objectForKey:@"ClarityTitle"];
    //NSString *CTitle = [[arrColors objectAtIndex:colorIndex] objectForKey:@"ColorTitle"];
    
    NSString *shapeID = @"1";
    if([myPickerView selectedRowInComponent:0] == 0)
        shapeID = @"2";
    
    NSString *sizeFrom = [arrSizeFrom objectAtIndex:[myPickerView selectedRowInComponent:1]];
    NSString *sizeTo = [arrSizeTo objectAtIndex:[myPickerView selectedRowInComponent:1]];
    
    sizeFrom = [Functions fixNumberFormat:sizeFrom];
    sizeTo = [Functions fixNumberFormat:sizeTo];
    //-(void)setCalc:(int)shapeID size:(float)size colorID:(int)colorID clarityID:(int)clarityID;
    
    
    if (buttonIndex == 0) {
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

        DiamondResultsVC *objDiamondResult = [[DiamondResultsVC alloc]initWithNibName:@"DiamondResultsVC" bundle:nil];
        
        [objDiamondResult changeTableHeight:375-35.0];
        
        [self.view addSubview:objDiamondResult.view];
        
        DiamondSearchParams *p = [[DiamondSearchParams alloc] init];
        p.searchType = @"REGULAR";
        p.firstRowNum = @"0";
        p.toRowNum = @"20";
        p.weightFrom = sizeFrom;
        p.weightTo = sizeTo;
        
        p.shapes = [[NSMutableArray alloc] init];
        [p.shapes addObject:[self getSearchObject:shapeID desc:@"" order:@"0"]];
        
        p.clarities = [[NSMutableArray alloc] init];
        [p.clarities addObject:[self getSearchObject:CLID desc:@"" order:@"0"]];
        
        p.colors = [[NSMutableArray alloc] init];
        [p.colors addObject:[self getSearchObject:CID desc:@"" order:@"0"]];
        
        [objDiamondResult search:p];
        [objDiamondResult release];

    }
    else if(buttonIndex == 1)
    {
        [delegate setCalc:[shapeID intValue] size:[sizeFrom floatValue] colorID:[CID intValue] clarityID:[CLID intValue]];
    }
}

-(IBAction)pricesBtnTapped:(id)sender{
    priceListSelectedIndex = [sender tag];
    
    UIActionSheet* actionSheet = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Open..."delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"RapNet",@"Calculator", nil ];
    //chkActnSheet=0;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //[actionSheet showInView:self.view];
    
   // [actionSheet showInView:self.tabBarController.view];
    [actionSheet showInView:[self.view window]];
    [actionSheet release];
}

-(float)getWieghtWithGridId:(NSInteger)ID{
    float w = 0;
    
    return w;
}

#pragma mark -
#pragma mark UIScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *) theScrollView { 
    CGPoint p = dataScrollView.contentOffset;
    [columnScrollView setContentOffset:CGPointMake(p.x, columnScrollView.contentOffset.y)]; 
    [rowScrollView setContentOffset:CGPointMake(rowScrollView.contentOffset.x, p.y)]; 
     
    /*
    if (p.y<40) {
        rowDownBtn.hidden = NO;
        rowUpBtn.hidden = YES;
    }else if (p.y>180) {
        rowUpBtn.hidden = NO;
        rowDownBtn.hidden = YES;
    }else{
        rowUpBtn.hidden = NO;
        rowDownBtn.hidden = NO;
    }
    
    
    if (p.x<40) {
        colRightBtn.hidden = NO;
        colLeftBtn.hidden = YES;
    }else if (p.x>400) {
        colLeftBtn.hidden = NO;
        colRightBtn.hidden = YES;
    }else{
        colLeftBtn.hidden = NO;
        colRightBtn.hidden = NO;
    }
    */
}

#pragma mark -
#pragma mark UIPickerView Methods

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *retval = (id)view;
    
    
    switch (component) {        
        case 0:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
            retval.text = [@"" stringByAppendingFormat:@"%@",[arrShape objectAtIndex:row]];
            
            
            break;
        case 1:
            if (!retval) {
                retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
            }
            
            NSString *sizeFrom = [NSString stringWithFormat:@"%@", [arrSizeFrom objectAtIndex:row]];
            NSString *sizeTo = [NSString stringWithFormat:@"%@", [arrSizeTo objectAtIndex:row]];
            
            NSString *strSize = [NSString stringWithFormat:@"%@ - %@ Ct.", sizeFrom, sizeTo];

            
            retval.text = [@"" stringByAppendingFormat:@"%@",strSize];
            
            
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
    
    [Functions saveData:[NSNumber numberWithInt:row]  key:component == 0 ? shapeSelectedRowKey : sizeSelectedRowKey];
    
    switch (component) {
        case 0:
            [self setAllPrices];
            break;
        case 1:
            [self setAllPrices];
            break;
        default:            
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
            numRows = [arrSizeFrom count];
            break;           
        default:
            break;     
    }
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 55;
    
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 30;
    
    switch (component) {
        case 0:
            sectionWidth = 120;            
            break;
        case 1:
            sectionWidth = 170;            
            break;
        default:
            break;
    }  
    
    return sectionWidth;
}


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

-(void)alertPriceListFinished:(int)type{
    
}

/*-(void)callGetPriceListDate
{
    if ([Reachability reachableAndAlert] == NO) {
        return;
    }
    
    GetPriceListDateParser *dateParser = [[GetPriceListDateParser alloc] init];
    dateParser.delegate = self;
    [dateParser getDate:[myPickerView selectedRowInComponent:0] == 1];
}*/

/*-(void)PriceListDateResult:(NSString*)date isRound:(BOOL)isRound
{
    if(date != nil && date.length > 4)
    {
        date = [Functions dateFormat:date format:@"MM/dd/yyyy"];
        [self setTitle:date];
    }
}*/



-(void)getAvgBestpriceWith{     
}

-(void)webserviceCallPriceCalcFinished{
  /*  arrPriceCalc = [objPriceCalcParser getResults];
    
    if ([arrPriceCalc count]>0) {
        
        NSDictionary *temp = [arrPriceCalc objectAtIndex:0];
        
        bestPrice = [[temp objectForKey:@"BestPrice"]intValue];
        avgPrice = [[temp objectForKey:@"AvgPrice"]intValue];
        bestDiscount = [[temp objectForKey:@"BestDiscount"]floatValue];
        avgDiscount = [[temp objectForKey:@"AvgDiscount"]floatValue];
        diamondCount = [[temp objectForKey:@"BestAvgDiamondCount"]intValue];
        
        avgDiscount*=100;
        bestDiscount*=100;
        
        
        
    }*/
    
    [appDelegate stopActivityIndicator:self];
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
