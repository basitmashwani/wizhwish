//
//  WZServiceParser.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-15.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZServiceParser : NSObject

/**
 Get WZServiceParser shared Instance
 **/

+ (WZServiceParser*)sharedParser;

- (void)processRegisterUserWithEmail:(NSString*)email userName:(NSString*)username password:(NSString*)password success:(void(^)(NSString* response))success failure:(void(^)(NSError *error))failure;


- (void)processLoginUserWithEmail:(NSString*)email password:(NSString*)password success:(void(^)(NSString* accessToken))success
                             failure:(void(^)(NSError *error))failure;

- (void)processPostText:(NSString*)text tags:(NSString*)tags imagesArray:(NSArray*)imageArray videoArray:(NSArray*)videoArray audioArray:(NSArray*)audioArray success:(void(^)(NSString* accessToken))success
                failure:(void(^)(NSError *error))failure;

- (void)processGetRecommendedFriendWithSuccess:(void(^)(NSDictionary* dict))success
                failure:(void(^)(NSError *error))failure;

- (void)processFollowUser:(NSString*)Username success:(void(^)(NSDictionary* dict))success
                                       failure:(void(^)(NSError *error))failure;

- (void)processGetWhizPostWithLimit:(NSInteger)limit success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure;

- (void)processCommentOnPost:(NSString*)postId commentText:(NSString*)text success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure;

- (void)processGetFollowerWithSuccess:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure;

+ (WZPost *)getDataFromDictionary:(NSDictionary *)dict haveComments:(BOOL)isComments;

- (void)processGetCommentsForPost:(NSString*)postId withLimit:(NSInteger)limit success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure;


- (void)processProfileWithName:(NSString*)name bio:(NSString*)bio phoneNumber:(NSString*)phoneNumber gender:(NSString*)gender profileImageURL:(NSString*)standardURL profileThumbnailURL:(NSString*)thumbnailURL bannerImageURL:(NSString*)bannerURL success:(void(^)(NSString* success))success failure:(void(^)(NSError *error))failure;

- (void)processGetProfileFor:(NSString*)profileURL success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure;


- (void)processUploadFileAWSWithfilePath:(NSString*)filePath fileName:(NSString*)fileName success:(void(^)(NSString* fileName))success;



@end
