//
//  MacTalkAppDelegate.m
//

#import "MacTalkAppDelegate.h"
#import "MacTalkForum.h"

@implementation MacTalkAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	forum = [[MacTalkForum alloc] init];
	[forum monitorPosts];
}

- (void)dealloc {
	[forum release];
	[super dealloc];
}

@end
