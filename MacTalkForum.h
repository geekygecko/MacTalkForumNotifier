//
//  MacTalkForum.h
//

#import <Cocoa/Cocoa.h>


@interface MacTalkForum : NSObject {
	NSInteger lastPostId;
}

- (void)monitorPosts;

@property (assign) NSInteger lastPostId;

@end
