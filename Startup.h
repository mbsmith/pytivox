//
//  Startup.h
//  from code:
//  Created by Justin Williams on 3/1/08.
//  Copyright 2008 Second Gear LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "runinshell.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
#define HAVE_LSSHARED
#endif

@interface Startup : NSObject {
	NSString *pyTivoXApplicationPath;
	NSUserDefaults *defaults;
}

- (IBAction)addLoginItem:(id)sender;
@end

@interface Startup (PrivateMethods)
#ifdef HAVE_LSSHARED
- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath;
- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath;
#endif
@end
