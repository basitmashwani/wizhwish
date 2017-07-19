//
//  WSetting.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-10-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSetting : NSObject

@property(nonatomic ,retain) NSString *frontVideoUrlPath;

@property(nonatomic ,retain) NSString *rearVideoUrlPath;

@property(nonatomic ,retain) NSString *audioUrlPath;

@property(nonatomic ,retain) NSString *firstOutputUrl;

@property(nonatomic ,retain) NSString *firstVideoFileName;

@property(nonatomic ,retain) NSString *secondVideoFileName;

@property(nonatomic ,retain) NSString *secondOutputUrl;

@property(nonatomic ,retain) NSString *postText;

@property(nonatomic ,retain) NSMutableArray *imageArray;


@property(nonatomic ,retain) UIImage *audioImage;

@property(nonatomic ,retain) NSURL *audioURL;


@property(nonatomic ,retain) NSString *isFirstVideoUploaded;

@property(nonatomic ,retain) NSString *isSecondVideoUploaded;

@property(nonatomic ,retain) NSString *isAudioImageUploaded;


@property(nonatomic ,retain) NSString *audioImageURL;

@property(nonatomic ,retain) NSString *postType;

@property(nonatomic ,retain) NSString *uploadedCompleted;




+ (WSetting*)getSharedSetting;

+ (void)distroySetting;


@end
