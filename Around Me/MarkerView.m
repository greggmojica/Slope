//
//  MarkerView.m
//  Around Me
//
//  Created by jdistler on 11.02.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "MarkerView.h"

#import "ARGeoCoordinate.h"

const float kWidth = 200.0f;
const float kHeight = 100.0f;

@interface MarkerView ()

@property (nonatomic, strong) UILabel *lblDistance;

@end


@implementation MarkerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoordinate:(ARGeoCoordinate *)coordinate delegate:(id<MarkerViewDelegate>)delegate {
	if((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kWidth, kHeight)])) {
		_coordinate = coordinate;
		_delegate = delegate;
		
        NSLog(@"The coordinate is %@", coordinate);
        
        NSLog(@"Turned");
        
        
        
        
		[self setUserInteractionEnabled:YES];
		
        NSString *firstWord = [[coordinate.title componentsSeparatedByString:@" "] objectAtIndex:0];
        NSLog(@"Word is %@", firstWord);
        
        NSString *search = [firstWord stringByReplacingOccurrencesOfString:@" " withString:@""];

        
        if ([search isEqualToString:@"Double"]) {
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, -230.0f, 250, 250)];
            [title setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.012 alpha:0.8]];
            [title setTextColor:[UIColor whiteColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setText:[[coordinate.title componentsSeparatedByString:@" "] objectAtIndex:1]];
            
            title.numberOfLines = 6;
            title.font = [UIFont fontWithName:@"Avenir-Book" size:25];
            
            UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(-45.0f, -230.0f, 250, 250)];
            [title2 setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.012 alpha:0.8] ];
            title2.layer.borderColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
            title2.layer.borderWidth = 5.0;
            
         
            _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, kWidth, 40.0f)];
            title.layer.borderColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
            title.layer.borderWidth = 5.0;
            
            title.transform = CGAffineTransformMakeRotation(M_PI_2 / 2);
            title2.transform = CGAffineTransformMakeRotation(M_PI_2 / 2);

            [self addSubview:title2];
            [self addSubview:title];


        }

        
        if ([search isEqualToString:@"Difficult"]) {
            NSLog(@"Coordinate YES");
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 85.0f, 250, 250)];
            [title setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0.012 alpha:0.8] ];
            [title setTextColor:[UIColor whiteColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setText:[[coordinate.title componentsSeparatedByString:@" "] objectAtIndex:1]];
            title.numberOfLines = 6;
            title.font = [UIFont fontWithName:@"Avenir-Book" size:25];
            //[title sizeToFit];
            //[[title layer] setCornerRadius:15];
            title.layer.cornerRadius = 0;
            title.clipsToBounds = YES;
            _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, kWidth, 40.0f)];
            
            title.layer.borderColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
            title.layer.borderWidth = 5.0;
            title.transform = CGAffineTransformMakeRotation(M_PI_2 / 2);
            //rotation in radians
            [self addSubview:title];


        }
        
        
        if ([search isEqualToString:@"Medium"]) {
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, -280.0f, 200, 200)];
            [title setBackgroundColor:[UIColor colorWithRed:0 green:0.251 blue:1 alpha:0.8]];
            [title setTextColor:[UIColor whiteColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setText:[[coordinate.title componentsSeparatedByString:@" "] objectAtIndex:1]];
            title.numberOfLines = 6;
            title.font = [UIFont fontWithName:@"Avenir-Book" size:25];
            //[title sizeToFit];
            //[[title layer] setCornerRadius:15];
            title.layer.cornerRadius = 0;
            title.clipsToBounds = YES;
            _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, kWidth, 40.0f)];
            
            title.layer.borderColor = [UIColor colorWithRed:0 green:0.851 blue:0.914 alpha:1].CGColor;
            title.layer.borderWidth = 5.0;
            
            
            //rotation in radians
            [self addSubview:title];
            
            
        }
        
        if ([search isEqualToString:@"Easy"]) {
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, -230.0f, 250, 250)];
            [title setBackgroundColor:[UIColor colorWithRed:0.016 green:0.518 blue:0.129 alpha:0.7]];
            [title setTextColor:[UIColor whiteColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setText:[[coordinate.title componentsSeparatedByString:@" "] objectAtIndex:1]];
            title.numberOfLines = 6;
            title.font = [UIFont fontWithName:@"Avenir-Book" size:25];
            
        
            
            //[title sizeToFit];
            [[title layer] setCornerRadius:15];
            title.layer.cornerRadius = title.layer.frame.size.width / 2;
            title.clipsToBounds = YES;
            _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, kWidth, 40.0f)];
            title.layer.borderColor = [UIColor colorWithRed:0.482 green:1 blue:0.306 alpha:1].CGColor;
            title.layer.borderWidth = 5.0;
            
            //rotation in radians
            [self addSubview:title];
        }
        
        
        
		//[_lblDistance setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.7f]];
		//[_lblDistance setTextColor:[UIColor whiteColor]];
		//[_lblDistance setTextAlignment:NSTextAlignmentCenter];
		//[_lblDistance setText:[NSString stringWithFormat:@"%.2f km", [coordinate distanceFromOrigin] / 1000.0f]];
		//[_lblDistance sizeToFit];
		
		//[self addSubview:title];
		//[self addSubview:_lblDistance];
		
		[self setBackgroundColor:[UIColor clearColor]];
	}

	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

    //  NSLog(@"REct %@", rect);
    // NSLog(@"i %@", NSStringFromCGRect(rect));

    
    [[self lblDistance] setText:[NSString stringWithFormat:@"%.2f km", [[self coordinate] distanceFromOrigin] / 1000.0f]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(_delegate && [_delegate conformsToProtocol:@protocol(MarkerViewDelegate)]) {
		[_delegate didTouchMarkerView:self];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect theFrame = CGRectMake(0, 0, kWidth, kHeight);
    
	return CGRectContainsPoint(theFrame, point);
}

@end
