//
//  iHOSFix.m
//  iHOS
//
//  Created by Chris Martinez on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iHOSFix.h"

@implementation iHOSFix
@synthesize inTrackID;
@synthesize inUser;
@synthesize inDev;
@synthesize inLocation;

- (id) init
{
    self = [super init];
    if (self != nil) {
        inDev = [UIDevice currentDevice].name;
        inLocation = [CLLocation alloc];
    }
    return self;
}

- (Boolean) uploadToServer
{    
    
    NSMutableURLRequest *request = 
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://www.kickserve.net/loco/poc/web/postdata.php"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [[NSString alloc] initWithFormat:@"inTrackID=%d&inLat=%f&inLon=%f&inAcc=%f&inSpd=%f&inAlt=%f&inAltAcc=%f&inUser=%@&inDev=%@",
                            inTrackID,
                            inLocation.coordinate.latitude,
                            inLocation.coordinate.longitude,
                            inLocation.horizontalAccuracy,
                            inLocation.speed,
                            inLocation.altitude,
                            inLocation.verticalAccuracy,
                            inUser,
                            inDev];
        
    [request setValue:[NSString 
                       stringWithFormat:@"%d", [postString length]] 
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString 
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] 
     initWithRequest:request delegate:self];
    
    return true;
}

@end
