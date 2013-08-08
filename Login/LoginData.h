//
//  LoginData.h
//  Rapnet
//
//  Created by Itzik on 14/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "LoginHelper.h"
#import "Functions.h"
#import "Login.h"
#import "GetUserPermissions.h"
#import "GetUserPermissionsParser.h"

@interface LoginData : NSObject
{
    //bool canViewNews;
    //bool canViewRapnet;
    //bool canViewPrices;
    //NSString *newsTicket;
    NSString *rapnetTicket;
    //NSString *pricesTicket;
    
    //NSDate *newsLoginTime;
    NSDate *rapnetLoginTime;
    //NSDate *pricesLoginTime;
    
    GetUserPermissions *userPermissions;
}

//@property (nonatomic, retain) NSString *newsTicket;

-(bool)canView:(LoginTypes)l;
-(NSString*)getTicket:(LoginTypes)l;
-(void)loginAll;
-(bool)isLogedIn;
-(void)logout;
-(GetUserPermissions*) getPermissions;
@end
