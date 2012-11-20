//
//  pyTivoController.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/8/08.
//  Copyright 2008 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "runinshell.h"
#import "Startup.h"
#import "PrefController.h"
#import "pyTivo.h"
#import "SB.h"

@interface pyTivoController : NSObject {
	NSMutableArray *DataList;
	IBOutlet NSTableView *myTableView;
	IBOutlet NSWindow *myWindow;
	Startup *startupController;
	SB *SBTask;
	pyTivo *pyTivoTask;
	BOOL windowNeedsOpening;
	NSUserDefaults *_defaults;
	PrefController *_prefsController;
}

-(NSMutableArray *)DataList;

-(IBAction) startButton:(id)sender;
-(IBAction) addRow:(id)sender;
-(IBAction) removeRow:(id)sender;
-(IBAction) toggleHide:(id)sender;
-(IBAction) showPreferences:(id) sender;

-(int)numberOfRowsInTableView:(NSTableView *)tableView;
-(id)tableView:(NSTableView *)tableView 
           objectValueForTableColumn:(NSTableColumn *)tableColumn
					 row:(int)row;
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex;

-(NSUserDefaults *) getGlobalDefaults;
-(Startup *) getStartup;
@end
