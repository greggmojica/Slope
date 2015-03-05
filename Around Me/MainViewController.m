//
//  MainViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "MainViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PlacesLoader.h"
#import "Place.h"
#import "PlaceAnnotation.h"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatiudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@interface MainViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@property (strong, nonatomic) IBOutlet UIButton *info;
@property (strong, nonatomic) IBOutlet UIButton *location;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myAction)];
    [self.image addGestureRecognizer:gestureRecognizer];
    
    
    
    self.camera.layer.borderColor = [UIColor colorWithRed:0.482 green:1 blue:0.306 alpha:1].CGColor;
    self.camera.layer.borderWidth = 3.0;
    
    [self.camera setBackgroundColor:[UIColor colorWithRed:0.016 green:0.518 blue:0.129 alpha:0.7]];

    self.camera.layer.cornerRadius = self.camera.frame.size.width / 2;
    self.camera.clipsToBounds = YES;

    self.info.layer.borderColor = [UIColor whiteColor].CGColor;
    self.info.layer.borderWidth = 1.5;
    
    self.location.layer.cornerRadius = self.location.frame.size.width / 2;
    self.location.clipsToBounds = YES;

    self.location.layer.borderColor = [UIColor colorWithRed:0.576 green:0.757 blue:0.988 alpha:1].CGColor;
    self.location.layer.borderWidth = 1.5;
    
 
    
    
    self.info.layer.cornerRadius = self.info.frame.size.width / 2;
    self.info.clipsToBounds = YES;

    

    [_locationManager requestAlwaysAuthorization];
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated {
    int imageNumber = arc4random_uniform(3); //because you have 8 image names in the array
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",imageNumber]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)myAction {
    NSLog(@"Hey");
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *lastLocation = [locations lastObject];
	
	CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
	
	NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
	
    
	if(accuracy < 100.0) {
		MKCoordinateSpan span = MKCoordinateSpanMake(0.08, 0.08);
		MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
		
		[_mapView setRegion:region animated:YES];

        // 0.08 and radius 0f 10
        
		[[PlacesLoader sharedInstance] loadPOIsForLocation:[locations lastObject] radius:20 successHanlder:^(NSDictionary *response) {
			NSLog(@"Response: %@", response);
            
            if(response == nil) {
                NSLog(@"There's been an error");
            }
			if([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
				id places = [response objectForKey:@"results"];
				NSMutableArray *temp = [NSMutableArray array];
				
                CLLocationManager *locationManager = [[CLLocationManager alloc] init];
                
                    locationManager.delegate = self;
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    locationManager.distanceFilter = kCLDistanceFilterNone;
                    [locationManager startUpdatingLocation];
                
                
                CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[kLatiudeKeypath floatValue] longitude:[kLongitudeKeypath floatValue]];
                CLLocationCoordinate2D coordinate1 = [LocationAtual coordinate];

                CLLocation *location2 = [locationManager location];
                CLLocationCoordinate2D coordinate = [location2 coordinate];
                
                NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
                NSLog(@"%@",str);
                
                CLLocationDistance distance = [location2 distanceFromLocation:LocationAtual];
                NSLog(@"Totall distance is %f", distance);
                
                
                
				if([places isKindOfClass:[NSArray class]]) {
					for(NSDictionary *resultsDict in places) {
						CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatiudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
						Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]];
                        
                        
                        CLLocationDistance distance = [location distanceFromLocation:location2];
                        
                        float feet= distance  * 3.28084;

                        NSLog(@"Distance is %f", feet);
                        
                        
                        if (feet <= 200) {
                            NSLog(@"Logging the place");
                            [temp addObject:currentPlace];
                        }
						
                     
                        
                            PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
                            [_mapView addAnnotation:annotation];
                        
						
                        
                        
					}
				}

				_locations = [temp copy];
				
				NSLog(@"Locations: %@", _locations);
			}
		} errorHandler:^(NSError *error) {
			NSLog(@"Error: %@", error);
		}];
		
       
		[manager stopUpdatingLocation];
	}
    
   
    

}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        if (_locations != nil) {
            [[segue destinationViewController] setLocations:_locations];
            [[segue destinationViewController] setUserLocation:[_mapView userLocation]];
        }
    }
}

@end
