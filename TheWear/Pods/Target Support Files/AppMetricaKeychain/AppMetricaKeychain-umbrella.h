#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AMAFallbackKeychain.h"
#import "AMAKeychain.h"
#import "AMAKeychainBridge.h"
#import "AMAKeychainStoring.h"
#import "AppMetricaKeychain.h"

FOUNDATION_EXPORT double AppMetricaKeychainVersionNumber;
FOUNDATION_EXPORT const unsigned char AppMetricaKeychainVersionString[];

