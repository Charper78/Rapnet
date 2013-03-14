//
//  LoginHelper.h
//  Rapnet
//
//  Created by Itzik on 12/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginHelper : NSObject
{
    
}

+(void)setUserNameAndPassword:(NSString*)user pass:(NSString*)pass save:(bool)save;
+(void)saveUserNameAndPassword:(NSString*)user pass:(NSString*)pass;
+(void)resetSavedUserNameAndPassword;
+(NSString*)getUserName;
+(NSString*)getPassword;
+(bool)hasUserNamendPassword;
@end
