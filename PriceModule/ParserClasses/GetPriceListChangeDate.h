//
//  GetPriceListChangeDate.h
//  Rapnet
//
//  Created by Itzik on 27/12/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functions.h"

@interface GetPriceListChangeDate : NSObject
{
    NSString *roundFromDate;
    NSString *roundToDate;
    NSString *pearFromDate;
    NSString *pearToDate;
}

-(id)initWithDates:(NSString*)roundFrom roundTo:(NSString*)roundTo pearFrom:(NSString*)pearFrom pearTo:(NSString*)pearTo;

-(NSDate *)getRoundFromDate;
-(NSDate *)getRoundToDate;
-(NSDate *)getPearFromDate;
-(NSDate *)getPearToDate;
@end
