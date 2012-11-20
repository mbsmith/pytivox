//
//  SB.h
//  pyTivoX
//
//  Created by Yoav Yerushalmi on 4/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MasterProc.h"
#import "PrefConstants.h"

#define STREAMBABYINI     "streambaby.ini"
#define STREAMBABYUSERINI "streambaby-user.ini"
#define STREAMBABYLOG     "streambaby.log"

@interface SB : MasterProc {

}

-(NSString *) getMyIP;

@end
