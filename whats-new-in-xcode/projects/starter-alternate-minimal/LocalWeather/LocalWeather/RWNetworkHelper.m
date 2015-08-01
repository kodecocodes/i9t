/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "RWNetworkHelper.h"

@implementation RWNetworkHelper

+ (void)fetchJSONAtURLString:(NSString * _Nonnull)urlString
             completionBlock:(void (^ _Nonnull)(id _Nullable, NSError * _Nullable))completionBlock
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
