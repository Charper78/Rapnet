//
//  funcClass.m
//  Rapnet
//
//  Created by NEHA SINGH on 20/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "funcClass.h"
#import <QuartzCore/QuartzCore.h> 

@implementation funcClass

+(void)showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles,nil];
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
	[alert release];
}


+(void)showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles,nil];
    alert.tag = tag;
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
	[alert release];
}


@end


