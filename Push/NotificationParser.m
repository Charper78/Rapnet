//
//  NotificationParser.m
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "NotificationParser.h"

@implementation NotificationParser


static NSString * const kMessageElementName = @"Message";
static NSString * const kIdElementName = @"ID";
static NSString * const kMessageDataElementName = @"MessageData";
static NSString * const kMessageDateElementName = @"MessageDate";

static NSString * const kDataElementName = @"Data";
static NSString * const kResultElementName = @"Result";


-(void)getNotifications:(NSString*)deviceID {
    
    NSString *soapAction = @"GetMessages";
    NSString *soapMessage = @"";
    
    soapMessage = [self getSoapMessage:soapAction deviceID:deviceID];
    
    NSLog(@"%@", soapMessage);
    
    [self sendMessage:soapMessage soapAction:soapAction];
}

-(NSString*)getSoapMessage:(NSString*)soapAction deviceID:(NSString*)deviceID 
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<%@ xmlns=\"%@/\"> \n"
                             "<deviceID>%@</deviceID> \n"
                             "</%@> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, soapAction, PnsNamespace, deviceID,
                             soapAction];
    return soapMessage;
}

-(void)sendMessage:(NSString*)soapMessage soapAction:(NSString*)soapAction
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", PnsUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/%@", PnsNamespace, soapAction] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableData *webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
    
    NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self]autorelease];
    
    if( theConnection ){
		ReleaseObject(_webData);
		_webData = [[NSMutableData data] retain];
	}
	else{
		//NSLog(@"theConnection is NULL");
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	
	[_webData appendData:mydata];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",theXML);
	[theXML release];
	[self connectToParser:_webData];
    
}

-(void)connectToParser:(NSMutableData *)xmldata
{
	ReleaseObject(_xmlParser);
	_xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
    
	[_xmlParser setDelegate: self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if(nil != qName){
		elementName = qName;
	}
    
	_currentElement = [elementName copy];
	
    if ([elementName isEqualToString:kDataElementName])
        results = [[NSMutableArray alloc] init];
	else if ([elementName isEqualToString:kMessageElementName])
	{
        ReleaseObject(notification);
		ReleaseObject(notificationID);
		ReleaseObject(messageData);
        ReleaseObject(messageDate);
        
        notification    = [[Notification alloc] init];
		notificationID  = [[NSMutableString alloc] init];
		messageData     = [[NSMutableString alloc] init];
        messageDate     = [[NSMutableString alloc] init];
	}
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([_currentElement isEqualToString:kMessageDataElementName]){
		[messageData  appendString:string];
    }
    else if ([_currentElement isEqualToString:kIdElementName]){
		[notificationID  appendString:string];
    }
    else if ([_currentElement isEqualToString:kMessageDateElementName]){
		[messageDate  appendString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:kMessageElementName])
	{
        notification.notificationID = [notificationID integerValue];
        notification.messageData = messageData;
        notification.messageDate = [Functions getDate:messageDate];
        
        [NotificationsHelper addNotification:notification];
        
		[results addObject:notification];
    }
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
    NSString * localizedDescription = parseError.localizedDescription;

}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    //NSMutableArray *arr = [self getResults];
    [_delegate getNotificationsFinished:results total:results.count];
    
    
}


- (void)dealloc
{
    ReleaseObject(results);
    ReleaseObject(notificationID);
    ReleaseObject(messageData);
    ReleaseObject(notification);
    
	[_xmlParser release];
	[_webData release];
	//[data release];
    
	[super dealloc];
}

@end
