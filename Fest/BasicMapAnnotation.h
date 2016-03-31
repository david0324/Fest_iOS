#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString *_title;
}

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@property (nonatomic, copy) NSString *title;

@end
