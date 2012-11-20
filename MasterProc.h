//
//  MasterProc.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MasterProc : NSObject {
	NSString *type;
	NSArray *typesArray;
	NSTask *task;
	NSUserDefaults *_defaults;
}

-(void) prekill;
-(void) kill;
-(void) writeConfigFile:(NSMutableArray *)data;
-(void) start;

@end
