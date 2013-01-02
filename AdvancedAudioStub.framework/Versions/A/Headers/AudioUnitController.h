//


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <streamMorePlay/GLPLayer.h>
@class GLPlayer;


@interface AudioUnitController : NSObject {
    AudioStreamBasicDescription audioStreamBasicDesc_;
    AVStream *_audioStream;
    GLPlayer *_streamer;
    AVCodecContext *_audioCodecContext;
    BOOL started_, finished_;
    NSInteger state_;
    AudioUnit _audioUnit;
      double _nextDecodedTime;
    int _nextAudioPts;
    UInt8* _buffer;
   

  

}
@property (nonatomic, assign) UInt8 *_buffer;


- (void)nextAudio:(const AudioTimeStamp*)timeStamp busNumber:(UInt32)busNumber
      frameNumber:(UInt32)frameNumber audioData:(AudioBufferList*)ioData;
- (void)_startAudio;
- (void)_stopAudio;
-(OSStatus)start;
-(OSStatus)stop;
-(void)cleanUp;
-(void)initialiseAudio;
-(void) queueAudio:(AVPacket)audioPacket;
- (id)initWithStreamer:(GLPlayer*)streamer;
- (OSStatus)enqueueBuffer:(AudioQueueBufferRef)buffer;


    


@end
