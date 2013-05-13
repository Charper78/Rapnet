//
//  SavedCalculations.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedCalculations.h"


@implementation SavedCalculations

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    [AnalyticHelper sendView:@"Price - SavedCalc."];
    
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

/*- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [StoredData sharedData].updateFileFlag = FALSE;
    [StoredData sharedData].saveCalcFlag = FALSE;
    
    [self.view addSubview:toolBar];
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y-36, toolBar.frame.size.width, toolBar.frame.size.height);
    toolBar.userInteractionEnabled = NO;
    
    checkAllFlag = FALSE;
    checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    
    
    
    selectedRowArr = [[NSMutableArray alloc]init ];
    
    [self loadDataInTable];
    tableView.editing = NO;
    
    deleteFlag = FALSE;
    //  [deleteBtn setImage:[UIImage imageNamed:@"Delete1X.png"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    
    [self loadSavedDiamonds];
    
    if ([[StoredData sharedData].dbSavedDiamondsArr count]==0) {
        deleteBtn.enabled = NO;
        renameBtn.enabled = NO;
        openBtn.enabled = NO;
    }else{
        deleteBtn.enabled = YES;
        renameBtn.enabled = YES;
        openBtn.enabled = YES;
    }
    
    fileNameArr = [[NSMutableArray alloc]init ];
    
    //   NSLog(@"s====%@",[StoredData sharedData].dbSavedDiamondsArr );
    int c = [[StoredData sharedData].dbSavedDiamondsArr count];
    int count;
    NSNumber *diamonds;
    int foundIndex = -1;
    NSString *fileName;
    for (int i = 0; i<c; i++)
    {
        NSArray *arr  = [[StoredData sharedData].dbSavedDiamondsArr objectAtIndex:i];
        count = [arr count];
        
        for (int j = 0; j<count; j++)
        {
            fileName = [[arr objectAtIndex:j] objectForKey:@"FileName"];
            for (int x = 0; x< [fileNameArr count]; x++)
            {
                if ([[[fileNameArr objectAtIndex:x] objectForKey:@"FileName"] isEqualToString:fileName])
                {
                    diamonds = [[fileNameArr objectAtIndex:x] objectForKey:@"Diamonds"];
                    foundIndex = x;
                }
            }
            if (foundIndex >= 0) {
                diamonds ++;
                [[fileNameArr objectAtIndex:foundIndex] objectForKey:@"Diamonds"] = diamonds;
                foundIndex = -1;
            }
            else
            {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init ];
        [dic setObject:[NSNumber numberWithInt:[arr count]] forKey:@"Diamonds"];
        [dic setObject:[[arr objectAtIndex:j]objectForKey:@"FileName"] forKey:@"FileName"];
        [dic setObject:[[arr objectAtIndex:j]objectForKey:@"Time"] forKey:@"Time"];
        [fileNameArr addObject:dic];
        [dic release];
        dic = nil;
        }
    }
    NSLog(@"%@",fileNameArr);
    [tableView reloadData];
    
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [StoredData sharedData].updateFileFlag = FALSE;
    [StoredData sharedData].saveCalcFlag = FALSE;
    
    [self.view addSubview:toolBar];
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y-36, toolBar.frame.size.width, toolBar.frame.size.height);
    toolBar.userInteractionEnabled = NO;
    
    checkAllFlag = FALSE;
    checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    
    
    
    selectedRowArr = [[NSMutableArray alloc]init ];
    
    [self loadDataInTable];
    tableView.editing = NO;
    
    deleteFlag = FALSE;
    //  [deleteBtn setImage:[UIImage imageNamed:@"Delete1X.png"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    
    [self loadSavedDiamonds];
    
    if ([[StoredData sharedData].dbSavedDiamondsArr count]==0) {
        deleteBtn.enabled = NO;
        renameBtn.enabled = NO;
        openBtn.enabled = NO;
    }else{
        deleteBtn.enabled = YES;
        renameBtn.enabled = YES;
        openBtn.enabled = YES;
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
    //   NSLog(@"%@",fileNameArr);
    [tableView reloadData];
    
}


-(void)loadSavedDiamonds{
    [Database fetchDiamonds:[Database getDBPath]];
     NSLog(@"%@",[StoredData sharedData].dbSavedDiamondsArr);
    int c = [[StoredData sharedData].dbSavedDiamondsArr count];
    NSLog(@"c = %d", c);
}


-(void)loadDataInTable{
    //UIImageView *headerBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.png"]];
    //headerBG.frame = CGRectMake(0, 0, 320, 40);
    //[self.view addSubview:headerBG];
    
  /*  UILabel *lbl;
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
    lbl.text = [NSString stringWithFormat:@"Create Date"];
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
    */
    
    
    
    //[headerBG release];
   // headerBG = nil;
    
    [self.view bringSubviewToFront:checkBoxSelAllBtn];
    [self.view bringSubviewToFront:checkAllImage];
    //checkBoxSelAllBtn.frame = CGRectMake(checkBoxSelAllBtn.frame.origin.x, checkBoxSelAllBtn.frame.origin.y, checkBoxSelAllBtn.frame.size.width, checkBoxSelAllBtn.frame.size.height+10);
    //checkAllImage.frame = CGRectMake(checkAllImage.frame.origin.x, checkAllImage.frame.origin.y+6, checkAllImage.frame.size.width, checkAllImage.frame.size.height);
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, vButtom.frame.origin.y - vButtom.frame.size.height + 30) style:UITableViewStylePlain];
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

-(IBAction)openBtnTapped:(id)sender{
    if ([selectedRowArr count]==1) {
        
        if (![StoredData sharedData].openFileAlertFlag) {
            openAlert=[[CustomOpenAlertView alloc]initWithNibName:@"CustomOpenAlertView" bundle:nil];
            openAlert.delegate = self;   
            [self.view addSubview:openAlert.view];
            view = openAlert.view;
            [self initialDelayEnded];
        }else{
            [self alertOpenFinished:[StoredData sharedData].openFileAlertType];
        }         
        
    }else if([selectedRowArr count]==0){        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any saved calc";
        
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

-(IBAction)deleteBtnTapped:(id)sender{
    if ([selectedRowArr count]>0) {
        
        customAlert2=[[DeleteSelectedAlertView alloc]initWithNibName:@"DeleteSelectedAlertView" bundle:nil];
        customAlert2.delegate = self; 
        
        [self.view addSubview:customAlert2.view];
        
        view = customAlert2.view;
        [self initialDelayEnded];
        
        
               
       
    }else{
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any saved calc";
        
        view = alertView.view;
        [self initialDelayEnded];
    }
    
    
    
    
}

-(IBAction)renameBtnTapped:(id)sender{
    if ([selectedRowArr count]==1) {
        renameAlert=[[CustomRenameAlert alloc]initWithNibName:@"CustomRenameAlert" bundle:nil];
        renameAlert.delegate = self;   
        [self.view addSubview:renameAlert.view];
        renameAlert.time = [[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:0]intValue]]objectForKey:@"Time"];
        renameAlert.idDiamond.text = [[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:0]intValue]]objectForKey:@"FileName"];
        view = renameAlert.view;
        [self initialDelayEnded];
    }else if([selectedRowArr count]==0){        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any saved calc";
        
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

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
 
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
    
    NSInteger nRows = [tv numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
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
        
        
        if ([[StoredData sharedData].dbSavedDiamondsArr count]==0) {
            deleteBtn.enabled = NO;
            renameBtn.enabled = NO;
            openBtn.enabled = NO;
        }else{
            deleteBtn.enabled = YES;
            renameBtn.enabled = YES;
            openBtn.enabled = YES;
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

-(void)alertRenameFinished:(NSString *)name type:(int)type{
    [renameAlert.view removeFromSuperview];		
	[renameAlert release];
    
    if (type==1) {
      //  NSLog(@"N===%@",name);
        
        [[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:0]intValue]]setObject:name forKey:@"FileName"];
        [selectedRowArr removeAllObjects];
        
        [tableView reloadData];
      //  NSLog(@"%@",fileNameArr);
    }
    
    
}

-(void)alertOpenFinished:(int)type{
    if (openAlert!=nil) {
        [openAlert.view removeFromSuperview];		
        [openAlert release];
        openAlert = nil;
    }
    
    if (type==3) {
        
    }else{
        
        if (![StoredData sharedData].openFileAlertFlag) {
            [StoredData sharedData].openFileAlertFlag = TRUE;
            [StoredData sharedData].openFileAlertType = type;
        }
        
      //  [delegate savedCalcFinished:type index:[[selectedRowArr objectAtIndex:0]intValue]]; 
        
        int index = 0;
        
        if ([selectedRowArr count]>0) {
            index = [[selectedRowArr objectAtIndex:0]intValue];
            [StoredData sharedData].openFileIndex = index;
        }else{
            index = [StoredData sharedData].openFileIndex;
        }
        
        if (type==2) {
            NSMutableArray *diamondsArr = [[NSMutableArray alloc]init ];
            
            NSArray *arr = [[StoredData sharedData].dbSavedDiamondsArr objectAtIndex:index];
            
            [StoredData sharedData].openFileName = [[arr objectAtIndex:0] objectForKey:@"FileName"];
            [StoredData sharedData].openFileTime = [[arr objectAtIndex:0] objectForKey:@"Time"];
            
            for (int i = 0; i<[arr count]; i++) {
                
                NSDictionary *dic1 = [arr objectAtIndex:i];
                
                float w = [[dic1 objectForKey:@"Size"]floatValue];
                NSString *shapeID = [dic1 objectForKey:@"Shape"];
                //   NSLog(@"sh = %@",shapeID);
                shapeType = [self GetShapeType:shapeID];
                NSString *CID = [dic1 objectForKey:@"Color"];
                NSString *CLID = [dic1 objectForKey:@"Clarity"];
                
                int ID = [self getGridSizeID:w];
                
                //float rpl = [Database fetchPriceWithGridID:[NSString stringWithFormat:@"%d",ID] Shape:shapeType Color:CID Clarity:CLID];  
                float rpl = [PriceListData getPrice:[NSString stringWithFormat:@"%d",ID] shape:shapeType color:CID clarity:CLID];
                
                int d = [[dic1 objectForKey:@"rapPercent"]floatValue];
                
                float pricePerCarat = rpl + ((rpl*d)/100);
                float priceTotal = pricePerCarat*w;
                
                
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:[dic1 objectForKey:@"Shape"] forKey:@"Shape"];
                [dic setObject:[dic1 objectForKey:@"Clarity"] forKey:@"Clarity"];
                [dic setObject:[dic1 objectForKey:@"Color"] forKey:@"Color"];
                [dic setObject:[dic1 objectForKey:@"ID"] forKey:@"ID"];
                [dic setObject:[NSNumber numberWithFloat:rpl] forKey:@"RapPriceList"];
                [dic setObject:[NSNumber numberWithFloat:rpl*w] forKey:@"TotalRapPriceList"];
                [dic setObject:[dic1 objectForKey:@"rapPercent"] forKey:@"rapPercent"];
                [dic setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
                [dic setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
                [dic setObject:[dic1 objectForKey:@"AvgDiscount"] forKey:@"AvgDiscount"];
                [dic setObject:[dic1 objectForKey:@"AvgPrice"] forKey:@"AvgPrice"];
                [dic setObject:[dic1 objectForKey:@"BestDiscount"] forKey:@"BestDiscount"];
                [dic setObject:[dic1 objectForKey:@"BestPrice"] forKey:@"BestPrice"];
                [dic setObject:[dic1 objectForKey:@"Size"] forKey:@"Size"];
                [dic setObject:[dic1 objectForKey:@"DiamondIndex"] forKey:@"DiamondIndex"];
                
                [diamondsArr addObject:dic];
                
                
                [dic release];
                dic = nil;
            }
            
            //    [StoredData sharedData].saveCalcFlag = FALSE;
            
            OpenFileModuleScreen *wamc = [[OpenFileModuleScreen alloc ]initWithNibName:@"OpenFileModuleScreen" bundle:nil];
            wamc.allDiamondsArr = [diamondsArr mutableCopy];
            wamc.delegate = self;
            // [self.navigationController pushViewController:wamc animated:YES];
            [self.view addSubview:wamc.view];
           /* [wamc release];
            wamc = nil;*/
            [diamondsArr removeAllObjects];
            [diamondsArr release];
            diamondsArr = nil;        
            
        }else if (type==1) {
            NSMutableArray *diamondsArr = [[NSMutableArray alloc]init ];
            NSArray *arr = [[StoredData sharedData].dbSavedDiamondsArr objectAtIndex:index];
            
            [StoredData sharedData].openFileName = [[arr objectAtIndex:0] objectForKey:@"FileName"];
            [StoredData sharedData].openFileTime = [[arr objectAtIndex:0] objectForKey:@"Time"];
            
            for (int i = 0; i<[arr count]; i++) {
                
                NSDictionary *dic1 = [arr objectAtIndex:i];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:[dic1 objectForKey:@"Shape"] forKey:@"Shape"];
                [dic setObject:[dic1 objectForKey:@"Clarity"] forKey:@"Clarity"];
                [dic setObject:[dic1 objectForKey:@"Color"] forKey:@"Color"];
                [dic setObject:[dic1 objectForKey:@"ID"] forKey:@"ID"];
                [dic setObject:[dic1 objectForKey:@"RapPriceList"] forKey:@"RapPriceList"];
                [dic setObject:[dic1 objectForKey:@"TotalRapPriceList"] forKey:@"TotalRapPriceList"];
                [dic setObject:[dic1 objectForKey:@"rapPercent"] forKey:@"rapPercent"];
                [dic setObject:[dic1 objectForKey:@"PriceTotal"] forKey:@"PriceTotal"];
                [dic setObject:[dic1 objectForKey:@"PricePerCarat"] forKey:@"PricePerCarat"];
                [dic setObject:[dic1 objectForKey:@"AvgDiscount"] forKey:@"AvgDiscount"];
                [dic setObject:[dic1 objectForKey:@"AvgPrice"] forKey:@"AvgPrice"];
                [dic setObject:[dic1 objectForKey:@"BestDiscount"] forKey:@"BestDiscount"];
                [dic setObject:[dic1 objectForKey:@"BestPrice"] forKey:@"BestPrice"];
                [dic setObject:[dic1 objectForKey:@"Size"] forKey:@"Size"];
                [dic setObject:[dic1 objectForKey:@"DiamondIndex"] forKey:@"DiamondIndex"];
                
                [diamondsArr addObject:dic];
                
                
                
                //  NSLog(@"Diamond = %@",dic);
                
                [dic release];
                dic = nil;
            }
            
            //     [StoredData sharedData].saveCalcFlag = FALSE;
            
            OpenFileModuleScreen *wamc = [[OpenFileModuleScreen alloc ]initWithNibName:@"OpenFileModuleScreen" bundle:nil];
            wamc.allDiamondsArr = [diamondsArr mutableCopy];
            wamc.delegate = self;
            [self.view addSubview:wamc.view];
         /*   [wamc release];
            wamc = nil;*/
            [diamondsArr removeAllObjects];
            [diamondsArr release];
            diamondsArr = nil;
        }
        
        
    }
    
}

-(void)openFileModuleFinished:(int)type{
    
    switch (type) {
        case 1:
            [delegate savedCalcFinished:type index:0]; 
            break;
        case 2:
            [delegate savedCalcFinished:type index:0]; 
            break;
            
        default:
            break;
    }
}

-(void)alertDeleteSelectedFinished:(int)index{
    [customAlert2.view removeFromSuperview];		
	[customAlert2 release]; 
    
    if (index==1) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        NSMutableArray *arr = [[NSMutableArray alloc]init ];
        
        for (int i = 0; i<[selectedRowArr count]; i++) {
            [indexes addIndex:[[selectedRowArr objectAtIndex:i]intValue]];
            [arr addObject:[NSIndexPath indexPathForRow:[[selectedRowArr objectAtIndex:i]intValue] inSection:0]];
            //[Database deleteDiamonds:[Database getDBPath] arg2:[[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:i]intValue]]objectForKey:@"Time"]];
            [Database deleteDiamonds:[Database getDBPath] arg2:[[fileNameArr objectAtIndex:[[selectedRowArr objectAtIndex:i]intValue]]objectForKey:@"FileName"]];
        }
        
        
        [fileNameArr removeObjectsAtIndexes:indexes];
        [[StoredData sharedData].dbSavedDiamondsArr removeObjectsAtIndexes:indexes];
        [tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
        [arr release];
        
        
        [selectedRowArr removeAllObjects];
        
        NSInteger nRows = [tableView numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
            }
        }
        
        
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        
        if ([[StoredData sharedData].dbSavedDiamondsArr count]==0) {
            deleteBtn.enabled = NO;
            renameBtn.enabled = NO;
            openBtn.enabled = NO;
        }else{
            deleteBtn.enabled = YES;
            renameBtn.enabled = YES;
            openBtn.enabled = YES;
        }
        
    }else{
        
    }
}

-(void)alertmsgFinished{
    [alertView.view removeFromSuperview];		
	[alertView release]; 
}



-(int)getGridSizeID:(float)size{
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
