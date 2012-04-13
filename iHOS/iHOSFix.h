//
//  iHOSFix.h
//  iHOS
//
//  Created by Chris Martinez on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//inTrackID:  Trackid is a Unix time stamp of the first datapoint in the track, all other points use this ID until Motorcade decides a new track starts
//inUser:  Id of user; user may have multiple devices 
//inDev:  Unique device id

//And then all the fields of the geolocation position object:
//inLat:  
//inLon:  
//inAcc:  
//inSpd:  
//inAlt:  
//inAltAcc

//Here is a sample of posted data from Chrome on the Mac, where speed and altitude are undefined.
//inTrackID:1333681925
//inLat:26.959515183990018
//inLon:-80.13579593303677
//inAcc:100
//inSpd:undefined
//inAlt:undefined
//inAltAcc:undefined
//inUser:Axel
//inDev:iMac    

@interface iHOSFix : NSObject
@property (readwrite) long inTrackID;
@property (copy, readwrite)  NSString * inUser;
@property (copy, readwrite) NSString * inDev;
@property (copy, readwrite) CLLocation * inLocation;

- (id) init;

- (Boolean) uploadToServer;

@end
