//
//  MainDiamondSearchVC.m
//  Rapnet
//
//  Created by Itzik on 03/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "MainDiamondSearchVC.h"
#import "Database.h"
#import "MoreViewDetailC.h"
@interface MainDiamondSearchVC ()

@end

@implementation MainDiamondSearchVC
NSInteger mainViewHeightInit = 990;

bool isKeyBoardDown = YES;
bool isLoadingCity = NO;
bool shapeLoaded = NO;
bool colorLoaded = NO;
bool fancyColorLoaded = NO;
bool fancyColorIntensityLoaded = NO;
bool fancyColorOvertoneLoaded = NO;
bool clarityLoaded = NO;
bool cutLoaded = NO;
bool polishLoaded = NO;
bool symLoaded = NO;
bool fluorLoaded = NO;
bool labLoaded = NO;
bool countryLoaded = NO;

bool listsLoaded = NO;
bool mainViewLoaded = NO;
bool stopDismissTextFields = NO;
UITextField *lastTextField;

UIFont *buttonFont;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"RapNet", @"RapNet");
        self.tabBarItem.image = [UIImage imageNamed:@"rapnet1.png"];
        //[self.tabBarItem. addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    [AnalyticHelper sendView:@"Rapnet - Search"];
    IsDownloadViewVisible = NO;
    buttonFont = [UIFont boldSystemFontOfSize:15];
    return self;
}

-(void)initReachability
{
    countReach = 0;
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
                countReach ++;
                if(countReach == 2)
                    [Functions NoInternetAlert];
                
                break;
            }
                
            case ReachableViaWWAN:
            {
                isReachable = YES;
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }
                
                if(listsLoaded == NO)
                    [self loadLists];
                
                countReach ++;
                break;
            }
            case ReachableViaWiFi:
            {
                if(listsLoaded == NO)
                    [self loadLists];
                
                countReach ++;
                isReachable = YES;
                if ([Functions isLogedIn] == NO) {
                    [Functions loginAll];
                }

                break;
            }
        }
        
    }
    
    if (countReach == 2) {
        countReach = 0;
    }
    
    if (isReachable && viewLoaded == NO) {
        [self initScreen];
    }
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    [self sColorTypeClicked:sColorType];
    
    [self addMainScrollView];
    
    startRow = 0;
    endRow = 20;
    numIncrease = 20;
    svMain.delegate = self;
    vCity.hidden = YES;
    vPrice.frame = CGRectMake(0, 498, 320, vPrice.frame.size.height);
    btnCityClear.hidden = YES;
    [self resetButtonSelection:arrCityButtons];
    
    txtWeightFrom.delegate = self;
    txtWeightTo.delegate = self;
    txtPriceTypeFrom.delegate = self;
    txtPriceTypeTo.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self.view addSubview:vDownload];
    
   // IsDownloadViewVisible = YES;
    /*if ([Reachability reachableAndAlert] == NO) {
        return;
    }*/
    
    [self initReachability];
    [self showLogin];
}

-(bool)showLogin
{
    if (customAlert1) {
        [customAlert1.view removeFromSuperview];
        [customAlert1 release];
        customAlert1 = nil;
    }
    
    if ([Functions canView:L_Rapnet] == NO)
    {
        [StoredData sharedData].rapnetAlertFlag = TRUE;
        [self.view addSubview:[StoredData sharedData].blackScreen];
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
        [self.view addSubview:customAlert1.view];
        view = customAlert1.view;
        [self initialDelayEnded];
        return YES;
    }
    
    return NO;
}

-(void)initScreen
{
  //  if (viewLoaded) {
   //     return;
   // }
    
    
    if([self showLogin] == NO)
    {
        if(listsLoaded == NO)
        {
           // [self loadLists];
            //[vDownload removeFromSuperview];
            //IsDownloadViewVisible = NO;
            txtWeightFrom.text = @"";
            txtWeightTo.text = @"";
            txtPriceTypeFrom.text = @"";
            txtPriceTypeTo.text = @"";
        }
        else {
            [self hideLoadingScreen];
        }

    }
    
    viewLoaded = YES;
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    
       // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loginCompleted:(BOOL)res
{
    if (res == YES) {
       
        if(listsLoaded == NO)
        {
            [self loadLists];
        //[vDownload removeFromSuperview];
        //IsDownloadViewVisible = NO;
            txtWeightFrom.text = @"";
            txtWeightTo.text = @"";
            txtPriceTypeFrom.text = @"";
            txtPriceTypeTo.text = @"";
        }
        else {
            [self hideLoadingScreen];
        }
    }
}

-(IBAction)btnResetClicked:(id)sender
{
    [self closeKeyboard:lastTextField];
    
    txtPriceTypeFrom.text = @"";
    txtPriceTypeTo.text = @"";
    txtWeightFrom.text = @"";
    txtWeightTo.text = @"";
    
    [self resetButtonSelection:arrShapesButtons];
    [self resetButtonSelection:arrColorButtons];
    [self resetButtonSelection:arrFancyColorButtons];
    [self resetButtonSelection:arrFancyColorOvertoneButtons];
    [self resetButtonSelection:arrFancyColorIntensityButtons];
    [self resetButtonSelection:arrClaritiesButtons];
    [self resetButtonSelection:arrCutButtons];
    [self resetButtonSelection:arrPolishButtons];
    [self resetButtonSelection:arrSymButtons];
    [self resetButtonSelection:arrFluorButtons];
    [self resetButtonSelection:arrLabButtons];
    [self resetButtonSelection:arrCountryButtons];
    [self resetButtonSelection:arrCityButtons];
    
    vCity.hidden = YES;
    vPrice.frame = CGRectMake(0, 498, 320, vPrice.frame.size.height);
    
    btnCityClear.hidden = YES;
    btnClaritiesClear.hidden = YES;
    btnColorsClear.hidden = YES;
    btnCountryClear.hidden = YES;
    btnCountryClear.hidden = YES;
    btnCutClear.hidden = YES;
    btnFancyColorsIntensityClear.hidden = YES;
    btnFancyColorsOvertoneClear.hidden = YES;
    btnFluorClear.hidden = YES;
    btnLabClear.hidden = YES;
    btnPolishClear.hidden = YES;
    btnPolishClear.hidden = YES;
    btnShapesClear.hidden = YES;
    btnSymClear.hidden = YES;
    
}

-(IBAction)btnSearchClicked:(id)sender
{
    [self closeKeyboard:lastTextField];
    
    if (isReachable == NO) {
        [Functions NoInternetAlert];
        return;
    }
    
    /*if([Functions canView:L_Rapnet] == NO)
    {
        [self.view addSubview:[StoredData sharedData].blackScreen];
        [appDelegate stopActivityIndicator:self];
        
        if (customAlert1) {
            [customAlert1.view removeFromSuperview];
            [customAlert1 release];
            customAlert1 = nil;
        }
        
        [StoredData sharedData].rapnetAlertFlag = TRUE;
        
        customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
        [self.view addSubview:customAlert1.view];
        view = customAlert1.view;
        [self initialDelayEnded];
        return;
    }*/
    if([self showLogin])
        return;
    
    DiamondResultsVC *objDiamondResult = [[DiamondResultsVC alloc]initWithNibName:@"DiamondResultsVC" bundle:nil];
    //[self.navigationController pushViewController:objDiamondResult animated:YES];
 //   float h = 375.0;
  //  if(IsTallPhone())
 //       h = 555.0;
 //    [objDiamondResult changeTableHeight:h];
    [self.view addSubview:objDiamondResult.view];
    
    CGRect f = self.view.frame;
   // f.size.height = fixHeight;

    
    DiamondSearchParams *p = [[DiamondSearchParams alloc] init];
    
    p.firstRowNum = [NSString stringWithFormat:@"%d", startRow];
    p.toRowNum = [NSString stringWithFormat:@"%d", endRow];
    p.weightFrom = [Functions fixNumberFormat: txtWeightFrom.text];
    p.weightTo = [Functions fixNumberFormat:txtWeightTo.text];
    p.shapes = [self getSearchParamsList:arrShapes arrButtons:arrShapesButtons];
    if (sColorType.selectedSegmentIndex == ST_Regular)
    {
        p.searchType = @"REGULAR";
        p.colors = [self getSearchParamsList:arrColors arrButtons:arrColorButtons];
    }
    else
    {
        p.searchType = @"FANCY";
        p.fancyColors = [self getSearchParamsList:arrFancyColor arrButtons:arrFancyColorButtons];
        p.fancyOvertones = [self getSearchParamsList:arrFancyColorOvertone arrButtons:arrFancyColorOvertoneButtons];
        p.fancyIntensities = [self getSearchParamsList:arrFancyColorIntensity arrButtons:arrFancyColorIntensityButtons];
    }
    
    switch (sPriceType.selectedSegmentIndex) {
        case PS_Carat:
            p.caratPriceFrom = [Functions fixNumberFormat: txtPriceTypeFrom.text];
            p.caratPriceTo = [Functions fixNumberFormat: txtPriceTypeTo.text];
            break;
        case PS_RapPercent:
            p.discountFrom = [Functions fixNumberFormat: txtPriceTypeFrom.text];
            p.discountTo = [Functions fixNumberFormat: txtPriceTypeTo.text];
            break;
        case PS_Total:
            p.totalPriceFrom = [Functions fixNumberFormat: txtPriceTypeFrom.text];
            p.totalPriceTo = [Functions fixNumberFormat: txtPriceTypeTo.text];
            break;
        default:
            break;
    }
    p.clarities = [self getSearchParamsList:arrClarities arrButtons:arrClaritiesButtons];
    p.cuts  = [self getSearchParamsList:arrCut arrButtons:arrCutButtons];
    p.polishes  = [self getSearchParamsList:arrPolish arrButtons:arrPolishButtons];
    p.symmetries  = [self getSearchParamsList:arrSym arrButtons:arrSymButtons];
    p.fluorescenceIntensities = [self getSearchParamsList:arrFluor arrButtons:arrFluorButtons];
    p.labs = [self getSearchParamsList:arrLab arrButtons:arrLabButtons];
    p.countries = [self getSearchParamsList:arrCountry arrButtons:arrCountryButtons];
    p.cities= [self getSearchParamsList:arrCity arrButtons:arrCityButtons];
    [objDiamondResult search:p];
    [objDiamondResult release];
}

-(NSMutableArray*)getSearchParamsList:(NSMutableArray*)arrData arrButtons:(NSMutableArray*)arrButtons
{

    UIButton *btn;
    id selectedItem;
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrButtons.count; i++) {
        btn = [arrButtons objectAtIndex:i];
        if(btn.selected)
        {
            selectedItem = [arrData objectAtIndex:i];
            [selectedItems addObject:selectedItem];
            
        }
        
    }
    
    return selectedItems;

}

-(IBAction)btnColorsRightScrollClicked:(id)sender
{
    [self scrollRight:svColors scrollAmount:30];
}


-(IBAction)btnColorsLeftScrollClicked:(id)sender
{
    [self scrollLeft:svColors scrollAmount:30];
}

-(IBAction)btnClarityRightScrollClicked:(id)sender
{
    [self scrollRight:svClarities scrollAmount:30];
}

-(IBAction)btnClarityLeftScrollClicked:(id)sender
{
    [self scrollLeft:svClarities scrollAmount:30];
}

-(IBAction)btnCutRightScrollClicked:(id)sender
{
    [self scrollRight:svCut scrollAmount:30];
}
-(IBAction)btnCutLeftScrollClicked:(id)sender
{
    [self scrollLeft:svCut scrollAmount:30];
}

-(IBAction)btnShapeRightScrollClicked:(id)sender
{
    [self scrollRight:svShapes scrollAmount:30];
}

-(IBAction)btnShapeLeftScrollClicked:(id)sender
{
    [self scrollLeft:svShapes scrollAmount:30];
}

-(IBAction)btnFancyColorOvertoneRightScrollClicked:(id)sender
{
    [self scrollRight:svFancyColorOvertone scrollAmount:30];
}

-(IBAction)btnFancyColorOvertoneLeftScrollClicked:(id)sender
{
    [self scrollLeft:svFancyColorOvertone scrollAmount:30];
}

-(IBAction)btnFancyColorIntensityRightScrollClicked:(id)sender
{
    [self scrollRight:svFancyColorIntensity scrollAmount:30];
}

-(IBAction)btnFancyColorIntensityLeftScrollClicked:(id)sender
{
    [self scrollLeft:svFancyColorIntensity scrollAmount:30];
}

-(IBAction)btnPolishRightScrollClicked:(id)sender
{
    [self scrollRight:svPolish scrollAmount:30];
}

-(IBAction)btnPolishLeftScrollClicked:(id)sender
{
    [self scrollLeft:svPolish scrollAmount:30];
}

-(IBAction)btnSymRightScrollClicked:(id)sender
{
    [self scrollRight:svSym scrollAmount:30];
}

-(IBAction)btnSymLeftScrollClicked:(id)sender
{
    [self scrollLeft:svSym scrollAmount:30];
}

-(IBAction)btnFluorRightScrollClicked:(id)sender
{
    [self scrollRight:svFluor scrollAmount:30];
}

-(IBAction)btnFluorLeftScrollClicked:(id)sender
{
    [self scrollLeft:svFluor scrollAmount:30];
}

-(IBAction)btnCountryRightScrollClicked:(id)sender
{
    [self scrollRight:svCountry scrollAmount:30];
}

-(IBAction)btnCountryLeftScrollClicked:(id)sender
{
    [self scrollLeft:svCountry scrollAmount:30];
}

-(IBAction)btnCityRightScrollClicked:(id)sender
{
    [self scrollRight:svCity scrollAmount:30];
}

-(IBAction)btnCityLeftScrollClicked:(id)sender
{
    [self scrollLeft:svCity scrollAmount:30];
}

-(IBAction)btnLabRightScrollClicked:(id)sender
{
    [self scrollRight:svLab scrollAmount:30];
}

-(IBAction)btnLabLeftScrollClicked:(id)sender
{
    [self scrollLeft:svLab scrollAmount:30];
}

-(void)scrollRight:(UIScrollView*)sv scrollAmount:(NSInteger)scrollAmount
{
    //[self resignTextFields];
    [self closeKeyboard:lastTextField];
    CGPoint offset = [sv contentOffset];
    offset.x += scrollAmount;
    if (offset.x <= [sv contentSize].width) {
        [sv setContentOffset:offset animated:YES];
        
    }
}

-(void)scrollLeft:(UIScrollView*)sv scrollAmount:(NSInteger)scrollAmount
{
    //[self resignTextFields];
    [self closeKeyboard:lastTextField];
    CGPoint offset = [sv contentOffset];
    offset.x = offset.x -scrollAmount >= 0 ? offset.x - scrollAmount : 0;
    
    [sv setContentOffset:offset animated:YES];
}

-(void)scrolUp:(UIScrollView*)sv scrollAmount:(NSInteger)scrollAmount
{
    //[self resignTextFields];
    CGPoint offset = [sv contentOffset];
    offset.y += scrollAmount;
    if(offset.y <= [sv contentSize].height)
        [sv setContentOffset:offset animated:YES];
}

-(void)scrolDown:(UIScrollView*)sv scrollAmount:(NSInteger)scrollAmount
{
    //[self resignTextFields];
    CGPoint offset = [sv contentOffset];
    offset.y += scrollAmount;
    if(offset.y >= [sv contentSize].height)
        [sv setContentOffset:offset animated:YES];
}

-(bool)hasSelectedButton:(NSMutableArray*)arrButtons
{
    UIButton *btn;
    
    for (int i = 0; i < arrButtons.count ; i++) {
        btn = [arrButtons objectAtIndex:i];
        if ( btn.selected) {
            return YES;
        }
    }
    
    return NO;
}

-(IBAction)btnShapeClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrShapesButtons isRange:NO];
    btnShapesClear.hidden = [self hasSelectedButton:arrShapesButtons] == NO;
}

-(IBAction)btnShapesClearClicked:(id)sender
{
    [self resetButtonSelection:arrShapesButtons];
    
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnClarityClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrClaritiesButtons isRange:YES];
    btnClaritiesClear.hidden = [self hasSelectedButton:arrClaritiesButtons] == NO;
}

-(IBAction)btnClarityClearClicked:(id)sender
{
    [self resetButtonSelection:arrClaritiesButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnCutClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrCutButtons isRange:YES];
    btnCutClear.hidden = [self hasSelectedButton:arrCutButtons] == NO;
}

-(IBAction)btnCutClearClicked:(id)sender
{
    [self resetButtonSelection:arrCutButtons];
    UIButton *btn = sender;
    btn.hidden = YES;

}

-(IBAction)btnColorClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrColorButtons isRange:YES];
    
    //if (sColorType.selectedSegmentIndex == 0)
        btnColorsClear.hidden = [self hasSelectedButton:arrColorButtons] == NO;
    //else
        //btnColorsClear.hidden = [self hasSelectedButton:arrFancyColorButtons] == NO;
}

-(IBAction)btnColorClearClicked:(id)sender
{
    if (sColorType.selectedSegmentIndex == 0) 
        [self resetButtonSelection:arrColorButtons];
    else
        [self resetButtonSelection:arrFancyColorButtons];
    
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnFancyColorClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrFancyColorButtons isRange:NO];
    btnColorsClear.hidden = [self hasSelectedButton:arrFancyColorButtons] == NO;
}

-(IBAction)btnFancyColorClearClicked:(id)sender
{
    [self resetButtonSelection:arrFancyColorButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnFancyColorOvertoneClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrFancyColorOvertoneButtons isRange:YES];
    btnFancyColorsOvertoneClear.hidden = [self hasSelectedButton:arrFancyColorOvertoneButtons] == NO;
}

-(IBAction)btnFancyColorOvertoneClearClicked:(id)sender
{
    [self resetButtonSelection:arrFancyColorOvertoneButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnFancyColorIntensityClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrFancyColorIntensityButtons isRange:YES];
    btnFancyColorsIntensityClear.hidden = [self hasSelectedButton:arrFancyColorIntensityButtons] == NO;
}

-(IBAction)btnFancyColorIntensityClearClicked:(id)sender
{
    [self resetButtonSelection:arrFancyColorIntensityButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnPolishClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrPolishButtons isRange:YES];
    btnPolishClear.hidden = [self hasSelectedButton:arrPolishButtons] == NO;
}

-(IBAction)btnPolishClearClicked:(id)sender
{
    [self resetButtonSelection:arrPolishButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnSymClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrSymButtons isRange:YES];
     btnSymClear.hidden = [self hasSelectedButton:arrSymButtons] == NO;
}

-(IBAction)btnSymClearClicked:(id)sender
{
    [self resetButtonSelection:arrSymButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnFluorClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrFluorButtons isRange:NO];
     btnFluorClear.hidden = [self hasSelectedButton:arrFluorButtons] == NO;
}

-(IBAction)btnFlurClearClicked:(id)sender
{
    [self resetButtonSelection:arrFluorButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnCountryClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrCountryButtons isRange:NO];
    
     btnCountryClear.hidden = [self hasSelectedButton:arrCountryButtons] == NO;
    if(arrCity == nil)
        arrCity = [[NSMutableArray alloc] init];
    
    UIButton *btn = sender;
    int i = btn.tag;
    NSString * str = [[arrCountry objectAtIndex:i] objectForKey:kValueElementName];
    if (btn.selected) {
        [self addCities:[str intValue]];
    }
    else {
        [self removeCities:[str intValue]];
    }
    
    if (arrCity.count == 0) 
    {
        vCity.hidden = YES;
        //[self vAfterColor].frame = CGRectMake(0, 354, 320, 701);
        vPrice.frame = CGRectMake(0, 498, vPrice.frame.size.width, vPrice.frame.size.height);
        
        [arrCityButtons removeAllObjects];
        [arrCity removeAllObjects];
        [self addToMainViewContentSize:0 h:-85];
    } 
    else 
    {
        vPrice.frame = CGRectMake(0, 569, vPrice.frame.size.width, vPrice.frame.size.height);
        vCity.hidden = NO;
      
        
        [self addToMainViewContentSize:0 h:85];
    }
}

-(void)addCities:(NSInteger)countryID
{
    isLoadingCity = YES;
    
    NSMutableArray *cities = [LT_City get:countryID];
    
    if(cities.count == 0)
        return;
    
    if(arrCityButtons == nil)
        arrCityButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<cities.count; i++) {
        [arrCity addObject:[cities objectAtIndex:i]];
    }
    
    [self loadToScrollView:svCity arrButtons:arrCityButtons arrData:[LT_City get:countryID] action:@selector(btnCityClicked:)];
    isLoadingCity = NO;
}

-(void)removeCities:(NSInteger)countryID
{
    LT_City *c;
    NSInteger index;
    UIButton *b;
    NSMutableArray *remove = [[NSMutableArray alloc] init];
    
    for (UIView *subview in [svCity subviews])
    {
        b = (UIButton*)subview;
        index = subview.tag;
        index = b.tag;
        c = [arrCity objectAtIndex:index];
        if (c.countryID == countryID) {
            [remove addObject: c];
            [subview removeFromSuperview];
            //[arrCity removeObject:c];
            [arrCityButtons removeObject:b];
        }
    }
    
    for (int j = 0; j<remove.count; j++) {
        [arrCity removeObject:[remove objectAtIndex:j]];
    }
    
    if(arrCityButtons.count == 0)
        return;
    
    b = [arrCityButtons objectAtIndex:0];
    
    CGFloat y = 3;
    CGFloat x = 3;
    CGFloat space = 3;
    CGFloat height = b.frame.size.height;
    CGFloat width = b.frame.size.width;
    CGFloat maxWidth;
    CGFloat maxHeight = height + space + space;
    
    for (int i=0; i< arrCityButtons.count; i++)
    {
        b = [arrCityButtons objectAtIndex:i];
        b.frame = CGRectMake(x, y, width, height);
        b.tag = i;
        x += width + space;
        maxWidth = x;
    }
    
    svCity.contentSize = CGSizeMake(maxWidth, maxHeight);
    

}

-(IBAction)btnCountryClearClicked:(id)sender
{
    [self resetButtonSelection:arrCountryButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
    
    btnCityClear.hidden = YES;
    [arrCityButtons removeAllObjects];
    [arrCity removeAllObjects];
    
    vCity.hidden = YES;
    //[self vAfterColor].frame = CGRectMake(0, 354, 320, 701);
    vPrice.frame = CGRectMake(0, 498, vPrice.frame.size.width, vPrice.frame.size.height);
}

-(IBAction)btnCityClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrCityButtons isRange:NO];
    btnCityClear.hidden = [self hasSelectedButton:arrCityButtons] == NO;
}

-(IBAction)btnCityClearClicked:(id)sender
{
    [self resetButtonSelection:arrCityButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)btnLabClicked:(id)sender
{
    [self setSelection:sender arrButtons:arrLabButtons isRange:NO];
     btnLabClear.hidden = [self hasSelectedButton:arrLabButtons] == NO;
}

-(IBAction)btnLabClearClicked:(id)sender
{
    [self resetButtonSelection:arrLabButtons];
    UIButton *btn = sender;
    btn.hidden = YES;
}

-(IBAction)sColorTypeClicked:(id)sender
{
    //[self resignTextFields];
    [self closeKeyboard:lastTextField];
    if (sColorType.selectedSegmentIndex == 0) 
    {
        vFancy.hidden = YES;
        //[self vAfterColor].frame = CGRectMake(0, 354, 320, 701);326
        vAfterColor.frame = CGRectMake(0, 310, vAfterColor.frame.size.width, vAfterColor.frame.size.height);
        
        [self resetButtonSelection:arrFancyColorButtons];
        [self resetButtonSelection:arrFancyColorOvertoneButtons];
        [self resetButtonSelection:arrFancyColorIntensityButtons];
        
        [self loadColor:arrColors];
        [self addToMainViewContentSize:0 h:- (vFancy.frame.size.height + 20)];
    } 
    else 
    {
        [self resetButtonSelection:arrColorButtons];
        vAfterColor.frame = CGRectMake(0, 456, vAfterColor.frame.size.width, vAfterColor.frame.size.height);
        vFancy.hidden = NO;
        [self loadFancyColor:arrFancyColor];
        [self addToMainViewContentSize:0 h:vFancy.frame.size.height + 20];
    }
}

-(void)resetButtonSelection:(NSMutableArray*)arrButtons
{
    //[self resignTextFields];
    [self closeKeyboard:lastTextField];
    UIButton *btn;
    
    for (int i=0; i<arrButtons.count; i++) {
        btn = [arrButtons objectAtIndex:i];
        btn.selected = NO;
    }
}

-(void)priceListDownloadFinished:(NSInteger)type{
    [priceDownloader.view removeFromSuperview];		
	[priceDownloader release]; 
    
    if (type==1) {
        [[StoredData sharedData].blackScreen removeFromSuperview];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        
        NSString *date = [NSString stringWithFormat:@"%d-%d-%d",[components month],[components day],[components year]];    
        NSString *ctime = [NSString stringWithFormat:@"%d:%d:%d",[components hour],[components minute],[components second]];
        
        
        NSString *time = [NSString stringWithFormat:@"%@ %@",date,ctime];
        
        [Database updateCheckerTable:[Database getDBPath] arg2:time updateFlag:@"YES"];
        //[self loadAllDataFromDatabase];
        
    }else{
        /* if (customAlert1) {
         [customAlert1.view removeFromSuperview];
         [customAlert1 release];
         customAlert1 = nil;
         }
         
         // NSLog(@"price not ");
         
         [StoredData sharedData].priceAlertFlag = TRUE;
         
         customAlert1=[[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];          
         [self.view addSubview:customAlert1.view];        
         view = customAlert1.view;
         [self initialDelayEnded];*/
    }
    
    
}

-(UIButton*) getButton:(NSString*)title action:(SEL)action x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height 
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [btn.titleLabel setFont:buttonFont];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedButton.png"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"unselectedButton.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(x, y, width, height);
    
    return btn;
}

-(void)showLoadingScreen
{
    // [self.view addSubview:vDownload];
    [self.view.window addSubview:vDownload];
    //[self.view addSubview:[StoredData sharedData].blackScreen];
    IsDownloadViewVisible = YES;
}


-(void)hideLoadingScreen
{
    if((shapeLoaded && colorLoaded && fancyColorLoaded && fancyColorIntensityLoaded && fancyColorOvertoneLoaded && clarityLoaded && cutLoaded && polishLoaded && symLoaded && fluorLoaded && labLoaded && countryLoaded) || listsLoaded)
    {
        [vDownload removeFromSuperview];
        //[[StoredData sharedData].blackScreen removeFromSuperview];
        IsDownloadViewVisible = NO;
        //[self addMainScrollView];
        listsLoaded = YES;
    }
    
    
}

-(void)loadLists
{
    
    
    NSMutableArray *shpaes = [LT_Shape get];
    if (shpaes.count == 0) 
    {
       
        [self showLoadingScreen];
        
        
        ShapeParser *parser = [[ShapeParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
       
    }
    else 
    {
        [self loadShapes:shpaes];
        
    }
    
    NSMutableArray *clarity = [LT_Clarity get];
    if (clarity.count == 0) 
    {
        if(IsDownloadViewVisible == NO)
        {
            [self showLoadingScreen];
        }
        
        ClarityParser *parser = [[ClarityParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
    }
    else 
    {
        [self loadClarity:clarity];
    }
    
    NSMutableArray *cut = [LT_Cut get];
    if (cut.count == 0)
    {
        if(IsDownloadViewVisible == NO)
        {
            [self showLoadingScreen];
        }
     
        CutParser *parser = [[CutParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
     }
     else 
     {
         [self loadCut:cut];
        cutLoaded = YES;
     }
     
     NSMutableArray *color = [LT_Color get];
     if (color.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         ColorParser *parser = [[ColorParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
     }
     else 
     {
         [self loadColor:color];
      
     }

    NSMutableArray *fancyColor = [LT_FancyColor get];
    if (fancyColor.count == 0) 
    {
        if(IsDownloadViewVisible == NO)
        {
            [self showLoadingScreen];
        }
        
        FancyColorParser *parser = [[FancyColorParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
    }
    else 
    {
        [self loadFancyColor:fancyColor];
     
    }
    
    NSMutableArray *fancyColorOvertone = [LT_FancyColorOvertone get];
    if (fancyColorOvertone.count == 0) 
    {
        if(IsDownloadViewVisible == NO)
        {
            [self showLoadingScreen];
        }
        
        FancyColorOvertoneParser *parser = [[FancyColorOvertoneParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
    }
    else 
    {
        [self loadFancyColorOvertone:fancyColorOvertone];
     
    }
    
    NSMutableArray *fancyColorIntensity = [LT_FancyColorIntensity get];
    if (fancyColorIntensity.count == 0) 
    {
        if(IsDownloadViewVisible == NO)
        {
            [self showLoadingScreen];
        }
        
        FancyColorIntesityParser *parser = [[FancyColorIntesityParser alloc] init];
        parser.delegate = self;
        [parser startDownload];
    }
    else 
    {
        [self loadFancyColorIntensity:fancyColorIntensity];
    
    }
    
     NSMutableArray *polish = [LT_Polish get];
     if (polish.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         PolishParser *parser = [[PolishParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
     }
     else 
     {
         [self loadPolish:polish];
       
     }
     
     NSMutableArray *sym = [LT_Sym get];
     if (sym.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         SymParser *parser = [[SymParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
     }
     else 
     {
         [self loadSym:sym];
     }
     
     NSMutableArray *fluor = [LT_Fluor get];
     if (fluor.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         FluorParser *parser = [[FluorParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
     }
     else 
     {
         [self loadFluor:fluor];
    }
     
     NSMutableArray *country = [LT_Country get];
     if (country.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         CountryParser *parser = [[CountryParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
     }
     else 
     {
         [self loadCountry:country];
     }
     
     NSMutableArray *lab = [LT_Lab get];
     if (lab.count == 0) 
     {
         if(IsDownloadViewVisible == NO)
         {
             [self showLoadingScreen];
         }
     
         LabParser *parser = [[LabParser alloc] init];
         parser.delegate = self;
         [parser startDownload];
    }
    else 
    {
        [self loadLab:lab];
      
        labLoaded = YES;
    }
    
    [self hideLoadingScreen];
}

-(void)loadShapes:(NSMutableArray*)arrData
{
    btnShapesClear.hidden = YES;
    arrShapes = arrData;
    arrShapesButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];    
    [self loadToScrollView:svShapes arrButtons:arrShapesButtons arrData:arrData action:@selector(btnShapeClicked:) numRows:2];
     shapeLoaded = YES;
}

-(void)loadClarity:(NSMutableArray*)arrData
{
    btnClaritiesClear.hidden = YES;
    arrClarities = arrData;
    arrClaritiesButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svClarities arrButtons:arrClaritiesButtons arrData:arrData action:@selector(btnClarityClicked:)];
    
    [self scrollRight:svClarities scrollAmount:43];
    clarityLoaded = YES;
    NSLog(@"clarity = %d ", svClarities.subviews.count);
}

-(void)loadCut:(NSMutableArray*)arrData
{
    btnCutClear.hidden = YES;
    arrCut = arrData;
    arrCutButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svCut arrButtons:arrCutButtons arrData:arrData action:@selector(btnCutClicked:)];
    cutLoaded = YES;
    
    NSLog(@"cut = %d ", svCut.subviews.count);
}

-(void)loadColor:(NSMutableArray*)arrData
{
    btnColorsClear.hidden = YES;
    arrColors = arrData;
    arrColorButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    if (sColorType.selectedSegmentIndex == 0) 
        [self loadToScrollView:svColors arrButtons:arrColorButtons arrData:arrData action:@selector(btnColorClicked:)];
    colorLoaded = YES;
    
    NSLog(@"color = %d ", svColors.subviews.count);
}

-(void)loadFancyColor:(NSMutableArray*)arrData
{
    btnColorsClear.hidden = YES;
    arrFancyColor = arrData;
    arrFancyColorButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    if (sColorType.selectedSegmentIndex == 1) 
        [self loadToScrollView:svColors arrButtons:arrFancyColorButtons arrData:arrData action:@selector(btnFancyColorClicked:)];
    fancyColorLoaded = YES;
}

-(void)loadFancyColorOvertone:(NSMutableArray*)arrData
{
    btnFancyColorsOvertoneClear.hidden = YES;
    arrFancyColorOvertone = arrData;
    arrFancyColorOvertoneButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svFancyColorOvertone arrButtons:arrFancyColorOvertoneButtons arrData:arrData action:@selector(btnFancyColorOvertoneClicked:)];
    fancyColorOvertoneLoaded = YES;
}

-(void)loadFancyColorIntensity:(NSMutableArray*)arrData
{
    btnFancyColorsIntensityClear.hidden = YES;
    arrFancyColorIntensity = arrData;
    arrFancyColorIntensityButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svFancyColorIntensity arrButtons:arrFancyColorIntensityButtons arrData:arrData action:@selector(btnFancyColorIntensityClicked:)];
    
    fancyColorIntensityLoaded = YES;
}

-(void)loadPolish:(NSMutableArray*)arrData
{
    btnPolishClear.hidden = YES;
    arrPolish = arrData;
    arrPolishButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    
    [self loadToScrollView:svPolish arrButtons:arrPolishButtons arrData:arrData action:@selector(btnPolishClicked:)];
    
    polishLoaded = YES;
}

-(void)loadSym:(NSMutableArray*)arrData
{
    btnSymClear.hidden = YES;
    arrSym = arrData;
    arrSymButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svSym arrButtons:arrSymButtons arrData:arrData action:@selector(btnSymClicked:)];
    
    symLoaded = YES;
}

-(void)loadFluor:(NSMutableArray*)arrData
{
    btnFluorClear.hidden = YES;
    arrFluor = arrData;
    arrFluorButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svFluor arrButtons:arrFluorButtons arrData:arrData action:@selector(btnFluorClicked:)];
    
    fluorLoaded = YES;
}

-(void)loadCountry:(NSMutableArray*)arrData
{
    btnCountryClear.hidden = YES;
    arrCountry = arrData;
    arrCountryButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svCountry arrButtons:arrCountryButtons arrData:arrData action:@selector(btnCountryClicked:)];
    
    countryLoaded = YES;
}

-(void)loadLab:(NSMutableArray*)arrData
{
    btnLabClear.hidden = YES;
    arrLab = arrData;
    arrLabButtons = [[NSMutableArray alloc] initWithCapacity:arrData.count];
    
    [self loadToScrollView:svLab arrButtons:arrLabButtons arrData:arrData action:@selector(btnLabClicked:)];
    
    labLoaded = YES;
}

-(void) loadToScrollView:(UIScrollView*)sv arrButtons:(NSMutableArray*)arrButtons arrData:(NSMutableArray*)arrData action:(SEL)action
{
    [self loadToScrollView:sv arrButtons:arrButtons arrData:arrData action:action numRows:1];
}

-(void) loadToScrollView:(UIScrollView*)sv arrButtons:(NSMutableArray*)arrButtons arrData:(NSMutableArray*)arrData action:(SEL)action numRows:(NSInteger)numRows 
{
    CGFloat space = 1;
    CGFloat height = 39;  
    CGFloat x = space;
    CGFloat y = space;
    CGFloat width = 39;
    CGFloat maxWidth = width;
    CGFloat maxHeight = (height * numRows) + (space * (numRows + 1));
    CGFloat buttonMaxWidth = 0;
    UIButton *btn;
    NSString *str;
    NSInteger modRes = 0;
    LT_City *c;
    CGSize s;
    int curTag = 0;
    if(isLoadingCity == NO)
        [sv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    else {
         curTag = arrCityButtons.count;
        if(curTag > 0)
            x = sv.contentSize.width;
       
    }
    
    
    for (int i=0; i<arrData.count; i++) {
        if(isLoadingCity)
        {
            c = [arrData objectAtIndex:i];
            str = c.desc;
        }
        else
            str = [[arrData objectAtIndex:i] objectForKey:kDescriptionElementName];
        s = [str sizeWithFont:buttonFont];
        if(s.width > buttonMaxWidth)
            buttonMaxWidth = s.width;
        
    }
    
    if(buttonMaxWidth > width)
        width = buttonMaxWidth;
    
    
    for (int i=0; i< arrData.count; i++)
    {
        if(isLoadingCity)
        {
            c = [arrData objectAtIndex:i];
            str = c.desc;
        }
        else
            str = [[arrData objectAtIndex:i] objectForKey:kDescriptionElementName];
        
        if (numRows > 1) 
        {
            modRes  = i % numRows;
            y = modRes == 0 ? space : height + (space * numRows);
        }
        
        
        btn = [self getButton:str action:action x:x y:y width:width height:height];
        
        if (numRows == 1 || modRes != 0) {
              x+= width + space;
        }
          
        maxWidth = x;
        
        
        
        [arrButtons insertObject:btn atIndex:i];
        btn.tag = curTag;
        curTag ++;
        [sv addSubview:btn];
    }
    
    if(numRows > 1 && modRes == 0)
        maxWidth += width + space;
        
    sv.frame = CGRectMake(20, 0, 280, maxHeight);
    sv.contentSize = CGSizeMake(maxWidth, maxHeight);
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setShowsVerticalScrollIndicator:NO];
}

-(void) setSelection:(UIButton*)sender arrButtons:(NSMutableArray*)arrButtons isRange:(bool)isRange
{
   // [self resignTextFields];
    [self closeKeyboard:lastTextField];
    UIButton *btn = sender;
    UIButton *curButton = [arrButtons objectAtIndex:btn.tag];
    NSInteger curButtonIndex = btn.tag;
    NSInteger startIndex = -1;
    NSInteger endIndex = -1;
    
    btn.selected = !btn.selected;
    if(isRange == NO)
        return;
    
    bool FoundStartIndex = NO;
    
    for (int i = 0; i < arrButtons.count; i++) 
    {
        btn = [arrButtons objectAtIndex:i];
        if(curButton.selected)
        {
            if(btn.selected)
            {
                if (i < curButtonIndex)
                {
                    startIndex = i;
                    i = curButtonIndex - 1;
                    FoundStartIndex = YES;
                }
                else if(FoundStartIndex == NO)
                {
                    startIndex = i;
                    FoundStartIndex = YES;
                }
                else
                {
                    endIndex = i;
                }
            }
        }
        else
        {
            if(btn.selected)
            {
                if(i < curButtonIndex)
                {
                    startIndex = i;
                    endIndex = curButtonIndex - 1;
                    break;
                }
                else
                {
                    return;
                }
            }
        }
    }
    
    if(endIndex < startIndex)
        endIndex = startIndex;
    
    
    for (int i = 0; i < arrButtons.count; i++) 
    {
        btn = [arrButtons objectAtIndex:i];
        btn.selected = (i >= startIndex && i<=endIndex);
    }
    
    
    

}



-(void)addMainScrollView
{
    if (mainViewLoaded == NO) {
        svMain.frame = CGRectMake(0, 41, 320, 504);
        svMain.contentSize = CGSizeMake(320, mainViewHeightInit);
        //[self addToMainViewContentSize:0 h:85];
        [self.view addSubview:svMain];
        mainViewLoaded = YES;
    }
    
}

-(void)DownloadFinished:(LT_Tables)type result:(NSMutableArray*)result
{
    if (type == LT_TableShape) 
    {
        [LT_Shape addToDatabase:result];
        [self loadShapes:[LT_Shape get]];
    //    shapeLoaded = YES;
    }
    else if (type == LT_TableClarity) 
    {
        [LT_Clarity addToDatabase:result];
        [self loadClarity:[LT_Clarity get]];
      //  clarityLoaded = YES;
    }
    else if (type == LT_TableCut) 
    {
        [LT_Cut addToDatabase:result];
        [self loadCut:[LT_Cut get]];
      //  cutLoaded = YES;
     }
     else if (type == LT_TableColor) 
     {
         [LT_Color addToDatabase:result];
         [self loadColor:[LT_Color get]];
       //  colorLoaded = YES;
     }
     else if (type == LT_TableFancyColor) 
     {
         [LT_FancyColor addToDatabase:result];
         [self loadFancyColor:[LT_FancyColor get]];
      //   fancyColorLoaded = YES;
     }
     else if (type == LT_TableFancyColorOvertones) 
     {
         [LT_FancyColorOvertone addToDatabase:result];
         [self loadFancyColorOvertone:[LT_FancyColorOvertone get]];
       //  fancyColorOvertoneLoaded = YES;
     }
     else if (type == LT_TableFancyColorIntensities) 
     {
         [LT_FancyColorIntensity addToDatabase:result];
         [self loadFancyColorIntensity:[LT_FancyColorIntensity get]];
      //   fancyColorIntensityLoaded = YES;
     }
     else if (type == LT_TablePolish) 
     {
         [LT_Polish addToDatabase:result];
         [self loadPolish:[LT_Polish get]];
       //  polishLoaded = YES;
     }
     else if (type == LT_TableSym) 
     {
         [LT_Sym addToDatabase:result];
         [self loadSym:[LT_Sym get]];
      //   symLoaded = YES;
     }
     else if (type == LT_TableFluor) 
     {
         [LT_Fluor addToDatabase:result];
         [self loadFluor:[LT_Fluor get]];
       //  fluorLoaded = YES;
     }
     else if (type == LT_TableCountry) 
     {
         [LT_Country addToDatabase:result];
         [self loadCountry:[LT_Country get]];
      //   countryLoaded = YES;
     }
     else if (type == LT_TableLab) 
     {
         [LT_Lab addToDatabase:result];
         [self loadLab:[LT_Lab get]];
      //   labLoaded = YES;
     }
    
    
    [self hideLoadingScreen];
    ///webCallEndFlag[1] = TRUE;
}


/*-(BOOL)txtShouldReturn:(UITextField*)txt
{
    [txt resignFirstResponder];
    return NO;
}*/

-(void)resignTextFields
{
    [txtWeightFrom resignFirstResponder];
    [txtWeightTo resignFirstResponder];
    [txtPriceTypeFrom resignFirstResponder];
    [txtPriceTypeTo resignFirstResponder];
    
    //isKeyBoardDown = YES;
}
-(IBAction)dismissKeyboard:(id)sender
{
    [self resignTextFields];
}

-(void)closeKeyboard:(UITextField *)textField
{
    
    if (textField == nil) {
        //isKeyBoardDown = YES;
        return;
    }
    
    [textField resignFirstResponder];
	//svMain.frame = CGRectMake(0, 40, 320, 416);
    //svMain.contentSize = CGSizeMake(320, 1134);
	
	
	if(textField.tag == 1 || textField.tag == 2)
	{
		//loginScroll.contentSize = CGSizeMake(0,540);
        lastTextField = nil;
        [self addToMainViewContentSize:0 h:-50];
        //[self scrolDown:svMain scrollAmount:180];
		//[self setViewMovedUp:NO coordinateY:0];
		
	}
    else if(textField.tag == 3 || textField.tag == 4)
    {
        lastTextField = nil;
        [self addToMainViewContentSize:0 h:-250];
    }
    isKeyBoardDown = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeKeyboard:textField];
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //[self resignTextFields];
   /// [self closeKeyboard:textField];
    return YES;
}

#pragma mark textFieldDidBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastTextField = textField;
	//textField.keyboardType = UIKeyboardTypeDecimalPad;
   // stopDismissTextFields = YES;
	if(textField.tag == 1 || textField.tag == 2)
	{
		if(isKeyBoardDown)
		{
			//svMain.contentSize = CGSizeMake(0,700);
            //[self addToMainViewContentSize:0 h:-300];
            [self addToMainViewContentSize:0 h:50];
			//[self setViewMovedUp:YES coordinateY:50];
            isKeyBoardDown = NO;
		}
        //else
       //     stopDismissTextFields = NO;
	}
    else if(textField.tag == 3 || textField.tag == 4)
	{
		if(isKeyBoardDown)
		{
            stopDismissTextFields = YES;
			//svMain.contentSize = CGSizeMake(0,1500);
            [self addToMainViewContentSize:0 h:250];
            [self scrolUp:svMain scrollAmount:180];
            isKeyBoardDown = NO;
			//[self setViewMovedUp:YES coordinateY:180];
		}
        //else
       //     stopDismissTextFields = NO;
	}
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    stopDismissTextFields = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    if (stopDismissTextFields == NO) {
        [self closeKeyboard:lastTextField];
    }
    
    // [self resignTextFields];
    /*sizeTF.borderStyle = UITextBorderStyleRoundedRect;
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
     }*/
    
}

/*-(void)setViewMovedUp:(BOOL)movedUp coordinateY:(NSInteger)coordinateY
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
	CGRect rect = svMain.frame;
	
	if(movedUp)
	{
		isKeyBoardDown = NO;
		
		rect.origin.y -= coordinateY;
		//rect.size.height += coordinateY;
	}
	
	else
	{
		isKeyBoardDown = YES;
		rect.origin.y += coordinateY;
		//rect.size.height -= coordinateY;
	}
	
	svMain.frame = rect;
	
	[UIView commitAnimations];
}
*/
-(void)addToMainViewContentSize:(NSInteger)w h:(NSInteger)h
{
    w += svMain.contentSize.width;
    h += svMain.contentSize.height;
    
    svMain.contentSize = CGSizeMake(w, h);
}


- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /*  allow only these characters in the textField  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789,."];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            return NO;
        }
    }
    
    if (theTextField.text.length == 1 && [theTextField.text isEqualToString:[Functions getFractionSeparator]]) {
        theTextField.text = [NSString stringWithFormat:@"0%@", [Functions getFractionSeparator]];
    }
    
    return YES;
    //return (newLength > 28) ? NO : YES;
}
@end
