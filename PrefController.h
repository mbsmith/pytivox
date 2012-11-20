//
//  PrefController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SS_PrefsController/SS_PrefsController.h"
#import "PrefPaneController.h"



@interface PrefController : SS_PrefsController {

}

- (id)initWithPanesSearchPath:(NSString*)path bundleExtension:(NSString *)ext controller:(id)controller;
- (void)activatePane:(NSString*)path controller:(id)controller;

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;

- (void)showPreferencesWindow;
- (void)showPreferencePane:(NSString *) paneName;

@end
