//
//  SKMultiPartFormUploadRequest.h
//  backgroundSessionTest
//
//  Created by sherif on 8/7/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKPostRequest.h"

@interface SKMultiPartFormUploadRequest : SKPostRequest

- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler parameters:(NSDictionary*)parameters filePath:(NSString*)filePath  fieldName:(NSString*)fileName;
-(NSMutableURLRequest*) getMethodRequestObject;

@end
