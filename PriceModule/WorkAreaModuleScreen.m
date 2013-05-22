//
//  WorkAreaModuleScreen.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkAreaModuleScreen.h"


@implementation WorkAreaModuleScreen

@synthesize delegate;
CGRect vButtomFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    [AnalyticHelper sendView:@"Price - WorkArea"];
    
    return self;
}

- (void)dealloc
{
    [selectedRowArr release];
    [tableView release];
    [toolBar release];
    [avgDperC release];
    [DperTtl release];
    [rapPercentage release];
    [rapPerC release];
    [rapPerTtl release];
    
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
    
    //   NSLog(@"view did load");
    
    [StoredData sharedData].saveCalcFlag = FALSE;
    [StoredData sharedData].updateFileFlag = FALSE;
    
    [self.view addSubview:toolBar];
    toolBar.userInteractionEnabled = NO;
    
    diamondSavedMsgflag = FALSE;
    
    deleteFlag = FALSE;
  //  [deleteBtn setImage:[UIImage imageNamed:@"Delete1X.png"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    tableView.editing = NO;
    
    //NSLog(@"S==%@",[StoredData sharedData].savedDiamondsArr);
    
    if ([[StoredData sharedData].savedDiamondsArr count]==0) {
        deleteBtn.enabled = NO;
        saveSelectedBtn.enabled = NO;
        emailBtn.enabled = NO;
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }else{
        deleteBtn.enabled = YES;
        saveSelectedBtn.enabled = YES;
        emailBtn.enabled = YES;
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
    }
    
    
    selectedRowArr = [[NSMutableArray alloc]init ];
    
    for (int i = 0; i<[[StoredData sharedData].savedDiamondsArr count]; i++) {
        [selectedRowArr addObject:[NSNumber numberWithInt:i]];
    }
    
    [self loadDataInTable];
    
    [self updateLabels];
}


-(void)loadDataInTable{
   /* UIImageView *headerBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.png"]];
    headerBG.frame = CGRectMake(0, 30, 320, 40);
    [self.view addSubview:headerBG];
    
    UILabel *lbl;
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 56, 20)]; // 0
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"ID"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(77, 10, 40, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Shape"];
    [headerBG addSubview:lbl];  
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(119, 10, 30, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Size"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(152, 10, 35, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Color"];
    [headerBG addSubview:lbl];    
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil; 
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(186, 10, 40, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Clarity"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;
    
        
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(225, 10, 32, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"Rap%%"];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;
    
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 41, 20)];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
    lbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbl.text = [NSString stringWithFormat:@"$/Ct."];
    [headerBG addSubview:lbl]; 
    lbl.backgroundColor=[UIColor clearColor];
    [lbl release];
    lbl = nil;
    
    
    [headerBG release];
    headerBG = nil;
    
    
    UIImageView *headerBG1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
    headerBG1.frame = CGRectMake(0, -3, 320, 40);
    [self.view addSubview:headerBG1];
    headerBG1.contentMode = UIViewContentModeScaleToFill;
    
    [headerBG1 release];
    headerBG1 = nil;
    */
    [self.view bringSubviewToFront:calcBtn];
    [self.view bringSubviewToFront:calcL];
    [self.view bringSubviewToFront:deleteAllBtn];
    [self.view bringSubviewToFront:workAreaText];
    
    [self.view bringSubviewToFront:checkBoxSelAllBtn];
    [self.view bringSubviewToFront:checkAllImage];
    //checkBoxSelAllBtn.frame = CGRectMake(checkBoxSelAllBtn.frame.origin.x, checkBoxSelAllBtn.frame.origin.y, checkBoxSelAllBtn.frame.size.width, checkBoxSelAllBtn.frame.size.height+10);
    //checkAllImage.frame = CGRectMake(checkAllImage.frame.origin.x, checkAllImage.frame.origin.y+6, checkAllImage.frame.size.width, checkAllImage.frame.size.height);
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, vButtom.frame.origin.y - vButtom.frame.size.height + 20) style:UITableViewStylePlain];
    [tableView setAutoresizesSubviews:YES];    
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];     
    [tableView setDelegate:self];  
    [tableView setDataSource:self];
    //[tableView reloadData];
    [[self view] addSubview:tableView];
    
}


-(void)updateLabels{
    float avgPricePerCarat,avgTotalPrice,avgRapdisc,avgRapprice,avgRapTotal, totalSize;
    
    avgPricePerCarat = 0;
    avgTotalPrice = 0;
    avgRapdisc = 0;
    avgRapprice = 0;
    avgRapTotal = 0;
    totalSize = 0;
    //  NSLog(@"%@",selectedRowArr);
    
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        //  NSLog(@"T=== %d",t);
        avgPricePerCarat+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"PricePerCarat"]floatValue];
        avgTotalPrice+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"PriceTotal"]floatValue];
        avgRapdisc+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"rapPercent"]floatValue];
        avgRapprice+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"RapPriceList"]floatValue];
        avgRapTotal+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"TotalRapPriceList"]floatValue];
        totalSize+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
    }
    
    
    
    /*avgPricePerCarat = avgPricePerCarat/[selectedRowArr count];
    avgTotalPrice = avgTotalPrice/[selectedRowArr count];
    avgRapdisc = avgRapdisc/[selectedRowArr count];
    avgRapprice = avgRapprice/[selectedRowArr count];
    avgRapTotal = avgRapTotal/[selectedRowArr count];
    */
    
    
    avgPricePerCarat = avgTotalPrice / totalSize;
    avgDperC.text = [self convertNumberToCommaSeparatedString:avgPricePerCarat];
    DperTtl.text = [self convertNumberToCommaSeparatedString:avgTotalPrice];
    rapPercentage.text = [self convertNumberToCommaSeparatedString:avgRapdisc];
    rapPerC.text =   [self convertNumberToCommaSeparatedString: avgRapTotal / totalSize];//[self convertNumberToCommaSeparatedString:avgRapprice];
    rapPerTtl.text = [self convertNumberToCommaSeparatedString:avgRapTotal];
    
    float rapAvgPercent = ((1.0 - (avgTotalPrice / avgRapTotal)) * 100.0) * (-1.0);
    rapPercentage.text = [Functions getFractionDisplay:rapAvgPercent format:@"%.2f"];
    
    
    //The Rap% should be 1-($tl/RapTl).
    if ([selectedRowArr count]==0) {
        avgDperC.text = @"";
        DperTtl.text = @"";
        rapPercentage.text = @"";
        rapPerC.text = @"";
        rapPerTtl.text = @"";
    }
}

-(void)deleteSelectedDiamonds{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    // NSLog(@"%@",selectedRowArr);
    
    for (int i = 0; i<[selectedRowArr count]; i++) {
        NSLog(@"%@",[StoredData sharedData].savedDiamondsArr);
        [indexes addIndex:[[selectedRowArr objectAtIndex:i]intValue]];
        [arr addObject:[NSIndexPath indexPathForRow:[[selectedRowArr objectAtIndex:i]intValue] inSection:0]];
        [Database deleteWorkAreaDiamonds:[[[[StoredData sharedData].savedDiamondsArr objectAtIndex:[[selectedRowArr objectAtIndex:i]intValue]]objectForKey:@"DiamondIndex"]intValue]];
        
    }
    
    // NSLog(@"%@",indexes);
    
    [[StoredData sharedData].savedDiamondsArr removeObjectsAtIndexes:indexes];
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
    
    
    
    
    if ([[StoredData sharedData].savedDiamondsArr count]==0) {
        deleteBtn.enabled = NO;
        saveSelectedBtn.enabled = NO;
        emailBtn.enabled = NO;
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }else{
        deleteBtn.enabled = YES;
        saveSelectedBtn.enabled = YES;
        emailBtn.enabled = YES;
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
    }
    
    checkAllFlag = FALSE;
    checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    
    //  NSLog(@"Selected = %@",selectedRowArr);
    
    [self updateLabels];
    
    [[StoredData sharedData].workABtnGlobal setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
}


-(IBAction)calcBtnTapped:(id)sender{
  //  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)deleteAllBtnTapped:(id)sender{
 /*   if ([[StoredData sharedData].savedDiamondsArr count]>0) {
       
        customAlert1=[[DeleteAllAlertView alloc]initWithNibName:@"DeleteAllAlertView" bundle:nil];
        customAlert1.delegate = self; 
        
        [self.view addSubview:customAlert1.view];
        
        view = customAlert1.view;
        [self initialDelayEnded];
        
    }else{
       
        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not saved any diamonds";
        
        view = alertView.view;
        [self initialDelayEnded];
    }
    */    
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void)alertView:(UIAlertView *)av willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (av.tag==20) {
        if (buttonIndex==0) {
            
        }else{
            if ([[StoredData sharedData].savedDiamondsArr count]>0) {
                [[StoredData sharedData].savedDiamondsArr removeAllObjects];        
            }
            
            if ([selectedRowArr count]>0) {
                [selectedRowArr removeAllObjects];
            }
            
            [tableView reloadData];
            
            [self updateLabels];
            
            checkAllFlag = FALSE;
          //  [checkBoxSelAllBtn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
            
            checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        }
    }else{
        if (buttonIndex==0) {
            
        }
    }
    
    
}


-(IBAction)emailBtnTapped:(id)sender{
    
    vButtomFrame = vButtom.frame;
    CGRect aa = tableView.frame;
    
    //MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
     MFMailComposeViewController *picker = [MFMailComposeViewController new];
	picker.mailComposeDelegate = self;
    
	[picker setSubject: @"Diamond Report"];
    
    /*table, th, td
    {
    border: 1px solid black;
    }*/
    NSString *emailBody = @""
    "<style>"
        "table,th,td { border:1px solid black; }"
        "td { font-family:verdana; font-size:12px;}"
        "th { font-family:verdana; font-size:12px; font-weight:bold;}"
    "</style>"
        "Hi, <br/>My saved Diamond Report<br/><br/>"
        "<table border='0' cellpadding='0' cellspacing='0'>"
            "<th>#</th>"
            "<th>ID</th>"
            "<th>Shape</th>"
            "<th>Ct.</th>"
            "<th>Color</th>"
            "<th>Clarity</th>"
            "<th>$.Ct.</th>"
            "<th>$.Total</th>"
            "<th>%/Rap</th>"
            "<th>Rap/Ct.</th>"
            "<th>Rap.Total</th>";
            //"<th>%RapNet Avg</th>";
    
    NSString *str = @"";
    
    float avgPricePerCarat,avgTotalPrice,avgRapdisc,avgRapprice,avgRapTotal,totalCarat, totalSize;
    float rapAvgPercent;
    
    avgPricePerCarat = 0;
    avgTotalPrice = 0;
    avgRapdisc = 0;
    avgRapprice = 0;
    avgRapTotal = 0;
    totalCarat = 0;
    totalSize = 0;
    
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        
        totalCarat+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
        
        avgPricePerCarat+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"PricePerCarat"]floatValue];
        avgTotalPrice+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"PriceTotal"]floatValue];
        avgRapdisc+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"rapPercent"]floatValue];
        avgRapprice+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"RapPriceList"]floatValue];
        avgRapTotal+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"TotalRapPriceList"]floatValue];
        totalSize+= [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];

        
        
        NSDictionary *dic = [[StoredData sharedData].savedDiamondsArr objectAtIndex:t];
        
        rapAvgPercent = ((1.0 - ([[dic objectForKey:@"PriceTotal"]floatValue] / [[dic objectForKey:@"TotalRapPriceList"]floatValue])) * 100.0) * (-1.0);
        
        str = [str stringByAppendingFormat:@""
               "<tr>"
                "<td>%d</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                "<td>%@</td>"
                //"<td>%0.2f</td>"
               "</tr>",
               i+ 1,
               [dic objectForKey:@"ID"],
               [dic objectForKey:@"Shape"],
               [Functions getFractionDisplay:[[dic objectForKey:@"Size"]floatValue] format:@"%.2f"],
               [dic objectForKey:@"Color"],
               [dic objectForKey:@"Clarity"],
               [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"PricePerCarat"]intValue]]],
               [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"PriceTotal"]intValue]]],
               [Functions getFractionDisplay:[[dic objectForKey:@"rapPercent"]floatValue] format:@"%.2f"],
               [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"RapPriceList"]intValue]]],
               [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"TotalRapPriceList"]intValue]]]
                //rapAvgPercent
               ];
        
    }
    
    
    emailBody = [emailBody stringByAppendingString:str];
    //emailBody = [emailBody stringByAppendingString:@"</table>"];
    
    avgPricePerCarat = avgTotalPrice / totalSize;

    rapAvgPercent = ((1.0 - (avgTotalPrice / avgRapTotal)) * 100.0) * (-1.0);
    
   // NSString *emailBody1 = @"<br/></br><table border=1><th>No. of Diamonds</th><th>Total Carat</th><th>Avg $/Ct.</th><th>Avg Rap%</th><th>Total Price</th>";
    
    NSString *str1 = @"";
    
    //[Functions getFractionDisplay:rapAvgPercent format:@"%.2f"];
        
    if ([selectedRowArr count]!=0) {
        str1 = [str1 stringByAppendingFormat:@""
                "<tr>"
                    "<td></td>"
                    "<td></td>"
                    "<td></td>"
                    "<td>%@</td>"
                    "<td></td>"
                    "<td></td>"
                    "<td>%@</td>"
                    "<td>%@</td>"
                    "<td>%@</td>"
                    "<td>%@</td>"
                    "<td>%@</td>"
                    //"<td>%0.2f</td>"
                "</tr>",
                [Functions getFractionDisplay:totalCarat format:@"%.2f"],
                [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:(int)avgPricePerCarat]],
                [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:(int)avgTotalPrice]],
                [Functions getFractionDisplay:rapAvgPercent format:@"%.2f"],
                [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:(int)(avgRapTotal / totalSize)]],
                [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:(int)avgRapTotal]]];//,
              //  rapAvgPercent];
    }
    
    
   // emailBody1 = [emailBody1 stringByAppendingString:str1];
    NSString *emailBody1 = @"</table><br/>Created By Rapnet"; 
  
    emailBody = [emailBody stringByAppendingString:str1];
    emailBody = [emailBody stringByAppendingString:emailBody1];
    
	[picker setMessageBody:emailBody isHTML:YES];
    [delegate clickedButton:TRUE];
    if (picker!=nil) {
        picker.modalPresentationStyle =UIModalPresentationFullScreen;
picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
      //  [self presentViewController:picker animated:YES completion:NULL];
        [self presentModalViewController:picker animated:YES];
        //[self addChildViewController:picker];
        //[self.view.window addSubview:picker.view];
        [picker release];
        
        CGRect frame = tableView.frame;
        frame.size.height = vButtom.frame.origin.y - vButtom.frame.size.height + 20;
        frame.size.width = 320;
        frame.origin.x = 0;
        frame.origin.y = 70;
        //tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, vButtom.frame.origin.y - vButtom.frame.size.height + 20) style:UITableViewStylePlain];
        tableView.frame = frame;
        
        
    }
    
	
}

-(IBAction)saveSelectedAllBtnTapped:(id)sender{
    
    if ([selectedRowArr count]>0) {
        //[self showAlertView];
        
        customExistAlert=[[CustomSaveExistListAlert alloc]initWithNibName:@"CustomSaveExistListAlert" bundle:nil];
        customExistAlert.delegate = self;           
        [self.view addSubview:customExistAlert.view];        
        view = customExistAlert.view;
        [self initialDelayEnded];
        
    }else{
        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any diamond";
        
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
        
        
    }else if([[StoredData sharedData].savedDiamondsArr count]>0){
      
        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"You have not selected any diamond";
        
        view = alertView.view;
        [self initialDelayEnded];
        
        
    }
    
    
    int d1,d2;
    d1 = 0;
    d2 = 0;
    
    NSInteger nRows = [tableView numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.contentView viewWithTag:10]){
            NSLog(@"selected");
            d1++;
        }else if([cell.contentView viewWithTag:20]){
            NSLog(@"unselected");
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
    
    [self updateLabels];
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
    
    
    [self updateLabels];
    
    int d1,d2;
    d1 = 0;
    d2 = 0;
    
    NSInteger nRows = [tableView numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.contentView viewWithTag:10]){
            NSLog(@"selected");
            d1++;
        }else if([cell.contentView viewWithTag:20]){
            NSLog(@"unselected");
            d2++;
        }
    }
    
    NSLog(@"Rows = %d %d %d",nRows,d1,d2);
    
    if (d1==nRows) {
        checkAllFlag = TRUE;
        checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
    }else if (d2==nRows) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
    
    if (nRows==0) {
        checkAllFlag = FALSE;
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
    }
    
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods

-(void) mailComposeController: (MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed – Unknown Error  "
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
            
            break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
	[delegate clickedButton:FALSE];
    
    vButtom.frame = vButtomFrame;
    [self.view bringSubviewToFront:vButtom];
    

}


#pragma mark -
#pragma mark UITableViewDelegate Methods

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,24)] autorelease];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel.textAlignment = UITextAlignmentRight;
    headerLabel.text = @"hwlloo";
    headerLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:headerLabel];
    [headerLabel release];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  24.0;
}
*/

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [StoredData sharedData].calcFromWAFlag = TRUE;
    [StoredData sharedData].updateWADiamondIndex = [[[[StoredData sharedData].savedDiamondsArr objectAtIndex:indexPath.row] objectForKey:@"DiamondIndex"]intValue];
    [StoredData sharedData].WAEditRowIndex = indexPath.row;
    [delegate workAreaFinished:1];
 //   [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    /*
    UIView *view1 = [cell viewWithTag:100];
    if (view1!=nil) {
        [view1 removeFromSuperview];
        [view1 release];
    }else{
        view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
        view1.backgroundColor = [[[UIColor alloc] initWithRed:232/255.0 green:231/255.0 blue:230/255.0 alpha:0.6]autorelease];
        view1.tag = 100;
        [cell.contentView addSubview:view1];
    }*/
    
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
    
    
    [self updateLabels];
    
    
    int d1,d2;
    d1 = 0;
    d2 = 0;
    
    NSInteger nRows = [tableView numberOfRowsInSection:0];
    for (int i=0; i<nRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.contentView viewWithTag:10]){
            NSLog(@"selected");
            d1++;
        }else if([cell.contentView viewWithTag:20]){
            NSLog(@"unselected");
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
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        [Database deleteWorkAreaDiamonds:[[[[StoredData sharedData].savedDiamondsArr objectAtIndex:indexPath.row]objectForKey:@"DiamondIndex"]intValue]];
        
        [[StoredData sharedData].savedDiamondsArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        
        [selectedRowArr removeAllObjects];
        
        NSInteger nRows = [tableView numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                [selectedRowArr addObject:[NSNumber numberWithInt:indexPath.row]];
            }
        }
        
        //  NSLog(@"Selected = %@",selectedRowArr);
        
        [self updateLabels];
        
        if ([[StoredData sharedData].savedDiamondsArr count]==0) {
            deleteBtn.enabled = NO;
            saveSelectedBtn.enabled = NO;
            emailBtn.enabled = NO;
            checkAllFlag = FALSE;
            checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        }else{
            deleteBtn.enabled = YES;
            saveSelectedBtn.enabled = YES;
            emailBtn.enabled = YES;
            checkAllFlag = TRUE;
            checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
        }
        
        int d1,d2;
        d1 = 0;
        d2 = 0;
        
        nRows = [tableView numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.contentView viewWithTag:10]){
                NSLog(@"selected");
                d1++;
            }else if([cell.contentView viewWithTag:20]){
                NSLog(@"unselected");
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
        
        [[StoredData sharedData].workABtnGlobal setTitle:[NSString stringWithFormat:@"Work Area (%d)",[[StoredData sharedData].savedDiamondsArr count]] forState:UIControlStateNormal];
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
    int count = [[StoredData sharedData].savedDiamondsArr count];
    return count;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // NSLog(@"rowwwwwwww = %d",indexPath.row);
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        //  NSLog(@"row = %d",indexPath.row);
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSDictionary *dic = [[StoredData sharedData].savedDiamondsArr objectAtIndex:indexPath.row];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(4, 12, 15, 15); //8,14 4
        [btn addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        BOOL flag = FALSE;
        for (int i = 0; i<[selectedRowArr count]; i++) {
            if ([[selectedRowArr objectAtIndex:i]intValue]==indexPath.row) {
                flag = TRUE;
                break;
            }
        }
        if (flag) {
            [btn setImage:[UIImage imageNamed:@"check_box_1X.png"] forState:UIControlStateNormal];
            btn.tag = 10;
        }else{
            [btn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
            btn.tag = 20;
        }
        
        [cell.contentView addSubview:btn];
        NSLog(@"%@", dic);
        
        
        UILabel *lbl;
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 56, 20)]; // 0
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ID"]];
        [cell.contentView addSubview:lbl]; 
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil;    
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(77, 10, 40, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Shape"]];
        [cell.contentView addSubview:lbl];  
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil; 
        
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(119, 10, 30, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        //lbl.text = [NSString stringWithFormat:@"%0.2f", [[dic objectForKey:@"Size"]floatValue]];
        lbl.text = [Functions getFractionDisplay:[[dic objectForKey:@"Size"]floatValue] format:@"%0.2f"]; 
        [cell.contentView addSubview:lbl]; 
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil; 
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(152, 10, 30, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Color"]];
        [cell.contentView addSubview:lbl];    
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil; 
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(186, 10, 35, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Clarity"]];
        [cell.contentView addSubview:lbl]; 
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil;
        
      
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(225, 10, 32, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        
        lbl.text = [Functions getFractionDisplay:[[dic objectForKey:@"rapPercent"]floatValue] format:@"%.2f"];
        //lbl.text = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]];
        
        [cell.contentView addSubview:lbl];
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil;
        
        
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 41, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        lbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text = [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"PricePerCarat"]intValue]]];
        [cell.contentView addSubview:lbl]; 
        lbl.backgroundColor=[UIColor clearColor];
        [lbl release];
        lbl = nil;
        /*
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(301.0, 12.0, 12*1.5, 12*1.5);
        button.frame = frame;
        [button setBackgroundImage:[UIImage imageNamed:@"red-arrow1X.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:button];
        */
    }
    
    // Configure the cell...
  //  cell.indentationLevel = 1;
   // cell.indentationWidth = 20;
    
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(320-50.0, 0.0, 50, 43);
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red-arrow1X.png"]];
    image.frame = CGRectMake(32, 12, 15, 15);
    image.userInteractionEnabled = NO;
    [button addSubview:image];
    [image release];
    image = nil;
    
    [cell addSubview:button];
    //  cell.accessoryView = button;
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark showLoginAlertView

-(void)showAlertView
{
    NSMutableArray *arr= [[NSMutableArray alloc]init ];
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        [arr addObject:[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]];
    }
    
	customAlert=[[CustomSaveDiamondAlert alloc]initWithNibName:@"CustomSaveDiamondAlert" bundle:nil];
    customAlert.delegate = self;   
    customAlert.savedDiamonds = arr;
    
	[self.view addSubview:customAlert.view];
    [arr release];
    arr = nil;
    view = customAlert.view;
	[self initialDelayEnded];
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

-(void)alertSaveDiamondFinished:(int)type{    
    [customAlert.view removeFromSuperview];		
	[customAlert release]; 
    
    if (type==1) {
        diamondSavedMsgflag = TRUE;
        
        alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
        alertView.delegate = self; 
        
        [self.view addSubview:alertView.view];
        alertView.msglbl.text = @"Diamonds saved sucessfully";
        
        view = alertView.view;
        [self initialDelayEnded];
    }else{
        
    }
    
    
}

-(void)alertDeleteFinished:(int)index{
    [customAlert1.view removeFromSuperview];		
	[customAlert1 release]; 
    
    if (index==1) {
        
        [Database deleteAllWorkAreaDiamonds];
        
        if ([[StoredData sharedData].savedDiamondsArr count]>0) {
            [[StoredData sharedData].savedDiamondsArr removeAllObjects];        
        }
        
        if ([selectedRowArr count]>0) {
            [selectedRowArr removeAllObjects];
        }
        
        [tableView reloadData];
        
        [self updateLabels];
        
        
        
        
        if ([[StoredData sharedData].savedDiamondsArr count]==0) {
            deleteBtn.enabled = NO;
            saveSelectedBtn.enabled = NO;
            emailBtn.enabled = NO;
            checkAllFlag = FALSE;
            checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        }else{
            deleteBtn.enabled = YES;
            saveSelectedBtn.enabled = YES;
            emailBtn.enabled = YES;
            checkAllFlag = TRUE;
            checkAllImage.image = [UIImage imageNamed:@"check_box_1X.png"];
        }
        
        checkAllFlag = FALSE;
        // [checkBoxSelAllBtn setImage:[UIImage imageNamed:@"UnCheck_box_1X.png"] forState:UIControlStateNormal];
        checkAllImage.image = [UIImage imageNamed:@"UnCheck_box_1X.png"];
        
    }else{
        
    }
}


-(void)alertDeleteSelectedFinished:(int)index{
    [customAlert2.view removeFromSuperview];		
	[customAlert2 release]; 
    
    if (index==1) {
        [self deleteSelectedDiamonds];
    }else{
        
    }
}

-(void)alertmsgFinished{
    [alertView.view removeFromSuperview];		
	[alertView release]; 
    alertView = nil;
    if (diamondSavedMsgflag) {
        diamondSavedMsgflag = FALSE;   
        [self deleteSelectedDiamonds];
    }
}

-(void)alertSaveExistListFinished:(int)type;{
    [customExistAlert.view removeFromSuperview];		
	[customExistAlert release]; 
    
    if (type==1) {
        SaveToExistFile *wamc = [[SaveToExistFile alloc ]initWithNibName:@"SaveToExistFile" bundle:nil];
        
        NSMutableArray *arr= [[NSMutableArray alloc]init ];
        for (int i = 0; i<[selectedRowArr count]; i++) {
            int t = [[selectedRowArr objectAtIndex:i]intValue];
            [arr addObject:[[StoredData sharedData].savedDiamondsArr objectAtIndex:t]];
        }
        
        wamc.dataArr = arr;
        wamc.delegate = self;
        [arr release];
        arr = nil;
        
       // [self.navigationController pushViewController:wamc animated:YES];
        
        [self.view addSubview:wamc.view];
        
      //  [wamc release];
       // wamc = nil; 
    }else if(type==2){
        [self showAlertView];
    }
}

-(void)alertrapEditFinished:(int)index:(int)value{
    [customRapEditAlert.view removeFromSuperview];		
	[customRapEditAlert release];
    customRapEditAlert = nil;
    
    if (index==1) {
        NSDictionary *dic;
        for (int i = 0; i<[selectedRowArr count]; i++) {
            int t = [[selectedRowArr objectAtIndex:i]intValue];
            dic = [[StoredData sharedData].savedDiamondsArr objectAtIndex:t];
            
            int discount = [[dic objectForKey:@"rapPercent"]intValue];
            discount+=value;
            
            float size = [[dic objectForKey:@"Size"]floatValue];
            float rpl = [[dic objectForKey:@"RapPriceList"]floatValue];
            float pricePerCarat = rpl + ((rpl*discount)/100);
            float priceTotal = pricePerCarat*size;
            
            [[[StoredData sharedData].savedDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
            [[[StoredData sharedData].savedDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
            [[[StoredData sharedData].savedDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:discount] forKey:@"rapPercent"];
        }
        [tableView reloadData];
        [self updateLabels];
    }else{
        
    }
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


-(NSString *)convertToNumberFromString:(NSString *)str{    
    NSString *stringWithoutSpaces = [str stringByReplacingOccurrencesOfString:@"," withString:@""];    
    return stringWithoutSpaces;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //CGPoint location = [touch locationInView:self.view];
    CGPoint location = [touch locationInView:vButtom];
    CGRect rect = rapPercentage.frame;
    if (CGRectContainsPoint(rapPercentage.frame, location)) {
        if ([[StoredData sharedData].savedDiamondsArr count]>0) {
            if ([selectedRowArr count]>0) {
                if (customRapEditAlert==nil) {
                    customRapEditAlert=[[CustomrapEditAlert alloc]initWithNibName:@"CustomrapEditAlert" bundle:nil];
                    customRapEditAlert.delegate = self;         
                    [self.view addSubview:customRapEditAlert.view];
                    view = customRapEditAlert.view;
                    [self initialDelayEnded];
                }
                
            }else{
                if (alertView==nil) {
                    alertView=[[MsgAlertView alloc]initWithNibName:@"MsgAlertView" bundle:nil];
                    alertView.delegate = self; 
                    
                    [self.view addSubview:alertView.view];
                    alertView.msglbl.text = @"Please select atleast one diamond";
                    
                    view = alertView.view;
                    [self initialDelayEnded];
                }
                
            }
        }
        
        
    }
}

-(void)saveExistListFinished:(int)type{
    if ([StoredData sharedData].saveToExistFileFlag) {
        [StoredData sharedData].saveToExistFileFlag = FALSE;
        [self deleteSelectedDiamonds];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    // NSLog(@"appear");
    if ([StoredData sharedData].saveToExistFileFlag) {
        [StoredData sharedData].saveToExistFileFlag = FALSE;
        [self deleteSelectedDiamonds];
    }
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
