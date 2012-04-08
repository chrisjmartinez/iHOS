//
//  iHOSViewController.h
//  iHOS
//
//  Created by Chris Martinez on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface iHOSViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)startTracking:(id)sender;
- (IBAction)stopTracking:(id)sender;
- (void) postGPSFix:(double) lat lonParam:(double) lon;

@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet UITextField *accuracy;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager * locMan;
@property (weak, nonatomic) IBOutlet UITextField *lon;
@end
