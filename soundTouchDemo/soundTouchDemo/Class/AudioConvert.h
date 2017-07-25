//
//  AudioConvert.h
//  SoundTouchDemo
//
//  Created by chuliangliang on 15-1-29.
//  Copyright (c) 2015年 chuliangliang. All rights reserved.
//
/**
 * 说明:
 *      一款对音频处理的软件, 包括: 音频解码 、音频变声、音频编码; 此软件以技术研究为主要目的 使用简单只需要引入 AudioConvert.h 即可;
 * 版本:
 *      V3.1
 * 功能:
 *      1)常见音频格式解码 (输入音频格式: 常见音频格式均可)
 *      2)音频变声处理
 *      3)指定音频格式编码处理 (输出音频格式 MP3 WAV AMR)
 *
 * 系统类库: AVFoundation.framework 、AudioToolbox.framework
 *
 * 第三方类库: SoundTouch (变声处理库)、 lame (MP3编码库)
 *
 * 反馈及联系方式:
 *          QQ:949977202
 *          Email : chuliangliang300@sina.com
 * 更多资源 : http://chuliangliang.com
 **/

#import <Foundation/Foundation.h>
#import "AudioDecodeOperation.h"
#import "AudioSoundTouchOperation.h"
#import "AudioEncodeOperation.h"
#import "AudioConvertDelegate.h"
#import "AudioDefine.h"

@interface AudioConvert : NSObject

+ (AudioConvert *)shareAudioConvert;

/**
 * 说明:
 *
 * 功能: 1)输入音频 ->  2)解码 ->  3)变声 ->  4)处理文件准备编码 -> 5)编码
 *
 * 注意: 
 *      一、如果 2)执行后会调用 "- (BOOL)audioConvertOnlyDecode;" 若返回yes 返回解码结果 此时音频格式为wav  并结束 否则继续 详见 - (BOOL)audioConvertOnlyDecode 说明
 *      二、如果 4)执行后会调用 "- (BOOL)audioConvertHasEnecode;" 若返回 NO 返回变声处理后的结果 此时音频格式为wav 并结束 否则继续 详见 - (BOOL)audioConvertHasEnecode 说明
 **/
- (void)audioConvertBegin:(AudioConvertConfig )config
     withCallBackDelegate:(id<AudioConvertDelegate>)aDelegate;


#pragma mark- 分块接口

/**
 * 说明: 音频解码入口 这里 将音频解码成 wav
 * 
 * 参数: sourceAudioPath      原始文件的路径
 *       aDelegate           回调对象
 **/
- (void)audioConvertBeginDecode:(NSString *)sourceAudioPath
           withCallBackDelegate:(id<AudioConvertDelegate>)aDelegate;

/**
 * 说明: 对已经解码的音频进行变声的入口
 *
 * 参数: sourceAudioPath     经过解码后的音频路径
 *      aDelegate           回调对象
 *      tempoChange         速度 <变速不变调>  范围 -50 ~ 100
 *      pitch               音调  范围 -12 ~ 12
 *      rate                声音速率 范围 -50 ~ 100
 **/
- (void)audioConvertBeginSoundTouch:(NSString *)sourceAudioPath
               withCallBackDelegate:(id<AudioConvertDelegate>)aDelegate
                   audioTempoChange:(int)tempoChange
                         audioPitch:(int)pitch
                          audioRate:(int)rate;


/**
 * 说明: 对未编码音频进行编码 如 wav -> MP3
 *
 * 参数: sourceAudioPath     输入音频路径
 *      aDelegate           代理回调
 *      sampleRate          输出采样率
 *      format              输出音频格式
 *      channels            输出音频通道数 如 MP3 通道是 必须是 2 否则会出现音频变速
 **/
- (void)audioConvertBeginEncode:(NSString *)sourceAudioPath
           withCallBackDelegate:(id<AudioConvertDelegate>)aDelegate
          audioOutputSampleRate:(Float64)sampleRate
              audioOutputFormat:(AudioConvertOutputFormat)format
    audioOutputChannelsPerFrame:(int)channels;


/**
 * 结束所有子线程 同时取消代理
 **/
- (void)cancelAllThread;
@end
