//
//  DiamondResultsVC.m
//  Rapnet
//
//  Created by Itzik on 04/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "DiamondResultsVC.h"

@interface DiamondResultsVC ()

@end

@implementation DiamondResultsVC

const NSInteger numIncrease = 20;
bool loadingResults = YES;
CGFloat fixHeight = 0;
@synthesize resultCell,moreResultsCell;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AnalyticHelper sendView:@"Rapnet - SearchResults"];
    
    CGRect f = tblResults.frame;
    f.size.height = fixHeight;
    tblResults.frame = f;
 //[self.navigationController setNavigationBarHidden:YES];
    
    //resultParser = [[DiamondsSearchResultParser alloc] init];
    //resultParser.delegate = self;
    //[resultParser GetDiamondsList:@"REGULAR" firstRowNum:0 toRowNum:10 weightFrom:@"1" weightTo:@"1"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)webserviceCallDiamondsSearchResultFinished:(NSMutableArray*)res total:(NSInteger)total
{
    //results = [resultParser getResults];
    totalCount = total;
    results = res;
   // [results retain];
    NSString *t = [Functions numberWithComma:totalCount];
    lblTitle.text = [NSString stringWithFormat:@"%d of %@", results.count, t];
    loadingResults = NO;
    [self.tblResults reloadData];
}


#pragma mark - Table view data source
-(void)changeTableHeight:(CGFloat)height
{
    fixHeight = height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return results.count + 1;
    //return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger c = [results count];
    if (row == c ){
        static NSString *CellIdentifier = @"MoreResultsCell";
        moreResults = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (moreResults == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"MoreResultsCell" owner:self options:nil];
            moreResults = moreResultsCell;
            self.moreResultsCell = nil;
            
            if (loadingResults == NO) {
                lblMoreResultsTitle.text = @"More Results...";
                [activityIndicator stopAnimating];
            }
            else
                lblMoreResultsTitle.text = @"Loading...";
            
            
            //cellMore = [[[MoreResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        //cell.lblTitle.frame=CGRectMake(17, 22,145, 35);
        //cellMore.textLabel.text=@"More Results...";
        //cellMore.accessoryType=UITableViewCellAccessoryNone;
        return moreResults;
    }
    
    static NSString *CellIdentifier = @"ApplicationCell";
	cell = (DiamondResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil){
		[[NSBundle mainBundle] loadNibNamed:@"DiamondResultCell" owner:self options:nil];
		cell = resultCell;
		self.resultCell = nil;
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    DiamondSearchResult *diamond = [results objectAtIndex:indexPath.row];
    [cell setDiamond:diamond];
    
   // NSString *str;
    
    lblShapeVal.text = diamond.shape;
    //lblSizeVal.text = [NSString stringWithFormat: @"%.2f",[diamond.weight floatValue]];
    lblSizeVal.text = [Functions getFractionDisplay:[diamond.weight floatValue] format:@"%.2f"];
    lblClarityVal.text = diamond.clarity;
    lblPolishVal.text = diamond.polish;
    lblColorVal.text = diamond.color;
    if(diamond.isFancy)
        lblColorVal.text = diamond.fancyColor1;
    lblCutVal.text = [NSString stringWithFormat:@"%@ %@ %@", diamond.cut, diamond.polish, diamond.symmetry];
    lblSymVal.text = diamond.symmetry;
    lblFluorVal.text = diamond.fluorescenceIntensity;
    lblLabVal.text = diamond.lab;
    
   
    lblRapPercentVal.text = @"";
    
    NSString * rapPercent = @"";
    
   // NSString *gg = diamond.lowestDiscount;
    if ([diamond.lowestDiscount floatValue] != 0) {
        rapPercent = [Functions getFractionDisplay:[diamond.lowestDiscount floatValue] * 100 format:@"%.1f%%"];
        //rapPercent = [NSString stringWithFormat: @"%.1f%%", [diamond.lowestDiscount floatValue] * 100];
        //lblRapPercentVal.text = [NSString stringWithFormat: @"%.2f", [diamond.lowestDiscount floatValue] * 100];
    }
    
    NSString *pricePerCarat = [Functions numberWithComma:[diamond.pricePerCarat intValue]];
    lblCaratVal.text = [NSString stringWithFormat: @"%@ %@/ct", rapPercent, pricePerCarat];
    
    
    lblLocVal.text = diamond.country;
    lblTableVal.text = diamond.tablePercent;
    lblDepthVal.text = diamond.depthPercent;
    //lbl
  
    
    
    /*NSInteger row = indexPath.row;
    id val = [results objectAtIndex:row];
    
    NSString *weight = [NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]objectForKey:@"weight"]];
    cell.textLabel.text = weight;
    */
    // Configure the cell...
   // [self.activityIndicator stopAnimating];
    UIView *myView = [[UIView alloc] init];
    
    if(indexPath.row % 2 == 0)
        myView.backgroundColor = [UIColor lightGrayColor];
    else
        myView.backgroundColor = [UIColor whiteColor];
    
    cell.backgroundView = myView;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//for pull to refresh
	/*if (indexPath.row==0){
        return 0;
	}*/
    if(indexPath.row == [results count])
        return 37;
    return 79;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
   // WorkerController *detailViewController = [[WorkerController alloc] init];
    // ...
    // Pass the selected object to the new view controller.
    // detailViewController.worker = [[allWorkers objectAtIndex:indexPath.row] retain];
  //  detailViewController.worker = [allWorkers objectAtIndex:indexPath.row];
  //  [self.navigationController pushViewController:detailViewController animated:YES];
    //[detailViewController release];
    if(indexPath.row == [results count])
    {
        NSInteger tmp = [searchParams.toRowNum intValue] + numIncrease;
        searchParams.firstRowNum = [NSString stringWithFormat: @"%d", [searchParams.toRowNum intValue] + 1];
        searchParams.toRowNum = [NSString stringWithFormat:@"%d", tmp];
        [self search:searchParams];
        return;
    }
    
    DiamondDesultDetailsVC *details = [[DiamondDesultDetailsVC alloc]initWithNibName:@"DiamondDesultDetailsVC" bundle:nil];
    //[self.navigationController pushViewController:details animated:YES];
    [self.view addSubview:details.view];
    
    DiamondSearchResult *curResult = [results objectAtIndex:indexPath.row];
    
    if (fixHeight != 375) {
        [details changeTableHeight:375-30];
    }
    else
        [details changeTableHeight:375];
    
    [details loadDiamond:curResult];
   // [details release];
}


-(IBAction)btnBackClicked:(id)sender
{
   // UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
   // [navC popViewControllerAnimated:YES];
    
    //[[self navigationController] popViewControllerAnimated:YES];
    
    [self.view removeFromSuperview];
}

-(void) search:(DiamondSearchParams*)params
{
    //bool R = [Reachability reachableAndAlert];
    
    searchParams = params;
    startRow = [params.firstRowNum intValue];
    endRow = [params.toRowNum intValue];
    
    if(resultParser == nil)
    {
        resultParser = [[DiamondsSearchResultParser alloc] init];
        resultParser.delegate = self;
    }
    
    
    
    //if(R == YES)
    //{
        loadingResults = YES;
        lblMoreResultsTitle.text = @"Loading...";
        [activityIndicator startAnimating];
        [resultParser getDiamondsList:params];
   /* }
    else
    {
        lblMoreResultsTitle.text = @"No Results";
        [activityIndicator stopAnimating];
    }*/
}

@end
