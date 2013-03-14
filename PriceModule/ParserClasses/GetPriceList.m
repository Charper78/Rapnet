//
//  GetPriceList.m
//  Rapnet
//
//  Created by Itzik on 06/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetPriceList.h"

@implementation GetPriceList

@synthesize delegate;

NSMutableDictionary *priceList;


-(void)download
{
    NSInteger countRound = 0;
    NSInteger countPear = 0;
    Stopwatch *sTotal = [[Stopwatch alloc] initWithName:@"Total time download"];
    [sTotal start];
    
    Stopwatch *s = [[Stopwatch alloc] initWithName:@"Test download"];
    
    [s start];
    priceList = [[NSMutableDictionary alloc] init];
    
    countRound += [self download:S_Round];
    [delegate increaseProgress:[[NSNumber alloc] initWithFloat:1800.0]];
    if (countRound > 0) 
    {
        countPear += [self download:S_Pear];
        [delegate increaseProgress:[[NSNumber alloc] initWithFloat:1800.0]];
    }
    
    [s stop];
    [s statistics];
    
    Stopwatch *sWriteFile = [[Stopwatch alloc] initWithName:@"Test WriteFile"];
    [sWriteFile start];
    if (countRound > 0 && countPear > 0) 
    {
        [PriceListData deleteFile];
        [PriceListData writeToFile:priceList];
    }
    [sWriteFile stop];
    [sWriteFile statistics];
    
    [sTotal stop];
    [sTotal statistics];
    //NSLog(@"priceList count = %d", [priceList count]);
    //[delegate finishedDownloading];
}

-(NSInteger)download:(Shapes)shape
{
    NSString *username = [[LoginHelper getUserName] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSString *password = [[LoginHelper getPassword] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString *url;
    
    if (shape == S_Round) {
        url = RoundUrl;
    }
    else if (shape == S_Pear) {
        url = PearUrl;
    }
    
   // NSLog(@"download");
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@&submit=",username,password];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err = nil;
    
    Stopwatch *sw = [[Stopwatch alloc] initWithName:@"Test 1"];
    [sw start];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    [sw stop];
    [sw statistics];
    
    
    NSString* newStr = [NSString stringWithUTF8String:[responseData bytes]];
    //NSInteger len = [newStr length];
    //NSLog(@"%@", newStr);
    //NSLog(@"%@", [err localizedDescription]);
    
   // NSLog(@"parse");
    Stopwatch *swParse = [[Stopwatch alloc] initWithName:@"Test 1 parse"];
    [swParse start];
    NSInteger count = [self parse:newStr shape:shape];
    [swParse stop];
    [swParse statistics];
    return count;
    //[delegate finishedDownloading];
}

-(NSInteger)parse:(NSString*)data shape:(Shapes)shape
{
    NSInteger gridSizeID;
    
    NSString *color;
    NSString *clarity;
    NSString *priceStr;
    float price;
    NSArray *cols;
    
    NSArray *rows = [data componentsSeparatedByString:@"\n"];
    NSInteger totalRows = 0;
    NSInteger totalColumns = 0;
    NSString *shapeStr = [Functions getShape:shape];
    NSInteger duplicateRowTimes;
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    PriceListData *pld;
    NSInteger numRows = rows.count;
    NSString *key;
    NSInteger mainCounter = 0;
    NSInteger columnsDuplicateTimes;
    for (int i = 0; i<numRows; i++) 
    {
        //NSLog([rows objectAtIndex:i]);
        gridSizeID = [self getGridSizeID:totalRows shape:shape];
        cols = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
        if(cols.count > 1)
        {
            duplicateRowTimes = [self getRowsDuplicateTimes:i shape:shape];
        
            for (int rowTimes = 0; rowTimes < duplicateRowTimes; rowTimes ++)
            {
                totalColumns = 0;
                color = [self getColor:totalRows gridSizeID:gridSizeID];
            
                for (int j = 0; j < cols.count; j++)
                {
                    priceStr = [cols objectAtIndex:j];
                    price = [priceStr floatValue] * 100;
                    priceStr = [NSString stringWithFormat: @"%f", price];
                    columnsDuplicateTimes = [self getColumnsDuplicateTimes:j gridSizeID:gridSizeID];
                    for (int colTimes = 0; colTimes < columnsDuplicateTimes; colTimes ++)
                    {
                        pld = [[PriceListData alloc] init];
                        clarity = [self getClarity:totalColumns];
                        pld.gridSizeID = [NSString stringWithFormat:@"%d", gridSizeID];
                        pld.shape = shapeStr;
                        pld.color = color;
                        pld.clarity = clarity;
                        pld.price = priceStr;
                        key = [PriceListData getDictionaryKey:pld];
                        [priceList setObject:pld forKey:key];
                        totalColumns ++;
                        mainCounter++;
                        //[delegate increaseProgress];
                    }
                }
                totalRows ++;
            }
        }
    }
    
    
    return totalRows;
    
   
}

-(NSInteger)getRowsDuplicateTimes:(NSInteger)row shape:(Shapes)shape
{
    if ((shape == S_Round && row > 29) || (shape == S_Pear && row > 9) ) {
        return 1;
    }
    
    NSInteger tmp = row % 5;
    if (tmp == 0) {
        return 3;
    }
    
    if((shape == S_Round && (tmp == 4 || tmp == 9 || tmp == 14 || tmp == 19)) || (shape == S_Pear && (tmp == 4 || tmp == 9)))
        return 1;
    
    return 2;
}

-(NSInteger)getColumnsDuplicateTimes:(NSInteger)col gridSizeID:(NSInteger)gridSizeID
{
    if (gridSizeID > 150) {
        return 1;
    }
    
    NSInteger tmp = col % 8;
    if (tmp == 0) {
        return 3;
    }
    
    if (tmp == 1) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)getGridSizeID:(NSInteger)row shape:(Shapes)shape
{
    if ((shape == S_Round && row >= 170) ||  (shape == S_Pear && row >= 130)){
        return 300;
    }
    
    NSInteger add = 0;
    if (shape == S_Pear) {
        add = 40;
    }
    return (((row / 10) + 10) * 10) + add;
}

/*-(NSInteger)getFixedRow:(NSInteger)row
{
    if(row > 29)
        return row;
    
    
}*/

-(NSString*)getColor:(NSInteger)row gridSizeID:(NSInteger)gridSizeID
{
    NSString *color;
    NSInteger fixedRow = row % 10;
    
    if (gridSizeID <= 150) {
        row = row;
    }
    
    
    switch (fixedRow) {
        case 0:
            color = @"D";
            break;
            
        case 1:
            color = @"E";
            break;
            
        case 2:
            color = @"F";
            break;
            
        case 3:
            color = @"G";
            break;
            
        case 4:
            color = @"H";
            break;
            
        case 5:
            color = @"I";
            break;
            
        case 6:
            color = @"J";
            break;
            
        case 7:
            color = @"K";
            break;
            
        case 8:
            color = @"L";
            break;
            
        case 9:
            color = @"M";
            break;
    }
    
    return color;
}

-(NSString*)getClarity:(NSInteger)col
{
    NSString *clarity = nil;
    
    switch (col) {
        case 0:
            clarity = @"IF";
            break;
            
        case 1:
            clarity = @"VVS1";
            break;
            
        case 2:
            clarity = @"VVS2";
            break;
            
        case 3:
            clarity = @"VS1";
            break;
            
        case 4:
            clarity = @"VS2";
            break;
            
        case 5:
            clarity = @"SI1";
            break;
            
        case 6:
            clarity = @"SI2";
            break;
            
        case 7:
            clarity = @"SI3";
            break;
            
        case 8:
            clarity = @"I1";
            break;
            
        case 9:
            clarity = @"I2";
            break;
            
        case 10:
            clarity = @"I3";
            break;
            
    }
    
    return clarity;
}
@end
