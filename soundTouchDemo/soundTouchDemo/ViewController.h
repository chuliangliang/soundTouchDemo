//
//  ViewController.h
//  soundTouchDemo
//
//  Created by Chu,Liangliang on 2017/7/21.
//  Copyright © 2017年 baidu-初亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContanierView;
@property (weak, nonatomic) IBOutlet UILabel *tempoDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *tmpoSlider;
@property (weak, nonatomic) IBOutlet UILabel *pitchSemiTonesDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *pitchSemiTonesValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *pitchSemiTonesSlider;
@property (weak, nonatomic) IBOutlet UILabel *rateDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UILabel *outFileFormatLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outFormatSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *effectSegment;
@property (weak, nonatomic) IBOutlet UILabel *resourceChooseLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *resourceSegment;
@property (weak, nonatomic) IBOutlet UILabel *countDowntimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recorderEndButton;
@property (weak, nonatomic) IBOutlet UIButton *recorderPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;


- (IBAction)playFileAction:(UIButton *)sender;
- (IBAction)recorderBeginAction:(UIButton *)sender;
- (IBAction)recorderEndAction:(UIButton *)sender;
- (IBAction)recorderPlayAction:(UIButton *)sender;
- (IBAction)stopAction:(UIButton *)sender;
- (IBAction)segChanged:(UISegmentedControl *)sender;
- (IBAction)effectSegChanged:(UISegmentedControl *)sender;
- (IBAction)resourceChanged:(UISegmentedControl *)sender;
- (IBAction)tempoChangeValue:(UISlider *)sender;
- (IBAction)pitchSemitonesValue:(UISlider *)sender;
- (IBAction)rateChangeValue:(UISlider *)sender;
@end

