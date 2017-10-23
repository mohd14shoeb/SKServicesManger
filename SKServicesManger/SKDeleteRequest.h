//
//  SKDeleteRequest.h
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKBaseRquest.h"

@interface SKDeleteRequest : SKBaseRquest
- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler;
-(NSMutableURLRequest*) getMethodRequestObject;
-(NSURL*)getURL;

@end
