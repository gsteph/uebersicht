//
//  Log.m
//  Uebersicht
//
//  Created by George Stephanos on 30/04/2022.
//  Copyright © 2022 tracesOf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log.h"

@implementation Log

- (NSString*) getCurrentTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"HH:mm:ss.SSS000 ";
    [formatter setDateFormat:formatString];
    
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    return dateString;
}

- (void) logMessage:(NSString*) message
{
    NSString *currentTimestamp = [self getCurrentTimestamp];
    
    NSString *fullMessage = [currentTimestamp stringByAppendingString:@"ubersicht  : "];
    fullMessage = [fullMessage stringByAppendingString:message];
    
    NSData *postData = [fullMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://127.0.0.1:41417/http://127.0.0.1:5000/log"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [request setValue:@"http://127.0.0.1:41416" forHTTPHeaderField:@"Origin"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        //NSLog(@"Request reply: %@", requestReply);
    }] resume];
}

@end
