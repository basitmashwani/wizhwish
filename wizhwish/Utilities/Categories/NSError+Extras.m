//
//  NSError+Extras.m
//  ZemCar
//
//  Created by Arslan Raza on 10/06/2015.
//  Copyright (c) 2015 Arslan Raza. All rights reserved.
//

#import "NSError+Extras.h"

@implementation NSError (Extras)

+ (NSError*)createErrorWithDomain:(NSString*)domain localizedDescription:(NSString*)description {
    
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:description forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:domain code:200 userInfo:details];
    return error;
}

@end
