//
//  GetCountries.m
//  Rapnet
//
//  Created by Richa on 6/10/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "GetCountriesParser.h"


@implementation GetCountriesParser
@synthesize webData,xmlParser,results,delegate;

-(void)GetCountryName
{
	
	if(results == nil)
		results= [[NSMutableArray alloc] init];
	
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetCountries xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetCountries> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode];
    
   // NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetCountries", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	//NSLog(@"%@",theXML);
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
		ReleaseObject(data);
		ReleaseObject(countryID);
		ReleaseObject(countryName);
		ReleaseObject(countryPhoneCode);
		
		data      = [[NSMutableDictionary alloc] init];
		countryID	 = [[NSMutableString alloc] init];
		countryName = [[NSMutableString alloc] init];
		countryPhoneCode = [[NSMutableString alloc] init];
		
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"CountryID"]){
		[countryID  appendString:string];
	}
	else if ([currentElement isEqualToString:@"CountryName"]){
		[countryName  appendString:string];
	}
	else if ([currentElement isEqualToString:@"CountryPhoneCode"]){
		[countryPhoneCode  appendString:string];
	}
		
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Table"])
	{
		[data setObject:countryID forKey:@"CountryID"];
		[data setObject:countryName forKey:@"CountryName"];
		[data setObject:countryPhoneCode forKey:@"CountryPhoneCode"];
		[results addObject:data];
	}		
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    [delegate webserviceCallFinished];	
}

-(NSMutableArray*)getResults
{
	return results;
}

- (void)dealloc 
{
	[countryID release];
	[countryName release];
	[countryPhoneCode release];
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[super dealloc];
}

@end
