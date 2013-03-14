//
//  DiamondDesultDetailsVC.m
//  Rapnet
//
//  Created by Itzik on 19/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "DiamondDesultDetailsVC.h"

@interface DiamondDesultDetailsVC ()

@end



@implementation DiamondDesultDetailsVC

#define TEST_TEXT @"Hellow world, today is monday, yesurday was sunday tomorrow will tuesday";
#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 200.0f
#define CELL_CONTENT_MARGIN 2.0f

CGFloat fixHeight;
@synthesize resultCell, resultCellActions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    [AnalyticHelper sendView:@"Rapnet - DiamondDetails"];
    
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
                
                countReach ++;
                break;
            }
            case ReachableViaWiFi:
            {
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
    // Do any additional setup after loading the view from its nib.
    lblMainTitle.text = @"Diamond Details";
    CGRect f = tblDiamond.frame;
    f.size.height = fixHeight;
    tblDiamond.frame = f;
    
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)] autorelease];
    txtSubject.leftView = paddingView;
    txtSubject.leftViewMode = UITextFieldViewModeAlways;
    
    [self initReachability];
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

-(IBAction)btnBackClicked:(id)sender
{
    // UINavigationController *navC = [AppDelegate getAppDelegate].navigationController;
    // [navC popViewControllerAnimated:YES];
    
   // [[self navigationController] popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}

-(void)loadDiamond:(DiamondSearchResult*)res
{
    result = res;
    [tblDiamond reloadData];
}
#pragma mark - Table view data source

-(void)changeTableHeight:(CGFloat)height
{
    fixHeight = height;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = @"";
    
	if (section == 0) 
    {
        header = @"Diamond Details";
        if([result.lab length] > 0)
            header = [NSString stringWithFormat:@"%@ %@", [self getLabValue], [self getCertNumberValue]];
    }
    else if(section == 1)
        header = @"Additional Information";
    else if(section == 2)
        header = [NSString stringWithFormat:@"Lot #:%@", [self getDiamondIdValue]];
    else if(section == 3) 
        header = [NSString stringWithFormat:@"%@", result.company];
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    //return results.count;
    
    if (section == 0) {
        if(result.isFancy == NO)
            return 21;
        else
            return 22;
    }
    else if(section == 1)
        return 5;
    else if(section == 2)
        return 7;
    else if(section == 3)
        return 8;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 4)
    {
        static NSString *cellActionsIdentifier = @"cellActions";
        cellActions = (DiamondResultDetailsActions *)[tableView dequeueReusableCellWithIdentifier:cellActionsIdentifier];
        
        if (cellActions == nil){
            [[NSBundle mainBundle] loadNibNamed:@"DiamondResultDetailsActions" owner:self options:nil];
            cellActions = resultCellActions;
            self.resultCellActions = nil;
            
                        
            
            
            //[btnSms setImage:[UIImage imageNamed:@"sms32BW.png"] forState:UIControlStateNormal];
            
            if ((result.tel1 == nil || result.tel1.length == 0) && (result.tel2 == nil || result.tel2.length == 0)) {
                btnSms.enabled = NO;
                btnTel.enabled = NO;
            }
            
            if(result.email == nil || result.email.length == 0)
                btnEmail.enabled = NO;
            
            if(result.imageFile == nil || result.certificateLink.length == 0 || [[result.certificateLink substringToIndex:4] isEqualToString:@"http"] == NO)
                btnImage.enabled = NO;
            
            if(result.certificateLink == nil || result.certificateImage.length == 0 || [[result.certificateImage substringToIndex:4] isEqualToString:@"http"] == NO)
                btnCert.enabled = NO;
        }
        cellActions.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellActions;
    }
    
    static NSString *CellIdentifier = @"ApplicationCell";
	cell = (DiamondResultDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil){
		[[NSBundle mainBundle] loadNibNamed:@"DiamondResultDetailCell" owner:self options:nil];
		cell = resultCell;
		self.resultCell = nil;
	}
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //DiamondFields field;// = indexPath.row;
    NSString *title = @"-";
    NSString *value = @"";

    //field = DF_LotID; 
    int curRow = indexPath.row;
    
    if(result.isFancy == NO && curRow > DF_Color)
        curRow++;
    
    if(indexPath.section == 0)
    {
        switch (curRow) {
            case DF_Shape:
                title = @"Shape";
                value = [self getShapeValue];
                break;
            case DF_Size:
                title = @"Size";
                
                value = [self getSizeValue];
                break;
           
            case DF_Color:
                title = @"Color";
                value = [self getColorValue];
                break;
            case DF_FancyOvertone:
                title = @"Overtones";
                value = [self getFancyOvertonesValue];
                break;
            case DF_Clarity:
                title = @"Clarity";
                value = [self getClarityValue];
                break;
            case DF_Cut:
                title = @"Cut";
                value = [self getCutValue];
                break;
            case DF_Polish:
                title = @"Polish";
                value = [self getPolishValue];
                break;
            case DF_Symmetry:
                title = @"Symmetry";
                value = [self getSymmetryValue];
                break;
            case DF_Fluorescence:
                title = @"Fluorescence";
                value = [self getFluorescenceValue];
                break;
            case DF_Depth:
                title = @"Depth";
                value = [self getDepthValue];
                break;
            case DF_Table:
                title = @"Table";
                value = [self getTableValue];
                break;
            case DF_ReportDate:
                title = @"Report date";
                value = [self getReportDateValue];
                break;
            case DF_Measurements:
                title = @"Measurements";
                value = [self getMeasurementsValue];
                break;
            case DF_Culet:
                title = @"Culet";
                value = [self getCuletValue];
                break;
            case DF_Girdle:
                title = @"Girdle";
                value = [self getGirdleValue];
                break;
            case DF_Crown:
                title = @"Crown";
                value = [self getCrownValue];
                break;
            case DF_Pavilion:
                title = @"Pavilion";
                value = [self getPavilionValue];
                break;
            case DF_Treatment:
                title = @"Treatment";
                value = [self getTreatmentValue];
                break;
            case DF_Inscription:
                title = @"Inscription";
                value = [self getInscriptionValue];
                break;
            case DF_Ratio:
                title = @"Ratio";
                value = [self getRatioValue];
                break;
            case DF_StarLength:
                title = @"Star Length";
                value = [self getStarLengthValue];
                break;
            case DF_Comment:
                title = @"Comment";
                value = [self getCertCommentValue];
                //value = TEST_TEXT;
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case AF_Center:
                title = @"Center inclusion";
                value = [self getCenterInclusionValue];
                break;
            case AF_Black:
                title = @"Black inclusion";
                value = [self getBlackInclusion];
                break;
            case AF_Shade:
                title = @"Shade";
                value = [self getShadeValue];
                break;
            case AF_Location:
                title = @"Lab Location";
                value = [self getLabLocation];
                break;
            case AF_Comment:
                title = @"Member comment";
                value = [self getMemberComment];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 2)
    {
        switch (indexPath.row) {
            case LF_Stock:
                title = @"Stock#";
                value = [self getVendorStockNumberValue];
                break;
            case LF_Updated:
                title = @"Updated";
                value = [self getUpdatedValue];
                break;
            case LF_Availability:
                title = @"Availability";
                value = [self getAvailabilityValue];
                break;
            case LF_Location:
                title = @"Location";
                value = [self getLotLocationValue];
                break;
            case LF_Price:
                //Price: Rap -30.2% $/ct 400
                //Total Price $450
                
                title = @"Price";
                value = [self getPriceValue];
                
                break;
            case LF_PriceTotal:
                title = @"Total Price";
                value =  [self getPriceTotalValue];
                break;
            case LF_CashPricePerCarat:
                title = @"Cash Price/ct";
                value = [self getCashPricePerCaratValue];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case SF_RapID:
                title = @"RapID/Code";
                value = [self getRapSellerIDValue];
                break;
            case SF_Name:
                title = @"Name";
                value = [self getSellerNameValue];
                break;
            
            case SF_Tel1:
                title = @"Telephone";
                //result.tel1 = @"+972546644724";
                value = [self getTel1Value];
                
                break;
            case SF_Tel2:
                title = @"Telephone";
                //result.tel2 = @"+97229920334";
                value = [self getTel2Value];
                
                break;
            case SF_Fax:
                title = @"Fax";
                value = value = [self getFaxValue];
                break;
            case SF_Email:
                title = @"Email";
                value = value = [self getEmailValue];;
                break;
            case SF_Location:
                title = @"Location";
                value = [self getLocationValue];
                break;
            case SF_Rating:
                title = @"Rating";
                value = [self getRatingValue];
                break;
                
            default:
                break;
        }
    }

    lblTitle.text = title;
    lblValue.text = value;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//for pull to refresh
	/*if (indexPath.row==0){
     return 0;
     }*/
    
    if(indexPath.section == 4)
        return 45;
    
    NSString *text = nil;
    int curRow = indexPath.row;
    
    if(result.isFancy == NO && curRow > DF_Color)
        curRow++;
    
    if(indexPath.section == 1 && curRow == AF_Comment)
    {
        text = result.memberComment;
    }
    else if(indexPath.section == 0 && curRow == DF_Comment)
    {
        text = result.certComment;
        //text = TEST_TEXT;
    }
    
    
    
    if(text != nil && [text isEqualToString:@""] == false)
    {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
        CGFloat height = MAX(size.height, 44.0f);
    
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    return 26;
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
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
        return;
    
    NSString *t;
    if(buttonIndex == 0)
        t = result.tel1;
    else if(buttonIndex == 1)
        t = result.tel2;
    
    t = [t stringByReplacingOccurrencesOfString:@" " withString:@""];
    t = [t stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if(isSmsAction)
    {
        [self sendSMS:t];
        //NSString *sms = [NSString stringWithFormat:@"sms:%@", t];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:sms]];
    }
    else
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: [NSString stringWithFormat: @"tel:%@", t]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(IBAction) btnSmsClicked:(id)sender
{
    isSmsAction =YES;
    
   
    if(result.tel1.length > 2 && result.tel2.length > 2)
    {
        UIActionSheet* actionSheet = nil;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:result.tel1,result.tel2, nil ];
        //chkActnSheet=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[self.view window]];
        [actionSheet release];
    }

    else if(result.tel1.length > 2 || result.tel2.length > 2)
    {
        NSString *t = result.tel1.length > 2 ? result.tel1 : result.tel2;
        
        t = [t stringByReplacingOccurrencesOfString:@" " withString:@""];
        t = [t stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [self sendSMS:t];
        /*MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:t, nil];
        [picker setRecipients:toRecipients];

        [self presentModalViewController:picker animated:YES];
        [picker release];*/
        //NSString *sms = [NSString stringWithFormat:@"sms:%@", t];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:sms]];
    }

    
}

-(void)sendSMS:(NSString*)tel
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObjects:tel, nil];
    [picker setBody:[NSString stringWithFormat: @"I am interested in your diamond, stock number %@ from RapNet", [self getVendorStockNumberValue]]];
    [picker setRecipients:toRecipients];
    
    [self presentModalViewController:picker animated:YES];
   // [picker release];
}

-(IBAction) btnTelClicked:(id)sender
{
    isSmsAction = NO;
    
    if(result.tel1.length > 2 && result.tel2.length > 2)
    {
        UIActionSheet* actionSheet = nil;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:result.tel1,result.tel2, nil ];
        //chkActnSheet=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[self.view window]];
        [actionSheet release];
    }
    
    else if(result.tel1.length > 2 || result.tel2.length > 2)
    {
        NSString *t = result.tel1.length > 2 ? result.tel1 : result.tel2;
        
        t = [t stringByReplacingOccurrencesOfString:@" " withString:@""];
        t = [t stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSURL *url = [ [ NSURL alloc ] initWithString: [NSString stringWithFormat: @"tel:%@", t]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(IBAction)btnCancelClicked:(id)sender
{
    
    
    vNotifySeller.hidden = YES;
    [self resetNotifySeller];
}

-(IBAction)btnNotifySellerClicked:(id)sender
{
    [self showNotifySeller];
}

-(IBAction)btnOkClicked:(id)sender
{
    if(isReachable == NO)
    {
        [Functions NoInternetAlert];
        return;
    }
    vNotifySeller.hidden = YES;
    NSString *msg = @"\n\nMessage Sent";
    //[self displayComposerSheet:result.email];
    NotifySeller *ns = [[NotifySeller alloc] init];
    //[ns notify:@"41337840" body:@" "];
    BOOL res = [ns notify:[self getDiamondIdValue] body:txtMessage.text subject:txtSubject.text reference: txtReference.text];
    //BOOL res = [ns notify:@"41337840" body:txtMessage.text subject:txtSubject.text reference: txtReference.text];
    
    if(res == NO)
        msg = @"\n\nMessage Wasn't Sent";
    
    alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];
    theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    CGSize theSize = [alert frame].size;
    
    UIGraphicsBeginImageContext(theSize);
    [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    for (UIView *sub in [alert subviews])
    {
        if ([sub class] == [UIImageView class] && sub.tag == 0) {
            [sub removeFromSuperview];
            break;
        }
    }
    [[alert layer] setContents:(id)theImage.CGImage];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target: self selector:@selector(theTimer:)userInfo:nil repeats:NO];
    //[ns notify:@"41337840"];
    //[ns notify:@"41337840" from:@"i@i-k.co.il" body:@"Body data" subject:@"Results of Email Notification" reference:@"Reference data"];

}

-(IBAction)btnEmailClicked:(id)sender
{
    //[self displayComposerSheet:result.email];
    [self showNotifySeller];
}

- (void)theTimer:(NSTimer*)timer
{
	[alert dismissWithClickedButtonIndex:0 animated:YES];
	[theTimer invalidate];
	[theTimer release];
}

-(void)displayComposerSheet:(NSString*)email
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	//[picker setSubject:@"Hello iPhone!"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObjects:email, nil];
    NSString *body;
    body = [NSString stringWithFormat:@""
        "Hi, <br/><br/>I am interested in the following diamonds which you have listed on the "
        "RapNet Diamond Trading network at <a href='http://www.Rapnet.com'>http://www.Rapnet.com.</a>"
        "<table>"
            "<tr><td>Lot#:</td><td>%@</td></tr>"
            "<tr><td>Stock#:</td><td>%@</td></tr>"
            "<tr><td>Shape:</td><td>%@</td></tr>"
            "<tr><td>Size:</td><td>%@</td></tr>"
            "<tr><td>Color:</td><td>%@</td></tr>"
            "<tr><td>Clarity:</td><td>%@</td></tr>"
            "<tr><td>Cut:</td><td>%@</td></tr>"
            "<tr><td>Pol:</td><td>%@</td></tr>"
            "<tr><td>Sym:</td><td>%@</td></tr>"
            "<tr><td>Lab:</td><td>%@</td></tr>"
            "<tr><td>Fluor.:</td><td>%@</td></tr>"
            "<tr><td>Depth:</td><td>%@</td></tr>"
            "<tr><td>Table:</td><td>%@</td></tr>"
            "<tr><td>Meas.:</td><td>%@</td></tr>"
            "<tr><td>Cert#:</td><td>%@</td></tr>"
            "<tr><td>Price:</td><td>%@</td></tr>"
            "<tr><td>Price Total:</td><td>%@</td></tr>"
        "</table>",
        [self getDiamondIdValue],
        [self getVendorStockNumberValue],
        [self getShapeValue],
        [self getSizeValue],
        [self getColorValue],
        [self getClarityValue],
        [self getCutValue],
        [self getPolishValue],
        [self getSymmetryValue],
        [self getLabValue],
        [self getFluorescenceValue],
        [self getDepthValue],
        [self getTableValue],
        [self getMeasurementsValue],
        [self getCertNumberValue],
        [self getPriceValue],
        [self getPriceTotalValue]
        ];
    body = [body stringByAppendingString:@"<br/>Member comment: Interested<br/>"];
    body = [body stringByAppendingString:@"<br/>Thank You.<br/>"];
    /*
     
     Member comment: Interested
     
     Please call me at + (1) 800 -205-9061 ext 144
     
     Thank You.
     
     Saville Stern Rapaport Account ID: 43713
     */
	//NSString *emailBody = @"Nice  to See you!";
	[picker setMessageBody:body isHTML:YES];
	[picker setToRecipients:toRecipients];
	[self presentModalViewController:picker animated:YES];
	//[picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    /*feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            feedbackMsg.text = @"Result: SMS not sent";
            break;
    }*/
    [self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	/*NSString *msg = @"";
     
     // Notifies users about errors associated with the interface
     switch (result)
     {
     case MFMailComposeResultCancelled:
     msg = @"Result: canceled";
     break;
     case MFMailComposeResultSaved:
     msg = @"Result: saved";
     break;
     case MFMailComposeResultSent:
     msg = @"Result: sent";
     break;
     case MFMailComposeResultFailed:
     msg = @"Result: failed";
     break;
     default:
     msg = @"Result: not sent";
     break;
     }*/
    
    /*
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Mahar" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [v show];
     [v release];*/
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnCertClicked:(id)sender
{
    //NSString *str = [NSString stringWithFormat:@"http://www.rapnet.com/rapnet/search/getimagefile.aspx?lotid=%@&filetype=CERT", result.diamondID];
    [self openImage:result.certificateImage];
}

-(IBAction)btnImageClicked:(id)sender
{
    //NSString *str = [NSString stringWithFormat:@"http://www.rapnet.com/rapnet/search/getimagefile.aspx?lotid=%@&filetype=CERT", result.diamondID];
    [self openImage:result.certificateLink];
}

-(void)openImage:(NSString*)urlString
{
    if (urlString.length == 0 || [[urlString substringToIndex:4] isEqualToString:@"http"] == NO) {
        return;
    }
    WebSiteController *website=[[WebSiteController alloc]initWithNibName:@"WebSiteController" bundle:nil];
	//website.chkUrl = YES;
    
    website.strUrl = urlString;
    
	//[[self navigationController] pushViewController:website animated:YES];
	[self.view addSubview:website.view];
	//[website release];
	//website = nil;
}

-(void)showNotifySeller
{
    [self resetNotifySeller];
    vNotifySeller.hidden = NO;
}

-(void)resetNotifySeller
{
    txtSubject.text = @"Your listing on RapNet";
    txtMessage.text = @"";
    txtReference.text = @"";
}

-(NSString*)getShapeValue
{
    return result.shape;
}

-(NSString*)getSizeValue
{
    float f = [result.weight floatValue];
    return [Functions getFractionDisplay:f format:@"%.2f"];
}

-(NSString*)getColorValue
{
    NSString *value = @"", *intensity, *color;
    
    if(result.isFancy == NO)
        value = result.color;
    else
    {
        
        if(result.fancyColor1 != nil && result.fancyColor1.length > 0 && result.fancyColor2 != nil && result.fancyColor2.length > 0)
        {
            color = [NSString stringWithFormat:@"%@-%@", result.fancyColor1, result.fancyColor2];
        }
        else if(result.fancyColor1 != nil && result.fancyColor1.length > 0)
        {
            color = [NSString stringWithFormat:@"%@", result.fancyColor1];
        }
        else if(result.fancyColor2 != nil && result.fancyColor2.length > 0)
        {
            color = [NSString stringWithFormat:@"%@", result.fancyColor2];
        }
        if (result.fancyColorIntensity != nil && result.fancyColorIntensity.length > 0) {
            intensity = [NSString stringWithFormat:@"%@ ", result.fancyColorIntensity];
        }
        value = [NSString stringWithFormat:@"%@%@", intensity, color];
        
    }
    return value;
}

-(NSString*)getFancyOvertonesValue
{
    return result.fancyColorOvertones;
}

-(NSString*)getClarityValue
{
    return result.clarity;
}

-(NSString*)getCutValue
{
    return result.cut;
}

-(NSString*)getPolishValue
{
    return result.polish;
}

-(NSString*)getSymmetryValue
{
    return result.symmetry;
}

-(NSString*)getFluorescenceValue
{
    return [NSString stringWithFormat:@"%@ %@", result.fluorescenceIntensity, result.fluorescenceColor];
}

-(NSString*)getDepthValue
{
    NSString *value = @"";
    if ([result.depthPercent floatValue] != 0) {
        value = [NSString stringWithFormat:@"%@%%", [Functions fixNumberFormat: result.depthPercent]];
    }
    return value;
}

-(NSString*)getTableValue
{
    float f = [result.tablePercent floatValue];
    NSString *value = @"";
    
    if(f != 0)
        value = [Functions getFractionDisplay:f format:@"%.1f%%"];
    return value;
}

-(NSString*)getReportDateValue
{
    NSString *value = @"";
    
    if(result.reportDate != nil && result.reportDate.length > 4)
        value = [Functions dateFormat:result.reportDate format:@"MMMM dd, yyyy"];
    
    return value;
}

-(NSString*)getMeasurementsValue
{
    NSString *p, *value = @"";
    if([result.shape isEqualToString:@"Round"])
        p = @"-";
    else {
        p = @"x";
    }
    
    if([result.measLength intValue] != 0 && [result.measDepth intValue] != 0 && [result.measWidth intValue] != 0)
        value = [NSString  stringWithFormat:@"%@ %@ %@ x %@", [Functions fixNumberFormat: result.measLength], p, [Functions fixNumberFormat: result.measWidth], [Functions fixNumberFormat: result.measDepth]];
    return value;
}

-(NSString*)getCuletValue
{
    return result.culetCondition;
}

-(NSString*)getGirdleValue
{
    return result.girdleMinSize;
}

-(NSString*)getCrownValue
{
    NSString *value = @"";
    
    if ([result.crownAngle intValue] != 0 && [result.crownHeight intValue] != 0) {
        value = [NSString stringWithFormat:@"%@\u00B0, %@%%", [Functions fixNumberFormat: result.crownAngle], [Functions fixNumberFormat: result.crownHeight]];
    }
    else if([result.crownAngle intValue] != 0)
        value = [NSString stringWithFormat:@"%@\u00B0", [Functions fixNumberFormat: result.crownAngle]];
    else if([result.crownHeight intValue] != 0)
        value = [NSString stringWithFormat:@"%@%%", [Functions fixNumberFormat: result.crownHeight]];
    
    return value;
}

-(NSString*)getPavilionValue
{
    NSString *value = @"";
    
    if ([result.pavilionAngle intValue] != 0 && [result.pavilionDepth intValue] != 0) {
        value = [NSString stringWithFormat:@"%@\u00B0, %@%%", [Functions fixNumberFormat: result.pavilionAngle], [Functions fixNumberFormat: result.pavilionDepth]];
    }
    else if([result.pavilionAngle intValue] != 0)
        value = [NSString stringWithFormat:@"%@\u00B0", [Functions fixNumberFormat: result.pavilionAngle]];
    else if([result.pavilionDepth intValue] != 0)
        value = [NSString stringWithFormat:@"%@%%",[Functions fixNumberFormat: result.pavilionDepth]];
    
    return value;
}

-(NSString*)getTreatmentValue
{
    return result.treatment;
}

-(NSString*)getInscriptionValue
{
    return result.laserInscription;
}

-(NSString*)getRatioValue
{
    return [Functions fixNumberFormat: result.ratio];
}

-(NSString*)getStarLengthValue
{
    return [Functions fixNumberFormat: result.starLength];
}

-(NSString*)getCertCommentValue
{
    return result.certComment;
}

-(NSString*)getCenterInclusionValue
{
    return result.centerInclusion;
}

-(NSString*)getBlackInclusion
{
    return result.blackInclusion;
}

-(NSString*)getShadeValue
{
    return result.shade;
}

-(NSString*)getLabLocation
{
    return result.labLocation;
}

-(NSString*)getMemberComment
{
    return result.memberComment;
}

-(NSString*)getVendorStockNumberValue
{
    return result.vendorStockNumber;
}

-(NSString*)getUpdatedValue
{
    return [Functions dateFormat:result.dateUpdated format:@"MMMM dd, yyyy"];
}


-(NSString*)getAvailabilityValue
{
    return result.availability;
}

-(NSString*)getLotLocationValue
{
    return result.lotLocation;
}

-(NSString*)getPriceValue
{
    NSString *value = @"", * rapPercent = @"";
    NSString * pricePerCarat = @"";
    
    if ([result.lowestDiscount floatValue] != 0) {
        //rapPercent = [NSString stringWithFormat: @"%.1f", [result.lowestDiscount floatValue] * 100];
        rapPercent = [Functions getFractionDisplay:[result.lowestDiscount floatValue] * 100 format:@"%.1f"];
        
        rapPercent = [NSString stringWithFormat: @"Rap %@%%", rapPercent];
    }
    
    if([result.pricePerCarat intValue] != 0)
    {
        pricePerCarat = [NSString stringWithFormat: @"$/ct %@", [Functions numberWithComma:[result.pricePerCarat intValue]]];
    }
    
    
    value =  [NSString stringWithFormat: @"%@  %@", rapPercent, pricePerCarat];
    
    return value;
}

-(NSString*)getPriceTotalValue
{
    NSInteger tot;
    NSString *t = @"";
    
    tot = [result.lowestTotalPrice intValue];
    if(tot != 0)
    {
        t = [NSString stringWithFormat: @"$%@", [Functions numberWithComma:tot]];
    }
    NSString *value =  [NSString stringWithFormat: @"%@", t];
    return value;
}

-(NSString*)getCashPricePerCaratValue
{
    return [NSString stringWithFormat:@"%@", [Functions numberWithComma:[result.cashPricePerCarat intValue]]];
}

-(NSString*)getRapSellerIDValue
{
    NSString *value = @"";
    if(result.sellerNameCode != nil && result.sellerNameCode.length > 0)
        value = [NSString stringWithFormat:@"%@, %@", result.accountID, result.sellerNameCode];
    else
        value = result.accountID;
    return value;
}

-(NSString*)getSellerNameValue
{
    return [NSString stringWithFormat:@"%@ %@", result.firstName, result.lastName];
}

-(NSString*)getTel1Value
{
    return [NSString stringWithFormat:@"%@", result.tel1];
}

-(NSString*)getTel2Value
{
    return [NSString stringWithFormat:@"%@", result.tel2];
}

-(NSString*)getFaxValue
{
    return [NSString stringWithFormat:@"%@", result.fax];
}

-(NSString*)getEmailValue
{
    return [NSString stringWithFormat:@"%@", result.email];
}

-(NSString*)getLocationValue
{
    return [NSString stringWithFormat: @"%@, %@", result.country, result.city];
}

-(NSString*)getRatingValue
{
    NSString *value = @"";
    float r  = [result.ratingPercent floatValue] * 100;
    if(r > 0)
    {
        value = [Functions getFractionDisplay:r format:@"%.2f%%"];
        value = [NSString stringWithFormat:@"%@ / %@", value, result.totalRating];
        //value = [NSString stringWithFormat:@"%.2f%% / %@", r, result.totalRating];
    }
    return value;
}

-(NSString*)getDiamondIdValue
{
    return result.diamondID;
}

-(NSString*)getLabValue
{
    return result.lab;
}

-(NSString*)getCertNumberValue
{
    return result.certificateNumber;
}

-(void)resignTextFields
{
    [txtSubject resignFirstResponder];
    [txtMessage resignFirstResponder];
    [txtReference resignFirstResponder];
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
        //[self addToMainViewContentSize:0 h:-50];
        //[self scrolDown:svMain scrollAmount:180];
		//[self setViewMovedUp:NO coordinateY:0];
		
	}
    else if(textField.tag == 3 || textField.tag == 4)
    {
        lastTextField = nil;
        //[self addToMainViewContentSize:0 h:-250];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
 
    
    CGPoint bottomOffset = CGPointMake(0, 130);
    [svNotifySellerContent setContentOffset:bottomOffset animated:YES];
    isKeyBoardDown = NO;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint bottomOffset = CGPointMake(0, 0);
    [svNotifySellerContent setContentOffset:bottomOffset animated:YES];
}



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
            //[self addToMainViewContentSize:0 h:50];
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
            //[self addToMainViewContentSize:0 h:250];
            //[svNotifySellerContent sc]
            [self scrolUp:svNotifySellerContent scrollAmount:180];
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
    /*if (isKeyBoardDown == NO) {
        [txtReference resignFirstResponder];
        isKeyBoardDown = YES;
    }*/
    
}
@end
