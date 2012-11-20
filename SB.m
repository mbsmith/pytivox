//
//  SB.m
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "SB.h"
#import "runinshell.h"
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#import <sys/param.h>
#import <sys/sysctl.h>

@implementation SB

-(id) init {
	type = @"StreamBaby";
	return [super init];
}

-(void) prekill {
	[runinshell runWithCommand:@"kill -9 `ps -Aww -o pid,command | grep java | grep pyTivoX | cut -d ' ' -f 1`"];
	[super prekill];
}


-(void) writeConfigFile:(NSMutableArray *)data {
	FILE *outfile;
	NSString *datadir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX"];
	NSString *cachedir= [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/pyTivoX"];

	NSString *configFile = [datadir stringByAppendingPathComponent:@STREAMBABYINI];
	NSString *userConfigFile = [datadir stringByAppendingPathComponent:@STREAMBABYUSERINI];

	NSString *ipbeacon = [self getMyIP];
	NSLog(@"Writing Config File %@\n",configFile);
	mkdir([datadir UTF8String], S_IRWXU|S_IRGRP|S_IROTH);
	
	if ((outfile = fopen([configFile UTF8String], "w")) == NULL) {
		NSLog(@"Failed to open config file");
		return;
	}
	
	NSBundle *myBundle = [NSBundle mainBundle];
	if (myBundle == nil) {
		NSLog(@"Failed to find bundle");
		return;
	}
	
#define MAX_HOSTNAME 40
	
	int     core_count ;
  size_t  core_size=sizeof(core_count) ;
	char hostname[MAX_HOSTNAME+1];
	
	if (gethostname(hostname, MAX_HOSTNAME) == -1) {
		strcpy(hostname, "StreamBaby");
	}
	hostname[MAX_HOSTNAME]='\0';
  if (sysctlbyname("hw.ncpu",&core_count,&core_size,NULL,0)) core_count=1;
	if (core_count > 8) core_count=8;
	if (core_count < 1) core_count=1;
	
	fprintf(outfile, "# Created by pyTivoX, edits here WILL BE OVERWRITTEN\n");
	fprintf(outfile, "#  If you wish to make modifications, please put them in\n");
	fprintf(outfile, "#  %s\n\n", [userConfigFile UTF8String]);
	fprintf(outfile, "title=pyTivoX - %s\n", hostname);
	fprintf(outfile, "preview.cache=%s\n", [cachedir UTF8String]);
	fprintf(outfile, "autogenerate.delete=true\n");
	fprintf(outfile, "port=7290\n");
	fprintf(outfile, "ip=%s\n", [ipbeacon UTF8String]);
	fprintf(outfile, "ffmpeg.path=%s\n", [[myBundle pathForResource:@"ffmpeg" ofType:@"bin"] UTF8String]);
	fprintf(outfile, "ffmpegjava.avutil=%s\n", [[myBundle pathForResource:@"libavutil" ofType:@"dylib"] UTF8String]);
	fprintf(outfile, "ffmpegjava.avcodec=%s\n", [[myBundle pathForResource:@"libavcodec" ofType:@"dylib"] UTF8String]);
	fprintf(outfile, "ffmpegjava.avformat=%s\n", [[myBundle pathForResource:@"libavformat" ofType:@"dylib"] UTF8String]);
	fprintf(outfile, "ffmpegjava.swscale=%s\n", [[myBundle pathForResource:@"libswscale" ofType:@"dylib"] UTF8String]);
	fprintf(outfile, "\n");
	fprintf(outfile, "ffmpegexe.transcode=-acodec ac3 -vcodec mpeg2video -f vob -async 1 -r ${closest.mpeg.fps} -v 0 -threads %d\n", core_count);
	fprintf(outfile, "ffmpegexe.transcode.sameqargs=-sameq -ab 384k -ar ${asamplerate}\n\n");
	fprintf(outfile, "tivo.username=%s\n", [[_defaults stringForKey:PREF_USERNAME] UTF8String]);
	fprintf(outfile, "tivo.password=%s\n", [[_defaults stringForKey:PREF_PASSWORD] UTF8String]);
	fprintf(outfile, "quality.highestabr=384\n");
	fprintf(outfile, "quality.highres=1080\n");
	fprintf(outfile, "trimextensions=true\n");
	fprintf(outfile, "\n# GUI CONFIG \n");
	fprintf(outfile, "sort.filename=%s\n\n# Shares\n", [_defaults boolForKey:PREF_SB_SORT_FILENAME] ? "true" : "false");
	
	NSEnumerator *e = [data objectEnumerator];
	id memberObject;
	int count=1;
	while ((memberObject = [e nextObject])) {
		NSString *loctype = [typesArray objectAtIndex:[[memberObject objectForKey:@"Type"] intValue]];
		if ([loctype isEqual:@"video"] || [loctype isEqual:@"video:stream"]) {
			fprintf(outfile, "dir.%d=%s\n", count, [[memberObject objectForKey:@"Location"] UTF8String]);	
			fprintf(outfile, "dir.%d.name=%s\n", count, [[memberObject objectForKey:@"Name"] UTF8String]);
			count++;
		}
	}
	fclose(outfile);
}

-(void) start {
	NSLog(@"Starting %@\n", type);
	if ([_defaults boolForKey:PREF_SB_BUTTON] == NO) {
		return;
	}
	NSString *datadir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/pyTivoX"];
	NSString *logdir =  [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Logs/pyTivoX"];
	NSString *cachedir= [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/pyTivoX"];

	NSString *configFile = [datadir stringByAppendingPathComponent:@STREAMBABYINI];
	NSString *userConfigFile = [datadir stringByAppendingPathComponent:@STREAMBABYUSERINI];
	NSString *logFile = [logdir stringByAppendingPathComponent:@STREAMBABYLOG];
	
	task = [[NSTask alloc] init];
	NSBundle *myBundle = [NSBundle mainBundle];
	mkdir([cachedir UTF8String], S_IRWXU|S_IRGRP|S_IROTH);
	mkdir([logdir UTF8String], S_IRWXU|S_IRGRP|S_IROTH);
	[task setCurrentDirectoryPath:@"/tmp"];
	[task setLaunchPath:@"/usr/bin/java"];
	[task setArguments:[NSArray arrayWithObjects:@"-Xmx256m",
											@"-Djava.awt.headless=true",
											@"-d32",
											@"-jar",
												[myBundle pathForResource:@"streambaby" ofType:@"jar" inDirectory:@"streambaby/jbin/"],
											@"--config", configFile,
											@"--config", userConfigFile,
												nil]];
	[[NSFileManager defaultManager] createFileAtPath:logFile contents: @"" attributes: nil];
	NSFileHandle *myoutput = [NSFileHandle fileHandleForWritingAtPath:logFile];
	[task setStandardOutput:myoutput];
	[task setStandardError:myoutput];
	
	NSDictionary *old_env = [[NSProcessInfo processInfo] environment];
	NSMutableDictionary *new_env = [NSMutableDictionary dictionaryWithCapacity:50];
	[new_env addEntriesFromDictionary:old_env];
	[new_env setObject:[myBundle resourcePath] forKey:@"DYLD_FALLBACK_LIBRARY_PATH"];
	[task setEnvironment:new_env];
	
	[task launch];
}

-(NSString *) getMyIP {
	NSString *baddr = [runinshell runWithCommand:@"ifconfig `route get default | sed -n -e 's/.*interface: \\(.*\\)/\\1/p'` | sed -n -e 's/.*inet \\(.*\\) netmask .*/\\1/p' | head -1"];
	return [baddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
