
#import <Foundation/Foundation.h>


typedef struct {
    double time;
    double picturePts;
    double packetCount;
    float startTime;
    float duration;
   } StreamInfo;


@interface FrameData : NSObject {
	StreamInfo info;
    NSMutableData *data;
	int64_t pts;

}


@property (assign) StreamInfo info;
@property  NSMutableData *data;
@property (assign) int64_t pts;
-(StreamInfo) getStreamInfo;

@end
