//
//  GeneralPrefsPaneController.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.ß
//  Copyright 2009 home. All rights reserved.
//

#import "SBPrefsPaneController.h"
#import "pyTivoController.h"


@implementation SBPrefsPaneController

- (BOOL) SBEnabled{
	return [[_controller getGlobalDefaults] boolForKey:PREF_SB_BUTTON];
}
- (void) setSBEnabled:(BOOL) checkBox {
	[[_controller getGlobalDefaults] setBool:checkBox forKey:PREF_SB_BUTTON];
}

- (BOOL) SBSortFilename {
	return [[_controller getGlobalDefaults] boolForKey:PREF_SB_SORT_FILENAME];
}
- (void) setSBSortFilename:(BOOL) checkBox {
	[[_controller getGlobalDefaults] setBool:checkBox forKey:PREF_SB_SORT_FILENAME];
}



@end
