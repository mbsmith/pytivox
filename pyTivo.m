//
//  pyTivo.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "pyTivo.h"
#import "runinshell.h"
#import "PrefConstants.h"
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#import <sys/param.h>
#import <sys/sysctl.h>


@implementation pyTivo

-(id) init {
	type = @"pyTivo";
	return [super init];
}

-(void) prekill {
	[runinshell runWithCommand:@"kill -9 `ps -Aww -o pid,command | grep Python | grep pyTivoX | cut -d ' ' -f 1`"];
	[super prekill];
}

-(void) writeConfigFile:(NSMutableArray *)data {
	FILE *outfile;
	NSString *datadir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX"];
	NSString *configFile = [datadir stringByAppendingPathComponent:@"pyTivo.conf"];
	NSString *ipbeacon = [self getBroadcast];
	NSString *tivo_username = [_defaults stringForKey:PREF_USERNAME];
	NSString *tivo_password = [_defaults stringForKey:PREF_PASSWORD];
	NSLog(@"Writing Config File %@\n",configFile);
	mkdir([datadir UTF8String], S_IRWXU|S_IRGRP|S_IROTH);
	
	if ((outfile = fopen([configFile UTF8String], "w")) == NULL) {
		NSLog(@"Failed to write out necessary config file");
		return;
	}
	
	NSBundle *myBundle = [NSBundle mainBundle];
	if (myBundle == nil) {
		NSLog(@"Failed to find application bundle");
		return;
	}
	
	NSString *myffmpeg = [myBundle pathForResource:@"ffmpeg" ofType:@"bin"];
	fprintf(outfile, "# Created by pyTivoX, edits here WILL BE OVERWRITTEN\n\n");
	fprintf(outfile, "[Admin]\ntype=admin\n\n");
	fprintf(outfile, "[Server]\n");
	fprintf(outfile, "debug=True\n");
	if ([tivo_username length] > 0) {
		fprintf(outfile, "tivo_username=%s\ntivo_password=%s\n", [tivo_username UTF8String], [tivo_password UTF8String]);
	}
	fprintf(outfile, "ffmpeg=%s\n", [myffmpeg UTF8String]);
	fprintf(outfile, "beacon=%s\n", [ipbeacon UTF8String]);
	
	NSEnumerator *e = [data objectEnumerator];
	id memberObject;
	
	while ((memberObject = [e nextObject])) {
		NSString *loctype = [typesArray objectAtIndex:[[memberObject objectForKey:@"Type"] intValue]];
		if ([loctype isEqual:@"video:stream"])
			continue;
		if ([loctype isEqual:@"video:pytivo"])
			loctype = @"video";
		fprintf(outfile, "[%s]\n", [[memberObject objectForKey:@"Name"] UTF8String]);
		fprintf(outfile, "type=%s\n", [loctype UTF8String] );
		fprintf(outfile, "path=%s\n", [[memberObject objectForKey:@"Location"] UTF8String]);
		fprintf(outfile, "force_alpha=%s\n", [_defaults boolForKey:PREF_PYTIVO_SORT_ALPHA] ? "true" : "false");
		printf("testing\n");
		fprintf(outfile, "\n");
	}
	fclose(outfile);
}

-(void) start {
	NSLog(@"Starting %@\n", type);
	if ([_defaults boolForKey:PREF_PYTIVO_BUTTON] == NO) {
		return;
	}
	task = [[NSTask alloc] init];
	NSBundle *myBundle = [NSBundle mainBundle];
	if (myBundle == nil) {
		NSLog(@"Failed to find application bundle");
		return;
	}

	NSString *datadir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX"];
	NSString *logdir =  [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Logs/pyTivoX"];

	NSString *configFile = [datadir stringByAppendingPathComponent:@"pyTivo.conf"];
	NSString *logFile = [logdir stringByAppendingPathComponent:@"pytivo.log"];

	mkdir([logdir UTF8String], S_IRWXU|S_IRGRP|S_IROTH);

	[task setLaunchPath:@"/usr/bin/python"];
	[task setArguments:[NSArray arrayWithObjects:[myBundle pathForResource:@"pyTivo" ofType:@"py" inDirectory:@"pyTivo-wmcbrine"],
											@"-c", configFile,
											nil]];
	[[NSFileManager defaultManager] createFileAtPath:logFile contents: @"" attributes: nil];
	NSFileHandle *myoutput = [NSFileHandle fileHandleForWritingAtPath:logFile];
	[task setStandardOutput:myoutput];
	[task setStandardError:myoutput];
	
	NSDictionary *old_env = [[NSProcessInfo processInfo] environment];
	NSMutableDictionary *new_env = [NSMutableDictionary dictionaryWithCapacity:5];
	[new_env addEntriesFromDictionary:old_env];
	[new_env setObject:[[myBundle resourcePath] stringByAppendingString:@"/PIL"] forKey:@"PYTHONPATH"];
	[new_env setObject:[myBundle resourcePath] forKey:@"DYLD_FALLBACK_LIBRARY_PATH"];
	[task setEnvironment:new_env];
	
	[task launch];
}

-(NSString *) getBroadcast {
	NSString *baddr = [runinshell runWithCommand:@"ifconfig `route get default | sed -n -e 's/.*interface: \\(.*\\)/\\1/p'` | sed -n -e 's/.*broadcast \\(.*\\)/\\1/p' | head -1"];
	return [baddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
