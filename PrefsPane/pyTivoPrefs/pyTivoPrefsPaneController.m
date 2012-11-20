//
//  GeneralPrefsPaneController.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.ß
//  Copyright 2009 home. All rights reserved.
//

#import "pyTivoPrefsPaneController.h"


@implementation pyTivoPrefsPaneController

- (BOOL) pyTivoEnabled {
	return [[_controller getGlobalDefaults] boolForKey:PREF_PYTIVO_BUTTON];
}
- (void) setPyTivoEnabled:(BOOL) checkBox {
	[[_controller getGlobalDefaults] setBool:checkBox forKey:PREF_PYTIVO_BUTTON];
}

- (BOOL) pyTivoSortAlpha {
	return [[_controller getGlobalDefaults] boolForKey:PREF_PYTIVO_SORT_ALPHA];
}
- (void) setPyTivoSortAlpha:(BOOL) checkBox {
	[[_controller getGlobalDefaults] setBool:checkBox forKey:PREF_PYTIVO_SORT_ALPHA];
}



@end
