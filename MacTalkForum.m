//
//  MacTalkForum.m
//

#import "MacTalkForum.h"
#import "MacTalkPost.h"
#import "MacTalkConstants.h"

@interface MacTalkForum(PrivateMethods)
- (NSInteger)_findLastPostId;
- (void)_findNewPosts;
@end

@implementation MacTalkForum

@synthesize lastPostId;

- (void)monitorPosts {
	NSLog(@"Starting to monitor posts...");
	
	self.lastPostId = [self _findLastPostId];
	NSLog(@"Last post id found: %d",self.lastPostId);
	
	[NSTimer scheduledTimerWithTimeInterval:15
									 target:self
								   selector:@selector(_findNewPosts)
								   userInfo:nil
									repeats:YES];
}

- (void)_findNewPosts {
	NSString *urlString = [NSString stringWithFormat:@"http://forums.mactalk.com.au/vaispy.php?do=xml&_=&last=%d&r=%lf", self.lastPostId, [[NSDate date] timeIntervalSince1970]];
	NSLog(@"%@",urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error; // Question: memory leak or is the stringWithContents creating it?
	//NSString *data = [NSString stringWithContentsOfURL:url  encoding:NSUTF8StringEncoding error:&error];
	//NSLog(@"%@",data);
	
	NSXMLDocument* doc = [[NSXMLDocument alloc]initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:&error];
	//NSLog(@"%@",doc);
	NSXMLElement* root = doc.rootElement;
	NSArray* events = [root elementsForName:@"event"];
	for (NSXMLElement* event in events) {
		NSLog(@"%@",event);
		MacTalkPost* post = [[MacTalkPost alloc]init];
		
		post.id = [[[[event elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
		NSLog(@"%d",post.id);
		post.what = [[[event elementsForName:@"what"] objectAtIndex:0] stringValue];
		post.when = [[[event elementsForName:@"when"] objectAtIndex:0] stringValue];
		post.title = [[[event elementsForName:@"title"] objectAtIndex:0] stringValue];
		post.preview = [[[event elementsForName:@"preview"] objectAtIndex:0] stringValue];
		post.poster = [[[event elementsForName:@"poster"] objectAtIndex:0] stringValue];
		post.threadid = [[[[event elementsForName:@"threadid"] objectAtIndex:0] stringValue] intValue];
		post.postid = [[[[event elementsForName:@"postid"] objectAtIndex:0] stringValue] intValue];
		post.userid = [[[[event elementsForName:@"userid"] objectAtIndex:0] stringValue] intValue];
		post.forumid = [[[[event elementsForName:@"forumid"] objectAtIndex:0] stringValue] intValue];
		post.forumname = [[[event elementsForName:@"forumname"] objectAtIndex:0] stringValue];
		
		if (post.id > self.lastPostId) {
			self.lastPostId = post.id;
		}
		
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:MacTalkNotificationNewPost object:post];
		
		[post release];
	
		//NSLog(@"%d",[[[[event elementsForName:@"id"] objectAtIndex:0] stringValue] intValue]);
		
	}
	
	[doc release];
	
}

- (NSInteger)_findLastPostId {
	NSString *urlString = @"http://forums.mactalk.com.au/vaispy.php"; // Question: do I have to release this? How do I make this a constant?
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"Calling url %@",urlString);
	NSError* error;
	// parse the page
	NSString *dataString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
	if (!dataString) {
		NSLog(@"Unable to download data. %@",error);
	    // TODO add to a status bar message
		return -1;
	}
	NSArray *lines = [dataString componentsSeparatedByString:@"\n"];
	for (NSString *line in lines) {
		NSRange range = [line rangeOfString:@"highestid = "];
		if (range.location != NSNotFound) {
			NSLog(@"Found line: %@",line);
			NSCharacterSet *equalsSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
			NSScanner *scanner = [NSScanner scannerWithString:line];
			NSInteger postId;
			NSString *test;
			if ([scanner scanUpToCharactersFromSet:equalsSet intoString:&test] &&
				[scanner scanString:@"=" intoString:NULL] &&
				[scanner scanInteger:&postId]) {
				NSLog(@"Found last post id: %d",postId);
				return postId;
			}
		}
	}
	
	return -1;
}

@end



