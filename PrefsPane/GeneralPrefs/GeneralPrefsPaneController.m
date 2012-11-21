//
//  GeneralPrefsPaneController.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "GeneralPrefsPaneController.h"
#import "pyTivoController.h"
#import "Startup.h"

@implementation GeneralPrefsPaneController

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
    return [self initWithNibName:@"GeneralPrefsView" bundle:[NSBundle mainBundle]];
}

- (NSString *)identifier
{
    return @"GeneralPrefsController";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the credentials preference pane");
}


@end
