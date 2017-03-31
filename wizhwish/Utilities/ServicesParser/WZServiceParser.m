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
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,@"/users/register?j_username=",email,@"&j_displayname=",username,@"&j_password=",password];
    
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:nil success:^(NSDictionary *responseDict) {
        
        success(@"success");
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

    
- (void)processLoginUserWithEmail:(NSString*)email password:(NSString*)password success:(void(^)(NSString* accessToken))success
                          failure:(void(^)(NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",k_BASE_SERVER_URL,@"/oauth/token?grant_type=password&username=",email,@"&password=",password];
    
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:k_AUTHORIZATION_BASIC success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"access_token"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
    
}

- (void)processPostText:(NSString*)text success:(void(^)(NSString* accessToken))success
                failure:(void(^)(NSError *error))failure {
   // networks/createPost?j_text=mypost&j_images=image,image2&j_privacy=public

    text = [text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/createPost?j_text=",text,@"&j_images=image&j_privacy=public"];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:header success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"status"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

- (void)processGetRecommendedFriendWithSuccess:(void(^)(NSDictionary* dict))success
                                       failure:(void(^)(NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/users"];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^(NSDictionary *responseDict) {
          success(responseDict);
    } failure:^(NSError *error) {
        failure(error);

    }];
    
}

- (void)processFollowUser:(NSString*)Username success:(void(^)(NSDictionary* dict))success
                  failure:(void(^)(NSError *error))failure {
 
    NSString *url = [NSString stringWithFormat:@"%@%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/follow?j_username=",Username];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:header success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"status"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}



- (void)processGetWhizPostWithLimit:(NSInteger)limit success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {
    
    NSInteger prevLimit = limit - 5;
    NSString *url = [NSString stringWithFormat:@"%@%@%ld%s%ld",k_BASE_SOCIAL_SERVER_URL,@"/networks/post?j_skip=",(long)prevLimit,"&&j_limit=",(long)limit];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^(NSDictionary *responseDict) {
        success(responseDict);
    } failure:^(NSError *error) {
        failure(error);
        
    }];

    
}

- (void)processCommentOnPost:(NSString*)postId commentText:(NSString*)text success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {

    text = [text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,
        @"/networks/commentOnPost?j_text=",text,@"&j_images=123123&j_postId=",postId];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:header success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"status"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];

    
}

- (void)processGetFollowerWithSuccess:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {
 
    NSString *url = [NSString stringWithFormat:@"%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/following"];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^
     
     (NSDictionary *responseDict) {
     
         success(responseDict);
    
     } failure:^(NSError *error) {
     
         failure(error);
        
    }];
}

- (void)processGetCommentsForPost:(NSString*)postId withLimit:(NSInteger)limit success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {
    
    NSInteger prevLimit = limit - 5;
    NSString *url = [NSString stringWithFormat:@"%@%@%d%@%d%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/comments?j_skip=",prevLimit,@"&j_limit=",limit,@"&j_postId=",postId];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^
     
     (NSDictionary *responseDict) {
         
         success(responseDict);
         
     } failure:^(NSError *error) {
         
         failure(error);
         
     }];

}



+ (WZPost *)getDataFromDictionary:(NSDictionary *)dict haveComments:(BOOL)isComments {
    
    WZPost *post = [[WZPost alloc] init];
    post.displayName = [dict valueForKey:@"userDisplayName"];
    post.userProfileURL = [dict valueForKey:@"userProfileImage"];
    post.postText = [dict valueForKey:@"text"];
    NSTimeInterval timeInterval = [[dict valueForKey:@"createdDate"] doubleValue];
    post.commentCount = [dict valueForKey:@"totalComments"];
    NSDate *fromDate = [NSDate getDateFromEpochValue:timeInterval];
    NSDate *toDate = [NSDate getDateFromEpochValue:[[NSDate date] timeIntervalSince1970]];
    post.createdDate = [NSDate getMinutesDifferenceFromDate:fromDate toDate:toDate];
    post.postId = [dict valueForKey:@"id"];
    
    
    
    //[NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    if (isComments) {
    
    NSDictionary *commentsDict = [dict valueForKey:@"comments"];
    
    
    if ([commentsDict count] >0) {
        
        WZComments *comments = [[WZComments alloc] init];
        comments.displayName = [[commentsDict valueForKey:@"userDisplayName"] firstObject];
        comments.profileImageURL = [commentsDict valueForKey:@"userProfileImage"];
        comments.commentText = [[commentsDict valueForKey:@"text"] firstObject];
        
        NSTimeInterval timeInterval = [[dict valueForKey:@"createdDate"] doubleValue];
        comments.createdDate =  [NSDate getMinutesDifferenceFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval] toDate:[NSDate date]];
        post.postComment = comments;
        
    }
    }
    
    
    return  post;
}









@end
