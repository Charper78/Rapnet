//
//  GetUserPermissions.m
//  Rapnet
//
//  Created by Itzik on 04/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetUserPermissions.h"

@implementation GetUserPermissions

-(id)initWithRapnet:(bool)rapnet weeklyPrices:(bool)weeklyPrices monthlyPrices:(bool)monthlyPrices individual:(bool)individual
{
    if (self = [super init]) {
        hasRapnet = rapnet;
        hasWeeklyPrices = weeklyPrices;
        hasMonthlyPrices = monthlyPrices;
        hasIndividual = individual;
    }
    
    return self;
}

-(bool)getHasRapnet { return hasRapnet; }
-(bool)getHasWeeklyPrices { return hasWeeklyPrices; }
-(bool)getHasMonthlyPrices { return hasMonthlyPrices; }
-(bool)getHasIndividual { return hasIndividual; }

@end
