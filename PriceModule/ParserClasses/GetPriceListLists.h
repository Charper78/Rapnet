//
//  GetPriceListLists.h
//  Rapnet
//
//  Created by Itzik on 10/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetShapeParser.h"
#import "GetClarityParser.h"
#import "GetColorsParser.h"
#import "Database.h"

@interface GetPriceListLists : NSObject
{
    
}

-(void)downloadShape;
-(void)downloadColor;
-(void)downloadClarity;

@end
