//
//  key.h
//  TCWeiBoSDKDemo
//
//  Created by 北京市海淀区 guosong on 12-8-29.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#ifndef TCWeiBoSDKDemo_key_h
#define TCWeiBoSDKDemo_key_h


#define kJson    @"json"
#define kXml     @"xml"


#define kFriendPortrait    @"friendPortrait"
#define kFriendNick        @"friendNick"

#define kIndex             @"index"
#define kIndexFriend       @"indexFriend"



#pragma mark 腾讯微博 解析

// 公共部分

#define kWeiboReturn        @"ret"
#define kWeiboMsg           @"msg"
#define kWeiboErrorCode     @"errcode"
#define kWeiboData          @"data"
#define kWeiboHasNext       @"hasnext"

#define kWeiboNextStartPosition        @"nextstartpos"
#define kWeiboInfo                     @"info"

// 互听好友
#define kWeiboName                     @"name"
#define kWeiboOpenId                   @"openid"
#define kWeiboNick                     @"nick"
#define kWeiboHeadURL                  @"headurl"
#define kWeiboFansNum                  @"fansnum"
#define kWeiboIdolNum                  @"idolnum"
#define kWeiboIsVip                    @"isvip"


// 最近联系人
#define kWeiboCurrentNum      @"curnum"
#define kWeiboHead            @"head"
#define kWeiboCurrentNum      @"curnum"
#define kWeiboIsFans          @"isfans"
#define kWeiboIsIdol          @"isidol"

#define kWeiboIsRealName      @"isrealname"
#define kWeiboSex             @"sex"


// 收藏的话题列表
#define kWeiboFavListId              @"id"
#define kWeiboFavListFavNum          @"favnum"
#define kWeiboFavListTimeStamp       @"timestamp"
#define kWeiboFavListTweetNum        @"tweetnum"
#define kWeiboFavListText            @"text"


// 最近使用的话题
#define kWeiboRecentHtFavNum             @"favnum"
#define kWeiboRecentHtId                 @"id"
#define kWeiboRecentHtLatestTime         @"latesttime"
#define kWeiboRecentHtText               @"text"
#define kWeiboRecentHtTweetNum           @"tweetnum"
#define kWeiboRecentHtUserTweetNum       @"usertweetnum"  
#define kWeiboRecentHtSuccNum           @"succnum"


#define kRecentHtReqNum   15 
#define kHasNextYes       0
#define kHasNextNO        1


#define kUserName     @"userName"


// 调用接口数据成功
#define kWeiboSucess  0


#pragma mark 多语言

#define kTCWBTable             @"Language"

#define KLanguageCancel        @"取消"
#define KLanguageAuth          @"授权"
#define kLanguageRebroadcast   @"腾讯微博"
#define kLanguageSend          @"发送"

#define kLanguageBack             @"返回"
#define kLanguageFriends          @"朋友"

#define kLanguageSearchTopic          @"Search topic"

#define kLanguageRelay              @"Relay"
#define kLanguageVideo              @"Video"
#endif
