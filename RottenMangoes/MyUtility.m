//
//  MyUtility.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-23.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "MyUtility.h"

@implementation MyUtility

+ (void)responseFrom4sq:(CLLocation*)currentLocation categoryId:(NSString*)categoryId limit:(NSString*)limit block:(void (^)(NSArray *locationsArray, NSError *error))completionBlock{
    NSString *apiString4aq= @"https://api.foursquare.com/v2/venues/search?ll=";
    NSString *clientID = @"&client_id=OBPKCY1L3L1PYYTV3B3IFDJUINUF3DNW5K5ZNPODRZOOPEJZ&client_secret=TOWRESTHGUKBQB0EOC2KFPTAJ3UBSA2Z5ADXNFERZVWR3M0R";
    NSString *version = @"&v=20121219";
    
    NSMutableURLRequest *foursqRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%1.6f,%1.6f&categoryId=%@%@%@&limit=%@",apiString4aq,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,categoryId,clientID,version,limit]]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:foursqRequest completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        
        if(!error){
            NSError *error2 = nil;
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error2];
            
            if (!error2) {
                
                NSLog(@"4sq data retrieved successfully");
                
                NSDictionary *dataDictionary4sq = [json objectForKey:@"response"];
                NSArray *venueArray = [dataDictionary4sq objectForKey:@"venues"];
                
                completionBlock(venueArray,error);
                
            }else{
                completionBlock([NSArray array] ,error);
                NSLog(@"4sq data not retrieved successfully :(, with error %@", error.description);
            }
        }else{
            completionBlock([NSArray array] ,error);
            NSLog(@"4sq data not retrieved successfully :(, with error %@", error.description);
        }
        
        
    }];
    
    [dataTask resume];
    
}

@end
