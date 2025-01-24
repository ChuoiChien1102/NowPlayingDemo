//
//  ViewController.h
//  NowPlayingDemo
//
//  Created by chuoichien on 24/1/25.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) AVAudioPlayer *audioPlayer; // Trình phát nhạc
@property (nonatomic, strong) NSMutableArray *playlist;          // Danh sách bài hát
@property (nonatomic) NSInteger currentTrackIndex;        // Bài hát hiện tại

@end

