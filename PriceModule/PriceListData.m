//
//  PriceListData.m
//  Rapnet
//
//  Created by Itzik on 10/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "PriceListData.h"

@implementation PriceListData

@synthesize gridSizeID, shape, color, clarity, price;

static NSString * const kFileName = @"PriceListData.txt";
static NSString * const kRoundFileName = @"RoundPriceListData.txt";
static NSString * const kPearFileName = @"PearPriceListData.txt";
static NSDictionary *data = nil;
static NSDictionary *roundData = nil;
static NSDictionary *pearData = nil;
static NSLock *lock;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:gridSizeID forKey:@"gridSizeID"];
    [encoder encodeObject:shape forKey:@"shape"];
    [encoder encodeObject:color forKey:@"color"]; 
    [encoder encodeObject:clarity forKey:@"clarity"];
    [encoder encodeObject:price forKey:@"price"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.gridSizeID = [[decoder decodeObjectForKey:@"gridSizeID"] copy];
        self.shape = [[decoder decodeObjectForKey:@"shape"] copy];
        self.color = [[decoder decodeObjectForKey:@"color"] copy];
        self.clarity = [[decoder decodeObjectForKey:@"clarity"] copy];
        self.price = [[decoder decodeObjectForKey:@"price"] copy];
        
    }
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"<gridID = %@, shape = %@, color = %@, clarity = %@, price = %@>", gridSizeID, shape, color, clarity, price];
}

+(NSString*)getDictionaryKey:(NSString*)gridSizeID shape:(NSString*)shape color:(NSString*)color clarity:(NSString*)clarity
{
    return [NSString stringWithFormat:@"%@%@%@%@", gridSizeID, shape, color, clarity];
}

+(NSString*)getDictionaryKey:(PriceListData*)pld
{
    return [PriceListData getDictionaryKey:pld.gridSizeID shape:pld.shape color:pld.color clarity:pld.clarity];
}

+(void)lockThread
{
    if(lock == nil)
        lock = [[NSLock alloc] init];
    //[lock lock];
}

+(void)unlockThread
{
    //[lock unlock];
}


+(void)writeToFile:(NSDictionary*)d
{
    [PriceListData lockThread];
    data = d;
    [Functions writeToFile:d fileName:kFileName];
    [PriceListData unlockThread];
}

+(void)writeToFile:(NSDictionary*)d shape:(Shapes)shape
{
    if (shape == S_Round) {
        roundData = d;
        [Functions writeToFile:d fileName:kRoundFileName];
    }
    else if (shape == S_Pear) {
        pearData = d;
        [Functions writeToFile:d fileName:kPearFileName];
    }
}

+(NSDictionary*)readFromFile
{
    [PriceListData lockThread];
    //NSLog(@"Reading from file");
    data = [Functions readFromFile:kFileName];
    //NSLog(@"Finished Reading from file, Data count = %d", data.count);
    [PriceListData unlockThread];
    //CFShow(data);
    return data;
}

+(void) deleteFile
{
    
    [PriceListData lockThread];
    [Functions deleteFile:kFileName];
    [PriceListData unlockThread];
}

+(bool)isDownloadRequired
{
    [PriceListData lockThread];
    if(data == nil || data.count == 0)
        [PriceListData readFromFile];

    if (data != nil && data.count > 3500) {
        [PriceListData unlockThread];
        return NO;
    }
    [PriceListData unlockThread];
    return YES;
}

+(float)getPrice:(NSString*)gridSizeID shape:(NSString*)shape color:(NSString*)color clarity:(NSString*)clarity
{
    [PriceListData lockThread];
    if(data == nil || data.count == 0)
        [PriceListData readFromFile];
    
    //NSLog(@"data count = %d", data.count );
    NSString *key = [PriceListData getDictionaryKey:gridSizeID shape:shape color:color clarity:clarity];
    
    PriceListData *pld = [data objectForKey:key];
    /*NSLog(@"key = %@", key);
    if (key != nil) {
        NSLog(@"key = %@ => %@", key, [pld description]);
    }*/
    
    [PriceListData unlockThread];
    return [pld.price floatValue];
    
    /*for (NSInteger i = 0; i<[data allKeys].count ; i++)
    {
        if([key isEqualToString:[[data allKeys] objectAtIndex:i]])
        {
            //PriceListData *pld = [data objectForKey:key];
            PriceListData *pld = [[data allValues] objectAtIndex:i];
            return [pld.price floatValue];
        }
    }
    
    return 0;*/
    
}

+(void)download
{
    [PriceListData lockThread];
    GetPriceList *gpl = [[GetPriceList alloc] init];
    [gpl download];
    [PriceListData unlockThread];
}
@end
