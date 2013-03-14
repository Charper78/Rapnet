//
//  DiamondSearchResult.h
//  Rapnet
//
//  Created by Itzik on 15/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functions.h"

@interface DiamondSearchResult : NSObject
{
    NSString *diamondID;
    NSString *accountID;
    NSString *company;
    NSString *email;
    NSString *tel1;
    NSString *tel2;
    NSString *fax;
    NSString *shape;
    NSString *weight;
    NSString *color;
    NSString *clarity;
    NSString *cut;
    NSString *polish;
    NSString *depthPercent;
    NSString *fluorescenceIntensity;
    NSString *fluorescenceColor;
    NSString *lab;
    NSString *certificateNumber;
    NSString *lowestPricePerCarat;
    NSString *lowestDiscount;
    NSString *lowestPriceTotal;
    NSString *pricePerCarat;
    NSString *listPrice;
    
    NSString *measDepth;
    NSString *measLength;
    NSString *measWidth;
    
    NSString *symmetry;
    NSString *tablePercent;
    NSString *city;
    
    NSString *country;
    NSString *girdleMaxSize;
    NSString *girdleMinSize;
    NSString *state;
    
    NSString *certificateImage;
    
    NSString *fancyColorOvertones;
    NSString *fancyColorIntensity;
    NSString *fancyColor1;
    NSString *fancyColor2;
    NSString *sellerNameCode;
    NSString *firstName;
    NSString *lastName;
    NSString *cashPricePerCarat;
    NSString *girdleCondition;
    NSString *girdlePercent;
    NSString *vendorStockNumber;
    NSString *culetCondition;
    NSString *crownAngle;
    NSString *crownHeight;
    NSString *pavilionDepth;
    NSString *pavilionAngle;
    NSString *ratio;
    NSString *rapSpec;
    NSString *isLaserDrilled;
    NSString *isIrradiated;
    NSString *isClarityEnhanced;
    NSString *isColorEnhanced;
    NSString *isHPHT;
    NSString *isOtherTreatment;
    NSString *availability;
    NSString *ratingPercent;
    NSString *totalRating;
    NSString *laserInscription;
    NSString *rapCode;
    NSString *dateUpdated;
    NSString *has3Dfile;
    NSString *imageFile;
    
    NSString *starLength;
    NSString *certComment;
    NSString *centerInclusion;
    NSString *blackInclusion;
    NSString *shade;
    NSString *labLocation;
    NSString *memberComment;
    NSString *lotLocation;
    
    NSString *certificateLink;
    
    bool isFancy;
}

@property (nonatomic, retain) NSString *diamondID;
@property (nonatomic, retain) NSString *accountID;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel1;
@property (nonatomic, retain) NSString *tel2;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *shape;
@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *clarity;
@property (nonatomic, retain) NSString *cut;
@property (nonatomic, retain) NSString *polish;
@property (nonatomic, retain) NSString *depthPercent;
@property (nonatomic, retain) NSString *fluorescenceIntensity;
@property (nonatomic, retain) NSString *fluorescenceColor;
@property (nonatomic, retain) NSString *lab;
@property (nonatomic, retain) NSString *certificateNumber;
@property (nonatomic, retain) NSString *lowestPricePerCarat;
@property (nonatomic, retain) NSString *lowestDiscount;
@property (nonatomic, retain) NSString *lowestTotalPrice;
@property (nonatomic, retain) NSString *pricePerCarat;
@property (nonatomic, retain) NSString *listPrice;

@property (nonatomic, retain) NSString *measDepth;
@property (nonatomic, retain) NSString *measLength;
@property (nonatomic, retain) NSString *measWidth;


@property (nonatomic, retain) NSString *symmetry;
@property (nonatomic, retain) NSString *tablePercent;
@property (nonatomic, retain) NSString *city;

@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *girdleMaxSize;
@property (nonatomic, retain) NSString *girdleMinSize;
@property (nonatomic, retain) NSString *state;

@property (nonatomic, retain) NSString *certificateImage;

@property (nonatomic, retain) NSString *fancyColorOvertones;
@property (nonatomic, retain) NSString *fancyColorIntensity;
@property (nonatomic, retain) NSString *fancyColor1;
@property (nonatomic, retain) NSString *fancyColor2;
@property (nonatomic, retain) NSString *sellerNameCode;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *cashPricePerCarat;
@property (nonatomic, retain) NSString *girdleCondition;
@property (nonatomic, retain) NSString *girdlePercent;
@property (nonatomic, retain) NSString *vendorStockNumber;
@property (nonatomic, retain) NSString *culetCondition;
@property (nonatomic, retain) NSString *crownAngle;
@property (nonatomic, retain) NSString *crownHeight;
@property (nonatomic, retain) NSString *pavilionDepth;
@property (nonatomic, retain) NSString *pavilionAngle;
@property (nonatomic, retain) NSString *ratio;
@property (nonatomic, retain) NSString *rapSpec;
@property (nonatomic, retain) NSString *isLaserDrilled;
@property (nonatomic, retain) NSString *isIrradiated;
@property (nonatomic, retain) NSString *isClarityEnhanced;
@property (nonatomic, retain) NSString *isColorEnhanced;
@property (nonatomic, retain) NSString *isHPHT;
@property (nonatomic, retain) NSString *isOtherTreatment;
@property (nonatomic, retain) NSString *availability;
@property (nonatomic, retain) NSString *ratingPercent;
@property (nonatomic, retain) NSString *totalRating;
@property (nonatomic, retain) NSString *laserInscription;
@property (nonatomic, retain) NSString *rapCode;
@property (nonatomic, retain) NSString *dateUpdated;
@property (nonatomic, retain) NSString *has3Dfile;
@property (nonatomic, retain) NSString *imageFile;


@property (nonatomic, retain) NSString *starLength;
@property (nonatomic, retain) NSString *certComment;
@property (nonatomic, retain) NSString *centerInclusion;
@property (nonatomic, retain) NSString *blackInclusion;
@property (nonatomic, retain) NSString *shade;
@property (nonatomic, retain) NSString *labLocation;
@property (nonatomic, retain) NSString *memberComment;
@property (nonatomic, retain) NSString *lotLocation;
@property (nonatomic, retain) NSString *certificateLink;
@property (nonatomic, retain) NSString *treatment;
@property (nonatomic, retain) NSString *reportDate;
@property (nonatomic) bool isFancy;
@end
