//
//  MacTalkWindow.h
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface MacTalkWindow : NSObject<GrowlApplicationBridgeDelegate, NSTableViewDelegate, NSTableViewDataSource> {
	IBOutlet NSTableView *postView;
	NSMutableArray* posts;
}

@end
