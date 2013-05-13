//
//  RaportPriceChange.m
//  RapnetPriceModule
//
//  Created by Deepak Pathak on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaportPriceChange.h"


@implementation RaportPriceChange

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isReachable = NO;
        // Custom initialization
    }
    [AnalyticHelper sendView:@"Price - RapaportPriceChanges"];
    
    return self;
}

- (void)dealloc
{
    for (NSInteger i =0; i<2; i++) {
        [arrPriceChange[i] release];
    }
    
    [roundShapeTableView release];
    [pearShapeTableView release];
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
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:toolBar];
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y-36, toolBar.frame.size.width, toolBar.frame.size.height);
    toolBar.userInteractionEnabled = NO;
    
    [self loadDataInTable];
    
    
    
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self initReachability];
    //Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
	//NetworkStatus internetStatus = [reach currentReachabilityStatus];
	
/*	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
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
	}else{
        
        //if ([[StoredData sharedData].strPriceTicket length]==0)
       /* if([Functions canView:L_Prices] == NO)
        {
            
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
            [appDelegate showActivityIndicator:self];         
            
            roundShapeBtn.enabled = NO;
            pearShapeBtn.enabled = NO;
            
            shapeTypeFlag = 1;
            
            objPriceChangeParser=[[GetPriceChangeParser alloc]init];
            objPriceChangeParser.delegate = self;
            [objPriceChangeParser GetPriceChange:[Functions getTicket:L_Prices] withPriceType:@"ROUND"];
            //[objPriceChangeParser GetPriceChange:[StoredData sharedData].strPriceTicket withPriceType:@"ROUND"];
        }
        
        
        
        
    }*/
    
    
}

-(void)initScreen
{
    if([Functions canView:L_Prices] == NO)
    {
        
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
        [appDelegate showActivityIndicator:self];
        
        roundShapeBtn.enabled = NO;
        pearShapeBtn.enabled = NO;
        
        shapeTypeFlag = 1;
        
        objPriceChangeParser=[[GetPriceChangeParser alloc]init];
        objPriceChangeParser.delegate = self;
        [objPriceChangeParser GetPriceChange:[Functions getTicket:L_Prices] withPriceType:@"ROUND"];
        //[objPriceChangeParser GetPriceChange:[StoredData sharedData].strPriceTicket withPriceType:@"ROUND"];
    }

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


-(IBAction)roundShapeBtnClicked:(id)sender{
    roundShapeTableView.hidden=NO;
    pearShapeTableView.hidden=YES;
    roundShapeBtn.backgroundColor=[UIColor colorWithWhite:0.4 alpha:1.0];
    pearShapeBtn.backgroundColor=[UIColor clearColor];
    
    if (roundShapeTableView.hidden==NO) {
        dateFromLbl.text = roundFromDate;
        dateToLbl.text = roundToDate;
        NSInteger count = [arrPriceChange[0] count];
        infoLbl.text = [NSString stringWithFormat:@" %d Round Price Changes from %@ to %@ (Price in US$/Ct)",count,roundFromDate,roundToDate];
    }
}

-(IBAction)pearShapeBtnClicked:(id)sender{
    roundShapeTableView.hidden=YES;
    pearShapeTableView.hidden=NO;
    pearShapeBtn.backgroundColor=[UIColor colorWithWhite:0.4 alpha:1.0];
    roundShapeBtn.backgroundColor=[UIColor clearColor];
    
    if (pearShapeTableView.hidden==NO) {
        dateFromLbl.text = pearFromDate;
        dateToLbl.text = pearToDate;
        
        NSInteger count = [arrPriceChange[1] count];
        infoLbl.text = [NSString stringWithFormat:@" %d PEAR Price Changes from %@ to %@ (Price in US$/Ct)",count,pearFromDate,pearToDate];
    }
}

-(void)loadDataInTable{
    
    CGFloat height = 320;
    
    roundShapeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, height) style:UITableViewStylePlain];    
    [roundShapeTableView setAutoresizesSubviews:YES];    
    [roundShapeTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];     
    [roundShapeTableView setDelegate:self];  
    [roundShapeTableView setDataSource:self];
    roundShapeTableView.showsVerticalScrollIndicator = NO;
    [[self view] addSubview:roundShapeTableView];
    
    
    
    pearShapeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, height) style:UITableViewStylePlain];    
    [pearShapeTableView setAutoresizesSubviews:YES];    
    [pearShapeTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];     
    [pearShapeTableView setDelegate:self];  
    [pearShapeTableView setDataSource:self];
    pearShapeTableView.showsVerticalScrollIndicator = NO;
    [[self view] addSubview:pearShapeTableView];
    
    roundShapeTableView.hidden=NO;
    pearShapeTableView.hidden=YES;
    
    roundShapeBtn.backgroundColor=[UIColor colorWithWhite:0.4 alpha:1.0];
    pearShapeBtn.backgroundColor=[UIColor clearColor];
    
    /*
    NSInteger dayOfWeek = [Functions getDayOfWeek:[NSDate date]];
    NSDate *t = [Functions addToDate:[NSDate date] year:0 month:0 day:-(dayOfWeek + 1)];
    NSDate *from = [Functions addToDate:t year:0 month:0 day:-7];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"MMM dd, yyyy"];
    
    fromDate = [[df stringFromDate:from] copy];
    toDate = [[df stringFromDate:t] copy];
    */
    
    GetPriceListChangeDate *changeDate = [Functions getPriceListChangeDate];
    
    roundFromDate = [[Functions dateFormatFromDate:[changeDate getRoundFromDate] format:@"MMM dd, yyyy"] copy];
    roundToDate = [[Functions dateFormatFromDate:[changeDate getRoundToDate] format:@"MMM dd, yyyy"] copy];
    
    pearFromDate = [[Functions dateFormatFromDate:[changeDate getPearFromDate] format:@"MMM dd, yyyy"] copy];
    pearToDate = [[Functions dateFormatFromDate:[changeDate getPearToDate] format:@"MMM dd, yyyy"] copy];
    //fromDate = [Functions dateFormatFromDate[changeDate getRoundFromDate] format: @"MMM dd, yyyy"];
    //toDate = [Functions dateFormatFromDate[changeDate getRoundToDate] format: @"MMM dd, yyyy"];
    
    //NSDate *from = [Functions getDate:fromDate format:@""];
    
    dateFromLbl.text = [roundFromDate copy];
    dateToLbl.text = [roundToDate copy];

    
   /* infoLbl.text = @"";
    fromDate = @"Dec 07, 2012";
    toDate  = @"Dec 14, 2012";
    
    dateFromLbl.text = [fromDate copy];
    dateToLbl.text = [toDate copy];
    */
    
    
    
        // weekday 1 = Sunday for Gregorian calendar
    
    
   //
    
    
 //   NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:t];
    
    
    //toDate = [NSString stringWithFormat:@"%0.2d/%0.2d/%0.2d",[components month],[components day],[components year]];
    
    //NSDate *today = [[NSDate alloc] init];
  /*  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:0]; // note that I'm setting it to -1
    [offsetComponents setDay:-7];
    [offsetComponents setYear:0];    
    
    NSDate *from = [gregorian dateByAddingComponents:offsetComponents toDate:t options:0];
    */
    
    
    
   // components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:from];
    
  //  fromDate = [NSString stringWithFormat:@"%0.2d/%0.2d/%0.2d",[components month],[components day],[components year]];
    
        
    
  /*  [gregorian release];
    [offsetComponents release];
    [t release];*/
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    /*[StoredData sharedData].calcFromWAFlag = TRUE;
     [StoredData sharedData].WAEditRowIndex = indexPath.row;
     [self.navigationController popViewControllerAnimated:NO];*/
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"cell");
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // NSLog(@"Row height");
 return 20;
 }
 */

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"begin editing");
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    //  NSLog(@"end editing");
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

/*
 -(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
 return UITableViewCellAccessoryDetailDisclosureButton;    
 }
 */

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    if (tableView==roundShapeTableView) {
        return [arrPriceChange[0] count];
    }else{
        return [arrPriceChange[1] count];
    }
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    
    // Configure the cell...
    
    NSDictionary *dic; 
    int index = indexPath.row;
    
    if (tableView==roundShapeTableView) {
        
        dic = [arrPriceChange[0] objectAtIndex:index];
    }else{
        
        dic = [arrPriceChange[1] objectAtIndex:index];
    }
    
    
    
    UILabel *lbl;
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, 50, 37)]; // 0
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%@-%@", [dic objectForKey:@"LowSize"],[dic objectForKey:@"HighSize"]];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;  
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(51, 10, 24, 37)]; // 0
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Color"]];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(76, 10, 40, 37)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Clarity"]];
    
    [cell.contentView addSubview:lbl];  
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(117, 10, 57, 37)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"OldPrice"]intValue]];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(177, 10, 57, 37)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"NewPrice"]intValue]];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(237, 10, 46, 37)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"ChangeDollar"]intValue]];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(286, 10, 30, 37)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    float change = [[dic objectForKey:@"ChangePercent"]floatValue]*100;
    //lbl.text = [NSString stringWithFormat:@"%0.2f",change];
    lbl.text = [Functions getFractionDisplay:change format:@"%0.2f"];
    
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PC_GreenUp.png"]];
    img.frame=CGRectMake(313, 24, 6, 10);
    [cell.contentView addSubview:img]; 
    if ([[dic objectForKey:@"ChangePercent"]floatValue]<0) {
        [img setImage:[UIImage imageNamed:@"PC_redDown.png"]];
    }
    else{
        [img setImage:[UIImage imageNamed:@"PC_GreenUp.png"]];
    }
    [img release];
    img=nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)webserviceCallLoginFinished{
    strTicket = [[[objLoginParser getResults]objectAtIndex:0]objectForKey:@"Ticket"];
    
    shapeTypeFlag = 1;
    
    objPriceChangeParser=[[GetPriceChangeParser alloc]init];
    objPriceChangeParser.delegate = self;
    [objPriceChangeParser GetPriceChange:strTicket withPriceType:@"ROUND"];
}


-(void)webserviceCallPriceChangeFinished:(NSMutableArray *)results{
    
    
    if (shapeTypeFlag==1) {
        arrPriceChange[0] = results;//[objPriceChangeParser getResults];
        
        //NSLog(@"%@",arrPriceChange[0]);
        
        if (roundShapeTableView.hidden==NO) {
            infoLbl.text = [NSString stringWithFormat:@" %d Round Price Changes from %@ to %@ (Price in US$/Ct)",[arrPriceChange[0] count],roundFromDate,roundToDate];
        }
        
        
        
        shapeTypeFlag = 2;
        [roundShapeTableView reloadData];
        [objPriceChangeParser GetPriceChange:[Functions getTicket:L_Prices] withPriceType:@"PEAR"];
        //[objPriceChangeParser GetPriceChange:[StoredData sharedData].strPriceTicket withPriceType:@"PEAR"];
    }else if(shapeTypeFlag==2){
        
        arrPriceChange[1] = results;//[objPriceChangeParser getResults];
        
        //NSLog(@"%@",arrPriceChange[1]);
        
        if (pearShapeTableView.hidden==NO) {
            NSInteger c = [arrPriceChange[1] count];
            infoLbl.text = [NSString stringWithFormat:@" %d PEAR Price Changes from %@ to %@ (Price in US$/Ct)",c,pearFromDate,pearToDate];
        }
        
        shapeTypeFlag = 3;
        [pearShapeTableView reloadData];
        [appDelegate stopActivityIndicator:self];
        
        roundShapeBtn.enabled = YES;
        pearShapeBtn.enabled = YES;
    }
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
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
