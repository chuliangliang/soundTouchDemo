//
//  ViewController.m
//  soundTouchDemo
//
//  Created by Chu,Liangliang on 2017/7/21.
//  Copyright © 2017年 baidu-初亮亮. All rights reserved.
//

/**
 * 说明:
 *      一款对音频处理的软件, 包括: 音频解码 、音频变声、音频编码; 此软件以技术研究为主要目的,使用简单只需要引入 AudioConvert.h 即可;
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
 */

#import "ViewController.h"
#import "Masonry.h"
#import "Recorder.h"
#import "DotimeManage.h"
#import "AudioConvert.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"

const int maxRecorderTime = 30;     //最大录音时间默认设置30s
@interface ViewController ()<DotimeManageDelegate,AudioConvertDelegate,AVAudioPlayerDelegate>
{
    BOOL isPlayRecoder; //是否播放的是录音
    AudioConvertOutputFormat outputFormat; //输出音频格式

    /*
     * 初始值 均为0
     */
    int tempoChangeNum;
    int pitchSemiTonesNum;
    int rateChangeNum;
    DotimeManage *timeManager;
    AVAudioPlayer *audioPalyer;
    NSString *audioFileName;

}
@end

@implementation ViewController

- (void)addConstraints
{

    __weak typeof(self)wself = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.view).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    [self.scrollViewContanierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.scrollView);
        make.width.equalTo(wself.scrollView);
        make.bottom.equalTo(wself.stopButton.mas_bottom).offset(10);
    }];
    
    
    [self.tempoDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.scrollViewContanierView);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    
    [self.tempoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.tempoDesLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.tmpoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.tempoValueLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.pitchSemiTonesDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.tmpoSlider.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.pitchSemiTonesValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.pitchSemiTonesDesLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.pitchSemiTonesSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.pitchSemiTonesValueLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.rateDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.pitchSemiTonesSlider.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.rateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.rateDesLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.rateSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.rateValueLabel.mas_bottom);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];

    [self.resourceChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.rateSlider.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    
    
    [self.resourceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.resourceChooseLabel.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];

    
    [self.outFileFormatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.resourceSegment.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    [self.outFormatSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.outFileFormatLabel.mas_bottom).offset(5);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];

    [self.effectSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.outFormatSegment.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];


    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.effectSegment.mas_bottom).offset(15);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);

    }];
    
    [self.countDowntimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.playButton.mas_top).offset(-10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(@(736-120-20));
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    [self.recorderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.playButton.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.recorderEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.recorderButton.mas_top);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    [self.recorderPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.recorderButton.mas_top);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];

    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.recorderButton.mas_bottom).offset(10);
        make.left.equalTo(wself.scrollViewContanierView).offset(10);
        make.right.equalTo(wself.scrollViewContanierView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addConstraints];
    
    //初始化参数
    tempoChangeNum = 0;
    pitchSemiTonesNum= 0;
    rateChangeNum = 0;
    audioFileName = @"一生无悔高安";
    outputFormat = AudioConvertOutputFormat_WAV;
    self.recorderEndButton.hidden = YES;
    self.recorderPlayButton.hidden = YES;
    self.outFormatSegment.selectedSegmentIndex = 0;
    self.effectSegment.selectedSegmentIndex = 0;
    self.resourceSegment.selectedSegmentIndex = 0;
    
    timeManager = [DotimeManage DefaultManage];
    [timeManager setDelegate:self];

}


#pragma mark -
#pragma mark - DotimeManageDelegate

//时间改变
- (void)TimerActionValueChange:(int)time
{
    
    if (time == maxRecorderTime) {
        
        [timeManager stopTimer];
        
        self.recorderButton.hidden = YES;
        self.recorderEndButton.hidden = YES;
        self.stopButton .hidden = NO;
        self.recorderPlayButton.hidden = NO;
        
        [[Recorder shareRecorder] stopRecord];
    }
    if (time > maxRecorderTime) time = maxRecorderTime;
    
    self.countDowntimeLabel.text = [NSString stringWithFormat:@"时间: %02d",time];
    
}

//播放音频文件
- (IBAction)playFileAction:(UIButton *)sender
{
    [self stopAudio];
    [[Recorder shareRecorder] stopRecord];
    
    [self.playButton setTitle:@"文件处理中..." forState:UIControlStateNormal];
    isPlayRecoder = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    NSString *p =  [[NSBundle mainBundle] pathForResource:audioFileName ofType:@"mp3"];
    AudioConvertConfig dconfig;
    dconfig.sourceAuioPath = [p UTF8String];
    dconfig.outputFormat = outputFormat;
    dconfig.outputChannelsPerFrame = 1;
    dconfig.outputSampleRate = 22050;
    dconfig.soundTouchPitch = pitchSemiTonesNum;
    dconfig.soundTouchRate = rateChangeNum;
    dconfig.soundTouchTempoChange = tempoChangeNum;
    [[AudioConvert shareAudioConvert] audioConvertBegin:dconfig withCallBackDelegate:self];
}

//开始录音
- (IBAction)recorderBeginAction:(UIButton *)sender
{
    //录音
    [self stopAudio];
    
    self.recorderButton.hidden = YES;
    self.recorderEndButton.hidden = NO;
    self.recorderPlayButton.hidden = YES;
    self.stopButton.hidden = YES;
    
    [timeManager setTimeValue:30];
    [timeManager startTime];
    
    [[Recorder shareRecorder] startRecord];

}

//录音结束
- (IBAction)recorderEndAction:(UIButton *)sender
{
    [timeManager stopTimer];
    
    self.recorderButton.hidden = YES;
    self.recorderEndButton.hidden = YES;
    self.recorderPlayButton.hidden = NO;
    self.stopButton.hidden = NO;
    
    [[Recorder shareRecorder] stopRecord];

}

//播放录音
- (IBAction)recorderPlayAction:(UIButton *)sender
{
    [self stopAudio];
    isPlayRecoder = YES;
    [self.recorderPlayButton setTitle:@"处理中..." forState:UIControlStateNormal];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    NSString *p =  [Recorder shareRecorder].filePath;
    AudioConvertConfig dconfig;
    dconfig.sourceAuioPath = [p UTF8String];
    dconfig.outputFormat = outputFormat;
    dconfig.outputChannelsPerFrame = 1;
    dconfig.outputSampleRate = 22050;
    dconfig.soundTouchPitch = pitchSemiTonesNum;
    dconfig.soundTouchRate = rateChangeNum;
    dconfig.soundTouchTempoChange = tempoChangeNum;
    [[AudioConvert shareAudioConvert] audioConvertBegin:dconfig withCallBackDelegate:self];
}

- (IBAction)stopAction:(UIButton *)sender
{
    self.recorderButton.hidden = NO;
    self.recorderEndButton.hidden = YES;
    self.recorderPlayButton.hidden = YES;
    self.countDowntimeLabel.text = @"时间";
    [self stopAudio];
    [SVProgressHUD dismiss];
    [[AudioConvert shareAudioConvert] cancelAllThread];
}

- (IBAction)segChanged:(UISegmentedControl *)sender {
    
    int selectIndex = (int)sender.selectedSegmentIndex;
    switch (selectIndex) {
        case 0:
            outputFormat = AudioConvertOutputFormat_WAV;
            break;
        case 1:
            outputFormat = AudioConvertOutputFormat_MP3;
            break;
        case 2:
            outputFormat = AudioConvertOutputFormat_AMR;
            break;
        default:
            break;
    }
}

- (IBAction)effectSegChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0: {
            //原声
            tempoChangeNum = 0;
            rateChangeNum = 0;
            pitchSemiTonesNum = 0;
        }
            break;
        case 1: {
            //男声
            tempoChangeNum = 0;
            rateChangeNum = 0;
            pitchSemiTonesNum = -6;
            
        }
            break;
        case 2: {
            //女声
            tempoChangeNum = 16;
            rateChangeNum = 0;
            pitchSemiTonesNum = 0;

        }
            break;
        case 3: {
            //快速
            tempoChangeNum = 90;
            rateChangeNum = 0;
            pitchSemiTonesNum = 0;

        }
            break;
        case 4: {
            //慢速
            tempoChangeNum = -40;
            rateChangeNum = 0;
            pitchSemiTonesNum = 0;
        }
            break;
            
        default:
            break;
    }
    
    self.tmpoSlider.value = tempoChangeNum;
    self.rateSlider.value = rateChangeNum;
    self.pitchSemiTonesSlider.value = pitchSemiTonesNum;
    
    self.tempoValueLabel.text = [NSString stringWithFormat:@"setTempoChange: %d",tempoChangeNum];
    self.pitchSemiTonesValueLabel.text = [NSString stringWithFormat:@"setPitchSemiTones: %d",pitchSemiTonesNum];
    self.rateValueLabel.text = [NSString stringWithFormat:@"setRateChange: %d",rateChangeNum];



}

- (IBAction)resourceChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        audioFileName = @"一生无悔高安";
    }else if (sender.selectedSegmentIndex == 1)
    {
        audioFileName = @"热雪";
    }
}
- (IBAction)tempoChangeValue:(UISlider *)sender {
    int value = (int)sender.value;
    self.tempoValueLabel.text = [NSString stringWithFormat:@"setTempoChange: %d",value];
    tempoChangeNum = value;
}


- (IBAction)pitchSemitonesValue:(UISlider *)sender {
    int value = (int)sender.value;
    self.pitchSemiTonesValueLabel.text = [NSString stringWithFormat:@"setPitchSemiTones: %d",value];
    pitchSemiTonesNum = value;
    
}
- (IBAction)rateChangeValue:(UISlider *)sender {
    
    int value = (int)sender.value;
    self.rateValueLabel.text = [NSString stringWithFormat:@"setRateChange: %d",value];
    rateChangeNum = value;
    
}



//停止播放
- (void)stopAudio {
    if (audioPalyer) {
        [audioPalyer stop];
        audioPalyer = nil;
    }
    [self.playButton setTitle:@"播放文件" forState:UIControlStateNormal];
    [self.recorderPlayButton setTitle:@"播放效果" forState:UIControlStateNormal];
}
//播放
- (void)playAudio:(NSString *)path {
    
    NSString *audioName = [path lastPathComponent];
    
    if ([audioName rangeOfString:@"amr"].location != NSNotFound) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"输出音频: %@ \n iOS 设备不能直接播放amr 格式音频",audioName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
        [SVProgressHUD dismiss];
        [self stopAudio];
        return;
    }else {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"文件名: %@",audioName ]];
    }
    
    
    if (!isPlayRecoder) {
        [self.playButton setTitle:@"播放文件中..." forState:UIControlStateNormal];
    }else {
        [self.recorderPlayButton setTitle:@"播放效果中..." forState:UIControlStateNormal];
    }
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *err = nil;
    if (audioPalyer) {
        [audioPalyer stop];
        audioPalyer = nil;
    }
    audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    audioPalyer.delegate = self;
    [audioPalyer play];
}

#pragma mak - 播放回调代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"恢复音效按钮");
    
    [self.playButton setTitle:@"播放文件" forState:UIControlStateNormal];
    [self.recorderPlayButton setTitle:@"播放效果" forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark - AudioConvertDelegate
- (BOOL)audioConvertOnlyDecode
{
    return  NO;
}
- (BOOL)audioConvertHasEnecode
{
    return YES;
}

/**
 * 对音频解码动作的回调
 **/
- (void)audioConvertDecodeSuccess:(NSString *)audioPath {
    //解码成功
    [self playAudio:audioPath];
}
- (void)audioConvertDecodeFaild
{
    //解码失败
    [SVProgressHUD showErrorWithStatus:@"解码失败"];
    [self stopAudio];
}


/**
 * 对音频变声动作的回调
 **/
- (void)audioConvertSoundTouchSuccess:(NSString *)audioPath
{
    //变声成功
    [self playAudio:audioPath];
}


- (void)audioConvertSoundTouchFail
{
    //变声失败
    [SVProgressHUD showErrorWithStatus:@"变声失败"];
    [self stopAudio];
}




/**
 * 对音频编码动作的回调
 **/

- (void)audioConvertEncodeSuccess:(NSString *)audioPath
{
    //编码完成
    [self playAudio:audioPath];
}

- (void)audioConvertEncodeFaild
{
    //编码失败
    [SVProgressHUD showErrorWithStatus:@"编码失败"];
    [self stopAudio];
}

@end
