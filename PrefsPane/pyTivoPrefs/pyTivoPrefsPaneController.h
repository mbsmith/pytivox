//
//  GeneralPrefsPaneController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrefPaneController.h"
#import "pyTivoController.h"

@interface pyTivoPrefsPaneController : PrefPaneController {

}
- (BOOL) pyTivoEnabled;
- (void) setPyTivoEnabled:(BOOL) checkBox;

- (BOOL) pyTivoSortAlpha;
- (void) setPyTivoSortAlpha:(BOOL) checkBox;

@end
