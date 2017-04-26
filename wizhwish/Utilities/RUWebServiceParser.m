//
//  RUWebServiceParser.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-15.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "RUWebServiceParser.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@implementation RUWebServiceParser


+ (void)postWebServiceWithURL:(NSString*)url parameter:(NSDictionary*)param  header:(NSString*)header success:(void(^)(NSDictionary* responseDict))success
                      failure:(void(^)(NSError *error))failure;
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    NSError *error;
    if (param != nil) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param
                                                       options:0
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // And finally, add it to HTTP body and job done.
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval=[[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
       
            success((NSDictionary*)responseObject);
       
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        
                failure(error);
                NSLog(@"Failure :Response from server 1 :  %@", error.localizedDescription);

    }];

//                                             
//            }];
    [operation start];
    
     
    
}


+ (void)getWebServiceWithURL:(NSString*)url header:(NSString*)header parameter:(NSDictionary*)param success:(void(^)(NSDictionary* responseDict))success
                     failure:(void(^)(NSError *error))failure
{
    
    
    //NSLog(@"Sent parameter to server 1 : %@",param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    [policy setValidatesDomainName:NO];
    
    [policy setAllowInvalidCertificates:YES];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    
    [manager.requestSerializer setValue:header forHTTPHeaderField:@"Authorization"];

    
    [manager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Success : Response from server :  %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        success(dictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Failure :Response from server :  %@", error.localizedDescription);
        failure(error);
        
    }];
    
}



     

@end
