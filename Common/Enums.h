//
//  Enums.h
//  Rapnet
//
//  Created by Itzik on 10/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#ifndef Rapnet_Enums_h
#define Rapnet_Enums_h

typedef enum
{
    MTI_News = 0,
    MTI_Prices = 1,
    MTI_Rapnet = 2,
    MTI_Login = 3
}MainTabIndexes;

typedef enum
{
    D_Second,
    D_Minute,
    D_Hour,
    D_Day
}DateDiffTypes;

typedef enum
{
    S_Round = kRoundShapeID,
    S_Pear = kPearShapeID
}
Shapes;

typedef enum
{
    L_News = 1,
    L_PricesWeekly = 2,
    L_PricesMonthly = 3,
    L_Rapnet = 4,
    L_Prices = 5
}
LoginTypes;

typedef enum 
{
    LT_TableShape = 1,
    LT_TableClarity = 2,
    LT_TableCut = 3,
    LT_TableColor = 4,
    LT_TableSym = 5,
    LT_TablePolish = 6,
    LT_TableFluor = 7,
    LT_TableLab = 8,
    LT_TableCountry = 9,
    LT_TableFancyColor = 10,
    LT_TableFancyColorIntensities = 11,
    LT_TableFancyColorOvertones = 12
}LT_Tables;

typedef enum 
{
    ST_Regular = 0,
    ST_Fancy = 1
}SearchTypes;

typedef enum
{
    PS_Carat = 0,
    PS_RapPercent = 1,
    PS_Total = 2
}PriceSearch;

typedef enum
{
    DF_Shape = 0,
    DF_Size = 1,
    DF_Color = 2,
    DF_FancyOvertone = 3,
    DF_Clarity = 4,
    DF_Cut = 5,
    DF_Polish = 6,
    DF_Symmetry = 7,
    DF_Fluorescence = 8,
    DF_Depth = 9,
    DF_Table = 10,
    DF_ReportDate = 11,
    DF_Measurements = 12,
    DF_Culet = 13,
    DF_Girdle = 14,
    DF_Crown = 15,
    DF_Pavilion = 16,
    DF_Treatment = 17,
    DF_Inscription = 18,
    DF_Ratio = 19,
    DF_StarLength = 20,
    DF_Comment = 21,
    DF_FancyIntnesity = 22
    
}DiamondFields;

typedef enum
{
    AF_Center = 0, 
    AF_Black = 1,
    AF_Shade = 2,
    AF_Location = 3,
    AF_Comment = 4
}AdditionalFields;

typedef enum
{
    LF_Stock = 0, 
    LF_Updated = 1,
    LF_Availability = 2,
    LF_Location = 3,
    LF_Price = 4,
    LF_PriceTotal = 5,
    LF_CashPricePerCarat = 6
}LotFields;

typedef enum
{
    SF_RapID = 0, 
    SF_Name = 1,
    SF_Tel1 = 2,
    SF_Tel2 = 3,
    SF_Fax = 4,
    SF_Email = 5,
    SF_Location = 6,
    SF_Rating = 7
}SellerFields;

typedef enum
{
    PD_All = 1,
    PD_Lists = 2,
    PD_Prices = 3
}PricesDownload;
#endif
