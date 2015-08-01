//
//  RWNetworkHelper.h
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/31/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWNetworkHelper : NSObject

+ (void)fetchJSONAtURLString:(NSString * _Nonnull)urlString
             completionBlock:(void (^ _Nonnull)(id _Nullable, NSError * _Nullable))completionBlock;

@end
