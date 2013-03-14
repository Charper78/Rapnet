//
//  GetPriceList.h
//  Rapnet
//
//  Created by Itzik on 06/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "Constants.h"
#import "Enums.h"
#import "Functions.h"
#import "PriceListData.h"
#import "LoginHelper.h"
#import "Stopwatch.h"
@protocol getPriceListDelegate
-(void)increaseProgress;
-(void)increaseProgress:(NSNumber*)amount;
@end

@interface GetPriceList : NSObject
{
    id<getPriceListDelegate> delegate;
}

-(void)download;
//-(void)download:(Shapes)shape;
@property(retain, nonatomic) id<getPriceListDelegate> delegate;

@end
