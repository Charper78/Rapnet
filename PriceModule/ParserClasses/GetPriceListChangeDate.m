//
//  GetPriceListChangeDate.m
//  Rapnet
//
//  Created by Itzik on 27/12/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetPriceListChangeDate.h"

@implementation GetPriceListChangeDate

NSString *dateFormat = @"MM/dd/yyyy";

-(id)initWithDates:(NSString*)roundFrom roundTo:(NSString*)roundTo pearFrom:(NSString*)pearFrom pearTo:(NSString*)pearTo
{
    if (self = [super init]) {
        roundFromDate = roundFrom;
        roundToDate = roundTo;
        pearFromDate = pearFrom;
        pearToDate = pearTo;
    }
    
    return self;
}

-(NSDate *)getRoundFromDate { return [Functions getDate:roundFromDate format:dateFormat]; }
-(NSDate *)getRoundToDate { return [Functions getDate:roundToDate format:dateFormat]; }
-(NSDate *)getPearFromDate { return [Functions getDate:pearFromDate format:dateFormat]; }
-(NSDate *)getPearToDate { return [Functions getDate:pearToDate format:dateFormat]; }

@end
