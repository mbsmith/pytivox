//
//  PrefPaneController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PANE_NAME_KEY @"paneName"
#define ICON_PATH_KEY @"iconPath"
#define TOOL_TIP_KEY @"toolTip"
#define HELP_ANCHOR_KEY @"helpAnchor"

#define ALLOWS_HORIZONTAL_RESIZING_KEY @"allowsHorizontalResizing"
#define ALLOWS_VERTICAL_RESIZING_KEY @"allowsVerticalResizing"


@interface PrefPaneController : NSObject {
	id _controller;
	
	NSString *_nibName;
	NSString *_paneName;    
	NSString *_iconPath;
	NSString *_toolTip; 
	
	NSImage *_paneIcon;
	
	BOOL _allowsHorizontalResizing;
	BOOL _allowsVerticalResizing;
	
	NSString *_helpAnchor; 
	
	IBOutlet NSView *_prefsView;
	
}

- (id) initWithNib:(NSString *)nibName dictionary:(NSDictionary *)dictionary controller:(id)controller;

- (void) dealloc;

- (id) controller;

- (void) showWarningAlert:(NSError *) error;
- (IBAction) showHelp:(id) sender;

// SS_PreferencePaneProtocol

// we don't need this.
// + (NSArray *)preferencePanes;
- (NSView *)paneView;
- (NSString *)paneName;
- (NSImage *)paneIcon;
- (NSString *)paneToolTip;
- (BOOL)allowsHorizontalResizing;
- (BOOL)allowsVerticalResizing;

@end
