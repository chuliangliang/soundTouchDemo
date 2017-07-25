# soundTouchDemo for iOS

说明: 

一款对音频处理的软件, 包括: 音频解码 、音频变声、音频编码; 此软件以技术研究为主要目的 使用简单只需要引入 AudioConvert.h 即可;
 * 版本: 
 *      V3.1
 *      本次更新内容:
 *         1.opencore-amr 解决不支持bitcode问题
 *         2.lame         解决不支持bitcode问题
 * 功能: 
 *      1)常见音频格式解码 (输入音频格式: 常见音频格式均可)
 *      2)音频变声处理
 *      3)指定音频格式编码处理 (输出音频格式 MP3 WAV AMR)
 *
 * 系统类库: AVFoundation.framework 、AudioToolbox.framework
 *
 * 第三方类库: SoundTouch (变声处理库)、 lame (MP3编码库)、opencore-amr (amr编码库)
 *

本程序使用soundTouch开源框架对 录音文件 进行处理达到 变声功能 由于需要在2015年2月1日 苹果强制 所有提交AppStore 的项目必须支持 arm64 导致原来变声不能使用 所以做了一些改动:

* 1、支持arm64 (bit-64)
* 2、增加多线程处理
* 3、增加对音频文件变声处理 常见的音频格式均可作为输入源 
* 4、输出音频 增加amr 音频格式 和 MP3 音频格式 

主要使用框架 soundTouch （音频变声处理） SpeakHere （苹果官方音频解码库） lame （MP3 音频编码库  已处理成支持 arm64）
