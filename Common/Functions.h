//
//  Functions.h
//  Rapnet
//
//  Created by Itzik on 24/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Enums.h"
#import "GetPriceListChangeDateParser.h"
#import "GetPriceListChangeDate.h"
#import "NotificationParser.h"
#import "NotificationSettings.h"

@interface Functions : NSObject
{}
+(NSString*) numberWithComma:(NSInteger)num;
+(NSString*) dateFormat:(NSString*)date format:(NSString*)format;
+(NSString*) dateFormatFromDate:(NSDate*)date format:(NSString*)format;
+(NSString*) dateFormat:(NSString*)str format:(NSString*)format fromFormat:(NSString*)fromFormat;
+(NSTimeInterval) dateDiff:(NSDate*)startDate endDate:(NSDate*)endDate;
+(float) dateDiff:(NSDate*)startDate endDate:(NSDate*)endDate diffType:(DateDiffTypes)diffType;
+(NSDate*)getDate:(NSString*)str;
+(NSDate*)getDate:(NSString*)str format:(NSString*)format;
+(void)NoInternetAlert;
+(NSString*)getShape:(Shapes)shape;
+(void)writeToFile:(NSDictionary*)d fileName:(NSString*)fileName;
+(NSDictionary*)readFromFile:(NSString*)fileName;
+(id)readObjectFromFile:(NSString*)fileName;
+(void)writeObjectToFile:(id)d fileName:(NSString*)fileName;
+(void)deleteFile:(NSString*)path;
+(bool)canView:(LoginTypes)l;
+(NSString*)getTicket:(LoginTypes)l;
+(bool)isLogedIn;
+(void)loginAll;
+(void)logout;
+(NSString*)getCurrentRegionCountryCode;
+(NSString*)getThousandSeparator;
+(NSString*)getFractionSeparator;
+(NSString*)getFractionDisplay:(float)f;
+(NSString*)getFractionDisplay:(float)f format:(NSString*)format;
+(NSString*)fixNumberFormat:(NSString*)str;
+(NSInteger)numDaysInMonth:(NSDate*)d;
+(NSDate*)addToDate:(NSDate*)d year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSInteger)getDayOfWeek:(NSDate*)d;
+(NSInteger) getSystemVersionAsAnInteger;
+(NSArray*) getDecimalFormatCountries;
+(void)saveData:(id)obj key:(NSString*)key;
+(id)getData:(NSString*)key;
+(void)saveBoolData:(bool)obj key:(NSString*)key;
+(bool)getBoolData:(NSString*)key;
+(bool)getBoolData:(NSString*)key defalutVal:(bool)defaultVal;
+(GetPriceListChangeDate*)getPriceListChangeDate;
+(NSString*)boolToString:(BOOL)b;
+(CGFloat)getScreenHeight;
+(CGFloat)getScreenWidth;
+(void) downloadNotifications;
@end
