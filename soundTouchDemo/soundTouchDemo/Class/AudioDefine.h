//
//  AudioDefine.h
//  SoundTouchDemo
//
//  Created by chuliangliang on 15-2-10.
//  Copyright (c) 2015年 chuliangliang. All rights reserved.
//

#ifdef __OBJC__

#define SOUNDTOUCH_DEBUG 1
#ifdef SOUNDTOUCH_DEBUG
#define CNLog(log, ...) NSLog(log, ## __VA_ARGS__)
#else
#define CNLog(log, ...)
#endif


typedef struct
{
    const char *sourceAuioPath;         //输入的音频路径         必选
    
    Float64    outputSampleRate;        //输出的采样率           建议设置 8000 (优点: 采样率 越低 处理速度越快 缺点: 声音效果:反之 但非专业检测 不明显)
    int        outputFormat;            //输出音频格式           可选 默认 AudioConvertOutputFormat_WAV  具体见AudioConvertOutputFormat
    int        outputChannelsPerFrame;  //输出文件的通道数        可选 默认  1 可选择 1 或者 2 注意 最后输出的音频格式为mp3 时 通道数必须是 2 否则会造成编码后的音频变速
    
    int        soundTouchTempoChange;   //速度 <变速不变调> 范围 -50 ~ 100
    int        soundTouchPitch;         //音调  范围 -12 ~ 12
    int        soundTouchRate;          //声音速率 范围 -50 ~ 100
    
} AudioConvertConfig;


// 输出文件格式
typedef NS_ENUM(NSInteger, AudioConvertOutputFormat) {
    AudioConvertOutputFormat_WAV = 1,
    AudioConvertOutputFormat_AMR,
    AudioConvertOutputFormat_MP3,
};


//文件保存路径
#define  DOCMENT  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define  OUTPUT_DECODEPATH  [NSString stringWithFormat:@"%@/AudioConvert/Decode",DOCMENT]           //解码音频存储位置
#define  OUTPUT_SOUNDTOUCHPATH  [NSString stringWithFormat:@"%@/AudioConvert/SoundTouch",DOCMENT]   //变声过的音频存储位置
#define  OUTPUT_ENCODETMPPATH  [NSString stringWithFormat:@"%@/AudioConvert/Encodetmp",DOCMENT]     //编码音频临时存储位置
#define  OUTPUT_ENCODEPATH  [NSString stringWithFormat:@"%@/AudioConvert/Encode",DOCMENT]           //编码音频存储位置


#endif

