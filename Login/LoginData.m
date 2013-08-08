//
//  LoginData.m
//  Rapnet
//
//  Created by Itzik on 14/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LoginData.h"


@implementation LoginData
//@synthesize newsTicket;

-(GetUserPermissions*) getPermissions
{
    return userPermissions;
    
}
-(void)loginAll
{
    if([LoginHelper hasUserNamendPassword] == NO)
        return;
    
    Login *lm = [[Login alloc] init];
    rapnetTicket = [[lm login:L_Rapnet] retain];
    rapnetLoginTime = [[NSDate date] retain];
    ReleaseObject(lm);
    
    /*lm = [[Login alloc] init];
    pricesTicket = [[lm login:L_Prices] retain];
    pricesLoginTime = [[NSDate date] retain];
    ReleaseObject(lm);
    
    lm = [[Login alloc] init];
    newsTicket = [[lm login:L_News] retain];
    newsLoginTime = [[NSDate date] retain];
    ReleaseObject(lm);
    */
    NSString *ticket = nil;
    if([self isTicketValid:L_Rapnet])
        ticket = rapnetTicket;
    /*else if([self isTicketValid:L_Prices])
        ticket = pricesTicket;
    else if([self isTicketValid:L_News])
        ticket = newsTicket;
    */
    
    GetUserPermissionsParser * p = [[GetUserPermissionsParser alloc] init];
    userPermissions = [[p hasPermissions:ticket] retain];
    
    //NSLog(@"%@", newsTicket);
    NSLog(@"%@", rapnetTicket);
    //NSLog(@"%@", pricesTicket);
}

-(bool)canView:(LoginTypes)l
{
    bool ticketValid = [self isTicketValid:l];
    
    if (ticketValid == NO) {
        [self getTicket:l];
    }
    
    bool res;
    switch (l) {
        case L_News:
            res = [userPermissions getHasIndividual];
            break;
        case L_Prices:
            res = [userPermissions getHasMonthlyPrices] || [userPermissions getHasWeeklyPrices];
            break;
        case L_PricesMonthly:
            res = [userPermissions getHasMonthlyPrices];
            break;
        case L_PricesWeekly:
            res = [userPermissions getHasWeeklyPrices];
            break;
        case L_Rapnet:
            res = [userPermissions getHasRapnet];
            break;
    }
    
    
    return res;
}

-(NSString*)getTicket:(LoginTypes)l
{
    bool valid = [self isTicketValid:l];
    NSString *ticket = nil;
    
    if (valid)
    {
        switch (l)
        {
            case L_News:
               /* ticket = newsTicket;
                break;*/
           case L_Prices:
        
               /* ticket = pricesTicket;
                break;*/
            case L_PricesMonthly:
            case L_PricesWeekly:
            case L_Rapnet:
                ticket = rapnetTicket;
                break;
        }
    }
    else if ([LoginHelper hasUserNamendPassword])
    {
        //Login *lm = [[Login alloc] init];
        //ticket = [lm login:l];
        [self loginAll];
        ticket = rapnetTicket;
        
        switch (l)
        {
            case L_News:
                /*newsTicket = ticket;
                newsLoginTime = [NSDate date];
                break;*/
            case L_Prices:
                /*pricesTicket = ticket;
                pricesLoginTime = [NSDate date];
                break;*/
            case L_PricesMonthly:
            case L_PricesWeekly:
            case L_Rapnet:
                rapnetTicket = ticket;
                rapnetLoginTime = [NSDate date];
                break;
        }
    }
    
    return ticket;
}

//+(float) dateDiff:(NSDate*)startDate endDate:(NSDate*)endDate diffType:(DateDiffTypes)diffType
-(bool)isTicketValid:(LoginTypes)l
{
    bool res = NO;
    
    switch (l)
    {
        case L_News:
        /*    if (newsTicket != nil && [newsTicket length] > 0 && [Functions dateDiff:newsLoginTime endDate:[NSDate date] diffType:D_Minute] < kTicketValidTimeInMinutes)
            {
                res = YES;
            }
            break;*/
        case L_Prices:
      /*      if (pricesTicket != nil && [pricesTicket length] > 0 && [Functions dateDiff:pricesLoginTime endDate:[NSDate date] diffType:D_Minute] < kTicketValidTimeInMinutes)
            {
                res = YES;
            }
            break;*/
        case L_PricesMonthly:
        case L_PricesWeekly:
        case L_Rapnet:
            if (rapnetTicket != nil && [rapnetTicket length] > 0 && [Functions dateDiff:rapnetLoginTime endDate:[NSDate date] diffType:D_Minute] < kTicketValidTimeInMinutes)
            {
                res = YES;
            }
            break;
    }
    
    return res;
}

-(bool)isLogedIn
{
    //return ([self isTicketValid:L_News] || [self isTicketValid:L_Prices] || [self isTicketValid:L_Rapnet]);
    return [self isTicketValid:L_Rapnet];
}

-(void)logout{
    //newsTicket = nil;
    rapnetTicket = nil;
    //pricesTicket = nil;
    userPermissions = nil;
    [LoginHelper resetSavedUserNameAndPassword];
}
@end
