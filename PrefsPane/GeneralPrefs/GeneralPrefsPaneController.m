//
//  GeneralPrefsPaneController.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "GeneralPrefsPaneController.h"
#import "pyTivoController.h"
#import "Startup.h"

@implementation GeneralPrefsPaneController

- (BOOL) LaunchStartup {
	return [[_controller getGlobalDefaults] boolForKey:PREF_LAUNCH_STARTUP];
}

- (void) setLaunchStartup:(BOOL) checkBox {
	[[_controller getGlobalDefaults] setBool:checkBox forKey:PREF_LAUNCH_STARTUP];
	[[_controller getStartup] addLoginItem:nil];
}

- (NSString *) pyTivoUsername {
	return [[_controller getGlobalDefaults] stringForKey:PREF_USERNAME];
}
- (void) setPyTivoUsername:(NSString *)username {
	[[_controller getGlobalDefaults] setObject:username forKey:PREF_USERNAME];
}

- (NSString *) pyTivoPassword {
	return [[_controller getGlobalDefaults] stringForKey:PREF_PASSWORD];
}
- (void) setPyTivoPassword:(NSString *) password {
	[[_controller getGlobalDefaults] setObject:password forKey:PREF_PASSWORD];
}

@end
