//
//  NSString+Range.h
//  aHeadsUp
//
//  Created by Arslan Raza on 08/03/2015.
//  Copyright (c) 2015 arkTechs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extras)

- (BOOL)hasSubString:(NSString*)other;
- (BOOL)hasNumbersOnly;
- (NSMutableDictionary*)getParametersFromURLString;
- (NSString *)extractYoutubeId;
+ (BOOL)validateStringForEmail:(NSString*)email;
+ (NSMutableAttributedString*)generateAttributedString:(NSString*)strName strDesc:(NSString*)strDesc;
+ (NSString*)getLoremText;
+ (id)jsonValue:(NSString*)string;
- (BOOL)isValidPassword:(NSString*)value;
- (BOOL)isValidPhoneNumber:(NSString*)number;
- (BOOL)isValidVerificationNumber:(NSString*)code;



/**
 Decode - image encoded data string
 */
+ (UIImage *)decodeBase64ToImageToWithString:(NSString *)stringEncodeData;


/**
 Get Date from timestamp in milliseconds
 */
+ (NSDate *)getDateFromTimeStamp:(NSString *)timeStamp;


/**
 Get attributed Unit string
 */

+ (NSAttributedString *)getAttributedTextForString:(NSString *)string fontSize:(float)fontSize;


+(BOOL)isStringNull:(NSString*)string;


@end
