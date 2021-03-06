//
//  DiamondsSearchResultParser.h
//  Rapnet
//
//  Created by Itzik on 05/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "DiamondSearchParams.h"
#import "LT_Const.h"
#import "DiamondSearchResult.h"
#import "LT_City.h"
@protocol getDiamondsSearchResultDelegate
-(void)webserviceCallDiamondsSearchResultFinished:(NSMutableArray*)res total:(NSInteger)total;

@end

@interface DiamondsSearchResultParser : NSObject <NSXMLParserDelegate>{
    id<getDiamondsSearchResultDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;

    NSMutableString *diamondID;
    NSMutableString *accountID;
    NSMutableString *company;
    NSMutableString *email;
    NSMutableString *tel1;
    NSMutableString *tel2;
    NSMutableString *fax;
    NSMutableString *shape;
    NSMutableString *weight;
    NSMutableString *color;
    NSMutableString *clarity;
    NSMutableString *cut;
    NSMutableString *polish;
    NSMutableString *depthPercent;
    NSMutableString *fluorescenceIntensity;
    NSMutableString *fluorescenceColor;
    NSMutableString *lab;
    NSMutableString *certificateNumber;
    NSMutableString *lowestPricePerCarat;
    NSMutableString *lowestDiscount;
    NSMutableString *lowestTotalPrice;
    NSMutableString *pricePerCarat;
    NSMutableString *listPrice;
    
    NSMutableString *measDepth;
    NSMutableString *measLength;
    NSMutableString *measWidth;
    
    NSMutableString *symmetry;
    NSMutableString *tablePercent;
    NSMutableString *city;
    
    NSMutableString *country;
    NSMutableString *girdleMaxSize;
    NSMutableString *girdleMinSize;
    NSMutableString *state;
    
    NSMutableString *fancyColorOvertones;
    NSMutableString *fancyColorIntensity;
    NSMutableString *fancyColor1;
    NSMutableString *fancyColor2;
    NSMutableString *sellerNameCode;
    NSMutableString *firstName;
    NSMutableString *lastName;
    NSMutableString *cashPricePerCarat;
    NSMutableString *girdleCondition;
    NSMutableString *girdlePercent;
    NSMutableString *vendorStockNumber;
    NSMutableString *culetCondition;
    NSMutableString *crownAngle;
    NSMutableString *crownHeight;
    NSMutableString *pavilionDepth;
    NSMutableString *pavilionAngle;
    NSMutableString *ratio;
    NSMutableString *rapSpec;
    NSMutableString *isLaserDrilled;
    NSMutableString *isIrradiated;
    NSMutableString *isClarityEnhanced;
    NSMutableString *isColorEnhanced;
    NSMutableString *isHPHT;
    NSMutableString *isOtherTreatment;
    NSMutableString *availability;
    NSMutableString *ratingPercent;
    NSMutableString *totalRating;
    NSMutableString *laserInscription;
    NSMutableString *rapCode;
    NSMutableString *dateUpdated;
    NSMutableString *has3Dfile;
    NSMutableString *imageFile;
    
    NSMutableString *starLength;
    NSMutableString *certComment;
    NSMutableString *centerInclusion;
    NSMutableString *blackInclusion;
    NSMutableString *shade;
    NSMutableString *labLocation;
    NSMutableString *memberComment;
    NSMutableString *lotLocation;
    
    NSMutableString *certificateImage;
    NSMutableString *certificateLink;
    
    NSMutableString *treatment;
    NSMutableString *reportDate;
    
    DiamondSearchResult *diamond;
    
    NSMutableString *totalCount;
    bool isFancy;
}

@property(retain, nonatomic) id<getDiamondsSearchResultDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;
@property (nonatomic) bool isFancy;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getDiamondsList:(DiamondSearchParams*)params;


@end
