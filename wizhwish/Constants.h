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


//Segue Identifier

#define K_SEGUE_CONTACT                             @"K_SEGUE_CONTACTS"
#define K_SEGUE_NEW_FRIENDS                          @"K_SEGUE_FRIENDS"



//Cell Identifier

#define K_PEOPLE_COLLECTION_CELL                    @"Friend_Cell"
#define K_CELL_POST                                 @"K_CELL_POST"
#define K_POST_TABLEVIEW_CELL                       @"K_POST_CELL"
#define K_POST_TOP_CELL                             @"K_POST_TOP_CELL"

#define K_COLLECTION_VIEW_FOLLOWING                 @"K_FOLLOWING_COLLECTION_CELL"
#define K_COLLECTION_VIEW_FOLLOWER                  @"K_FOLLOWER_COLLECTION_CELL"
#define K_COLLECTION_VIEW_MY_WISHES                 @"K_MYWISHES_COLLECTION_CELL"
#define K_COLLECTION_VIEW_WISHLIST                  @"K_WISHLIST_COLLECTION_CELL"
#define K_FOLLOWER_CELL                             @"K_FOLLOWER_CELL"

#define K_CELL_MY_WISHES                            @"K_CELL_MYWISHES"
#define K_TABLE_CELL_MY_WISHES                      @"K_TABLE_CELL_MY_WISHES"
#define K_CELL_MY_POST                              @"K_CELL_MY_POST"




//Segue

#define  K_SEGUE_HOME                               @"K_SEGUE_HOME"
#define K_SEGUE_HOME_REGISTER                       @"K_SEGUE_HOME_REGISTER"



#endif /* Constansts_h */