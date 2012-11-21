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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)init
{
    return [self initWithNibName:@"SBPrefsView" bundle:[NSBundle mainBundle]];
}

- (NSString *)identifier
{
    return @"SBPrefsPaneController";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"pyTivoPrefs.png"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Streaming", @"Toolbar item name for the credentials preference pane");
}

#if 0
- (IBAction)enableStreamBaby:(id)sender {
    NSInteger state = [sender state];
    
    if (state) {
        [[_controller getGlobalDefaults] setBool:YES forKey:PREF_SB_BUTTON];
    } else {
        [[_controller getGlobalDefaults] setBool:NO forKey:PREF_SB_BUTTON];
    }
}

- (IBAction)sortByFilename:(id)sender {
    NSInteger state = [sender state];
    
    if (state) {
        [[_controller getGlobalDefaults] setBool:YES forKey:PREF_SB_SORT_FILENAME];
    } else {
        [[_controller getGlobalDefaults] setBool:NO forKey:PREF_SB_SORT_FILENAME];
    }
}

#endif

@end
