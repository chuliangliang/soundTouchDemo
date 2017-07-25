//
//  AudioConvertDelegate.h
//  soundTouchDemo
//
//  Created by Chu,Liangliang on 2017/7/21.
//  Copyright © 2017年 baidu-初亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioConvertDelegate <NSObject>
@optional

/**
 * 是否只对音频文件进行解码 默认 NO 分块执行时 不会调用此方法
 * return YES : 只解码音频 并且回调 "对音频解码动作的回调"  NO : 对音频进行变声 不会 回调 "对音频解码动作的回调"
 **/
- (BOOL)audioConvertOnlyDecode;

/**
 * 是否只对音频文件进行编码 默认 YES 分快执行时 不会调用此方法
 * return YES : 需要编码音频 并且回调 "对音频编码动作的回调"  NO : 不对音频进行编码 不会回调 "变声处理结果的回调"
 **/
- (BOOL)audioConvertHasEnecode;


/**
 * 对音频解码动作的回调
 **/
- (void)audioConvertDecodeSuccess:(NSString *)audioPath;//解码成功
- (void)audioConvertDecodeFaild;                        //解码失败
- (void)audioConvertDecodeProgress:(float)progress;     //解码进度<暂未实现>


/**
 * 对音频变声动作的回调
 **/
- (void)audioConvertSoundTouchSuccess:(NSString *)audioPath;//变声成功
- (void)audioConvertSoundTouchFail;                         //变声失败
- (void)audioConvertSoundTouchProgress:(float)progress;     //变声进度进度<暂未实现>



/**
 * 对音频编码动作的回调
 **/
- (void)audioConvertEncodeSuccess:(NSString *)audioPath;//编码完成
- (void)audioConvertEncodeFaild;                        //编码失败
- (void)audioConvertEncodeProgress:(float)progress;     //编码进度<暂未实现>

@end
