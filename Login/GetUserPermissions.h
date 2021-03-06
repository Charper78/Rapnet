//
//  GetUserPermissions.h
//  Rapnet
//
//  Created by Itzik on 04/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserPermissions : NSObject
{
    bool hasRapnet;
    bool hasWeeklyPrices;
    bool hasMonthlyPrices;
    bool hasIndividual;
    
    int accountID;
    int contactID;
}

-(id)initWithRapnet:(bool)rapnet weeklyPrices:(bool)weeklyPrices monthlyPrices:(bool)monthlyPrices individual:(bool)individual accID:(int)accID contID:(int)contID;

-(bool)getHasRapnet;
-(bool)getHasWeeklyPrices;
-(bool)getHasMonthlyPrices;
-(bool)getHasIndividual;

-(int)getAccountID;
-(int)getContactID;
@end
