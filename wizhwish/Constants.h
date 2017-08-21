//
//  Constansts.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-18.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#ifndef Constansts_h
#define Constansts_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)


#define K_SB_LOGIN_VIEW_CONTROLLER                  @"K_SB_LOGIN_VC"
#define K_SB_REGISTER_VIEW_CONTROLLER               @"K_SB_REGISTER_VC"
#define K_SB_HOME_VIEW_CONTROLLER                   @"K_SB_HOME_VC"
#define K_SB_FOLLOWER_VIEW_CONROLLER                @"K_SB_FOLLOWER_VC"
#define K_SB_MYWISHES_VIEW_CONROLLER                @"K_SB_MYWISHES_VC"
#define K_SB_POST_VIEW_CONTROLLER                   @"K_SB_POST_VIEW_CONTROLLER"
#define K_SB_PROFILE_VIEW_CONTROLLER                @"K_SB_PROFILE_VIEW_CONTROLLER"
#define K_SB_CHAT_VIEW_CONTROLLER                   @"K_SB_CHAT_VIEW_CONTROLLER"
#define K_SB_CHAT_LIST_VC                           @"K_SB_CHAT_LIST_VC"
#define K_SB_FRIEND_VIEW_CONTROLLER                 @"K_SB_FRIEND_VIEW_CONTROLLER"
#define K_SB_VIDEO_RECORD_VIEW_CONTROLLER           @"K_SB_VIDEO_RECORD_VIEW_CONTROLLER"
#define K_SB_PHOTO_VIEW_CONTROLLER                  @"K_SB_PHOTO_VIEW_CONTROLLER"
#define K_SB_RECORD_VIEW_CONTROLLER                 @"K_SB_RECORD_VIEW_CONTROLLER"
#define K_SB_TEXT_VIEW_CONTROLLER                   @"K_SB_TEXT_VIEW_CONTROLLER"
#define K_SB_WIZH_VIEW_CONTROLLER                   @"K_SB_WIZ_VIEW_CONTROLLER"
#define K_SB_GIFT_VIEW_CONTROLLER                   @"K_SB_GIFT_VIEW_CONTROLLER"

#define K_SB_WISHBOARD_VIEW_CONTROLLER              @"K_SB_WISHBOARD_VIEW_CONTROLLER"
#define K_SB_COMMENTS_VIEW_CONTROLLER               @"K_SB_COMMENTS_VC"
#define K_SB_TEMP_VIDEO_VIEW_CONTROLLER             @"k_SB_TEMP_VIDEO_VC"
#define k_SB_PROFILE_EDIT_VC                        @"K_SB_PROFILE_VC"
#define k_SB_MYDAILIES_VC                           @"K_SB_MY_DAILIES_VC"
#define k_SB_CAMERA_VC                              @"k_SB_CAMERA_VC"
#define k_SB_MEDIA_DISPLAY_VC                       @"k_SB_MEDIA_DISPLAY_VC"
#define k_SB_STICKER_VC                             @"k_SB_STICKER_VC"

#define k_KICKFLIP_API_KEY                          @"BBLr9ZEDw2cNHqRMLAU9VX5.UnU7Ttts3.HRYwH?"
//#define  @"OLvlmYM:?pv2E_gwTwmZAMDt=dO:3gSmErzS43pI:oor6auYfcD5pwM0b@gtfRv-B9g@8PtUDyeh4yq:Ee_eTb!lZD-7jQ?!!JZoVKo_p@79k:uNW3g@XR.w2AKpfxn"

#define k_FILE_UPLOADED_NOTIFICATION                 @"k_file_uploaded"

//URL
#define k_BASE_SERVER_URL                            @"http://54.190.5.74:9991"
#define k_BASE_SOCIAL_SERVER_URL                     @"http://54.190.5.74:8080"
#define k_AUTHORIZATION_BASIC                        @"Basic dHJ1c3RlZC1hcHA6c2VjcmV0"

//Segue Identifier

#define K_SEGUE_CONTACT                             @"K_SEGUE_CONTACTS"
#define K_SEGUE_NEW_FRIENDS                         @"K_SEGUE_FRIENDS"

#define k_AMAZON_S3_SERVER_URL                      @"https://s3.amazonaws.com/"

#define k_ACCESS_TOKEN                               @"access_token"
#define k_BUCKET_NAME                                @"images-test-123"


//Cell Identifier

#define k_COMMENTS_CELL                             @"k_COMMENT_CELL"
#define K_PEOPLE_COLLECTION_CELL                    @"Friend_Cell"
#define K_CELL_INVITE                               @"K_CELL_INVITE"
#define K_CELL_POST                                 @"K_CELL_POST"
#define K_POST_TABLEVIEW_CELL_IMAGE                 @"K_POST_CELL_IMAGE"
#define K_POST_TABLEVIEW_CELL_TEXT                  @"K_POST_CELL_TEXT"
#define k_POST_TABLEVIEW_CELL_VIDEO                 @"K_POST_CELL_VIDEO"
#define k_POST_TABLEVIEW_CELL_AUDIO                 @"K_POST_CELL_AUDIO"

#define K_POST_TOP_CELL                             @"K_POST_TOP_CELL"

#define K_COLLECTION_VIEW_FOLLOWING                 @"K_FOLLOWING_COLLECTION_CELL"
#define K_COLLECTION_VIEW_FOLLOWER                  @"K_FOLLOWER_COLLECTION_CELL"
#define K_COLLECTION_VIEW_MY_WISHES                 @"K_MYWISHES_COLLECTION_CELL"
#define K_COLLECTION_VIEW_WISHLIST                  @"K_WISHLIST_COLLECTION_CELL"
#define K_FOLLOWER_CELL                             @"K_FOLLOWER_CELL"

#define K_CELL_MY_WISHES                            @"K_CELL_MYWISHES"
#define K_TABLE_CELL_MY_WISHES                      @"K_TABLE_CELL_MY_WISHES"
#define K_CELL_MY_POST                              @"K_CELL_MY_POST"




#define k_VIDEO_TYPE                                @"type_video"
#define k_AUDIO_TYPE                                @"type_audio"
#define k_TEXT_TYPE                                 @"type_text"
#define k_IMAGE_TYPE                                @"type_image"

//Segue

#define  K_SEGUE_HOME                               @"K_SEGUE_HOME"
#define K_SEGUE_HOME_REGISTER                       @"K_SEGUE_HOME_REGISTER"



#endif /* Constansts_h */
