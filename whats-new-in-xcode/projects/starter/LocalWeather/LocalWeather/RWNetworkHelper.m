//
//  RWNetworkHelper.m
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/31/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

#import "RWNetworkHelper.h"

@implementation RWNetworkHelper

+ (void)fetchJSONAtURLString:(NSString * _Nonnull)urlString
             completionBlock:(void (^ _Nonnull)(id _Nullable, NSError *))completionBlock
{
  NSURLSession *session = [NSURLSession sharedSession];
  NSURL *url = [[NSURL alloc] initWithString:urlString];

  NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                          completionHandler:^(NSData * _Nullable data,
                                                              NSURLResponse * _Nullable response,
                                                              NSError * _Nullable error)
  {
    if (error != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(nil, error);
      });
    } else {
      NSError *error;
      id json = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers error:&error];

      if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completionBlock(nil, error);
        });
      }

      dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(json, nil);
      });
    }
  }];

  [dataTask resume];
}

@end
