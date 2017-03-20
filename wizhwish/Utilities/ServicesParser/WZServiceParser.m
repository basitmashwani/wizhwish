//
//  WZServiceParser.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-15.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WZServiceParser.h"

static WZServiceParser *_sharedInstance = nil;

@implementation WZServiceParser

+ (WZServiceParser*)sharedParser {
    
    if (!_sharedInstance ) {
        _sharedInstance = [[WZServiceParser alloc] init];
    }
    return _sharedInstance;
}

- (void)processRegisterUserWithEmail:(NSString*)email userName:(NSString*)username password:(NSString*)password success:(void(^)(NSString* response))success
        failure:(void(^)(NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,@"/users/register?j_username=",email,@"&j_displayname=",email,@"&j_password=",password];
    
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil success:^(NSDictionary *responseDict) {
        
        success(@"success");
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

    
- (void)processLoginUserWithEmail:(NSString*)email password:(NSString*)password success:(void(^)(NSString* accessToken))success
                          failure:(void(^)(NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",k_BASE_SERVER_URL,@"/oauth/token?grant_type=password&username=",email,@"&password=",password];
    
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"access_token"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}





@end
