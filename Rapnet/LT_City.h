//
//  LT_City.h
//  Rapnet
//
//  Created by Itzik on 25/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LT_City : NSObject
{
    NSInteger cityID;
    NSInteger countryID;
    NSString *desc;
}

@property (nonatomic) NSInteger cityID;
@property (nonatomic) NSInteger countryID;
@property (nonatomic, retain) NSString *desc;

+(NSMutableArray*)get:(NSInteger)countryID;
+(LT_City*)getCity:(NSInteger)cityID countryID:(NSInteger)countryID desc:(NSString*)desc;
@end
