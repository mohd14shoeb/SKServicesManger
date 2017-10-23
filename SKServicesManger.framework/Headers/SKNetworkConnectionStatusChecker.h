//
//  SKNetworkConnectionStatusChecker.h
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UNKNOWN,NotReachable, WIFI,CELLULAR
}SKNetworkConnectionState;


@interface SKNetworkConnectionStatusChecker : NSObject
+(SKNetworkConnectionState)checkCurrentNetworkConnectionState;

@end
