//
//  MacTalkWindow.m
//

#import "MacTalkWindow.h"
#import "MacTalkPost.h"
#import "MacTalkConstants.h"
#import <Growl/Growl.h>

@implementation MacTalkWindow

- (void)awakeFromNib {
	posts = [[NSMutableArray alloc]init];
	
	NSBundle *myBundle = [NSBundle bundleForClass:[MacTalkWindow class]];
	NSString *growlPath = [[myBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
	
	if (growlBundle && [growlBundle load]) {
		// Register ourselves as a Growl delegate
		[GrowlApplicationBridge setGrowlDelegate:self];
	}
	else {
		NSLog(@"ERROR: Could not load Growl.framework");
	}
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleNewPosts:) name:MacTalkNotificationNewPost object:nil];
	
	
}

-(void)handleNewPosts:(NSNotification *)notification {
	MacTalkPost* post = [notification object];
	NSLog(@"Post to Growl");
	
	NSString* postUrl = [NSString stringWithFormat:@"http://forums.mactalk.com.au/showthread.php?p=%d#post%d", post.id, post.postid];
	[GrowlApplicationBridge notifyWithTitle:post.title
								description:post.preview
						   notificationName:@"MacTalkPost"
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:postUrl];
	
	[posts addObject:post];
	// TODO uncomment once using the table
	//[postView reloadData];
}

- (void)growlNotificationWasClicked:(id)clickContext {
	NSLog(@"Clicked growl notification %@",clickContext);
	
	NSURL *url = [[NSURL alloc] initWithString:clickContext];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)dealloc {
	[posts release];
	[super dealloc];
}

#pragma mark NSTableView Implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [posts count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	return [[posts objectAtIndex:rowIndex] preview];
}

@end
