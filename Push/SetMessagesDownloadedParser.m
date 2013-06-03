//
//  SetMessagesDownloadedParser.m
//  Rapnet
//
//  Created by Home on 6/3/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "SetMessagesDownloadedParser.h"

@implementation SetMessagesDownloadedParser

-(void)setDownloadedNotifications:(NSString*)deviceID ids:(NSString*)ids
{
    NSString *soapAction = @"SetMessagesDownloaded";
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<%@ xmlns=\"%@/\"> \n"
                             "<token>%@</token> \n"
                             "<messageIDS>%@</messageIDS> \n"
                             "</%@> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, soapAction, PnsNamespace, deviceID,
                             ids, soapAction];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", PnsUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/%@", PnsNamespace, soapAction] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",soapMessage);
    
    NSMutableData *data = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    NSString *theXML = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
    
}

@end
