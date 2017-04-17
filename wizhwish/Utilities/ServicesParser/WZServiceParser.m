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
        
        if ([[responseDict valueForKey:@"status"] boolValue]) {
        success(@"success");
        }
        else {
            failure([NSError createErrorWithDomain:@"Error" localizedDescription:@"Email already in use" ]);
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

    
- (void)processLoginUserWithEmail:(NSString*)email password:(NSString*)password success:(void(^)(NSString* accessToken))success
                          failure:(void(^)(NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",k_BASE_SERVER_URL,@"/oauth/token?grant_type=password&username=",email,@"&password=",password];
    
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:k_AUTHORIZATION_BASIC success:^(NSDictionary *responseDict) {
        
        NSLog(@"response %@",responseDict);
        
            success([responseDict valueForKey:@"access_token"]);
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
    
}

- (void)processPostText:(NSString*)text tags:(NSString*)tags imagesArray:(NSArray*)imageArray videoArray:(NSArray*)videoArray audioArray:(NSArray*)audioArray success:(void(^)(NSString* accessToken))success
                failure:(void(^)(NSError *error))failure {
   // networks/createPost?j_text=mypost&j_images=image,image2&j_privacy=public
    
    tags = @"";

   // text = [text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/createPost?j_text=",@"",@"&j_tags=",@"AB",@"&j_privacy=public"];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];

    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    NSDictionary *parameters = @{@"images":imageArray,
                                 @"backendVideo":@"",
                                 @"fronendVideo":@"",
                                 @"audio":@"",
                                 @"audioImage":@""
                                 };
    
    ;    [RUWebServiceParser postWebServiceWithURL:url parameter:parameters header:header success:^(NSDictionary *responseDict) {
        
        
        if ([[responseDict valueForKey:@"status"] boolValue]) {
            
            success([responseDict valueForKey:@"status"]);
        }
        else {
            NSError *error = [NSError createErrorWithDomain:@"Error" localizedDescription:@"Webcall not succeed"];
            failure(error);
        }
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
    
    NSInteger maxLimit = limit + 5;
    NSString *url = [NSString stringWithFormat:@"%@%@%ld%s%ld",k_BASE_SOCIAL_SERVER_URL,@"/networks/post?j_skip=",(long)limit,"&&j_limit=",(long)maxLimit];
    
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

- (void)processGetFollowerWithLimit:(NSInteger)limit success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {
 
    NSInteger finalLimit = limit+5;
    NSString *url = [NSString stringWithFormat:@"%@%@%ld%@%ld",k_BASE_SOCIAL_SERVER_URL,@"/networks/follower?j_skip=",(long)limit,@"&j_limit=",(long)finalLimit];
    
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
    
    NSInteger maxLimit = limit + 5;
    NSString *url = [NSString stringWithFormat:@"%@%@%ld%@%ld%@%@",k_BASE_SOCIAL_SERVER_URL,@"/networks/comments?j_skip=",(long)limit,@"&j_limit=",(long)maxLimit,@"&j_postId=",postId];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^
     
     (NSDictionary *responseDict) {
         
         success(responseDict);
         
     } failure:^(NSError *error) {
         
         failure(error);
         
     }];

}


- (void)processProfileWithName:(NSString*)name bio:(NSString*)bio phoneNumber:(NSString*)phoneNumber gender:(NSString*)gender profileImageURL:(NSString*)standardURL profileThumbnailURL:(NSString*)thumbnailURL bannerImageURL:(NSString*)bannerURL success:(void(^)(NSString* success))success failure:(void(^)(NSError *error))failure {
    
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    bio = [bio stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@"+"];


    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",k_BASE_SOCIAL_SERVER_URL,
                     @"/users/profile?j_name=",name,@"&j_email=""&j_bio=",bio,@"&j_phone=",phoneNumber,@"&j_gender=",gender,@"&&j_standardImageUrl=",standardURL,@"&j_thumbnailImageUrl=",thumbnailURL,@"&j_bannerImageUrl=",bannerURL];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    [RUWebServiceParser postWebServiceWithURL:url parameter:nil header:header success:^(NSDictionary *responseDict) {
        
        success([responseDict valueForKey:@"status"]);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    

}

- (void)processGetProfileFor:(NSString*)profileURL success:(void(^)(NSDictionary* dict))success failure:(void(^)(NSError *error))failure {
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",k_BASE_SOCIAL_SERVER_URL,profileURL];
    
    NSString *header = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    header = [NSString stringWithFormat:@"%@%@",@"Bearer ",header];
    
    [RUWebServiceParser getWebServiceWithURL:url header:header parameter:nil success:^
     
     (NSDictionary *responseDict) {
         
         success([responseDict valueForKey:@"data"]);
         
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
    post.mediaDictionary = [dict valueForKey:@"media"];
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


- (void)processUploadFileAWSWithfilePath:(NSString*)filePath fileName:(NSString*)fileName success:(void(^)(NSString* fileName))success {
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.bucket = k_BUCKET_NAME;
   // self.bucketKey = fileName;
    NSLog(@"Budcket key %@",fileName);
    
    
    
    [self upload:uploadRequest success:^{
        
        NSString *filePath = fileName;
        success(filePath);
    }];
    
}

- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest success:(void(^)(void))success {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    }
                        break;
                        
                    default:
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            
            NSLog(@"uploaded %@",task.result);
            success();
          //  NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:self.bucketKey];
          //  NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
           // NSLog(@"Download Url %@",downloadingFileURL.absoluteString);
        }
        
        return nil;
    }];
}






@end
