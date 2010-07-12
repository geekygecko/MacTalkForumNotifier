//
//  MacTalkPost.m
//

#import "MacTalkPost.h"


@implementation MacTalkPost

@synthesize id;
@synthesize what;
@synthesize when;
@synthesize title;
@synthesize preview;
@synthesize poster;
@synthesize threadid;
@synthesize postid;
@synthesize userid;
@synthesize forumid;
@synthesize forumname;

- (void)dealloc {
	[what release];
	[when release];
	[title release];
	[preview release];
	[poster release];
	[forumname release];
	[super dealloc];
	 
}

@end
