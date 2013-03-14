//
//  SignUpParser.m
//  Rapnet
//
//  Created by NEHA SINGH on 19/06/11.
//  Copyright 2011 Tech. All rights reserved.
//


#import "SignUpParser.h"
@implementation SignUpParser
@synthesize webData,xmlParser,delegate;

-(void)signUpService:(NSString*)regTo language:(NSString*)language business:(NSString*)business firstName:(NSString*)firstName password:(NSString*)password phoneArea:(NSString*)phoneArea phoneNo:(NSString*)phoneNo company:(NSString*)company lastName:(NSString*)lastName email:(NSString*)email countryID:(NSInteger)countryID;
{
	if(results==nil){  
		results= [[NSMutableArray alloc] init];}
    NSString *soapMessage = [NSString stringWithFormat:
							 @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<AddTradeWireRegistration xmlns=\"%@/\">"
							 "<ConfirmationURL>%@</ConfirmationURL>"
                             "<Params>"
                             "<RegistrationTo>%@</RegistrationTo>"
							 "<AddToLanguage>%@</AddToLanguage>"
							 "<BusinessType>%@</BusinessType>"
							 "<FirstName>%@</FirstName>"
							 "<Password>%@</Password>"
							 "<BusinessPhoneArea>%@</BusinessPhoneArea>"
							 "<BusinessPhoneNumber>%@</BusinessPhoneNumber>"
							 "<Company>%@</Company>"
							 "<LastName>%@</LastName>"
							 "<Email>%@</Email>"
                             "<CountryID>%i</CountryID>"
                             "</Params>"
                             "<SoftwareCode>%@</SoftwareCode>"
                             "</AddTradeWireRegistration>"
                             "</SOAP-ENV:Body> \n"
							 "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,@"",regTo,language,business,firstName,password,phoneArea,phoneNo,company,lastName,email,countryID,SoftwareCode];
	//NSLog(@"%@", soapMessage);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];              
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/AddTradeWireRegistration", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	[delegate webserviceCallFinished];
}

-(void)connectToParser:(NSMutableData *)xmldata
{
	ReleaseObject(xmlParser);
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if(nil != qName){
		elementName = qName;
	}
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"AddTradeWireRegistrationResponse"]) 
	{
		ReleaseObject(data);
		ReleaseObject(signUpResult);
		signUpResult = [[NSMutableString alloc] init];
		data = [[NSMutableDictionary alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"AddTradeWireRegistrationResult"]){
		[signUpResult  appendString:string];
	}
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"AddTradeWireRegistrationResponse"])
	{	
		[data setObject:signUpResult forKey:@"AddTradeWireRegistrationResult"];
		[results addObject:data];
	}	
	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
}


-(NSMutableArray*)getResults
{
	return results;
	//NSLog(@"results%@",results);
}

- (void)dealloc 
{
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[signUpResult release];
	[super dealloc];
}

@end
