//
//  pyTivoController.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/8/08.
//  Copyright 2008 home. All rights reserved.
//

#import "pyTivoController.h"
#import "StreamPrefsController.h"
#import "GeneralPrefsController.h"
#import "MASPreferencesWindowController.h"

@implementation pyTivoController

-(void)awakeFromNib {
	DataList = [NSMutableArray new];
	NSArray *tempArray;
	_defaults = [NSUserDefaults standardUserDefaults];
	pyTivoTask = [[pyTivo alloc] init];
	SBTask = [[SB alloc] init];
	startupController = [[Startup alloc] init];
	NSDictionary *appDefaults = @{PREF_LAUNCH_STARTUP: @NO,
															 PREF_PYTIVO_BUTTON: @YES,
															 PREF_PYTIVO_SORT_ALPHA: @NO,
															 PREF_SB_BUTTON: @YES,
															 PREF_SB_SORT_FILENAME: @NO,
															 @"Version": @"0",
															 PREF_USERNAME: @"",
															 PREF_PASSWORD: @""};
	[_defaults registerDefaults:appDefaults];
	@try {
		tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX/Shares.data"]];
		[DataList setArray:tempArray];
	} @catch (id NSInvalidArgumentException) {
	}
	BOOL autoLaunch = [_defaults boolForKey:PREF_LAUNCH_STARTUP];
	NSString *oldVersion = [_defaults stringForKey:@"Version"];
	[myTableView reloadData];
	if (autoLaunch) {
		if (!([oldVersion isEqualToString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]])) {
			NSLog(@"Updating launch stuff");
			[startupController addLoginItem:nil];
		}
		windowNeedsOpening = YES;
	} else {
		windowNeedsOpening = NO;
		[myWindow makeKeyAndOrderFront:self];
	}
	[pyTivoTask prekill];
	[SBTask prekill];
	[pyTivoTask start];
	[SBTask start];
}

-(void)applicationWillTerminate:(NSNotification *)aNotification {
	[pyTivoTask kill];
	[SBTask kill];
	[NSKeyedArchiver archiveRootObject:DataList
					toFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX/Shares.data"]];
	[_defaults setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"Version"];
}

-(BOOL)windowShouldClose:(id)sender {
	[[NSApplication sharedApplication] hide:self];
	return NO;
}

-(void) dealloc {
	[pyTivoTask kill];
	[SBTask kill];
	[_defaults synchronize];
}

- (NSWindowController *)preferencesWindowController {
    
    if (!_preferencesWindowController) {
        StreamPrefsController *SBPref = [[StreamPrefsController alloc] init];
        GeneralPrefsController *genPref = [[GeneralPrefsController alloc] init];
        
        // Initialize preference window controller array.
        NSArray *controllers = @[[NSNull null], genPref, SBPref, [NSNull null]];
        
        _preferencesWindowController = [[MASPreferencesWindowController alloc]
                                        initWithViewControllers:controllers
                                        title:@"Preferences"];
    }
    
    return _preferencesWindowController;
}

- (IBAction) showPreferences:(id) sender{
    [self.preferencesWindowController showWindow:nil];
#if 0
	if(! _prefsController){
		NSString *path = nil;
		NSString *ext = nil;
		_prefsController = [[PrefController alloc] initWithPanesSearchPath:path 
																													 bundleExtension:ext 
																																controller:self];
		
		// so that we always see the toolbar, even with just one pane
		[_prefsController setAlwaysShowsToolbar:YES];
		[_prefsController setPanesOrder:[NSArray arrayWithObjects:@"General", @"pyTivo", @"SB", nil]];
	}
	
	[_prefsController showPreferencesWindow];
#endif
}

-(IBAction)startButton:(id)sender {
	[pyTivoTask kill];
	[SBTask kill];
	[pyTivoTask writeConfigFile:DataList];
	[pyTivoTask start];
	[SBTask writeConfigFile:DataList];
	[SBTask start];
}

- (IBAction)addRow:(id)sender {
	NSMutableDictionary *myDict;
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setPrompt:@"Choose folder to share"];
	[openPanel setCanChooseFiles:NO];
	
	int result = [openPanel runModal];
	if (result == NSOKButton) {
		myDict = [NSMutableDictionary dictionaryWithObjects:
							@[[openPanel URLs][0],
							 @0U,
							 @"My Share"]
						forKeys:@[@"Location", @"Type", @"Name"]];
		[DataList addObject:myDict];
		[myTableView reloadData];
		[myTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:([DataList count] - 1)]
                 byExtendingSelection:NO];
		[myTableView editColumn:2 row:([DataList count] -1) withEvent:nil select:YES];
	}
}

- (IBAction)removeRow:(id)sender {
	if ([myTableView selectedRow] < 0 || [myTableView selectedRow] >= [DataList count])
		return;
	[DataList removeObjectAtIndex:[myTableView selectedRow]];
	[myTableView reloadData];
}

-(IBAction) toggleHide:(id)sender {
	NSApplication *myApp = [NSApplication sharedApplication];
	if (windowNeedsOpening) {
		windowNeedsOpening = NO;
		[myWindow makeKeyAndOrderFront:self];
	} else {
		if ([myApp isHidden]) {
			[myApp unhide:self];
			[myWindow orderFront:self];
		} else {
			[myApp hide:self];
		}
	}
}

-(NSMutableArray *)DataList {
	return DataList;
}

-(int)numberOfRowsInTableView:(NSTableView *)myTableView{
	return [DataList count];
}

-(id)tableView:(NSTableView *)tableView
           objectValueForTableColumn:(NSTableColumn *)tableColumn
					 row:(int)row {
	return DataList[row][[tableColumn identifier]];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex
{
	DataList[rowIndex][[tableColumn identifier]] = anObject;
	[myTableView reloadData];
}

-(NSUserDefaults *) getGlobalDefaults { return _defaults ; }
-(Startup *) getStartup { return startupController ; }


@end
