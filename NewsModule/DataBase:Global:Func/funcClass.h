//
//  funcClass.h
//  Rapnet
//
//  Created by NEHA SINGH on 20/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface funcClass : NSObject
{
}

+(void)showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+(void)showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

@end
