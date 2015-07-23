//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-22.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "DetailViewController.h"
#import "MapKit/MapKit.h"
#import "AppDelegate.h"
#import "MyUtility.h"
#import "Venue.h"

#define zoominMapArea 20000

@interface DetailViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) NSString *postalCode;
@property (strong,nonatomic) NSString *movieTitle;
@property (assign,nonatomic) BOOL mapLoadedWithVenues;
@property (strong,nonatomic) NSMutableArray *theatresArray;

@end

@implementation DetailViewController

- (void)setMovie:(Movie *)newMovie {
    if (_movie != newMovie) {
        _movie = newMovie;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.movie) {
        self.movieTitle = [[self.movie valueForKey:@"title"] description];
        NSString *rating = [[self.movie valueForKey:@"score"] description];
        self.titleLabel.text = [NSString stringWithFormat:@"Movie Title: %@", self.title];
        self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@/100", rating];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    self.theatresArray = [[NSMutableArray alloc] init];
    
    NSString *title = [[self.movie valueForKey:@"title"] description];
    self.titleLabel.text = [NSString stringWithFormat:@"Movie Title: %@", title];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    double latt = appDelegate.currentLocation.coordinate.latitude;
    double lngg = appDelegate.currentLocation.coordinate.longitude;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latt longitude:lngg];
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
        CLPlacemark *place = [placemark objectAtIndex:0];
        if (error) {
            NSLog(@"fail %@", error);
        } else {
            self.postalCode = place.postalCode;
            [self runSession];
        }
    }];
    
    self.mapView.showsUserLocation = true;
    _mapLoadedWithVenues = NO;
}

-(void)runSession {
    NSString *urlString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@",self.postalCode ,self.movieTitle];
    
    NSString *encodedText = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:encodedText] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *theatresDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *theatres = theatresDict[@"theatres"];
            for (NSDictionary *eachTheatre in theatres){
                NSString *address = eachTheatre[@"address"];
                NSString *title = eachTheatre[@"name"];
                double longitude = [eachTheatre[@"lng"] doubleValue];
                double latitude = [eachTheatre[@"lat"] doubleValue];
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
                
                Venue* theatre = [[Venue alloc]initWithCoordinate:coord andTitle:title andSubtitle:address];
                [self.theatresArray addObject:theatre];
            }
            NSLog(@"Array: %@", self.theatresArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                for (Venue *theatre in self.theatresArray) {
                    [self.mapView addAnnotation:theatre];
                }
            });
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *title = [[self.movie valueForKey:@"title"] description];
    NSString *rating = [[self.movie valueForKey:@"score"] description];
    self.titleLabel.text = [NSString stringWithFormat:@"Movie Title: %@", title];
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@/100", rating];
    [self initiateMap];
}

#pragma mark -- Map

- (void) initiateMap {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    
}

-(void)mapViewDidFinishLoadingMap:(nonnull MKMapView *)mapView{
    [self initiateMap];
}

@end
