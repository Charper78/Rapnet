//
//  CustomAlertViewCOntroller.m
//  Rapnet
//
//  Created by Nikhil Bansal on 6/8/11.
//  Copyright 2011 Emantras. All rights reserved.
//


#import "CustomAlertAddDiamondViewCOntroller.h"



@implementation CustomAlertAddDiamondViewController
@synthesize msgLbl,addBtn,cancelBtn,idDiamond,delegate,popUPView;
@synthesize shape,clarity,color,discount,avgPrice,avgDiscount,bestPrice,bestDiscount,size,rapPriceList,totalRapPrice,priceTotal,pricePerCarat;

-(void)viewDidLoad 
{
    [super viewDidLoad];
    // NSLog(@"text = %@",idDiamond.text);
    if ([StoredData sharedData].calcFromWAFlag) {
        
        [idDiamond setText:[[[StoredData sharedData].savedDiamondsArr objectAtIndex:[StoredData sharedData].WAEditRowIndex]objectForKey:@"ID"]];
    }else if([StoredData sharedData].updateFileFlag){
        [idDiamond setText:[StoredData sharedData].openDiamondName];
    }
    
    [idDiamond becomeFirstResponder];
    idDiamond.autocapitalizationType = UITextAutocapitalizationTypeSentences;
}

-(IBAction)addBtn:(id)sender
{
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
            [alertSameName setMsg:@"Diamond with same ID already exists. Do you want to continue with the same ID?"];
            [self initialDelayEnded];
        }else{
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:shape forKey:@"Shape"];
            [dic setObject:clarity forKey:@"Clarity"];
            [dic setObject:color forKey:@"Color"];
            [dic setObject:idName forKey:@"ID"];
            [dic setObject:[NSNumber numberWithFloat:rapPriceList] forKey:@"RapPriceList"];
            [dic setObject:[NSNumber numberWithFloat:totalRapPrice] forKey:@"TotalRapPriceList"];
            [dic setObject:[NSNumber numberWithFloat:discount] forKey:@"rapPercent"];
            [dic setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
            [dic setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
            [dic setObject:[NSNumber numberWithFloat:avgDiscount] forKey:@"AvgDiscount"];
            [dic setObject:[NSNumber numberWithFloat:avgPrice] forKey:@"AvgPrice"];
            [dic setObject:[NSNumber numberWithFloat:bestDiscount] forKey:@"BestDiscount"];
            [dic setObject:[NSNumber numberWithFloat:bestPrice] forKey:@"BestPrice"];
            [dic setObject:[NSNumber numberWithFloat:size] forKey:@"Size"];
            
            if ([StoredData sharedData].calcFromWAFlag) {
                
                [Database updateWorkAreaDiamond:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]] diamondIndex:[StoredData sharedData].updateWADiamondIndex];
                
                //  NSLog(@"Dic = %@",dic);
                
                 [[StoredData sharedData].savedDiamondsArr replaceObjectAtIndex:[StoredData sharedData].WAEditRowIndex withObject:dic];
            }else if([StoredData sharedData].updateFileFlag){
                // NSLog(@"%@",[StoredData sharedData].openFileName);
                [Database updateDiamond:[Database getDBPath] fileName:[StoredData sharedData].openFileName time:[StoredData sharedData].openFileTime ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]] diamondIndex:[StoredData sharedData].updateDiamondIndex];
            }else if([StoredData sharedData].saveCalcFlag){
                [Database insertDiamonds:[Database getDBPath] fileName:[StoredData sharedData].openFileName time:[StoredData sharedData].openFileTime ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
            }else{
                
                
                int diamondIndex = [Database insertWorkAreaDiamonds:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
                [dic setObject:[NSString stringWithFormat:@"%d", diamondIndex] forKey:@"DiamondIndex"];
                
                //  [Database fetchWorkAreaDiamonds];
                
                 [[StoredData sharedData].savedDiamondsArr addObject:dic];
            }
            
            
            //  NSLog(@"Diamond = %@",dic);
            
            [dic release];
            dic = nil;
            
            self.view.hidden =YES;
            [delegate alertAddDiamondFinished:1];
        }        
        
    }
    
    
    
}



-(IBAction)cancelBtn:(id)sender
{
	self.view.hidden =YES;
    [delegate alertAddDiamondFinished:2];
}

-(BOOL)checkSameName:(NSString *)str{
    NSArray *arr = [StoredData sharedData].savedDiamondsArr;
    NSString *str1;
    for (int i = 0; i<[arr count]; i++) {
        str1 = [[arr objectAtIndex:i]objectForKey:@"ID"];
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
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:shape forKey:@"Shape"];
            [dic setObject:clarity forKey:@"Clarity"];
            [dic setObject:color forKey:@"Color"];
            [dic setObject:idName forKey:@"ID"];
            [dic setObject:[NSNumber numberWithFloat:rapPriceList] forKey:@"RapPriceList"];
            [dic setObject:[NSNumber numberWithFloat:totalRapPrice] forKey:@"TotalRapPriceList"];
            [dic setObject:[NSNumber numberWithFloat:discount] forKey:@"rapPercent"];
            [dic setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
            [dic setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
            [dic setObject:[NSNumber numberWithFloat:avgDiscount] forKey:@"AvgDiscount"];
            [dic setObject:[NSNumber numberWithFloat:avgPrice] forKey:@"AvgPrice"];
            [dic setObject:[NSNumber numberWithFloat:bestDiscount] forKey:@"BestDiscount"];
            [dic setObject:[NSNumber numberWithFloat:bestPrice] forKey:@"BestPrice"];
            [dic setObject:[NSNumber numberWithFloat:size] forKey:@"Size"];
            
            if ([StoredData sharedData].calcFromWAFlag) {
                [Database updateWorkAreaDiamond:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]] diamondIndex:[StoredData sharedData].updateWADiamondIndex];
                
                
                [[StoredData sharedData].savedDiamondsArr replaceObjectAtIndex:[StoredData sharedData].WAEditRowIndex withObject:dic];
            }else if([StoredData sharedData].updateFileFlag){
                NSLog(@"%@",[StoredData sharedData].openFileName);
                [Database updateDiamond:[Database getDBPath] fileName:[StoredData sharedData].openFileName time:[StoredData sharedData].openFileTime ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]] diamondIndex:[StoredData sharedData].updateDiamondIndex];
            }else if([StoredData sharedData].saveCalcFlag){
                [Database insertDiamonds:[Database getDBPath] fileName:[StoredData sharedData].openFileName time:[StoredData sharedData].openFileTime ID:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
            }else{
               
                
            int diamondIndex = [Database insertWorkAreaDiamonds:[dic objectForKey:@"ID"] shape:[dic objectForKey:@"Shape"] size:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"Size"]floatValue]] color:[dic objectForKey:@"Color"] clarity:[dic objectForKey:@"Clarity"] rapPercent:[NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"rapPercent"]floatValue]] perCarat:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PricePerCarat"]floatValue]] totalPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"PriceTotal"]floatValue]] rapPriceList:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"RapPriceList"]floatValue]] totalRapPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"TotalRapPriceList"]floatValue]] avgPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgPrice"]floatValue]] avgDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"AvgDiscount"]floatValue]] bestPrice:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestPrice"]floatValue]] bestDiscount:[NSString stringWithFormat:@"%0.0f",[[dic objectForKey:@"BestDiscount"]floatValue]]];
                [dic setObject:[NSString stringWithFormat:@"%d", diamondIndex] forKey:@"DiamondIndex"];
                //  [Database fetchWorkAreaDiamonds];
                [[StoredData sharedData].savedDiamondsArr addObject:dic];
                
            }
            
            
            //  NSLog(@"Diamond = %@",dic);
            
            [dic release];
            dic = nil;
            
            self.view.hidden =YES;
            //  [self.view removeFromSuperview];
            [delegate alertAddDiamondFinished:1];
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

-(void)didReceiveMemoryWarning 
{    
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}



-(void)dealloc 
{
    [popUPView release];
    [shape release];
    [color release];
    [clarity release];
    [idDiamond release];
	[msgLbl release];
	[addBtn release];
	[cancelBtn release];
    [super dealloc];
}


@end
