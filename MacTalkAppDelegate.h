//
//  MacTalkAppDelegate.h
//

#import <Cocoa/Cocoa.h>

@class MacTalkForum;

@interface MacTalkAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	MacTalkForum *forum;
}

@property (assign) IBOutlet NSWindow *window;

@end
