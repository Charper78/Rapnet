//
//  CustomSaveDiamondAlert.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomSaveDiamondAlert.h"


@implementation CustomSaveDiamondAlert

@synthesize msgLbl,addBtn,cancelBtn,idDiamond,delegate,savedDiamonds,popUPView;

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
    [popUPView release];
    [savedDiamonds release];
    [idDiamond release];
	[msgLbl release];
	[addBtn release];
	[cancelBtn release];
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
    
    //  NSLog(@"%@",savedDiamonds);
    [idDiamond becomeFirstResponder];
}


-(IBAction)addBtn:(id)sender
{
	idName = idDiamond.text;     
    
    NSArray *listItems = [idName componentsSeparatedByString:@" "];
    
    if ([idDiamond.text length]==0|| ([listItems count]==[idDiamond.text length]+1)) {
        
        self.view.hidden =YES;
        [idDiamond resignFirstResponder];
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the valid File name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
        
        if ([self checkSameName:idName]) {
            popUPView.hidden = YES;
            msgLbl.hidden = YES;
            idDiamond.hidden = YES;
            addBtn.hidden = YES;
            cancelBtn.hidden = YES;
            
            
            [idDiamond resignFirstResponder];
            alertSameName=[[CustomSameNameDiamondAlert alloc]initWithNibName:@"CustomSameNameDiamondAlert" bundle:nil];
            alertSameName.delegate = self;                
            [self.view addSubview:alertSameName.view];
            [alertSameName setMsg:@"File with same name already exists. Do you want to continue with the same name?"];
            [self initialDelayEnded];
        }else{
            NSDictionary *dic;
            NSString *fileName,*time;
            
            fileName = idName;
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
            
            
            NSString *date = [NSString stringWithFormat:@"%0.2d-%0.2d-%0.2d",[components month],[components day],[components year]];    
            NSString *ctime = [NSString stringWithFormat:@"%0.2d:%0.2d",[components hour],[components minute]];
            
            
            time = [NSString stringWithFormat:@"%@",date];
            
            NSString *dbPath = [Database getDBPath];
            
            for (int i = 0; i<[savedDiamonds count]; i++) {
                dic = [savedDiamonds objectAtIndex:i];
                [Database insertDiamonds:dbPath fileName:fileName time:time ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
            }
            
            
            self.view.hidden =YES;
            //  [self.view removeFromSuperview];
            [delegate alertSaveDiamondFinished:1];
        }        
        
    }
    
        
}



-(IBAction)cancelBtn:(id)sender
{
	self.view.hidden =YES;
    [delegate alertSaveDiamondFinished:2];
}

-(BOOL)checkSameName:(NSString *)str{
    [Database fetchDiamonds:[Database getDBPath]];
    NSArray *arr = [StoredData sharedData].dbSavedDiamondsArr;
    NSString *str1;
    for (int i = 0; i<[arr count]; i++) {
        str1 = [[[arr objectAtIndex:i]objectAtIndex:0] objectForKey:@"FileName"];
        //  NSLog(@"S===%@",str1);
        if ([str1 isEqualToString:str]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    idName = idDiamond.text;    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.view.hidden = NO;
        [idDiamond setText:@""];
        [idDiamond becomeFirstResponder];
    }
}

#pragma mark  Animate a Custome Alert View
-(void)initialDelayEnded
{
	alertSameName.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
	alertSameName.view.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	alertSameName.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	alertSameName.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	alertSameName.view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}



-(void)alertSameNameDiamondFinished:(int)type{
    [alertSameName.view removeFromSuperview];		
	[alertSameName release]; 
    
    if (type==1) {
        
        idName = idDiamond.text;
        
        
        NSArray *listItems = [idName componentsSeparatedByString:@" "];
        
        if ([idDiamond.text length]==0|| ([listItems count]==[idDiamond.text length]+1)) {
            
            self.view.hidden =YES;
            [idDiamond resignFirstResponder];
            
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the valid ID" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
            NSDictionary *dic;
            NSString *fileName,*time;
            
            fileName = idName;
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
            
            
            NSString *date = [NSString stringWithFormat:@"%0.2d-%0.2d-%0.2d",[components month],[components day],[components year]];    
            NSString *ctime = [NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d",[components hour],[components minute],[components second]];
            
            
            time = [NSString stringWithFormat:@"%@",date];
            
            NSString *dbPath = [Database getDBPath];
            
            for (int i = 0; i<[savedDiamonds count]; i++) {
                dic = [savedDiamonds objectAtIndex:i];
                [Database insertDiamonds:dbPath fileName:fileName time:time ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
            }
            
            
            self.view.hidden =YES;
            //  [self.view removeFromSuperview];
            [delegate alertSaveDiamondFinished:1];
        }
        
        
    }else if(type==2){
        
        popUPView.hidden = NO;
        msgLbl.hidden = NO;
        idDiamond.hidden = NO;
        addBtn.hidden = NO;
        cancelBtn.hidden = NO;
        
        [idDiamond setText:@""];
        [idDiamond becomeFirstResponder];
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
	return YES;
}

@end
