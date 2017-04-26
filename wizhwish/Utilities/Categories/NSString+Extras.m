//
//  NSString+Range.m
//  aHeadsUp
//
//  Created by Arslan Raza on 08/03/2015.
//  Copyright (c) 2015 arkTechs. All rights reserved.
//

#import "NSString+Extras.h"

@implementation NSString (Extras)

#pragma mark - Private Methods

+ (NSMutableAttributedString *)getStringAttributedUnitsFromPlainString:(NSString *)string WithFontSize:(float)fontSize
{
    int startRange = 0;
    int unitcharactersCount = 0;
    NSArray *stringArray = [string componentsSeparatedByString:@" "];
    if (stringArray.count > 0) {
        NSString *textpart = stringArray[0];
        if ([textpart isEqualToString:@"$"]) {
            startRange = 0;
        } else {
            startRange = (int)textpart.length + 1;
        }
        
        if ([textpart isEqualToString:@"$"]) {
            unitcharactersCount = 1;
        } else {
            NSString *unitspart = stringArray[1];
            unitcharactersCount = (int)unitspart.length;
        }
        
    }
    NSString *uppercasedString = [string uppercaseString];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:uppercasedString
                                                                                         attributes:@{NSFontAttributeName: [fnt fontWithSize:fontSize]}];
    
    
    [attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:fontSize/2]
                                      , NSBaselineOffsetAttributeName : @11} range:NSMakeRange(startRange,unitcharactersCount)];
    
    return attributedString;
}




#pragma mark Class Methods


+ (BOOL)validateStringForEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSMutableAttributedString*)generateAttributedString:(NSString*)strName strDesc:(NSString*)strDesc {
    
    NSMutableAttributedString * strAttributed;
    NSInteger _NameLength;
    
    if (strName!=nil) {
        strAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",strName,strDesc]];
        _NameLength = [strName length];
    }
    else
    {
        strAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",strDesc]];
        _NameLength = 0;
    }
    
    
    //    UIFont *font=[UIFont fontWithName:@"Helvetica" size:18.0f];
    UIColor * fontColor = [UIColor colorWithRed:49/255.0 green:153/255.0 blue:154/255.0 alpha:1.0];
    [strAttributed addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _NameLength+1)];
    //    [strAttributed addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [strAttributed length])];
    
    return strAttributed;
    
}

+ (NSString*)getLoremText {
    return @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting";
}

+ (id)jsonValue:(NSString*)string {
    if(string && string != [NSNull class]) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return json;
    }
    return nil;
    
}


+ (UIImage *)decodeBase64ToImageToWithString:(NSString *)stringEncodeData {
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:stringEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


#pragma mark Instance Methods



- (BOOL)hasSubString:(NSString*)other {
    NSRange range = [self rangeOfString:other options:NSCaseInsensitiveSearch];
    return range.length != 0;
}

- (BOOL)hasNumbersOnly
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (NSMutableDictionary*)getParametersFromURLString {
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    for (NSString *qs in [self componentsSeparatedByString:@"&"]) {
        // Get the parameter name
        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
        // Get the parameter value
        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
       value =  [value stringByRemovingPercentEncoding];
    //    value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        queryStrings[key] = value;
    }
    
    return queryStrings;
}

- (NSString *)extractYoutubeId {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:self options:0 range:NSMakeRange(0,self.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [self substringWithRange:result.range];
    }
    return nil;
}



- (BOOL)isValidPassword:(NSString*)value
{
    return value.length>7;
}
- (BOOL)isValidPhoneNumber:(NSString*)number
{
    if ([number hasNumbersOnly]) {
        
        return number.length>9 && number.length<16;
    }
    else
    {
        return NO;
    }
}
- (BOOL)isValidVerificationNumber:(NSString*)code
{
    if ([code hasNumbersOnly]) {
        return code.length == 4;
    }
    else
    {
        return NO;
    }
}


+ (NSDate *)getDateFromTimeStamp:(NSString *)timeStamp
{
    double milliseconds = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000];
    return date;
}


+ (NSAttributedString *)getAttributedTextForString:(NSString *)string fontSize:(float)fontSize {
    
    if (string) {
        NSMutableAttributedString *attributedString = [self getStringAttributedUnitsFromPlainString:string WithFontSize:fontSize];
        
        return attributedString;
    }
    
    return [[NSAttributedString alloc]initWithString:@""];
}

+(BOOL)isStringNull:(NSString*)string {
    
    if (![string isEqual:[NSNull null]]) {
        
        if (!string) {
            return YES;
        }
        if ([string isEqualToString:@"(null)"]) {
            
            return YES;
        }
        if (string.length > 0) {
            return NO;
        }
        else {
            
            return YES;
        }
    }
    else {
        return YES;
    }
}






@end
