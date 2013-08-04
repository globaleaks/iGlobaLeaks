//
//  GLClient.m
//  GlobaLeaks
//
//  Created by Lorenzo on 19/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import "GLClient.h"

@implementation GLClient

-(NSDictionary*)loadNode:(Boolean)use_cache {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    if (use_cache && timestamp < [[NSUserDefaults standardUserDefaults] doubleForKey:@"nodeTimestamp"] + [[NSUserDefaults standardUserDefaults] integerForKey:@"Cache"]){
        NSLog(@"cache");
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"node"]];
    }

    NSString *url = [NSString stringWithFormat: @"%@/node", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    //OPTIONAL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
    [request setTimeoutInterval:60];
    [request setHTTPMethod: @"GET"];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil];
    //NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    //NSLog(@"%@", stringResponse);
    if(response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        if (json != nil){
            [[NSUserDefaults standardUserDefaults] setDouble:timestamp forKey:@"nodeTimestamp"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:json] forKey:@"node"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return json;
        }
    }
    return nil;
}

-(NSArray*)loadData:(Boolean)use_cache ofType:(NSString*)type {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    if (use_cache && timestamp < [[NSUserDefaults standardUserDefaults] doubleForKey:[NSString stringWithFormat:@"%@Timestamp", type]] + [[NSUserDefaults standardUserDefaults] integerForKey:@"Cache"])
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:type]];
    
    NSString *url = [NSString stringWithFormat: @"%@/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"], type];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    [request setTimeoutInterval:60];
    [request setHTTPMethod: @"GET"];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil];
    if(response != nil){
        NSArray* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        if (json != nil){
            [[NSUserDefaults standardUserDefaults] setDouble:timestamp forKey:[NSString stringWithFormat:@"%@Timestamp", type]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:json] forKey:type];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return json;
        }
    }
    return nil;
}

-(NSData*)getImage:(Boolean)use_cache withId:(NSString*)receiver_id{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    if (use_cache && timestamp < [[NSUserDefaults standardUserDefaults] doubleForKey:[NSString stringWithFormat:@"%@Timestamp", receiver_id]] + [[NSUserDefaults standardUserDefaults] integerForKey:@"Cache"])
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:receiver_id]];
     
    NSString *url = [NSString stringWithFormat: @"%@/static/%@.png", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"], receiver_id];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    [request setTimeoutInterval:60];
    [request setHTTPMethod: @"GET"];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil];
    if (response != nil){
        [[NSUserDefaults standardUserDefaults] setDouble:timestamp forKey:[NSString stringWithFormat:@"%@Timestamp", receiver_id]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:response] forKey:receiver_id];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return response;
}

-(NSDictionary*)createSubmission:(Submission*)s{
    NSString *jsonRequest = [s toString];
    NSLog(@"%@", [s toString]);
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/submission", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        return json;
    }
    return nil;
}

-(NSDictionary*)sendSubmission:(Submission*)s{
    NSString *jsonRequest = [s toString];
    NSLog(@"%@", [s toString]);
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/submission", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]]]];
    [request setHTTPMethod:@"POST"];

    //[request addValue:@"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.224 Safari/534.10" forHTTPHeaderField:@"User-Agent"];

    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                         JSONObjectWithData:response
                         options:kNilOptions
                         error:nil];
        return json;
    }
    return nil;
}

-(NSDictionary*)updateSubmission:(Submission*)s;{
    NSString *jsonRequest = [s toString];
    NSLog(@"%@", [s toString]);
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/submission/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"], [s submission_id]]]];
    [request setHTTPMethod:@"PUT"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        return json;
    }
    return nil;
}

-(NSString*)uploadImage:(UIImage*)image submissionID:(NSString*)submisssion_id{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (imageData != nil)
    {
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *filename = [NSString stringWithFormat:@"%d", [timeStampObj integerValue]];
                
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/submission/%@/file", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"], submisssion_id]]];

        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"files[]\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        [request setHTTPBody:body];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
        
        if (response != nil){
            NSArray* json = [NSJSONSerialization
                                  JSONObjectWithData:response
                                  options:kNilOptions
                                  error:nil];
            NSDictionary *dict = [json objectAtIndex:0];
            NSLog(@"%@", [dict objectForKey:@"id"]);
            return [dict objectForKey:@"id"];
        }
    }
    return nil;
}

-(NSDictionary*)login:(NSString*)receipt{
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"username\":\"\",\"password\":\"%@\",\"role\":\"wb\"}", receipt];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/authentication", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        return json;
    }
    return nil;
}

-(NSDictionary*)logout{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/authentication", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]]]];
    [request setHTTPMethod:@"DELETE"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        return json;
    }
    return nil;
}

-(NSDictionary*)fetchTip{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/tip/5e1cb9bb-3fd0-6557-b775-4c153ad7ca82", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]]]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *stringResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
    NSLog(@"%@", stringResponse);
    if (response != nil){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:nil];
        return json;
    }
    return nil;
}
@end
