//
//  TivoMenulet.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/10/08.
//  Copyright 2008 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TivoMenulet : NSObject {
	NSStatusItem *statusItem;
	NSImage *menuIcon;
	IBOutlet NSMenu *theMenu;
}

@end
