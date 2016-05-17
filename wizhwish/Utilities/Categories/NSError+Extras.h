//
//  NSError+Extras.h
//  ZemCar
//
//  Created by Arslan Raza on 10/06/2015.
//  Copyright (c) 2015 Arslan Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extras)

+ (NSError*)createErrorWithDomain:(NSString*)domain localizedDescription:(NSString*)description;

@end
