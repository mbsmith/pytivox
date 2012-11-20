//
//  IPMenulet.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/10/08.
//  Copyright 2008 home. All rights reserved.
//

#import "TivoMenulet.h"


@implementation TivoMenulet

-(void)dealloc
{
	[statusItem release];
	[menuIcon release];
	[super dealloc];
}

- (void)awakeFromNib
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"tivo_icon" ofType:@"png"];
	menuIcon= [[NSImage alloc] initWithContentsOfFile:path];
	
	
	statusItem = [[[NSStatusBar systemStatusBar] 
								 statusItemWithLength:NSSquareStatusItemLength]
								retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString stringWithString:@""]]; 
  
	[statusItem setImage:menuIcon];
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"TivoMenulet"];
	
	[statusItem setMenu:theMenu];
}

@end
