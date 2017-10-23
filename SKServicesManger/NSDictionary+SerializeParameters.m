//
//  NSDictionary+SerializeParameters.m
//  backgroundSessionTest
//
//  Created by sherif on 8/7/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "NSDictionary+SerializeParameters.h"

@implementation NSDictionary (SerializeParameters)
- (NSString *)serializeParameters {
    NSMutableArray *pairs = NSMutableArray.array;
    for (NSString *key in self.keyEnumerator) {
        id value = self[key];
        if ([value isKindOfClass:[NSDictionary class]])
            for (NSString *subKey in value)
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, [self escapeValueForURLParameter:[value objectForKey:subKey]]]];
        
        else if ([value isKindOfClass:[NSArray class]])
            for (NSString *subValue in value)
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, [self escapeValueForURLParameter:subValue]]];
        
        else
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [self escapeValueForURLParameter:value]]];
        
    }
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)escapeValueForURLParameter:(NSString *)valueToEscape {
    return [valueToEscape stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
