//
//  RUWebServiceParser.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-15.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUWebServiceParser : NSObject

+ (void)postWebServiceWithURL:(NSString*)url parameter:(NSDictionary*)param success:(void(^)(NSDictionary* responseDict))success
                      failure:(void(^)(NSError *error))failure;

+ (void)getWebServiceWithURL:(NSString*)url parameter:(NSDictionary*)param success:(void(^)(NSDictionary* responseDict))success
                     failure:(void(^)(NSError *error))failure;



@end
