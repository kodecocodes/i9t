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

#import "RWHTTPManager.h"

@interface RWHTTPManager ()
@property (nonatomic, strong) NSURLSession *session;
@end


@implementation RWHTTPManager

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
  self = [super init];
  if (self) {
    self.baseURL = baseURL;
    self.session = [NSURLSession sharedSession];
  }
  return self;
}

- (void)fetchJSONAtPath:(NSString *)relativePath
        completionBlock:(void (^)(id, NSError *))completionBlock
{
  NSString *fullPath = [self.baseURL.absoluteString stringByAppendingPathComponent:relativePath];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:fullPath]
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(nil, error);
      });
    } else {
      NSError *error;
      id json = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers error:&error];

      if (error) {
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
