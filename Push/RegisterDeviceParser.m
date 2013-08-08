//
//  RegisterDeviceParser.m
//  Rapnet
//
//  Created by Home on 3/12/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "RegisterDeviceParser.h"

@implementation RegisterDeviceParser

-(bool)registerDevice:(NSString*)appName appVersion:(NSString*)appVersion clientID:(NSString*)clientID
          accountID:(NSString*)accountID contactID:(NSString*)contactID deviceToken:(NSString*)deviceToken
          deviceModel:(NSString*)deviceModel deviceVersion:(NSString*)deviceVersion pushBadge:(BOOL)pushBadge
            pushAlert:(BOOL)pushAlert pushSound:(BOOL)pushSound
{
    NSString *soapAction = @"RegisterDevice";
    NSString *soapMessage = @"";
    
    soapMessage = [self getSoapMessage:soapAction appName:appName appVersion:appVersion clientID:clientID accountID:accountID contactID:contactID deviceToken:deviceToken deviceModel:deviceModel deviceVersion:deviceVersion pushBadge:pushBadge pushAlert:pushAlert pushSound:pushSound notifyPriceChange:nil];
    
    NSLog(@"%@", soapMessage);
    
    return [self sendMessage:soapMessage soapAction:soapAction];
}

-(bool)registerDevice:(NSString*)appName appVersion:(NSString*)appVersion clientID:(NSString*)clientID
           accountID:(NSString*)accountID contactID:(NSString*)contactID deviceToken:(NSString*)deviceToken
          deviceModel:(NSString*)deviceModel deviceVersion:(NSString*)deviceVersion pushBadge:(BOOL)pushBadge
pushAlert:(BOOL)pushAlert pushSound:(BOOL)pushSound notifyPriceChange:(BOOL)notifyPriceChange
{
    NSString *soapAction = @"RegisterDevice";
    NSString *soapMessage = @"";
    
    soapMessage = [self getSoapMessage:soapAction appName:appName appVersion:appVersion clientID:clientID accountID:accountID contactID:contactID deviceToken:deviceToken deviceModel:deviceModel deviceVersion:deviceVersion pushBadge:pushBadge pushAlert:pushAlert pushSound:pushSound notifyPriceChange:[Functions boolToString:notifyPriceChange]];
        
    NSLog(@"%@", soapMessage);
    
    return [self sendMessage:soapMessage soapAction:soapAction];
}

-(BOOL)sendMessage:(NSString*)soapMessage soapAction:(NSString*)soapAction
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", PnsUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/%@", PnsNamespace, soapAction] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
    [theXML release];
	[self connectToParser:webData];
    
    return result;

}

-(NSString*)getSoapMessage:(NSString*)soapAction appName:(NSString*)appName appVersion:(NSString*)appVersion clientID:(NSString*)clientID
                 accountID:(NSString*)accountID contactID:(NSString*)contactID deviceToken:(NSString*)deviceToken
                                    deviceModel:(NSString*)deviceModel deviceVersion:(NSString*)deviceVersion pushBadge:(BOOL)pushBadge
                                      pushAlert:(BOOL)pushAlert pushSound:(BOOL)pushSound notifyPriceChange:(NSString*)notifyPriceChange
{
    
    
    NSString *client = @"";
    NSString *notifyPrice = @"";
    NSString *account = @"";
    NSString *contact = @"";
    
    if(notifyPriceChange != nil)
        notifyPrice = [NSString stringWithFormat:@"<notifyPriceChange>%@</notifyPriceChange> \n", notifyPriceChange];
    
    if(clientID != nil && [clientID length] > 0)
        client = [NSString stringWithFormat:@"<clientID>%@</clientID> \n", clientID];
    
    if(accountID != nil && [accountID length] > 0 && [accountID isEqualToString:@"0"] == false)
        account = [NSString stringWithFormat:@"<accountID>%@</accountID> \n", accountID];

    
    if(contactID != nil && [contactID length] > 0 && [contactID isEqualToString:@"0"] == false)
        contact = [NSString stringWithFormat:@"<contactID>%@</contactID> \n", contactID];

    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<%@ xmlns=\"%@/\"> \n"
                             "<appName>%@</appName> \n"
                             "<appVersion>%@</appVersion> \n"
                             "%@"
                             "%@"
                             "%@"
                             "<deviceToken>%@</deviceToken> \n"
                             "<deviceModel>%@</deviceModel> \n"
                             "<deviceVersion>%@</deviceVersion> \n"
                             "<pushBadge>%@</pushBadge> \n"
                             "<pushAlert>%@</pushAlert> \n"
                             "<pushSound>%@</pushSound> \n"
                             "%@"
                             "<devicePlatform>iOS</devicePlatform> \n"
                             "</%@> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, soapAction, PnsNamespace, appName, appVersion,
                             client, account, contact, deviceToken, deviceModel,
                             deviceVersion, [Functions boolToString: pushBadge],
                             [Functions boolToString: pushAlert], [Functions boolToString: pushSound],
                             notifyPrice,
                             soapAction];
    return soapMessage;

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
	if(nil != qName){
		elementName = qName;
	}
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"Result"])
	{
		/*if (data !=nil)
		{
			[data release];
			data = nil;
		}
		ReleaseObject(data)
		data= [[NSMutableDictionary alloc] init];
        */
         resultString = [[NSMutableString alloc] init];
        result = FALSE;
	}
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"Result"]){
		[resultString  appendString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Result"])
	{
		result = [[resultString lowercaseString] isEqualToString:@"succeeded"] ? true : false;
    }
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //ddfgdfgdgdfgdfiopiop
}


- (void)dealloc
{
    ReleaseObject(resultString);
    
	[xmlParser release];
	[webData release];
	//[data release];
    
	[super dealloc];
}

@end
