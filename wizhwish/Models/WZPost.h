//
//  WZPost.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-24.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZComments.h"

@interface WZPost : NSObject

@property(nonatomic ,retain) NSString *displayName;

@property(nonatomic ,retain) NSString *postId;

@property(nonatomic ,retain) NSString *userProfileURL;

@property(nonatomic ,retain) NSString *postText;

@property(nonatomic ,retain) NSString *createdDate;

@property(nonatomic ,retain) WZComments *postComment;

@property(nonatomic ,retain) NSDictionary *mediaDictionary;

@property(nonatomic ,retain) NSString *commentCount;






@end
