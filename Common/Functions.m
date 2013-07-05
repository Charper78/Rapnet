//
//  Functions.m
//  Rapnet
//
//  Created by Itzik on 24/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "Functions.h"

@implementation Functions


+(NSArray*) getDecimalFormatCountries
{
    //BE - Belgium, FR - France, CH - Swiss, IT - Italy, ES - Spain, DE - Germany, AL - Albania, AD - Andorra
    //AR - Argentina, AM - Armenia, AU - Australia, AT - Austria, AZ - Azerbaijan, BY - Belarus, BO - Bolivia
    //BA - Bosnia and Herzegovina, BR - Brazil, BG - Bulgaria, CM - Cameroon, CL - Chile, CO - Colombia
    //CR - Costa Rica, CU - Cuba, CY - Cyprus, DK - Denmark, DM - Dominican Republic, EE - Estonia, FI - Finland
    //GE - Georgia, GR - Greece, GL - Greenland, HN - Honduras, HU - Hungary, IS - Iceland, ID - Indonesia
    //KZ - Kazakhstan, KG - Kirgistan, LV - Latvia, LB - Lebanon, LT - Lithuania, MK - Macedonia, MD - Moldova
    //MN - Mongolia, MA - Morocco, NL - Netherlands, NO - Norway, PA - Panama, PY - Paraguay, PE - Peru, PL - Poland
    //PT - Portugal, RO - Romania, RU - Russia, RS - Serbia, SK - Slovakia, SI - Slovenia, SE - Sweden, TN - Tunisia
    //TR - Turkey, UA - Ukraine, UY - Uruguay, UZ - Uzbekistan, VE - Venezuela, VN - Vietnam
    NSArray *eurCounries = @[@"BE", @"FR", @"CH", @"IT", @"ES", @"DE", @"AL", @"AD", @"AR", @"AM", @"AU", @"AT",
    @"AZ", @"BY", @"BO", @"BA", @"BR", @"BG", @"CM", @"CL", @"CO", @"CR", @"CU", @"CY", @"DK", @"DM", @"EE", @"FI",
    @"GE", @"GR", @"GL", @"HN", @"HU", @"IS", @"ID", @"KZ", @"KG", @"LV", @"LB", @"LT", @"MK", @"MD", @"MN", @"MA",
    @"NL", @"NO", @"PA", @"PY", @"PE", @"PL", @"PT", @"RO", @"RU", @"RS", @"SK", @"SI", @"SE", @"TN", @"TR", @"UA",
    @"UY", @"UZ", @"VE", @"VN"];
    return eurCounries;
}

+(NSString*) numberWithComma:(NSInteger)num
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterNoStyle];
    [formatter setGroupingSeparator: [Functions getThousandSeparator]];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator: TRUE];
    
    NSNumber* n = [NSNumber numberWithInt: num];
    return [formatter stringFromNumber: n];
}

+(NSString*) dateFormatFromDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: format];
    
    NSString *d = [df stringFromDate:date];
    return d;
}

+(NSString*) dateFormat:(NSString*)str format:(NSString*)format
{
    /*NSDate *d = [NSDate date];
    2012-06-15T00:00:00
    NSDateFormatter * f = [[[NSDateFormatter alloc] init] autorelease];
    [f setDateFormat:format];
    
    NSString *str = [f dateFromString:date];
    return str;*/
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    str = [str substringWithRange:NSMakeRange(0, 19)];
    //NSString *t = @"2012-06-15 00:00:00";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d = [df dateFromString: str];
    
    [df setDateFormat: format];
    NSString *s = [df stringFromDate:d];
    return s;
}

+(NSString*) dateFormat:(NSString*)str format:(NSString*)format fromFormat:(NSString*)fromFormat
{
    /*NSDate *d = [NSDate date];
     2012-06-15T00:00:00
     NSDateFormatter * f = [[[NSDateFormatter alloc] init] autorelease];
     [f setDateFormat:format];
     
     NSString *str = [f dateFromString:date];
     return str;*/
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    //str = [str substringWithRange:NSMakeRange(0, 19)];
    //NSString *t = @"2012-06-15 00:00:00";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: fromFormat];
    
    NSDate *d = [df dateFromString: str];
    
    [df setDateFormat: format];
    NSString *s = [df stringFromDate:d];
    return s;
}


+(NSDate*)getDate:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    str = [str substringWithRange:NSMakeRange(0, 19)];
  
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d = [df dateFromString: str];
    return d;
}

+(NSDate*)getDate:(NSString*)str format:(NSString*)format
{

    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if([str length] >= 19)
        str = [str substringWithRange:NSMakeRange(0, 19)];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: format];
    
    NSDate *d = [df dateFromString: str];
    return d;
}

+(NSTimeInterval) dateDiff:(NSDate*)startDate endDate:(NSDate*)endDate
{
    
    NSDate *lastDate = endDate;
    NSDate *todaysDate = startDate;
    NSTimeInterval lastDiff = [lastDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [todaysDate timeIntervalSinceNow];
    NSTimeInterval diff = lastDiff - todaysDiff;
    
    return diff;
}

+(float) dateDiff:(NSDate*)startDate endDate:(NSDate*)endDate diffType:(DateDiffTypes)diffType
{
    NSTimeInterval i = [Functions dateDiff:startDate endDate:endDate];
    
    switch (diffType) {
        case D_Second:
            return (float)i;
        case D_Minute:
            return (i / 60);
        case D_Hour:
            return ( i / 60) / 60;
        case D_Day:
            return (( i / 60) / 60) / 24;
    }
    
}

+(void)NoInternetAlert
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [myAlert show];
    
    UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
    theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    CGSize theSize = [myAlert frame].size;
    
    UIGraphicsBeginImageContext(theSize);    
    [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
    theImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    for (UIView *sub in [myAlert subviews])
    {
        if ([sub class] == [UIImageView class] && sub.tag == 0) {
            [sub removeFromSuperview];
            break;
        }
    }
    [[myAlert layer] setContents:(id)theImage.CGImage];
    [myAlert release];

}

+(NSString*)getShape:(Shapes)shape
{
    switch (shape) 
    {
        case S_Round:
            return @"ROUND";
        case S_Pear:
            return @"PEAR";
       
    }
    
    return nil;
}

+(void)deleteFile:(NSString*)fileName
{
    NSFileManager *filemgr;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr removeItemAtPath: filePath error: NULL]  == YES)
        NSLog (@"Remove successful");
    else
        NSLog (@"Remove failed");
}

+(void)writeToFile:(NSDictionary*)d fileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
   // NSLog(@"%@", filePath);
    //bool r = [d writeToFile:filePath atomically:NO];
    
    [NSKeyedArchiver archiveRootObject:d toFile:filePath];
    //NSLog(@"After NSKeyedArchiver");
    //NSLog(r);
}

+(NSDictionary*)readFromFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSDictionary *d = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] mutableCopy];
    return d;
}

+(id)readObjectFromFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:filePath];
    id d = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] mutableCopy];
    return d;
}

+(void)writeObjectToFile:(id)d fileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
   // NSLog(@"%@", filePath);
    //bool r = [d writeToFile:filePath atomically:NO];
    
    [NSKeyedArchiver archiveRootObject:d toFile:filePath];
   // NSLog(@"After NSKeyedArchiver");
    //NSLog(r);

}

+(bool)canView:(LoginTypes)l
{
    return [[[StoredData sharedData] loginData] canView:l];
}

+(NSString*)getTicket:(LoginTypes)l
{
    return [[[StoredData sharedData] loginData] getTicket:l];
}

+(bool)isLogedIn
{
    return [[[StoredData sharedData] loginData] isLogedIn];
}

+(void)loginAll
{
    LoginData *ld = [[LoginData alloc] init];
    [ld loginAll];
   [StoredData sharedData].loginData = ld;
}

+(void)logout
{
    [[[StoredData sharedData] loginData] logout];
}

+(NSString*)getCurrentRegionCountryCode
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    return countryCode;
    //NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
    //NSLog(@"countryName %@", countryName);   // NSLocale *l = [[NSLocale currentLocale];
    //NSString *l = [[NSLocale currentLocale] localeIdentifier];
}

+(NSString*)getThousandSeparator 
{
    if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]])
        return @".";
    
    //if ([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"]) {
    //    return @".";
    
    return @",";
}

+(NSString*)getFractionSeparator
{
    //if ([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"]) {
    if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]])
        return @",";
    //}
    return @".";
}

+(NSString*)getFractionDisplay:(float)f
{
    NSString *tmp = [NSString stringWithFormat:@"%0.1f%%",f];
    //if ([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"]) {
    if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]]){
        tmp = [tmp stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    return tmp;
}

+(NSString*)getFractionDisplay:(float)f format:(NSString*)format
{
    NSString *tmp = [NSString stringWithFormat:format,f];
    //if ([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"]) {
    if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]]){
        tmp = [tmp stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    return tmp;
}

+(NSString*)fixNumberFormat:(NSString*)str
{
    
    //if ([[Functions getCurrentRegionCountryCode] isEqualToString:@"BE"])
    if ([[Functions getDecimalFormatCountries] containsObject:[Functions getCurrentRegionCountryCode]])
    {
        NSString *tmpComma = @"#";
        NSString *tmpDot = @"|";
        
        str = [str stringByReplacingOccurrencesOfString:@"," withString:tmpComma];
        str = [str stringByReplacingOccurrencesOfString:@"." withString:tmpDot];
        
        str = [str stringByReplacingOccurrencesOfString:tmpComma withString:@"."];
        str = [str stringByReplacingOccurrencesOfString:tmpDot withString:@","];
        
        //str = [str stringByReplacingOccurrencesOfString:@"," withString:@"."];
    }
    return str;
}

+(NSInteger)numDaysInMonth:(NSDate*)d
{
    if(d == nil)
        d = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:d];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

+(NSDate*)addToDate:(NSDate*)d year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    //NSDate *toDateCalc = [[NSDate alloc] init];
    NSCalendar *greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetToDate = [[NSDateComponents alloc] init];
    [offsetToDate setMonth:month]; // note that I'm setting it to -1
    [offsetToDate setDay:day];
    [offsetToDate setYear:year];
    NSDate *t = [greg dateByAddingComponents:offsetToDate toDate:d options:0];
    
    [greg release];
    [offsetToDate release];
    return t;
}

+(NSInteger)getDayOfWeek:(NSDate*)d
{
    
    
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents =[gregorian1 components:NSWeekdayCalendarUnit fromDate:d];
    NSInteger dayofweek = [weekdayComponents weekday];

  //  [gregorian1 release];
   // [weekdayComponents release];
    
    return dayofweek;
}

+ (NSInteger) getSystemVersionAsAnInteger{
    int index = 0;
    NSInteger version = 0;
    
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject]) {
        if (index>2) {
            break;
        }
        NSInteger multipler = powf(100, 2-index);
        version += [number intValue]*multipler;
        index++;
    }
    return version;
}

+(void)saveData:(id)obj key:(NSString*)key
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setObject:obj forKey:key];
    [SaveData synchronize];
}

+(id)getData:(NSString*)key
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    return [SaveData objectForKey:key];
}

+(void)saveBoolData:(bool)obj key:(NSString*)key
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setBool:obj forKey:key];
    [SaveData synchronize];
}

+(bool)getBoolData:(NSString*)key defalutVal:(bool)defaultVal
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    if ([SaveData objectForKey:key] == nil) {
        return defaultVal;
    }
    return [SaveData boolForKey:key];
}

+(bool)getBoolData:(NSString*)key
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    
    return [SaveData boolForKey:key];
}

+(GetPriceListChangeDate*)getPriceListChangeDate
{
    
    GetPriceListChangeDate *g;
    GetPriceListChangeDateParser *parser = [[GetPriceListChangeDateParser alloc] init];
    
    g = [parser getDates:[Functions getTicket:L_Prices]];
    
    return g;
}

+(NSString*)boolToString:(BOOL)b
{
    return b ? @"true" : @"false";
}

+(CGFloat)getScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+(CGFloat)getScreenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+(void)downloadNotifications {
    
    NotificationParser *nParser = [[NotificationParser alloc] init];
    
    NSString *deviceToken = [NotificationSettings getDeviceToken];
    
    if(deviceToken != nil)
        [nParser getNotifications:deviceToken];
}


/*
#pragma mark sendInAppSMS
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
-(void)sendInA/Users/admin/Documents/Google Drive/Projects/Rapnet/Rapnet/Common/Functions.mppSMS{
	
	Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (smsClass != nil && [MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *controller = smsClass ? [[smsClass alloc] init] : nil;
		controller.body = [NSString stringWithFormat:@"%@",self.strArticleURL];
		controller.recipients = [NSArray arrayWithObjects: nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
		[controller release];                
	}
	
	else{
		
		UIAlertView* aAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Messages cannot be send from this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[aAlert show];
		UIImage *theImage = [UIImage imageNamed:@"alertBG.png"];    
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [aAlert frame].size;
		
		UIGraphicsBeginImageContext(theSize);    
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
		theImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		for (UIView *sub in [aAlert subviews])
		{
			if ([sub class] == [UIImageView class] && sub.tag == 0) {
				[sub removeFromSuperview];
				break;
			}
		}
		[[aAlert layer] setContents:(id)theImage.CGImage];
		[aAlert release];
	}
}
*/
//#endif

@end
