//
//  MusicItem.h
//  NowPlayingDemo
//
//  Created by chuoichien on 24/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicItem : NSObject

@property (strong, nonatomic) NSString * songName;
@property (strong, nonatomic) NSString * artist;
@property (strong, nonatomic) NSString * albumName;
@property (strong, nonatomic) NSString * patchFileName;

@end

NS_ASSUME_NONNULL_END
