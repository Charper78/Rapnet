//
//  WorkAreaModuleScreen.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenFileModuleScreen.h"


@implementation OpenFileModuleScreen

@synthesize allDiamondsArr,delegate;

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
    [allDiamondsArr release];
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
    
   [self.view addSubview:toolBar];
    toolBar.userInteractionEnabled = NO;
    toolBar.center = CGPointMake(160, 194);
    
    workAreaText.text = [StoredData sharedData].openFileName;
    
    diamondSavedMsgflag = FALSE;
    
    deleteFlag = FALSE;
  //  [deleteBtn setImage:[UIImage imageNamed:@"Delete1X.png"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    tableView.editing = NO;

    
    if ([allDiamondsArr count]==0) {
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
    
    for (int i = 0; i<[allDiamondsArr count]; i++) {
        [selectedRowArr addObject:[NSNumber numberWithInt:i]];
    }
    
    [self loadDataInTable];
    
    [self updateLabels];
  //  NSLog(@"%@",allDiamondsArr);
}


-(void)loadDataInTable{
    /*UIImageView *headerBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.png"]];
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
    
    
    UIImageView *headerBG1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"work-area-header-1X.png"]];
    headerBG1.frame = CGRectMake(0, 0, 320, 33);
    [self.view addSubview:headerBG1];
    
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
    
    //tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, 204) style:UITableViewStylePlain];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, vButtom.frame.origin.y - vButtom.frame.size.height + 20) style:UITableViewStylePlain]; 
    [tableView setAutoresizesSubviews:YES];    
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];     
    [tableView setDelegate:self];  
    [tableView setDataSource:self];
    
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
    
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        avgPricePerCarat+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PricePerCarat"]floatValue];
        avgTotalPrice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PriceTotal"]floatValue];
        avgRapdisc+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"rapPercent"]floatValue];
        avgRapprice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"RapPriceList"]floatValue];
        avgRapTotal+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"TotalRapPriceList"]floatValue];
        totalSize+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
    }
    
    avgPricePerCarat = avgTotalPrice / totalSize;
    avgDperC.text = [self convertNumberToCommaSeparatedString:avgPricePerCarat];
    DperTtl.text = [self convertNumberToCommaSeparatedString:avgTotalPrice];
    rapPercentage.text = [self convertNumberToCommaSeparatedString:avgRapdisc];
    rapPerC.text =   [self convertNumberToCommaSeparatedString: avgRapTotal / totalSize];
    rapPerTtl.text = [self convertNumberToCommaSeparatedString:avgRapTotal];
    
    float rapAvgPercent = ((1.0 - (avgTotalPrice / avgRapTotal)) * 100.0) * (-1.0);
    rapPercentage.text = [Functions getFractionDisplay:rapAvgPercent format:@"%.2f"];
    
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
        //  NSLog(@"%@",selectedRowArr);
        [indexes addIndex:[[selectedRowArr objectAtIndex:i]intValue]];
        [arr addObject:[NSIndexPath indexPathForRow:[[selectedRowArr objectAtIndex:i]intValue] inSection:0]];
        [Database deleteDiamondWithIndex:[[[allDiamondsArr objectAtIndex:[[selectedRowArr objectAtIndex:i]intValue]]objectForKey:@"DiamondIndex"]intValue]];
    }
    
    // NSLog(@"%@",indexes);
    
    [allDiamondsArr removeObjectsAtIndexes:indexes];
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
    
    
    
    
    if ([allDiamondsArr count]==0) {
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
}


-(IBAction)calcBtnTapped:(id)sender{
   // [self.navigationController popViewControllerAnimated:YES];
    [delegate openFileModuleFinished:1];
}

-(IBAction)deleteAllBtnTapped:(id)sender{
   /* if ([allDiamondsArr count]>0) {
               
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
    
    [self.view removeFromSuperview];
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void)alertView:(UIAlertView *)av willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (av.tag==20) {
        if (buttonIndex==0) {
            
        }else{
            if ([allDiamondsArr count]>0) {
                [allDiamondsArr removeAllObjects];        
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
        
        totalCarat+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
        
        avgPricePerCarat+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PricePerCarat"]floatValue];
        avgTotalPrice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PriceTotal"]floatValue];
        avgRapdisc+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"rapPercent"]floatValue];
        avgRapprice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"RapPriceList"]floatValue];
        avgRapTotal+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"TotalRapPriceList"]floatValue];
        totalSize+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
        
        
        
        NSDictionary *dic = [allDiamondsArr objectAtIndex:t];
        
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
               [NSString stringWithFormat:@"%@",[self convertNumberToCommaSeparatedString:[[dic objectForKey:@"TotalRapPriceList"]intValue]]]];
               //rapAvgPercent
               //];
        
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
    }
    
    
    // emailBody1 = [emailBody1 stringByAppendingString:str1];
    NSString *emailBody1 = @"</table><br/>Created By Rapnet";
    
    emailBody = [emailBody stringByAppendingString:str1];
    emailBody = [emailBody stringByAppendingString:emailBody1];
    
	[picker setMessageBody:emailBody isHTML:YES];
    //[delegate clickedButton:TRUE];
    if (picker!=nil) {
        picker.modalPresentationStyle =UIModalPresentationFullScreen;
        picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //  [self presentViewController:picker animated:YES completion:NULL];
        [self presentModalViewController:picker animated:YES];
        //[self addChildViewController:picker];
        //[self.view.window addSubview:picker.view];
        [picker release];
    }
    
	

    /*
    
    //MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    MFMailComposeViewController *picker = [MFMailComposeViewController new];
	picker.mailComposeDelegate = self;
    
	[picker setSubject: @"Diamond Report"];
    
    
    NSString *emailBody = @"Hi, My saved Diamond Report<br/><br/><table border=1><th>ID</th><th>Shape</th><th>Ct.</th><th>Clarity</th><th>Color</th><th>Rap%</th><th>$/Ct.</th><th>$/ttl.</th>";
    
    NSString *str = @"";
    
    float avgPricePerCarat,avgTotalPrice,avgRapdisc,avgRapprice,avgRapTotal,totalCarat, totalSize;
    
    avgPricePerCarat = 0;
    avgTotalPrice = 0;
    avgRapdisc = 0;
    avgRapprice = 0;
    avgRapTotal = 0;
    totalCarat = 0;
    totalSize = 0;
    
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        
        totalCarat+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
        
        avgPricePerCarat+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PricePerCarat"]floatValue];
        avgTotalPrice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"PriceTotal"]floatValue];
        avgRapdisc+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"rapPercent"]floatValue];
        avgRapprice+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"RapPriceList"]floatValue];
        avgRapTotal+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"TotalRapPriceList"]floatValue];
        totalSize+= [[[allDiamondsArr objectAtIndex:t]objectForKey:@"Size"]floatValue];
        
        
        NSDictionary *dic = [allDiamondsArr objectAtIndex:t];
        
        str = [str stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%0.2f</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>",[dic objectForKey:@"ID"],[dic objectForKey:@"Shape"],[[dic objectForKey:@"Size"]floatValue],[dic objectForKey:@"Clarity"],[dic objectForKey:@"Color"],[[dic objectForKey:@"rapPercent"]intValue],[[dic objectForKey:@"PricePerCarat"]intValue],[[dic objectForKey:@"PricePerCarat"]intValue]*[[dic objectForKey:@"Size"]intValue]];
        
    }
    
    
    emailBody = [emailBody stringByAppendingString:str];
    emailBody = [emailBody stringByAppendingString:@"</table>"];
    
    avgPricePerCarat = avgTotalPrice / totalSize;
    
    float rapAvgPercent = ((1.0 - (avgTotalPrice / avgRapTotal)) * 100.0) * (-1.0);
    
    NSString *emailBody1 = @"<br/></br><table border=1><th>No. of Diamonds</th><th>Total Carat</th><th>Avg $/Ct.</th><th>Avg Rap%</th><th>Total Price</th>";
    
    NSString *str1 = @"";
    
    
    if ([selectedRowArr count]!=0) {
        str1 = [str1 stringByAppendingFormat:@"<tr><td>%d</td><td>%0.2f</td><td>%0.2f</td><td>%0.2f</td><td>%0.2f</td></tr>",[selectedRowArr count],totalCarat,avgPricePerCarat,rapAvgPercent,avgRapTotal];
    }
    
    
    emailBody1 = [emailBody1 stringByAppendingString:str1];
    emailBody1 = [emailBody1 stringByAppendingString:@"</table><br/>Created By Rapnet"];
    
    
    emailBody = [emailBody stringByAppendingString:emailBody1];
    
	[picker setMessageBody:emailBody isHTML:YES];
    //[delegate clickedButton:TRUE];
    if (picker!=nil) {
        picker.modalPresentationStyle =UIModalPresentationFullScreen;
        picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //  [self presentViewController:picker animated:YES completion:NULL];
        [self presentModalViewController:picker animated:YES];
        //[self addChildViewController:picker];
        //[self.view.window addSubview:picker.view];
        [picker release];
    }
    */
	
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
        
        
    }else if([allDiamondsArr count]>0){
              
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
    
    //  NSLog(@"Rows = %d %d %d",nRows,d1,d2);
    
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
    [StoredData sharedData].updateFileFlag = TRUE;
    [StoredData sharedData].updateDiamondIndex = [[[allDiamondsArr objectAtIndex:indexPath.row] objectForKey:@"DiamondIndex"]intValue];
    // NSLog(@"%@",[StoredData sharedData].openFileName);
    [StoredData sharedData].openDiamondName = [[allDiamondsArr objectAtIndex:indexPath.row] objectForKey:@"ID"];
    if ([[StoredData sharedData].savedDiamondToupdate count]>0) {
        [[StoredData sharedData].savedDiamondToupdate removeAllObjects];
    }
    [StoredData sharedData].savedDiamondToupdate = [allDiamondsArr objectAtIndex:indexPath.row];
  //  [self.navigationController popViewControllerAnimated:YES];
    
    [delegate openFileModuleFinished:2];
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

-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        [Database deleteDiamondWithIndex:[[[allDiamondsArr objectAtIndex:indexPath.row]objectForKey:@"DiamondIndex"]intValue]];
        
        [allDiamondsArr removeObjectAtIndex:indexPath.row];
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
        
        //  NSLog(@"Selected = %@",selectedRowArr);
        
        [self updateLabels];
        
        if ([allDiamondsArr count]==0) {
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
        
        nRows = [tv numberOfRowsInSection:0];
        for (int i=0; i<nRows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];            
            UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
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
    
    return [allDiamondsArr count];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSDictionary *dic = [allDiamondsArr objectAtIndex:indexPath.row];
        
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
        //lbl.text = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]];
        lbl.text = [Functions getFractionDisplay:[[dic objectForKey:@"Size"] floatValue] format:@"%0.2f"];
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
        //lbl.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"rapPercent"]intValue]];
        lbl.text = [Functions getFractionDisplay:[[dic objectForKey:@"rapPercent"]floatValue] format:@"%.2f"];
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
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 40, 40);
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red-arrow1X.png"]];
    image.frame = CGRectMake(22, 10, 15, 15);
    [button addSubview:image];
    [image release];
    image = nil;
    
    cell.accessoryView = button;
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark showLoginAlertView

-(void)showAlertView
{
    NSMutableArray *arr= [[NSMutableArray alloc]init ];
    for (int i = 0; i<[selectedRowArr count]; i++) {
        int t = [[selectedRowArr objectAtIndex:i]intValue];
        [arr addObject:[allDiamondsArr objectAtIndex:t]];
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
        
        //[Database deleteDiamonds:[Database getDBPath] arg2:[StoredData sharedData].openFileTime];
        [Database deleteDiamonds:[Database getDBPath] arg2:[StoredData sharedData].openFileName];
        
        if ([allDiamondsArr count]>0) {
            [allDiamondsArr removeAllObjects];        
        }
        
        if ([selectedRowArr count]>0) {
            [selectedRowArr removeAllObjects];
        }
        
        [tableView reloadData];
        
        [self updateLabels];
        
        
        
        
        if ([allDiamondsArr count]==0) {
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
            [arr addObject:[allDiamondsArr objectAtIndex:t]];
        }
        
        wamc.dataArr = arr;
        
        [arr release];
        arr = nil;
        
        [self.navigationController pushViewController:wamc animated:YES];
        [wamc release];
        wamc = nil; 
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
            dic = [allDiamondsArr objectAtIndex:t];
            
            int discount = [[dic objectForKey:@"rapPercent"]intValue];
            discount+=value;
            
            float size = [[dic objectForKey:@"Size"]floatValue];
            float rpl = [[dic objectForKey:@"RapPriceList"]floatValue];
            float pricePerCarat = rpl + ((rpl*discount)/100);
            float priceTotal = pricePerCarat*size;
            
            [[allDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
            [[allDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
            [[allDiamondsArr objectAtIndex:t] setObject:[NSNumber numberWithFloat:discount] forKey:@"rapPercent"];
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
    if (CGRectContainsPoint(rapPercentage.frame, location)) {
        if ([allDiamondsArr count]>0) {
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
