//
//  SKNetworkConnectionStatusChecker.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKNetworkConnectionStatusChecker.h"
#import <SystemConfiguration/SCNetworkReachability.h>
@implementation SKNetworkConnectionStatusChecker

+(SKNetworkConnectionState)checkCurrentNetworkConnectionState{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "8.8.8.8");
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    if (!success) {
        return UNKNOWN;
    }
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL isNetworkReachable = (isReachable && !needsConnection);
    
    if (!isNetworkReachable) {
        return NotReachable;
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        return CELLULAR;
    } else {
        return WIFI;
    }
}

@end
