//
//  DiamondSearchParams.h
//  Rapnet
//
//  Created by Itzik on 15/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiamondSearchParams : NSObject
{
    NSString *searchType;
    NSString *firstRowNum;
    NSString *toRowNum;
    NSString *weightFrom;
    NSString *weightTo;
    NSString *includeTreatments;
    NSString *hasCertFile;
    NSString *caratPriceFrom;
    NSString *caratPriceTo;
    NSString *totalPriceFrom;
    NSString *totalPriceTo;
    NSString *discountFrom;
    NSString *discountTo;
    NSString *depthPercentFrom;
    NSString *depthPercentTo;
    NSString *ratioFrom;
    NSString *ratioTo;
    NSString *cityID;
    NSString *stateID;
    NSMutableArray *sellers;
    NSMutableArray *countries;
    NSMutableArray *cities;
    NSMutableArray *shapes;
    NSMutableArray *colors;
    NSMutableArray *fancyColors;
    NSMutableArray *fancyOvertones;
    NSMutableArray *fancyIntensities;
    NSMutableArray *clarities;
    NSMutableArray *cuts;
    NSMutableArray *labs;
    NSMutableArray *polishes;
    NSMutableArray *symmetries;
    NSMutableArray *overtones;
    NSMutableArray *girdles;
    NSMutableArray *fluorescenceColors;
    NSMutableArray *fluorescenceIntensities;
    NSMutableArray *culetConditions;
    NSMutableArray *culetSizes;
    NSMutableArray *availabilities;
    NSMutableArray *sortOptions;
    NSString *rationCategory;
}

@property(nonatomic, retain) NSString *searchType;
@property(nonatomic, retain) NSString *firstRowNum;
@property(nonatomic, retain) NSString *toRowNum;
@property(nonatomic, retain) NSString *weightFrom;
@property(nonatomic, retain) NSString *weightTo;
@property(nonatomic, retain) NSString *includeTreatments;
@property(nonatomic, retain) NSString *hasCertFile;
@property(nonatomic, retain) NSString *caratPriceFrom;
@property(nonatomic, retain) NSString *caratPriceTo;
@property(nonatomic, retain) NSString *totalPriceFrom;
@property(nonatomic, retain) NSString *totalPriceTo;
@property(nonatomic, retain) NSString *discountFrom;
@property(nonatomic, retain) NSString *discountTo;
@property(nonatomic, retain) NSString *depthPercentFrom;
@property(nonatomic, retain) NSString *depthPercentTo;
@property(nonatomic, retain) NSString *ratioFrom;
@property(nonatomic, retain) NSString *ratioTo;
@property(nonatomic, retain) NSString *cityID;
@property(nonatomic, retain) NSString *stateID;
@property(nonatomic, retain) NSMutableArray *sellers;
@property(nonatomic, retain) NSMutableArray *countries;
@property(nonatomic, retain) NSMutableArray *cities;
@property(nonatomic, retain) NSMutableArray *shapes;
@property(nonatomic, retain) NSMutableArray *colors;
@property(nonatomic, retain) NSMutableArray *fancyColors;
@property(nonatomic, retain) NSMutableArray *fancyOvertones;
@property(nonatomic, retain) NSMutableArray *fancyIntensities;
@property(nonatomic, retain) NSMutableArray *clarities;
@property(nonatomic, retain) NSMutableArray *cuts;
@property(nonatomic, retain) NSMutableArray *labs;
@property(nonatomic, retain) NSMutableArray *polishes;
@property(nonatomic, retain) NSMutableArray *symmetries;
@property(nonatomic, retain) NSMutableArray *overtones;
@property(nonatomic, retain) NSMutableArray *girdles;
@property(nonatomic, retain) NSMutableArray *fluorescenceColors;
@property(nonatomic, retain) NSMutableArray *fluorescenceIntensities;
@property(nonatomic, retain) NSMutableArray *culetConditions;
@property(nonatomic, retain) NSMutableArray *culetSizes;
@property(nonatomic, retain) NSMutableArray *availabilities;
@property(nonatomic, retain) NSMutableArray *sortOptions;
@property(nonatomic, retain) NSString *rationCategory;
@end
