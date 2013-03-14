//
//  PriceListData.h
//  Rapnet
//
//  Created by Itzik on 10/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functions.h"
#import "GetPriceList.h"

@interface PriceListData : NSObject
{
    NSString *gridSizeID;
    NSString *shape;
    NSString *color;
    NSString *clarity;
    NSString *price;
}

@property (nonatomic, retain) NSString *gridSizeID;
@property (nonatomic, retain) NSString *shape;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *clarity;
@property (nonatomic, retain) NSString *price;


+(NSString*)getDictionaryKey:(NSString*)gridSizeID shape:(NSString*)shape color:(NSString*)color clarity:(NSString*)clarity;
+(NSString*)getDictionaryKey:(PriceListData*)pld;
+(void)writeToFile:(NSDictionary*)d;
+(void)writeToFile:(NSDictionary*)d shape:(Shapes)shape;

+(void)deleteFile;
+(NSDictionary*)readFromFile;
+(float)getPrice:(NSString*)gridSizeID shape:(NSString*)shape color:(NSString*)color clarity:(NSString*)clarity;
+(bool)isDownloadRequired;
+(void)download;
@end
