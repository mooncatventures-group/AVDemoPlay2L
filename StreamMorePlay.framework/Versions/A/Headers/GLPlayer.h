//
#import <AudioToolbox/AudioQueue.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIKit.h>
#import "CacheBuffer.h"
#import <FFmpegDecoder/libavformat/avformat.h>
#import <FFmpegDecoder/libavcodec/avcodec.h>
#import <FFmpegDecoder/libavdevice/avdevice.h>
#import <FFmpegDecoder/libavformat/avio.h>
#import <FFmpegDecoder/libswscale/swscale.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "AdvancedAudioStub/AudioUnitController.h"


#define AUDIO_BUFFER_QUANTITY 3



@class FrameData;
@class StreamInterface;
@class CacheBuffer;


@interface GLPlayer : UIView {
	EAGLContext *context;
	GLuint renderbuffer;
	GLuint framebuffer;
    GLint backingWidth;
	GLint backingHeight;
	GLuint texture;
    BOOL movieDone;
    BOOL usesTcp;
	AVFormatContext *avfContext;
	int video_index;
	int audio_index;
    int video_queue_max;
    int audio_queue_max;
    int no_video_queues;
	AVCodecContext *enc;
	CacheBuffer *videoBuffer;
	GLfloat points[8];
	GLfloat texturePoints[8];
	AVFrame *avFrame;
	BOOL frameReady;
    BOOL enableOpenGL;
    BOOL disableRotation;
	FrameData *currentVideoBuffer;
    int64_t framePresentTime;
	double nextPts;
	AudioQueueRef audioQueue;
	AudioQueueBufferRef audioBuffers[AUDIO_BUFFER_QUANTITY];
	AudioQueueBufferRef emptyAudioBuffer;
	NSMutableArray *videoPacketQueue;
	NSMutableArray *audioPacketQueue;
	NSLock *audioPacketQueueLock;
    AVStream *_audioStream;
    AVCodecContext *_audioCodecContext;
    NSString  *url;
	int decodeDone;
	NSLock *decodeDoneLock;
	BOOL seekRequested;
	float seekPosition;
    float aspectRt;
	BOOL pauseRequested;
	NSLock *pauseLock;
	int64_t startTime;
	UInt64 trimmedFrames;
	StreamInterface *streamInterface;
	struct SwsContext *img_convert_ctx;
	unsigned int audioDTSQuotient;
	int audioPacketQueueSize;
    int16_t *_audioBuffer;
    BOOL _inBuffer;
    BOOL primed;
    NSUInteger _audioBufferSize;
    AVPacket *_packet, _currentPacket;
    AVFormatContext *_pFormatCtx;
    AudioUnitController *audioController;
    

}
@property (assign) int64_t framePresentTime;
@property (nonatomic) NSString *url;
@property (nonatomic, assign)  AudioQueueBufferRef emptyAudioBuffer;
@property (nonatomic, retain) AudioUnitController *audioController;
@property (nonatomic, assign)  	int audioPacketQueueSize;
@property (nonatomic, assign)  	AVStream *_audioStream;
@property (nonatomic, assign)  AVCodecContext *_audioCodecContext;
@property (nonatomic, retain) NSMutableArray *audioPacketQueue;
@property (nonatomic, assign)  	AVFormatContext *_pFormatCtx;

- (id)initWithFrame:(CGRect)frame movie:(NSString*)movie aspectRatio:(float)aspectRatio useTCP:(BOOL)useTCP;
- (void)setMovie:(NSString*)movie useTCP:(BOOL)useTCP;
- (void)disableOpenGL:(BOOL)disable;
- (void)disableRotation:(BOOL)disable;
- (void)setMaxVideoBuffer:(int)buffersize; 
- (void)setMaxAudioBuffer:(int)buffersize;
- (void)setMaxVideoQueues:(int)queues;
- (AVPacket*)readPacket;
- (void) closeStreams;
- (BOOL)presentFrame;
- (void)pause;

@end
