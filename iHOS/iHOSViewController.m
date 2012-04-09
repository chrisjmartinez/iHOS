//
//  iHOSViewController.m
//  iHOS
//
//  Created by Chris Martinez on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iHOSViewController.h"

@implementation iHOSViewController
@synthesize lat;
@synthesize accuracy;
@synthesize map;
@synthesize locMan;
@synthesize lon;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    self.locMan.desiredAccuracy = kCLLocationAccuracyBest;// kCLLocationAccuracyBestForNavigation;
    self.locMan.distanceFilter = 100;  // 1 mile = 1609
    
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setMap:nil];
    [self setLocMan:nil];
    [self setLat:nil];
    [self setAccuracy:nil];
    [self setLon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // turn off the location manager updates
        [self.locMan stopUpdatingLocation];
        [self setLocMan:nil];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    // update the map with the new location    
    MKCoordinateRegion mapRegion;
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    int acc = newLocation.horizontalAccuracy;
    
    // CLLocationCoordinate2D
    mapRegion.center.latitude = latitude;
    mapRegion.center.longitude = longitude;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    [self.map setRegion:mapRegion animated:YES];
    
    // update the text fields
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    self.lat.text = [NSString stringWithFormat:@"%2.4f",latitude];
    self.lon.text = [NSString stringWithFormat:@"%2.4f",longitude];
    self.accuracy.text = [NSString stringWithFormat:@"%d", acc];
    
    // post the fix to the server
    [self postGPSFix:latitude lonParam:longitude];
    
}

- (IBAction)startTracking:(id)sender {
    if (nil != self.locMan) {
        [self.locMan startUpdatingLocation];
    }
}

- (IBAction)stopTracking:(id)sender {
    if (nil != self.locMan) {
        [self.locMan stopUpdatingLocation];
    }
}

- (void) postGPSFix:(double)lat lonParam:(double)lon {
    // Hardcode parameters for now
    // eventually, this should read from a plist or user settings
    
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

    NSMutableURLRequest *request = 
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://www.kickserve.net/loco/poc/web/postdata.php"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [[NSString alloc] initWithFormat:@"inTrackID=%@&inLat=%f&inLon=%f&inAcc=%@&inSpd=%@&inAlt=%@&inAltAcc=%@&inUser=%@&inDev=%@",
                            @"1333681926",
                            lat,
                            lon,
                            @"5",
                            @"1",
                            @"1",
                            @"1",
                            @"Chris",
                            @"iPhone_emulator"];
    
    //@"go=1&name=Bad%20Bad%20Bug&description=This%20bug%20is%20really%20really%20super%20bad.";
    
    [request setValue:[NSString 
                       stringWithFormat:@"%d", [postString length]] 
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString 
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] 
     initWithRequest:request delegate:self];
}
@end
