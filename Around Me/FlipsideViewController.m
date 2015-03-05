//
//  FlipsideViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "FlipsideViewController.h"

#import "Place.h"
#import "PlacesLoader.h"
#import "MarkerView.h"

NSString * const kPhoneKey = @"formatted_phone_number";
NSString * const kWebsiteKey = @"website";

const int kInfoViewTag = 1001;

@interface FlipsideViewController () <MarkerViewDelegate>

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation FlipsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // generateGeoLocations
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager startUpdatingLocation];
    
    

    
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self generateGeoLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [[self delegate] flipsideViewControllerDidFinish:self];
}

- (void)generateGeoLocations {
    
    
    
    [self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
    
    for(Place *place in _locations) {
        ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
        [coordinate calibrateUsingOrigin:[_userLocation location]];
        MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
        NSLog(@"Marker view %@", markerView);
        
        [coordinate setDisplayView:markerView];
        [_arController addCoordinate:coordinate];
        [_geoLocations addObject:coordinate];
    }
}

-(BOOL)prefersStatusBarHidden { return YES; }


#pragma mark - ARLocationDelegate

-(NSMutableArray *)geoLocations {
    if(!_geoLocations) {
        [self generateGeoLocations];
    }
    return _geoLocations;
}

- (void)locationClicked:(ARGeoCoordinate *)coordinate {
    NSLog(@"Tapped location %@", coordinate);
}

#pragma mark - ARDelegate

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

#pragma mark - ARMarkerDelegate

-(void)didTapMarker:(ARGeoCoordinate *)coordinate {
}

- (void)didTouchMarkerView:(MarkerView *)markerView {
    ARGeoCoordinate *tappedCoordinate = [markerView coordinate];
    CLLocation *location = [tappedCoordinate geoLocation];
    
    int index = [_locations indexOfObjectPassingTest:^(Place *obj, NSUInteger index, BOOL *stop) {
        return [[obj location] isEqual:location];
    }];
    if(index != NSNotFound) {
        Place *tappedPlace = [_locations objectAtIndex:index];
        [[PlacesLoader sharedInstance] loadDetailInformation:tappedPlace successHanlder:^(NSDictionary *response) {
            NSLog(@"Response: %@", response);
            NSDictionary *resultDict = [response objectForKey:@"result"];
            
            //[tappedPlace setPhoneNumber:[resultDict objectForKey:kPhoneKey]];
            //[tappedPlace setWebsite:[resultDict objectForKey:kWebsiteKey]];
            [self showInfoViewForPlace:tappedPlace];
        } errorHandler:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)showInfoViewForPlace:(Place *)place {
    CGRect frame = [[self view] frame];
    UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(80.0f, 80.0f, frame.size.width - 60.0f, frame.size.height - 100.0f)];
    infoView.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    infoView.textColor = [UIColor whiteColor];
    infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"circle"]];
    
    
    [infoView setCenter:[[self view] center]];
    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [infoView setText:[place infoText]];
    [infoView setTag:kInfoViewTag];
    [infoView setEditable:NO];
    [[self view] addSubview:infoView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
    
    [infoView removeFromSuperview];	
}

@end
