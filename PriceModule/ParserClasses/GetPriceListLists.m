//
//  GetPriceListLists.m
//  Rapnet
//
//  Created by Itzik on 10/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetPriceListLists.h"

@implementation GetPriceListLists

-(void)downloadShape
{
    GetShapeParser *objShapeParser=[[GetShapeParser alloc]init];
    NSMutableArray *arrShape = [objShapeParser GetShapeList];
    [Database deleteAllShapes:[Database getDBPath]];
    for (int i = 0; i<[arrShape count]; i++) {
        NSDictionary *dic = [arrShape objectAtIndex:i];
        [Database insertShapesWithID:[dic objectForKey:@"ShapeID"] Title:[dic objectForKey:@"ShapeTitle"] shortTitle:[dic objectForKey:@"ShapeShortTitle"]];
    }
    [StoredData sharedData].arrShape = arrShape;
    ReleaseObject(objShapeParser);
}

-(void)downloadColor
{
    GetColorsParser *objColorParser=[[GetColorsParser alloc]init];
    NSMutableArray *arrColors = [objColorParser GetColorList];
    [Database deleteAllColor:[Database getDBPath]];
    for (int i = 0; i<[arrColors count]; i++) {
        NSDictionary *dic = [arrColors objectAtIndex:i];
        [Database insertColorsWithID:[dic objectForKey:@"ColorID"] Title:[dic objectForKey:@"ColorTitle"]];
    }
    [StoredData sharedData].arrColors = arrColors;
    ReleaseObject(objColorParser);
}

-(void)downloadClarity
{
    GetClarityParser *objClarityParser=[[GetClarityParser alloc]init];
    NSMutableArray *arrClarity = [objClarityParser GetClarityList];
    [Database deleteAllClarity:[Database getDBPath]];
    for (int i = 0; i<[arrClarity count]; i++) {
        NSDictionary *dic = [arrClarity objectAtIndex:i];
        [Database insertClarityWithID:[dic objectForKey:@"ClarityID"] Title:[dic objectForKey:@"ClarityTitle"]];
    }
    
    [StoredData sharedData].arrClarity = arrClarity;
    ReleaseObject(objClarityParser);
}
@end
