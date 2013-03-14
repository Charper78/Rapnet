//
//  SavedCalculations.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveToExistFile.h"


@implementation SaveToExistFile


@synthesize delegate;
@synthesize dataArr;

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
    [selectedRowArr release];
    [fileNameArr release];
    [tableView release];
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
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y, toolBar.frame.size.width, toolBar.frame.size.height);
    toolBar.userInteractionEnabled = NO;
    
    checkAllFlag = FALSE;
    checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    
    diamondSavedMsgflag = FALSE;
    
    selectedRowArr = [[NSMutableArray alloc]init ];
    
    [self loadDataInTable];
    tableView.editing = NO;
    
   
    
    [self loadSavedDiamonds];
      
    fileNameArr = [[NSMutableArray alloc]init ];
    
    //   NSLog(@"s====%@",[StoredData sharedData].dbSavedDiamondsArr );
    
    for (int i = 0; i<[[StoredData sharedData].dbSavedDiamondsArr count]; i++) {
        NSArray *arr  = [[StoredData sharedData].dbSavedDiamondsArr objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init ];
        [dic setObject:[NSNumber numberWithInt:[arr count]] forKey:@"Diamonds"];
        [dic setObject:[[arr objectAtIndex:0]objectForKey:@"FileName"] forKey:@"FileName"];
        [dic setObject:[[arr objectAtIndex:0]objectForKey:@"Time"] forKey:@"Time"];
        [fileNameArr addObject:dic];
        [dic release];
        dic = nil;
    }
 //   NSLog(@"%@",fileNameArr);
    [tableView reloadData];
    
}


-(void)loadSavedDiamonds{
    [Database fetchDiamonds:[Database getDBPath]];
    // NSLog(@"%@",[StoredData sharedData].dbSavedDiamondsArr);
}


-(void)loadDataInTable{
    UIImageView *headerBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.png"]];
    headerBG.frame = CGRectMake(0, 0, 320, 40);
    [self.view addSubview:headerBG];
    
    UILabel *lbl;
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 70, 20)]; // 0
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Filename"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(115, 10, 120, 20)];
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Saved Time"];
    [headerBG addSubview:lbl];  
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(235, 10, 90, 20)];
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Diamond Count"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    
    
    
    [headerBG release];
    headerBG = nil;
    
    [self.view bringSubviewToFront:checkBoxSelAllBtn];
    [self.view bringSubviewToFront:checkAllImage];
    checkBoxSelAllBtn.frame = CGRectMake(checkBoxSelAllBtn.frame.origin.x, checkBoxSelAllBtn.frame.origin.y, checkBoxSelAllBtn.frame.size.width, checkBoxSelAllBtn.frame.size.height+10);
    checkAllImage.frame = CGRectMake(checkAllImage.frame.origin.x, checkAllImage.frame.origin.y+6, checkAllImage.frame.size.width, checkAllImage.frame.size.height);
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 310) style:UITableViewStylePlain];    
    [tableView setAutoresizesSubviews:YES];    
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];     
    [tableView setDelegate:self];  
    [tableView setDataSource:self];
    
    [[self view] addSubview:tableView];
    
}

-(IBAction)checkBoxSelAllBtnTapped:(id)sender{
    if (checkAllFlag) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        if ([selectedRowArr count]>0) {
            [selectedRowArr removeAllObjects];
        }
        
        
        NSInteger nRows = [tableView numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                UIButton *btn = (UIButton*)[cell.contentView viewWithTag:10];
                btn.tag = 20;
                [btn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
            }
        }
        
    }else{
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
        
        if ([selectedRowArr count]>0) {
            [selectedRowArr removeAllObjects];
        }
        
        
        NSInteger nRows = [tableView numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:20]){
                UIButton *btn = (UIButton*)[cell.contentView viewWithTag:20];
                btn.tag = 10;
                [btn setImage:[UIImage imageNamed:@"check_box_1X.png"] forState:UIControlStateNormal];
            }
            
            [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        
    }
    
}


-(IBAction)saveBtnTapped:(id)sender{
    if ([selectedRowArr count]==1) {
        diamondSavedMsgflag = TRUE;
        NSDictionary *dic;
        NSString *fileName,*time;
        
        fileName = [[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:0]intValue]]objectForKey:@"FileName"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        
        NSString *date = [NSString stringWithFormat:@"%0.2d-%0.2d-%0.2d",[components month],[components day],[components year]];    
        NSString *ctime = [NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d",[components hour],[components minute],[components second]];
        
        
        time = [NSString stringWithFormat:@"%@ %@",date,ctime];
        
        time = [[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:0]intValue]]objectForKey:@"Time"];
        
        NSString *dbPath = [Database getDBPath];
        
        for (int i = 0; i<[dataArr count]; i++) {
            dic = [dataArr objectAtIndex:i];
            [Database insertDiamonds:dbPath fileName:fileName time:time ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
        }
        
        
        [self loadSavedDiamonds];
        
        if (fileNameArr) {
            [fileNameArr removeAllObjects];
            [fileNameArr release];
            fileNameArr = nil;
        }
        
        fileNameArr = [[NSMutableArray alloc]init ];
        
        //   NSLog(@"s====%@",[StoredData sharedData].dbSavedDiamondsArr );
        
        for (int i = 0; i<[[StoredData sharedData].dbSavedDiamondsArr count]; i++) {
            NSArray *arr  = [[StoredData sharedData].dbSavedDiamondsArr objectAtIndex:i];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init ];
            [dic setObject:[NSNumber numberWithInt:[arr count]] forKey:@"Diamonds"];
            [dic setObject:[[arr objectAtIndex:0]objectForKey:@"FileName"] forKey:@"FileName"];
            [dic setObject:[[arr objectAtIndex:0]objectForKey:@"Time"] forKey:@"Time"];
            [fileNameArr addObject:dic];
            [dic release];
            dic = nil;
        }
        
        [tableView reloadData];
        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"Diamonds saved sucessfully";
        
        view = alertView.view;
        [self initialDelayEnded];
        
        
    }else if([selectedRowArr count]==0){          
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any diamond";
        
        view = alertView.view;
        [self initialDelayEnded];
    }else{        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"Please select only one diamond";
        
        view = alertView.view;
        [self initialDelayEnded];
        
    }
}

-(IBAction)cancelBtnTapped:(id)sender{
  //  [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}

-(void)btnClicked:(id)sender event:(id)event{
    UIButton *btn = sender;
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (btn.tag==10) {  /// already selected
        [btn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
        btn.tag = 20;
        
        if (indexPath != nil){
            [selectedRowArr removeObject:[NSNumber numberWithInt:indexPath.row]];
        }
        
    }else if (btn.tag==20) {  // already unselected
        [btn setImage:[UIImage imageNamed:@"check_box_1X.png"] forState:UIControlStateNormal];
        btn.tag = 10;
        
        if (indexPath != nil){
            [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        
    }
    
    
    int d1,d2;
    d1 = 0;
    d2 = 0;
    
    NSInteger nRows = [tableView numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.contentView viewWithTag:10]){
            d1++;
        }else if([cell.contentView viewWithTag:20]){
            d2++;
        }
    }
    
    if (d1==nRows) {
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
    }else if (d2==nRows) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
    
    if (nRows==0 || (d1!=nRows && d2!=nRows)) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  /*  UIView *view1 = [cell viewWithTag:100];
    if (view1!=nil) {
        [view1 removeFromSuperview];
        [view1 release];
    }else{
        view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
        view1.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
        view1.tag = 100;
        [cell.contentView addSubview:view1];
    }
    */
    
    
    
    
    
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.contentView viewWithTag:10]){
        [(UIButton*)[cell.contentView viewWithTag:10] setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
        ((UIButton*)[cell.contentView viewWithTag:10]).tag = 20;
        
        if (indexPath != nil){
            [selectedRowArr removeObject:[NSNumber numberWithInt:indexPath.row]];
        } 
    }else if([cell.contentView viewWithTag:20]){
        [(UIButton*)[cell.contentView viewWithTag:20] setImage:[UIImage imageNamed:@"check_box_1X.png"] forState:UIControlStateNormal];
        ((UIButton*)[cell.contentView viewWithTag:20]).tag = 10;
        
        if (indexPath != nil){
            [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
        }
    }
    
    
    int d1,d2;
    d1 = 0;
    d2 = 0;
    
    NSInteger nRows = [tableView numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.contentView viewWithTag:10]){
            d1++;
        }else if([cell.contentView viewWithTag:20]){
            d2++;
        }
    }
    
    if (d1==nRows) {
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
    }else if (d2==nRows) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
    
    if (nRows==0  || (d1!=nRows && d2!=nRows)) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
    
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

-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        // NSLog(@"delete");
        //[Database deleteDiamonds:[Database getDBPath] arg2:[[fileNameArr objectAtIndex:indexPath.row]objectForKey:@"Time"]];
        [Database deleteDiamonds:[Database getDBPath] arg2:[[fileNameArr objectAtIndex:indexPath.row]objectForKey:@"FileName"]];

        [fileNameArr removeObjectAtIndex:indexPath.row];
        [[StoredData sharedData].dbSavedDiamondsArr removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        
        
        [selectedRowArr removeAllObjects];
        
        NSInteger nRows = [tv numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
            }
        }
        
      
        
        int d1,d2;
        d1 = 0;
        d2 = 0;
        
        nRows = [tv numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                //  NSLog(@"selected");
                d1++;
            }else if([cell.contentView viewWithTag:20]){
                //  NSLog(@"unselected");
                d2++;
            }
        }
        
        // NSLog(@"Rows = %d %d %d",nRows,d1,d2);
        
        if (d1==nRows) {
            checkAllFlag = TRUE;
            // [checkBoxSelAllBtn setImage:[UIImage imageNamed:@"check_box_1X.png"] forState:UIControlStateNormal];
            checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
        }else if (d2==nRows) {
            checkAllFlag = FALSE;
            // [checkBoxSelAllBtn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
            checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        }
        
        if (nRows==0  || (d1!=nRows && d2!=nRows)) {
            checkAllFlag = FALSE;
            // [checkBoxSelAllBtn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
            checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        }
        
    }
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
    return [fileNameArr count];
	
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
   
    
    NSDictionary *dic = [fileNameArr objectAtIndex:indexPath.row];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(3, 13, 15, 15); //8,14 4
    [btn addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
    btn.tag = 20;
    [cell.contentView addSubview:btn];
    
    UILabel *lbl;
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 70, 20)]; // 0
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"FileName"]];
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(115, 10, 120, 20)];
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Time"]];
    [cell.contentView addSubview:lbl];  
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 40, 20)];
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"(%0.2d)",[[dic objectForKey:@"Diamonds"]intValue]];
    [cell.contentView addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;  
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
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


-(void)alertmsgFinished{
    [alertView.view removeFromSuperview];		
	[alertView release]; 
    
    if (diamondSavedMsgflag) {
        diamondSavedMsgflag = FALSE;   
        [StoredData sharedData].saveToExistFileFlag = TRUE;
      //  [self.navigationController popViewControllerAnimated:YES];
        [self.view removeFromSuperview];
    }
    
    [delegate saveExistListFinished:1];
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
