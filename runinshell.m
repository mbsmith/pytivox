//
//  runinshell.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/13/08.
//  Copyright 2008 home. All rights reserved.
//

#import "runinshell.h"


@implementation runinshell

-(id) init {
	return [super init];
}

+(NSString *)runWithCommand:(NSString *)cmd {
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setLaunchPath: @"/bin/bash"];

	NSArray *arguments;
	arguments = @[@"-c", cmd];
	[task setArguments: arguments];

	NSPipe *pipe;
	pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];

	NSFileHandle *file;
	file = [pipe fileHandleForReading];

	[task launch];

	NSData *data;
	data = [file readDataToEndOfFile];

	return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}
@end
