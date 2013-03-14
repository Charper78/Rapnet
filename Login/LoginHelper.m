//
//  LoginHelper.m
//  Rapnet
//
//  Created by Itzik on 12/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LoginHelper.h"

@implementation LoginHelper

static NSString *lhUserName;
static NSString *lhPassword;

+(void)setUserNameAndPassword:(NSString*)user pass:(NSString*)pass save:(bool)save
{
    lhUserName = [[NSString alloc] initWithString: user];
    lhPassword = [[NSString alloc] initWithString: pass];
    
    if (save)
    {
        /*NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
        [SaveData setObject:user forKey:@"UserName"];
        [SaveData setObject:pass forKey:@"Password"];
        [SaveData synchronize];*/
        [LoginHelper saveUserNameAndPassword:user pass:pass];
    }
}

+(void)saveUserNameAndPassword:(NSString*)user pass:(NSString*)pass
{
    /*lhUserName = nil;
    lhPassword = nil;
    
    if(user != nil)
        lhUserName = [[NSString alloc] initWithString: user];
    
    if(pass != nil)
        lhPassword = [[NSString alloc] initWithString: pass];
    */
    
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setObject:user forKey:@"UserName"];
    [SaveData setObject:pass forKey:@"Password"];
    [SaveData synchronize];
}

+(void)resetSavedUserNameAndPassword
{
    [LoginHelper saveUserNameAndPassword:nil pass:nil];
}

+(NSString*)getUserName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *user = [prefs stringForKey:@"UserName"];
    
    if(user != nil && [user length] > 0)
        lhUserName = user;
    
	return [lhUserName copy];
}

+(NSString*)getPassword
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *pass = [prefs stringForKey:@"Password"];
    if(pass != nil && [pass length] > 0)
        lhPassword = pass;
    
    return [lhPassword copy];
}

+(bool)hasUserNamendPassword
{
    NSString *u = [LoginHelper getUserName];
    NSString *p = [LoginHelper getPassword];
    
    return u != nil && p != nil && [u length] > 0 && [p length] > 0;
}
@end
