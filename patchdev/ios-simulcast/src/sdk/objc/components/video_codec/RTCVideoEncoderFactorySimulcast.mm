#import <Foundation/Foundation.h>

#import "RTCMacros.h"
#import "RTCVideoCodecInfo.h"
#import "RTCVideoEncoderFactorySimulcast.h"
#import "api/video_codec/RTCVideoEncoderSimulcast.h"

@interface RTC_OBJC_TYPE (RTCVideoEncoderFactorySimulcast) ()

@property id<RTC_OBJC_TYPE(RTCVideoEncoderFactory)> primary;
@property id<RTC_OBJC_TYPE(RTCVideoEncoderFactory)> fallback;

@end


@implementation RTC_OBJC_TYPE (RTCVideoEncoderFactorySimulcast)

@synthesize primary = _primary;
@synthesize fallback = _fallback;

- (instancetype)initWithPrimary:(id<RTC_OBJC_TYPE(RTCVideoEncoderFactory)>)primary
                       fallback:(id<RTC_OBJC_TYPE(RTCVideoEncoderFactory)>)fallback {
    if (self = [super init]) {
        _primary = primary;
        _fallback = fallback;
    }
    return self;
}

- (nullable id<RTC_OBJC_TYPE(RTCVideoEncoder)>)createEncoder: (RTC_OBJC_TYPE(RTCVideoCodecInfo) *)info {
    return [RTCVideoEncoderSimulcast simulcastEncoderWithPrimary: _primary fallback: _fallback videoCodecInfo: info];
}

- (NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *> *)supportedCodecs {
    NSArray *supportedCodecs = [[_primary supportedCodecs] arrayByAddingObjectsFromArray: [_fallback supportedCodecs]];

    auto av1Format = webrtc::SdpVideoFormat(
         cricket::kAv1CodecName, webrtc::SdpVideoFormat::Parameters(),
         webrtc::LibaomAv1EncoderSupportedScalabilityModes());
    RTCVideoCodecInfo *av1CodecInfo = [[RTCVideoCodecInfo alloc] initWithNativeSdpVideoFormat: av1Format];
    return [supportedCodecs arrayByAddingObject: av1CodecInfo];
}


@end