//
//  Submission.m
//  GlobaLeaks
//
//  Created by Lorenzo on 29/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import "Submission.h"

@implementation Submission

@synthesize context_gus;
@synthesize wb_fields;
@synthesize files;
@synthesize finalize;
@synthesize receivers;
@synthesize submission_id;

-(NSString*)toString{
    NSString *fields = @"";
    NSString *toreturn;
    for (id key in wb_fields) {
        fields = [fields stringByAppendingFormat:@"\"%@\":\"%@\",", key, [wb_fields objectForKey:key]];
    }
    if ( [fields length] > 0)
        fields = [fields substringToIndex:[fields length] - 1];
    if ([files count] >0 )
        toreturn = [NSString stringWithFormat:@"{\"context_gus\":\"%@\",\"wb_fields\":{%@},\"finalize\":%@,\"files\":[\"%@\"],\"receivers\":[\"%@\"]}", context_gus, fields, finalize, [files componentsJoinedByString:@"\", \""], [receivers componentsJoinedByString:@"\", \""]];
    else
    toreturn = [NSString stringWithFormat:@"{\"context_gus\":\"%@\",\"wb_fields\":{%@},\"finalize\":%@,\"files\":[],\"receivers\":[\"%@\"]}", context_gus, fields, finalize, [receivers componentsJoinedByString:@"\", \""]];
    return toreturn;
}

@end