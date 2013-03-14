//
//  DiamondsSearchResultParser.m
//  Rapnet
//
//  Created by Itzik on 05/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "DiamondsSearchResultParser.h"

@implementation DiamondsSearchResultParser

static NSString * const kSearchTypeField = @"SearchType";
static NSString * const kFirstRowNum = @"FirstRowNum";
static NSString * const kToRowNum = @"ToRowNum";
static NSString * const kWeightFrom = @"WeightFrom";
static NSString * const kWeightTo = @"WeightTo";
static NSString * const kIncludeTreatments = @"IncludeTreatments";
static NSString * const kHasCertFile = @"HasCertFile";
static NSString * const kCaratPriceFrom = @"CaratPriceFrom";
static NSString * const kCaratPriceTo = @"CaratPriceTo";
static NSString * const kTotalPriceFrom = @"TotalPriceFrom";
static NSString * const kTotalPriceTo = @"TotalPriceTo";
static NSString * const kDiscountFrom = @"DiscountFrom";
static NSString * const kDiscountTo = @"DiscountTo";
static NSString * const kDepthPercentFrom = @"DepthPercentFrom";
static NSString * const kDepthPercentTo = @"DepthPercentTo";
static NSString * const kRatioFrom = @"RatioFrom";
static NSString * const kRatioTo = @"RatioTo";
static NSString * const kCityID = @"CityID";
static NSString * const kStateID = @"StateID";
static NSString * const kSellerIDs = @"SellerIDs";
static NSString * const kCountryIDs = @"CountryIDs";
static NSString * const kShapeIDs = @"ShapeIDs";
static NSString * const kColorIDs = @"ColorIDs";
static NSString * const kFancyColorIDs = @"FancyColorIDs";
static NSString * const kFancyOvertoneIDs = @"FancyOvertoneIDs";
static NSString * const kClarityIDs = @"ClarityIDs";
static NSString * const kCutIDs = @"CutIDs";
static NSString * const kLabIDs = @"LabIDs";
static NSString * const kPolishIDs = @"PolishIDs";
static NSString * const kSymmetryIDs = @"SymmetryIDs";
static NSString * const kOvertoneIDs = @"OvertoneIDs";
static NSString * const kGirdleIDs = @"GirdleIDs";
static NSString * const kFluorescenceColorIDs = @"FluorescenceColorIDs";
static NSString * const kFluorescenceIntensityIDs = @"FluorescenceIntensityIDs";
static NSString * const kFancyIntensityIDs = @"FancyIntensityIDs";
static NSString * const kCuletConditionIDs = @"CuletConditionIDs";
static NSString * const kCuletSizeIDs = @"CuletSizeIDs";
static NSString * const kAvailabilityIDs = @"AvailabilityIDs";
static NSString * const kRatioCategory = @"RatioCategory";
static NSString * const kTotalCount = @"TotalCount";

@synthesize webData,xmlParser,results,delegate;


-(NSString*)getWebServiceField:(NSString*)field value:(NSString*)value
{
    if(value != nil && value.length > 0)
    {
        NSString *str = [NSString stringWithFormat:@"<%@>%@</%@> \n", field, value, field];
        return str;
    }
    
    return @"";
}

-(NSString*)getWebServiceField:(NSString*)field arr:(NSMutableArray*)arr idField:(NSString*)idField descField:(NSString*)descField
{
    NSString *value;
    NSMutableString *values = [[NSMutableString alloc] init];
    

    if(arr != nil && arr.count > 0)
    {
        for(int i = 0; i<arr.count; i++)
        {
            value = [[arr objectAtIndex:i] objectForKey:idField];
            [values appendString:value];
            if( i + 1 < arr.count)
                [values appendString:@", "];
        }
        NSString *str = [NSString stringWithFormat:@"<%@>%@</%@> \n", field, values, field];
        return str;
    }
    
    return @"";
}

-(void)getDiamondsList:(DiamondSearchParams*)params
{
    NSMutableString *request = [[NSMutableString alloc] init];
    
    [request appendString:[self getWebServiceField:kSearchTypeField value:params.searchType]];
    [request appendString:[self getWebServiceField:kFirstRowNum value:params.firstRowNum]];
    [request appendString:[self getWebServiceField:kToRowNum value:params.toRowNum]];
    [request appendString:[self getWebServiceField:kWeightFrom value:params.weightFrom]];
    [request appendString:[self getWebServiceField:kWeightTo value:params.weightTo]];
    [request appendString:[self getWebServiceField:kIncludeTreatments value:params.includeTreatments]];
    [request appendString:[self getWebServiceField:kHasCertFile value:params.hasCertFile]];
    [request appendString:[self getWebServiceField:kCaratPriceFrom value:params.caratPriceFrom]];
    [request appendString:[self getWebServiceField:kCaratPriceTo value:params.caratPriceTo]];
    [request appendString:[self getWebServiceField:kDiscountFrom value:params.discountFrom]];
    [request appendString:[self getWebServiceField:kDiscountTo value:params.discountTo]];
    [request appendString:[self getWebServiceField:kDepthPercentFrom value:params.depthPercentFrom]];
    [request appendString:[self getWebServiceField:kDepthPercentTo value:params.depthPercentTo]];
    [request appendString:[self getWebServiceField:kRatioFrom value:params.ratioFrom]];
    [request appendString:[self getWebServiceField:kRatioTo value:params.ratioTo]];
    
    [request appendString:[self getWebServiceField:kSellerIDs arr:params.sellers idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kCountryIDs arr:params.countries idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kShapeIDs arr:params.shapes idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kColorIDs arr:params.colors idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kFancyColorIDs arr:params.fancyColors idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kFancyOvertoneIDs arr:params.fancyOvertones idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kFancyIntensityIDs arr:params.fancyIntensities idField:kValueElementName descField:kDescriptionElementName]];
    
    [request appendString:[self getWebServiceField:kClarityIDs arr:params.clarities idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kCutIDs arr:params.cuts idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kLabIDs arr:params.labs idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kPolishIDs arr:params.polishes idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kSymmetryIDs arr:params.symmetries idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kOvertoneIDs arr:params.overtones idField:kValueElementName descField:kDescriptionElementName]];
   
    [request appendString:[self getWebServiceField:kGirdleIDs arr:params.girdles idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kFluorescenceColorIDs arr:params.fluorescenceColors idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kFluorescenceIntensityIDs arr:params.fluorescenceIntensities idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kCuletConditionIDs arr:params.culetConditions idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kCuletSizeIDs arr:params.culetSizes idField:kValueElementName descField:kDescriptionElementName]];
    [request appendString:[self getWebServiceField:kAvailabilityIDs arr:params.availabilities idField:kValueElementName descField:kDescriptionElementName]];
    
    [request appendString:[self getWebServiceField:kRatioCategory value:params.rationCategory]];
    
    if(results == nil)
		results= [[NSMutableArray alloc] init];
    NSString *ticket = [StoredData sharedData].strRapnetTicket;
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetDiamondResults xmlns=\"%@/\"> \n"
                             "<Params> \n"
                             "%@"
                             "</Params> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetDiamondResults> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, BaseUrl, ticket, BaseUrl, request, SoftwareCode];
    

    NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RapnetWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetDiamondResults", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self]autorelease];
    
    if( theConnection ){
		ReleaseObject(webData);
		webData = [[NSMutableData data] retain];
	}
	else{
		//NSLog(@"theConnection is NULL");
	}

}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	
	[webData appendData:mydata];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
	if(connection !=nil)
		ReleaseObject(connection);
	if(webData !=nil)
		ReleaseObject(webData);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    	NSLog(@"%@",theXML);
	[theXML release];
	[self connectToParser:webData];
    
}

-(void)connectToParser:(NSMutableData *)xmldata
{
	ReleaseObject(xmlParser);
	xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"Table"]) 
	{
        ReleaseObject(diamond);
        
        diamond = [[DiamondSearchResult alloc] init];
		ReleaseObject(data);
        
		ReleaseObject(diamondID);
        ReleaseObject(accountID);
        ReleaseObject(company);
        ReleaseObject(email);
        ReleaseObject(tel1);
        ReleaseObject(tel2);
        ReleaseObject(fax);
        ReleaseObject(shape);
        ReleaseObject(weight);
        ReleaseObject(color);
        ReleaseObject(clarity);
        ReleaseObject(cut);
        ReleaseObject(polish);
        ReleaseObject(depthPercent);
        ReleaseObject(fluorescenceIntensity);
        ReleaseObject(lab);
        ReleaseObject(certificateNumber);
        ReleaseObject(lowestPricePerCarat);
        ReleaseObject(lowestDiscount);
        ReleaseObject(lowestTotalPrice);
        ReleaseObject(pricePerCarat);
        ReleaseObject(listPrice);
        
        ReleaseObject(measDepth);
        ReleaseObject(measLength);
        ReleaseObject(measWidth);
        
        ReleaseObject(symmetry);
        ReleaseObject(tablePercent);
        ReleaseObject(city);
        
        ReleaseObject(country);
        ReleaseObject(girdleMaxSize);
        ReleaseObject(girdleMinSize);
        ReleaseObject(state);
        
        ReleaseObject(certificateImage);
        
        ReleaseObject(fancyColorOvertones);
        ReleaseObject(fancyColorIntensityTitle);
        ReleaseObject(fancyColorTitle1);
        ReleaseObject(fancyColorTitle2);
        ReleaseObject(nameCode);
        ReleaseObject(firstName);
        ReleaseObject(lastName);
        ReleaseObject(cashPricePerCarat);
        ReleaseObject(girdleCondition);
        ReleaseObject(girdlePercent);
        ReleaseObject(vendorStockNumber);
        ReleaseObject(culetCondition);
        ReleaseObject(crownAngle);
        ReleaseObject(crownHeight);
        ReleaseObject(pavilionDepth);
        ReleaseObject(pavilionAngle);
        ReleaseObject(ratio);
        ReleaseObject(rapSpec);
        ReleaseObject(isLaserDrilled);
        ReleaseObject(isIrradiated);
        ReleaseObject(isClarityEnhanced);
        ReleaseObject(isColorEnhanced);
        ReleaseObject(isHPHT);
        ReleaseObject(isOtherTreatment);
        ReleaseObject(availability);
        ReleaseObject(ratingPercent);
        ReleaseObject(totalRating);
        ReleaseObject(laserInscription);
        ReleaseObject(rapCode);
        ReleaseObject(dateUpdated);
        ReleaseObject(has3Dfile);
        ReleaseObject(imageFile);
        
        //data      = [[NSMutableDictionary alloc] init];
		
        diamondID	 = [[NSMutableString alloc] init];	
        accountID	 = [[NSMutableString alloc] init];
        company	 = [[NSMutableString alloc] init];	
        email	 = [[NSMutableString alloc] init];
        tel1	 = [[NSMutableString alloc] init];	
        tel2	 = [[NSMutableString alloc] init];
        fax      = [[NSMutableString alloc] init];	
        shape	 = [[NSMutableString alloc] init];
        weight	 = [[NSMutableString alloc] init];	
        color	 = [[NSMutableString alloc] init];	
        clarity	 = [[NSMutableString alloc] init];
        cut	 = [[NSMutableString alloc] init];	
        polish	 = [[NSMutableString alloc] init];
        depthPercent	 = [[NSMutableString alloc] init];	
        fluorescenceIntensity	 = [[NSMutableString alloc] init];
        lab      = [[NSMutableString alloc] init];	
        certificateNumber	 = [[NSMutableString alloc] init];
        lowestPricePerCarat	 = [[NSMutableString alloc] init];	
       
        lowestDiscount	 = [[NSMutableString alloc] init];	
        lowestTotalPrice	 = [[NSMutableString alloc] init];
        pricePerCarat	 = [[NSMutableString alloc] init];	
        listPrice	 = [[NSMutableString alloc] init];
        
        measDepth	 = [[NSMutableString alloc] init];	
        measLength	 = [[NSMutableString alloc] init];
        measWidth	 = [[NSMutableString alloc] init];	

        
        symmetry	 = [[NSMutableString alloc] init];	
        tablePercent	 = [[NSMutableString alloc] init];
         city     = [[NSMutableString alloc] init];	
        
        country     = [[NSMutableString alloc] init];
        girdleMaxSize     = [[NSMutableString alloc] init];
        girdleMinSize     = [[NSMutableString alloc] init];
        state     = [[NSMutableString alloc] init];
    
        
        certificateImage	 = [[NSMutableString alloc] init];	
        
        fancyColorOvertones= [[NSMutableString alloc] init];
        fancyColorIntensityTitle = [[NSMutableString alloc] init];;
        fancyColorTitle1 = [[NSMutableString alloc] init];;
        fancyColorTitle2 = [[NSMutableString alloc] init];;
        nameCode = [[NSMutableString alloc] init];;
        firstName = [[NSMutableString alloc] init];;
        lastName = [[NSMutableString alloc] init];;
        cashPricePerCarat = [[NSMutableString alloc] init];;
        girdleCondition = [[NSMutableString alloc] init];;
        girdlePercent = [[NSMutableString alloc] init];;
        vendorStockNumber = [[NSMutableString alloc] init];;
        culetCondition = [[NSMutableString alloc] init];;
        crownAngle = [[NSMutableString alloc] init];;
        crownHeight = [[NSMutableString alloc] init];;
        pavilionDepth = [[NSMutableString alloc] init];;
        pavilionAngle = [[NSMutableString alloc] init];;
        ratio = [[NSMutableString alloc] init];;
        rapSpec = [[NSMutableString alloc] init];;
        isLaserDrilled = [[NSMutableString alloc] init];;
        isIrradiated = [[NSMutableString alloc] init];;
        isClarityEnhanced = [[NSMutableString alloc] init];;
        isColorEnhanced = [[NSMutableString alloc] init];;
        isHPHT = [[NSMutableString alloc] init];;
        isOtherTreatment = [[NSMutableString alloc] init];;
        availability = [[NSMutableString alloc] init];;
        ratingPercent = [[NSMutableString alloc] init];;
        totalRating = [[NSMutableString alloc] init];;
        laserInscription = [[NSMutableString alloc] init];;
        rapCode = [[NSMutableString alloc] init];;
        dateUpdated = [[NSMutableString alloc] init];;
        has3Dfile = [[NSMutableString alloc] init];;
        imageFile = [[NSMutableString alloc] init];;
         
        
	}
    else if ([elementName isEqualToString:@"TotalCount"]) 
    {
        totalCount = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

	if ([currentElement isEqualToString:@"DiamondID"]){
		[diamondID  appendString:string];
	}else if ([currentElement isEqualToString:@"AccountNumber"]){
		[accountID  appendString:string];
	}else if ([currentElement isEqualToString:@"Company"]){
		[company  appendString:string];
	}else if ([currentElement isEqualToString:@"Email"]){
		[email  appendString:string];
	}else if ([currentElement isEqualToString:@"Tel1"]){
		[tel1  appendString:string];
	}else if ([currentElement isEqualToString:@"Tel2"]){
		[tel2  appendString:string];
	}else if ([currentElement isEqualToString:@"Fax"]){
		[fax  appendString:string];
	}else if ([currentElement isEqualToString:@"Shape"]){
		[shape  appendString:string];
	}else if ([currentElement isEqualToString:@"Weight"]){
		[weight  appendString:string];
	}else if ([currentElement isEqualToString:@"Color"]){
		[color  appendString:string];
	}else if ([currentElement isEqualToString:@"Clarity"]){
		[clarity  appendString:string];
	}else if ([currentElement isEqualToString:@"Cut"]){
		[cut  appendString:string];
	}else if ([currentElement isEqualToString:@"Polish"]){
		[polish  appendString:string];
	}else if ([currentElement isEqualToString:@"DepthPercent"]){
		[depthPercent  appendString:string];
	}else if ([currentElement isEqualToString:@"FluorescenceIntensity"]){
		[fluorescenceIntensity  appendString:string];
	}else if ([currentElement isEqualToString:@"Lab"]){
		[lab  appendString:string];
	}else if ([currentElement isEqualToString:@"CertificateNumber"]){
		[certificateNumber  appendString:string];
	}else if ([currentElement isEqualToString:@"LowestPricePerCarat"]){
		[lowestPricePerCarat  appendString:string];
	}else if ([currentElement isEqualToString:@"LowestDiscount"]){
		[lowestDiscount  appendString:string];
	}else if ([currentElement isEqualToString:@"LowestTotalPrice"]){
		[lowestTotalPrice  appendString:string];
	}else if ([currentElement isEqualToString:@"PricePerCarat"]){
		[pricePerCarat  appendString:string];
	}else if ([currentElement isEqualToString:@"ListPrice"]){
		[listPrice  appendString:string];
        
    } else if ([currentElement isEqualToString:@"MeasDepth"]){
		[measDepth  appendString:string];
	}else if ([currentElement isEqualToString:@"MeasLength"]){
		[measLength  appendString:string];
	}else if ([currentElement isEqualToString:@"MeasWidth"]){
		[measWidth  appendString:string];
        
	}else if ([currentElement isEqualToString:@"Symmetry"]){
		[symmetry  appendString:string];
	}else if ([currentElement isEqualToString:@"TablePercent"]){
		[tablePercent  appendString:string];
	}else if ([currentElement isEqualToString:@"City"]){
		[city  appendString:string];
	}else if ([currentElement isEqualToString:@"Country"]){
		[country  appendString:string];
	}else if ([currentElement isEqualToString:@"GirdleMaxSize"]){
		[girdleMaxSize  appendString:string];
	}else if ([currentElement isEqualToString:@"GirdleMinSize"]){
		[girdleMinSize  appendString:string];
	}else if ([currentElement isEqualToString:@"State"]){
		[state  appendString:string];
	}else if ([currentElement isEqualToString:@"CertificateImage"]){
		[certificateImage  appendString:string];
	}else if ([currentElement isEqualToString:@"TotalCount"]){
		[totalCount  appendString:string];
	}else if ([currentElement isEqualToString:@"FancyColorOvertones"]){
		[fancyColorOvertones  appendString:string];
	}else if ([currentElement isEqualToString:@"FancyColorIntensityTitle"]){
		[fancyColorIntensityTitle  appendString:string];
	}else if ([currentElement isEqualToString:@"FancyColorTitle1"]){
		[fancyColorTitle1  appendString:string];
	}else if ([currentElement isEqualToString:@"FancyColorTitle2"]){
		[fancyColorTitle2  appendString:string];
	}else if ([currentElement isEqualToString:@"NameCode"]){
		[nameCode  appendString:string];
	}else if ([currentElement isEqualToString:@"FirstName"]){
		[firstName  appendString:string];
	}else if ([currentElement isEqualToString:@"LastName"]){
		[lastName  appendString:string];
	}else if ([currentElement isEqualToString:@"CashPricePerCarat"]){
		[cashPricePerCarat  appendString:string];
	}else if ([currentElement isEqualToString:@"GirdleCondition"]){
		[girdleCondition  appendString:string];
	}else if ([currentElement isEqualToString:@"GirdlePercent"]){
		[girdlePercent  appendString:string];
	}else if ([currentElement isEqualToString:@"VendorStockNumber"]){
		[vendorStockNumber  appendString:string];
	}else if ([currentElement isEqualToString:@"CuletCondition"]){
		[culetCondition  appendString:string];
	}else if ([currentElement isEqualToString:@"CrownAngle"]){
		[crownAngle  appendString:string];
	}else if ([currentElement isEqualToString:@"CrownHeight"]){
		[crownHeight  appendString:string];
	}else if ([currentElement isEqualToString:@"PavilionDepth"]){
		[pavilionDepth  appendString:string];
	}else if ([currentElement isEqualToString:@"PavilionAngle"]){
		[pavilionAngle  appendString:string];
	}else if ([currentElement isEqualToString:@"Ratio"]){
		[ratio  appendString:string];
	}else if ([currentElement isEqualToString:@"RapSpec"]){
		[rapSpec  appendString:string];
    }else if ([currentElement isEqualToString:@"IsLaserDrilled"]){
		[isLaserDrilled  appendString:string];
	}else if ([currentElement isEqualToString:@"IsIrradiated"]){
		[isIrradiated  appendString:string];
	}else if ([currentElement isEqualToString:@"IsClarityEnhanced"]){
		[isClarityEnhanced  appendString:string];
	}else if ([currentElement isEqualToString:@"IsColorEnhanced"]){
		[isColorEnhanced  appendString:string];
	}else if ([currentElement isEqualToString:@"IsHPHT"]){
		[isHPHT  appendString:string];
	}else if ([currentElement isEqualToString:@"IsOtherTreatment"]){
		[isOtherTreatment  appendString:string];
	}else if ([currentElement isEqualToString:@"Availability"]){
		[availability  appendString:string];
	}else if ([currentElement isEqualToString:@"RatingPercent"]){
		[ratingPercent  appendString:string];
	}else if ([currentElement isEqualToString:@"TotalRating"]){
		[totalRating  appendString:string];
    }else if ([currentElement isEqualToString:@"LaserInscription"]){
		[laserInscription  appendString:string];
	}else if ([currentElement isEqualToString:@"RapCode"]){
		[rapCode  appendString:string];
	}else if ([currentElement isEqualToString:@"DateUpdated"]){
		[dateUpdated  appendString:string];
	}else if ([currentElement isEqualToString:@"Has3Dfile"]){
		[has3Dfile  appendString:string];
	}else if ([currentElement isEqualToString:@"ImageFile"]){
		[imageFile  appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Table"])
	{
        diamond.diamondID = diamondID;
        diamond.accountID = accountID;
        diamond.company = company;
        diamond.email =email;
        diamond.tel1 = tel1;
        diamond.tel2 = tel2;
        diamond.fax = fax;
        diamond.shape = shape;
        diamond.weight = weight;
        diamond.color = color;
        diamond.clarity = clarity;
        diamond.cut = cut;
        diamond.polish = polish;
        diamond.depthPercent = depthPercent;
        diamond.fluorescenceIntensity = fluorescenceIntensity;
        diamond.lab = lab;
        diamond.certificateNumber = certificateNumber;
        diamond.LowestPricePerCarat = lowestPricePerCarat;
        diamond.lowestDiscount = lowestDiscount;
        diamond.lowestTotalPrice = lowestTotalPrice;
        diamond.pricePerCarat = pricePerCarat;
        diamond.listPrice = listPrice;
        
        
        diamond.measDepth = measDepth;
        diamond.measLength = measLength;
        diamond.measWidth = measWidth;
      
        
        diamond.symmetry = symmetry;
        diamond.tablePercent = tablePercent;
        diamond.city = city;
        
        diamond.country = country;
        diamond.girdleMaxSize = girdleMaxSize;
        diamond.girdleMinSize = girdleMinSize;
        diamond.state = state;
 
        
        diamond.certificateImage = certificateImage;
        
        
        
        
        
        diamond.fancyColorOvertones = fancyColorOvertones;
        diamond.fancyColorIntensityTitle = fancyColorIntensityTitle;
        diamond.fancyColorTitle1 = fancyColorTitle1;
        diamond.fancyColorTitle2 = fancyColorTitle2;
        diamond.nameCode = nameCode;
        diamond.firstName = firstName;
        diamond.lastName = lastName;
        diamond.cashPricePerCarat = cashPricePerCarat;
        diamond.girdleCondition = girdleCondition;
        diamond.girdlePercent = girdlePercent;
        diamond.vendorStockNumber = vendorStockNumber;
        diamond.culetCondition = culetCondition;
        diamond.crownAngle = crownAngle;
        diamond.crownHeight = crownHeight;
        diamond.pavilionDepth = pavilionDepth;
        diamond.pavilionAngle = pavilionAngle;
        diamond.ratio = ratio;
        diamond.rapSpec = rapSpec;
        diamond.isLaserDrilled = isLaserDrilled;
        diamond.isIrradiated = isIrradiated;
        diamond.isClarityEnhanced = isClarityEnhanced;
        diamond.isColorEnhanced = isColorEnhanced;
        diamond.isHPHT = isHPHT;
        diamond.isOtherTreatment = isOtherTreatment;
        diamond.availability = availability;
        diamond.ratingPercent = ratingPercent;
        diamond.totalRating = totalRating;
        diamond.laserInscription = laserInscription;
        diamond.rapCode  =rapCode ;
        diamond.dateUpdated = dateUpdated;
        diamond.has3Dfile = has3Dfile;
        diamond.imageFile = imageFile;
        [results addObject:diamond];

	}
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    [delegate webserviceCallDiamondsSearchResultFinished:results total:[totalCount intValue]];	
}

/*
-(NSMutableArray*)getResults
{
	return results;
}
 */

- (void)dealloc 
{
    [diamond release];
    [diamondID release];
	[accountID release];
    [company release];
	[email release];
    [tel1 release];
	[tel2 release];
    [fax release];
	[shape release];
    [weight release];
	[color release];
    [clarity release];
	[cut release];
    [polish release];
	[depthPercent release];
    [fluorescenceIntensity release];
	[lab release];
    [certificateNumber release];
	[lowestPricePerCarat release];
    [lowestDiscount release];
	[lowestTotalPrice release];
    [pricePerCarat release];
	[listPrice release];
    
    
    [measDepth release];
    [measLength release];
	[measWidth release];
    
    [symmetry release];
    [tablePercent release];
    [city release];
 
    [country release];
	[girdleMaxSize release];
    [girdleMinSize release];
	[state release];    
    
    [certificateImage release];
    
    
    [fancyColorOvertones release];
    [fancyColorIntensityTitle release];
    [fancyColorTitle1 release];
    [fancyColorTitle2 release];
    [nameCode release];
    [firstName release];
    [lastName release];
    [cashPricePerCarat release];
    [girdleCondition release];
    [girdlePercent release];
    [vendorStockNumber release];
    [culetCondition release];
    [crownAngle release];
    [crownHeight release];
    [pavilionDepth release];
    [pavilionAngle release];
    [ratio release];
    [rapSpec release];
    [isLaserDrilled release];
    [isIrradiated release];
    [isClarityEnhanced release];
    [isColorEnhanced release];
    [isHPHT release];
    [isOtherTreatment release];
    [availability release];
    [ratingPercent release];
    [totalRating release];
    [laserInscription release];
    [rapCode release];
    [dateUpdated release];
    [has3Dfile release];
    [imageFile release];
    
    
    [xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[super dealloc];
}


@end

