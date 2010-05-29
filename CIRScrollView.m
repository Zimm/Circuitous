//Created by DanZimm
#import "CIRLauncherView.h"
#import "CIRScrollView.h"
#import "CIRIcon.h"

#import "DSDisplayController.h"

@interface UIDevice (iPad)
- (BOOL)isWildcat;
@end

#define isWildcat ([[UIDevice currentDevice] respondsToSelector:@selector(isWildcat)] && [[UIDevice currentDevice] isWildcat])

static NSMutableArray *_activeApps = nil;

@implementation CIRScrollView
@synthesize appSet;

- (id)initWithFrame:(CGRect)frame apps:(NSArray *)apps active:(BOOL)active
{
	id orig = [super initWithFrame:frame];
	float multi;
	if isWildcat
		multi = 55.0f;
	else
		multi = 40.0f;
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.zimm.circuitous.plist"];
	if (active) {
		if (_activeApps)
			[_activeApps release];
		NSArray *apps1 = [[DSDisplayController sharedInstance] activeApps];
		_activeApps = [[NSMutableArray alloc] initWithArray:apps1];
		if (!isWildcat)
			[apps1 release];
		for (NSString *app in apps) {
			if (![_activeApps containsObject:app])
				[_activeApps addObject:app];
		}
	}
	BOOL closeBox = [prefs objectForKey:@"close"] ? [[prefs objectForKey:@"close"] boolValue] : YES;
	appSet = [[NSArray alloc] initWithArray:apps];
	float width = 11.0f;
	int place = -1;
	for (NSString *app in apps) {
		place++;
		CIRIcon *icon = [[CIRIcon alloc] initWithIdentifier:app andXCoor:(11.0f + (place * multi)) animations:([prefs objectForKey:@"appanimations"] ? [[prefs objectForKey:@"appanimations"] boolValue] : YES) labels:([prefs objectForKey:@"icontext"] ? [[prefs objectForKey:@"icontext"] boolValue] : YES) badges:([prefs objectForKey:@"badges"] ? [[prefs objectForKey:@"badges"] boolValue] : YES)];
		width = icon.frame.size.width + icon.frame.origin.x;
		icon.tag = place++;
		if ([_activeApps containsObject:app] && closeBox)
			[icon setActive];
		else if ([_activeApps containsObject:app])
			[icon setActiveWithoutBox];
		[self addSubview:icon];
	}
	[prefs release];
	width = width + 11.0f;
	self.contentSize = CGSizeMake(width, self.frame.size.height);
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = YES;
	self.scrollsToTop = NO;
	self.alwaysBounceVertical = NO;
	self.alwaysBounceHorizontal = YES;
	self.pagingEnabled = NO;
	self.scrollEnabled = YES;
	return orig;
}

- (id)initWithFrameVertically:(CGRect)frame apps:(NSArray *)apps active:(BOOL)active
{
	id orig = [super initWithFrame:frame];
	float multi;
	if isWildcat
		multi = 75.0f;
	else
		multi = 40.0f;
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.zimm.circuitous.plist"];
	if (active) {
		if (_activeApps)
			[_activeApps release];
		_activeApps = [[NSArray alloc] initWithArray:apps];
	}
	BOOL closeBox = [prefs objectForKey:@"close"] ? [[prefs objectForKey:@"close"] boolValue] : YES;
	appSet = [[NSArray alloc] initWithArray:apps];
	float width = 11.0f;
	int place = -1;
	for (NSString *app in apps) {
		place++;
		CIRIcon *icon = [[CIRIcon alloc] initWithIdentifier:app andYCoor:(11.0f + (place * multi)) animations:([prefs objectForKey:@"appanimations"] ? [[prefs objectForKey:@"appanimations"] boolValue] : YES) labels:([prefs objectForKey:@"icontext"] ? [[prefs objectForKey:@"icontext"] boolValue] : YES) badges:([prefs objectForKey:@"badges"] ? [[prefs objectForKey:@"badges"] boolValue] : YES)];
		width = icon.frame.size.height + icon.frame.origin.y;
		icon.tag = place++;
		if ([_activeApps containsObject:app] && closeBox)
			[icon setActive];
		else if ([_activeApps containsObject:app])
			[icon setActiveWithoutBox];
		[self addSubview:icon];
	}
	[prefs release];
	width = width + 11.0f;
	self.contentSize = CGSizeMake(self.frame.size.width, width);
	self.showsVerticalScrollIndicator = YES;
	self.showsHorizontalScrollIndicator = NO;
	self.scrollsToTop = NO;
	self.alwaysBounceVertical = YES;
	self.alwaysBounceHorizontal = NO;
	self.pagingEnabled = NO;
	self.scrollEnabled = YES;
	return orig;
}

- (void)dealloc
{
	if (_activeApps) {
		[_activeApps release];
		_activeApps = nil;
	}
	[appSet release];
	[super dealloc];
}

@end