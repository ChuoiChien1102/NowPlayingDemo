//
//  ViewController.m
//  NowPlayingDemo
//
//  Created by chuoichien on 24/1/25.
//

#import "ViewController.h"
#import "MusicItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Init list musicItem
    MusicItem *item1 = [[MusicItem alloc] init];
    item1.songName = @"Tái Sinh";
    item1.artist = @"Tùng Dương";
    item1.albumName = @"Tái Sinh";
    item1.patchFileName = @"TaiSinh";
    
    MusicItem *item2 = [[MusicItem alloc] init];
    item2.songName = @"Vị Nhà";
    item2.artist = @"Đen Vâu";
    item2.albumName = @"Tết 2025";
    item2.patchFileName = @"ViNha";
    
    self.playlist = [[NSMutableArray alloc] init];
    [self.playlist addObject:item1];
    [self.playlist addObject:item2];
    
    // start from the first song
    self.currentTrackIndex = 0;
    
    // Setup Audio player
    [self setupAudioPlayer];
    
    // Setup NowPlayingInfo and RemoteCommandCenter
    [self setupNowPlayingInfo];
    [self setupRemoteCommandCenter];
}

#pragma mark - Setup Audio player

- (void)setupAudioPlayer {
    MusicItem *item = self.playlist[self.currentTrackIndex];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:item.patchFileName ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.audioPlayer play];
}

#pragma mark - Setup NowPlayingInfo

- (void)setupNowPlayingInfo {
    MPNowPlayingInfoCenter *nowPlayingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    MusicItem *item = self.playlist[self.currentTrackIndex];
    nowPlayingInfoCenter.nowPlayingInfo = @{
        MPMediaItemPropertyTitle: item.songName,  // songName
        MPMediaItemPropertyArtist: item.artist,                       // artist
        MPMediaItemPropertyAlbumTitle: item.albumName,                     // albumName
        MPMediaItemPropertyPlaybackDuration: @(self.audioPlayer.duration), // Song duration
        MPNowPlayingInfoPropertyElapsedPlaybackTime: @(self.audioPlayer.currentTime), // Current time
        MPNowPlayingInfoPropertyPlaybackRate: @(self.audioPlayer.isPlaying ? 1.0 : 0.0) // Playback speed
    };
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - Setup RemoteCommandCenter

- (void)setupRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // Handle Play
    [commandCenter.playCommand addTarget:self action:@selector(playCommandHandler)];
    commandCenter.playCommand.enabled = YES;
    
    // Handle Pause
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseCommandHandler)];
    commandCenter.pauseCommand.enabled = YES;
    
    // Handle Next
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackHandler)];
    commandCenter.nextTrackCommand.enabled = YES;
    
    // Handle Previous
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackHandler)];
    commandCenter.previousTrackCommand.enabled = YES;
}

- (MPRemoteCommandHandlerStatus)playCommandHandler {
    [self.audioPlayer play];
    [self updateNowPlayingInfoWithPlaybackRate:1.0];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)pauseCommandHandler {
    [self.audioPlayer pause];
    [self updateNowPlayingInfoWithPlaybackRate:0.0];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)nextTrackHandler {
    self.currentTrackIndex = (self.currentTrackIndex + 1) % self.playlist.count; // Move to next song
    [self changeTrack];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)previousTrackHandler {
    self.currentTrackIndex = (self.currentTrackIndex - 1 + self.playlist.count) % self.playlist.count; // Go back to previous song
    [self changeTrack];
    return MPRemoteCommandHandlerStatusSuccess;
}

#pragma mark - Update Track

- (void)changeTrack {
    [self.audioPlayer stop];
    [self setupAudioPlayer];
    [self.audioPlayer play];
    [self setupNowPlayingInfo];
}

#pragma mark - Update Song Info

- (void)updateNowPlayingInfoWithPlaybackRate:(float)playbackRate {
    MPNowPlayingInfoCenter *nowPlayingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayingInfo = [nowPlayingInfoCenter.nowPlayingInfo mutableCopy];
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.audioPlayer.currentTime);
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(playbackRate);
    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo;
}

@end
