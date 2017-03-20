//
//  RUWebServiceParser.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-15.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "RUWebServiceParser.h"
//#import <AFNetworking.h>
//#import <AFHTTPSessionManager.h>

@implementation RUWebServiceParser


+ (void)postWebServiceWithURL:(NSString*)url parameter:(NSDictionary*)param success:(void(^)(NSDictionary* responseDict))success
                      failure:(void(^)(NSError *error))failure
{
    
  //    NSLog(@"Sent parameter to server 1 : %@",param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    [policy setValidatesDomainName:NO];
    
    [policy setAllowInvalidCertificates:YES];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    
    [manager.requestSerializer setValue:k_AUTHORIZATION_BASIC forHTTPHeaderField:@"Authorization"];
    

    
    [manager POST:url parameters:param  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"Success : Response from server 1 :  %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
      
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];

        success(dictionary);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        failure(error);
        NSLog(@"Failure :Response from server 1 :  %@", error.localizedDescription);

    }];
    
    
}


+ (void)getWebServiceWithURL:(NSString*)url parameter:(NSDictionary*)param success:(void(^)(NSDictionary* responseDict))success
                             failure:(void(^)(NSError *error))failure
{
    
    
    NSLog(@"Sent parameter to server 1 : %@",param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    [policy setValidatesDomainName:NO];
    
    [policy setAllowInvalidCertificates:YES];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    
    
    
    [manager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Success : Response from server 1 :  %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        success(dictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Failure :Response from server 1 :  %@", error.localizedDescription);
        failure(error);
        
    }];
    
}



     

@end
