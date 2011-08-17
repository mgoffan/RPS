//
//  GameData.h
//  RPS
//
//  Created by Martin Goffan on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef RPS_GameData_h
#define RPS_GameData_h

typedef enum {
    kGameStatusNotPlaying,
    kGameStatusPlaying,
    kGameStatusPaused,
} kGameStatus;

typedef enum {
    kIsFirstTime,
    kIsNotFirstTime,
} kFirstTime;

#define kMaxPoints0 0
#define kMaxPoints1 1
#define kMaxPoints3 3
#define kMaxPoints5 5

#endif