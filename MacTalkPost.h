//
//  MacTalkPost.h
//

#import <Cocoa/Cocoa.h>


@interface MacTalkPost : NSObject {
	NSInteger id;
	NSString* what;
	NSString* when;
	NSString* title;
	NSString* preview;
	NSString* poster;
	NSInteger threadid;
	NSInteger postid;
	NSInteger userid;
	NSInteger forumid;
	NSString* forumname;
}

@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString* what;
@property (nonatomic, retain) NSString* when;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* preview;
@property (nonatomic, retain) NSString* poster;
@property (nonatomic) NSInteger threadid;
@property (nonatomic) NSInteger postid;
@property (nonatomic) NSInteger userid;
@property (nonatomic) NSInteger forumid;
@property (nonatomic, retain) NSString* forumname;

@end
