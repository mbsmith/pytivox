//
//  GeneralPrefsPaneController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrefPaneController.h"

@interface SBPrefsPaneController : PrefPaneController {

}

- (BOOL) SBEnabled;
- (void) setSBEnabled:(BOOL) checkBox;

- (BOOL) SBSortFilename;
- (void) setSBSortFilename:(BOOL) checkBox;
@end
