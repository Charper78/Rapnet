//
//  GetPricecalcParser.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetPricecalcParser.h"


@implementation GetPricecalcParser

@synthesize webData,xmlParser,results,delegate;

-(void)GetPriceCalcWithTicket:(NSString *)ticket PricePerCarat:(float)ppc PriceTotal:(float)total Discount:(float)d RapPriceList:(float)rpl Weight:(float)w ShapeID:(int)sID ClarityID:(int)CLID ColorID:(int)CID UsePear:(BOOL)pearFlag{
    if(results == nil)
		results= [[NSMutableArray alloc] init];
	
   /*
    NSLog(@" T = %@",ticket);
    NSLog(@" T = %f",ppc);
    NSLog(@" T = %f",total);
    NSLog(@" T = %f",d);
    NSLog(@" T = %f",rpl);
    NSLog(@" T = %f",w);
    NSLog(@" T = %d",sID);
    NSLog(@" T = %d",CLID);
    NSLog(@" T = %d",CID);
    NSLog(@" T = %d",pearFlag);
    */
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetPriceCalculation xmlns=\"%@/\"> \n"
                             "<Params>\n"
                             //  "<PricePerCarat>%f</PricePerCarat> \n"
                             //  "<PriceTotal>%f</PriceTotal> \n"
                             "<Discount>%f</Discount> \n"
                             //  "<RapPriceList>%f</RapPriceList> \n"
                             "<Weight>%f</Weight> \n"
                             "<ShapeID>%i</ShapeID> \n"
                             "<ClarityID>%i</ClarityID> \n"
                             "<ColorID>%i</ColorID> \n"
                             //"<Weight xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             //  "<ShapeID xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             //  "<ClarityID xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             //  "<ColorID xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<UsePear>%d</UsePear> \n"
                             "</Params>\n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetPriceCalculation> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,ticket,BaseUrl,d,w,sID,CLID,CID,pearFlag, SoftwareCode];
    
    //NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/PricesWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetPriceCalculation", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
    // NSLog(@"Receive response");
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	//NSLog(@"Receive Data");
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
    //NSLog(@"XML  = %@",theXML);
	[theXML release];
	[self connectToParser:webData];
		
}

-(void)connectToParser:(NSMutableData *)xmldata
{
    //NSLog(@"");
	ReleaseObject(xmlParser);
	xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
    
    
    ReleaseObject(data);		
    ReleaseObject(shape);
    ReleaseObject(clarity);
    ReleaseObject(color);
    
  /*  data      = [[NSMutableDictionary alloc] init];
    shape	 = [[NSMutableString alloc] init];	
    color	 = [[NSMutableString alloc] init];	
    clarity	 = [[NSMutableString alloc] init];	
    */
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	currentElement = [elementName copy];
    
    // NSLog(@"E == %@",elementName);
	
	if ([elementName isEqualToString:@"GetPriceCalculationResult"]) 
	{
		ReleaseObject(data);		
        ReleaseObject(shape);
        ReleaseObject(clarity);
        ReleaseObject(color);
		
		data      = [[NSMutableDictionary alloc] init];
		shape	 = [[NSMutableString alloc] init];	
        color	 = [[NSMutableString alloc] init];	
        clarity	 = [[NSMutableString alloc] init];	
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //  NSLog(@"S == %@",string);
	
	if ([currentElement isEqualToString:@"Shape"]){
		[shape  appendString:string];
        
	}else if ([currentElement isEqualToString:@"Clarity"]){
		[clarity  appendString:string];
        
	}else if ([currentElement isEqualToString:@"Color"]){
		[color  appendString:string];
        
	}else if ([currentElement isEqualToString:@"RapPriceList"]){
		rapPriceList = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"Discount"]){
		discount = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"PriceTotal"]){
		priceTotal = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"PricePerCarat"]){
		pricePerCarat = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"AvgDiscount"]){
		avgDiscount = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"AvgPrice"]){
		avgPrice = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"BestDiscount"]){
		bestDiscount = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"BestPrice"]){
		bestPrice = [string floatValue];
        
	}else if ([currentElement isEqualToString:@"BestAvgDiamondCount"]){
		diamondCount = [string intValue];        
	}
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"GetPriceCalculationResult"])
	{   
        [data setObject:shape forKey:@"Shape"];
        [data setObject:clarity forKey:@"Clarity"];
        [data setObject:color forKey:@"Color"];
        [data setObject:[NSNumber numberWithFloat:rapPriceList] forKey:@"RapPriceList"];
        [data setObject:[NSNumber numberWithFloat:discount] forKey:@"Discount"];
        [data setObject:[NSNumber numberWithFloat:priceTotal] forKey:@"PriceTotal"];
        [data setObject:[NSNumber numberWithFloat:pricePerCarat] forKey:@"PricePerCarat"];
        [data setObject:[NSNumber numberWithFloat:avgDiscount] forKey:@"AvgDiscount"];
        [data setObject:[NSNumber numberWithFloat:avgPrice] forKey:@"AvgPrice"];
        [data setObject:[NSNumber numberWithFloat:bestDiscount] forKey:@"BestDiscount"];
        [data setObject:[NSNumber numberWithFloat:bestPrice] forKey:@"BestPrice"];
        [data setObject:[NSNumber numberWithInt:diamondCount] forKey:@"BestAvgDiamondCount"];
		[results addObject:data];
	}	
	
    
    //  NSLog(@"E == %@",elementName);
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended = %@",results);
    [delegate webserviceCallPriceCalcFinished:results];	
}

-(NSMutableArray*)getResults
{
    
	return results;
}

- (void)dealloc 
{
    [shape release];
    [clarity release];
	[color release];
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[super dealloc];
}


@end
