//
//  Startup.m
//  from code:
//  Created by Justin Williams on 3/1/08.
//  Copyright 2008 Second Gear LLC. All rights reserved.
//

#import "Startup.h"
#import "PrefConstants.h"

@implementation Startup (PrivateMethods)
#ifdef HAVE_LSSHARED
- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath {
	// We call LSSharedFileListInsertItemURL to insert the item at the bottom of Login Items list.
	NSDictionary *props = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kLSSharedFileListItemHidden];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, thePath, (CFDictionaryRef)props, NULL);		
	if (item)
		CFRelease(item);
}

- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath {
	UInt32 seedValue;
			
	// We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
	// and pop it in an array so we can iterate through it to find our item.
	NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
	for (id item in loginItemsArray) {		
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
			if ([[(NSURL *)thePath path] hasPrefix:pyTivoXApplicationPath])
				LSSharedFileListItemRemove(theLoginItemsRefs, itemRef); // Deleting the item
		}
	}
	
	[loginItemsArray release];
}
#endif
@end

@implementation Startup

-(id)init {
	defaults = [[NSUserDefaults standardUserDefaults] retain];
	return [super init];
}

-(void) dealloc {
	[defaults release];
	[super dealloc];
}

- (IBAction)addLoginItem:(id)sender {

#ifdef HAVE_LSSHARED
	NSBundle *myBundle = [NSBundle mainBundle];
	if (myBundle == nil) {
		pyTivoXApplicationPath = @"/Applications/pyTivoX/";
	} else {
		pyTivoXApplicationPath = [myBundle bundlePath];
	}
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:pyTivoXApplicationPath];
	
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (loginItems) {
		if ([defaults boolForKey:PREF_LAUNCH_STARTUP] == YES) {
			NSLog(@"Adding startup item");
			[self enableLoginItemWithLoginItemsReference:loginItems ForPath:url];
			NSString *trimmedPath = [pyTivoXApplicationPath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"mv /%@ /%@.bak", trimmedPath, trimmedPath]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"cp /%@.bak/Contents/Info-daemon.plist /%@.bak/Contents/Info.plist", trimmedPath, trimmedPath]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"mv /%@.bak /%@", trimmedPath, trimmedPath]];
		} else {
			NSLog(@"Removing startup item");
			[self disableLoginItemWithLoginItemsReference:loginItems ForPath:url];
			NSString *trimmedPath = [pyTivoXApplicationPath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"mv /%@ /%@.bak", trimmedPath, trimmedPath]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"cp /%@.bak/Contents/Info-reg.plist /%@.bak/Contents/Info.plist", trimmedPath, trimmedPath]];
			[runinshell runWithCommand:[NSString stringWithFormat:@"mv /%@.bak /%@", trimmedPath, trimmedPath]];
		}
	}
	CFRelease(loginItems);
#else
	NSLog(@"Can't add login item\n");
#endif
}

@end
