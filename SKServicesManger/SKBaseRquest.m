//
//  SKBaseRquest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKBaseRquest.h"
#import "SKSessionManger.h"


@interface SKBaseRquest ()

@property  SKRequestMethodType requestMethod;
@property  NSString* path;
@property  NSDictionary* headers;
@property (nonatomic,copy)handlerBlock successHandler;
@property (nonatomic,copy)handlerBlock failureHandler;
@property NSUInteger taskIdentifier;

@end

@implementation SKBaseRquest

- (id)initWithPath:(NSString*)path method:(SKRequestMethodType)method headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler
{
    self = [super  init];
    self.path = path;
    self.requestMethod = method;
    self.headers = headers;
    self.successHandler = successHandler;
    self.failureHandler = failureHandler;
    
    return self;
}

-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" method:GET headers:[NSDictionary new] successHandler:nil failureHandler:nil];
}

-(NSString*)getPath{
    return self.path;
}

-(SKRequestMethodType)getRequestType{
    return self.requestMethod;
}

-(NSDictionary*)getHeaders{
    return self.headers;
}

-(handlerBlock)getSuccessHandler{
    return self.successHandler;
}

-(handlerBlock)getFailureHandler{
    return self.failureHandler;
}

-(NSMutableURLRequest*) getMethodRequestObject{
    
    return [NSMutableURLRequest new];
}

-(NSURL*)getURL{
    
    return self.fullUrl;
}


-(void)setTaskID:(NSUInteger)taskIdentifier{
    self.taskIdentifier = taskIdentifier;
}

-(NSUInteger)getTaskID{
    return self.taskIdentifier;
}

@end
