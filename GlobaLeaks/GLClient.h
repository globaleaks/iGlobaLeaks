//
//  GLClient.h
//  GlobaLeaks
//
//  Created by Lorenzo on 19/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Submission.h"

@interface GLClient : NSObject
-(NSDictionary*)loadNode:(Boolean)use_cache;
-(NSArray*)loadData:(Boolean)use_cache ofType:(NSString*)type;
-(NSData*)getImage:(Boolean)use_cache withId:(NSString*)receiver_id;
-(NSDictionary*)createSubmission:(Submission*)s;
-(NSDictionary*)sendSubmission:(Submission*)s;
-(NSDictionary*)updateSubmission:(Submission*)s;
-(NSString*)uploadImage:(UIImage*)image submissionID:(NSString*)submisssion_id;
@end
