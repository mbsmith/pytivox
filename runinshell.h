//
//  runinshell.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 12/13/08.
//  Copyright 2008 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface runinshell : NSTask {
}
-(id)init;
+(NSString *)runWithCommand:(NSString *)cmd;
@end
