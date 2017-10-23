//
//  SKDownloadRequest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKDownloadRequest.h"
#import "SKSessionManger.h"

@interface SKDownloadRequest ()


@end


@implementation SKDownloadRequest
- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler {
    self = [super initWithPath:path method:DOWNLOAD headers:headers successHandler:successHandler failureHandler:failureHandler];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[SKSessionManger sharedSessionManger] baseUrl] ,self.getPath]];
    self.fullUrl = url;

    return self;
}



-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" headers:[NSDictionary new] successHandler:nil failureHandler:nil];
}

-(NSMutableURLRequest*) getMethodRequestObject{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.fullUrl];
    
    return request;
}


-(NSURL*)getURL{
    
    return self.fullUrl;
}
@end
