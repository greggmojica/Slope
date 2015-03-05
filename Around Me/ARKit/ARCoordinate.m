//
//  ARCoordinate.m
//  AR Kit
//
//  Modified by Niels Hansen on 10/02/11
//  Copyright 2013 Agilite Software. All rights reserved.
//

#import "ARCoordinate.h"

@implementation ARCoordinate

@synthesize radialDistance;
@synthesize inclination;
@synthesize azimuth;
@synthesize title;
@synthesize subtitle;

+ (ARCoordinate *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth {
	
    NSLog(@"Distane is %f", newRadialDistance);
    
    
	ARCoordinate *newCoordinate	= [[ARCoordinate alloc] init];
	[newCoordinate setRadialDistance: newRadialDistance];
	[newCoordinate setInclination: newInclination];
	[newCoordinate setAzimuth: newAzimuth];
	[newCoordinate setTitle: @""];
	
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    
    CLLocation *location2 = [locationManager location];
    CLLocationCoordinate2D coordinate = [location2 coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@"MEEE latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
    
    
//    CLLocationDistance distance = [location distanceFromLocation:location2];
  //  NSLog(@"Distance is %f", distance);

    
    
	return newCoordinate;
}

- (NSUInteger)hash {
	return ([[self title] hash] ^ [[self subtitle] hash]) + (int)([self radialDistance] + [self inclination] + [self azimuth]);
}

- (BOOL)isEqual:(id)other {
    
	if (other == self)
        return YES;
    
	if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
	return [self isEqualToCoordinate:other];
}

- (BOOL)isEqualToCoordinate:(ARCoordinate *)otherCoordinate {

    if (self == otherCoordinate) 
		return YES;
    
	BOOL equal = [self radialDistance]	== [otherCoordinate radialDistance];
	equal = equal && [self inclination] == [otherCoordinate inclination];
	equal = equal && [self azimuth]		== [otherCoordinate azimuth];
		
	if (([self title] && [otherCoordinate title]) || ([self title] && ![otherCoordinate title]) || (![self title] && [otherCoordinate title]))
		equal = equal && [[self title] isEqualToString:[otherCoordinate title]];
	
	return equal;
}

- (void)dealloc {
	[self setTitle: nil];
	[self setSubtitle: nil];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ r: %.3fm φ: %.3f° θ: %.3f°", [self title], [self radialDistance], radiansToDegrees([self azimuth]), radiansToDegrees([self inclination])];
}

@end
