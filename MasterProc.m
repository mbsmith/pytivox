//
//  MasterProc.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MasterProc.h"

@implementation MasterProc

-(id) init {
	_defaults = [NSUserDefaults standardUserDefaults];
	typesArray = @[@"video", @"music", @"photo", @"video:stream", @"video:pytivo"];
	return [super init];
}


-(void) prekill {}

-(void) kill {
	NSLog(@"Killing %@\n", type);
	if (task != nil) {
		@try{
			[task terminate];
		} @catch (id NSInvalidArgumentException) {
		}
		[task waitUntilExit];
		task = nil;
	}
}

-(void) writeConfigFile:(NSMutableArray *)data {
}

-(void) start {}
@end
