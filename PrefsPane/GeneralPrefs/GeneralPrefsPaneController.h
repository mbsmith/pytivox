//
//  GeneralPrefsPaneController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrefPaneController.h"
#import "Startup.h"

@interface GeneralPrefsPaneController : PrefPaneController {
}

- (BOOL) LaunchStartup;
- (void) setLaunchStartup:(BOOL) checkBox;

- (NSString *) pyTivoUsername;
- (void) setPyTivoUsername:(NSString *) username;

- (NSString *) pyTivoPassword;
- (void) setPyTivoPassword:(NSString *) password;

@end
