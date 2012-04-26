//
//  iHOSViewController.m
//  iHOS
//
//  Created by Chris Martinez on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iHOSViewController.h"
#import "iHOSFix.h"

@implementation iHOSViewController
@synthesize user;
@synthesize lat;
@synthesize accuracy;
@synthesize map;
@synthesize locMan;
@synthesize lon;
@synthesize inTrackID;
@synthesize cacheFix;

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
    self.cacheFix = [[NSMutableArray alloc] init];
                     
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
    [self setUser:nil];
    [self setCacheFix:nil];
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

    int CACHE_LIMIT = 100;

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
//    [self postGPSFix:latitude lonParam:longitude];
    iHOSFix * fix = [[iHOSFix alloc] init];

    fix.inTrackID = inTrackID;
    fix.inUser = user.text;
    fix.inLocation = newLocation;
    
    [self.cacheFix addObject:fix];
        
    if ([self.cacheFix count] > CACHE_LIMIT) {
        [self flushCache];        
    }
}

- (IBAction)startTracking:(id)sender {
    if (nil != self.locMan) {
        inTrackID = [[NSDate date] timeIntervalSince1970];
        [self.locMan startUpdatingLocation];
    }
}

- (IBAction)stopTracking:(id)sender {
    if (nil != self.locMan) {
        [self.locMan stopUpdatingLocation];
    }
    
    [self flushCache];            
}

- (void) flushCache {
    iHOSFix * fix = nil;
    
    for (int nIndex = 0; nIndex < [self.cacheFix count]; nIndex++)
    {
        fix = [self.cacheFix objectAtIndex:nIndex];
        [fix uploadToServer];        
    }
    
    [self.cacheFix removeAllObjects];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.user resignFirstResponder];
}
@end
