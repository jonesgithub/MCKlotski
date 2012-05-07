//
//  MCGateViewController.h
//  MCKlotski
//
//  Created by gtts on 5/4/12.
//  Copyright (c) 2012 TJUT-SCCE-SIPC. All rights reserved.
//

#import "MCViewController.h"
#import "MCGameSceneMenuView.h"
#import "MCResetAlertView.h"
#import "MCGameSceneView.h"

@class MCAlertPassLevelView;

typedef enum BlockViewMoveFlag{
    
    kBlockViewMoveInvalid = 0,
    kBlockViewMoveNormal, // 正常移动
    kBlockViewMoveUndo, // 返回
}kBlockViewMoveFlag;


@interface MCGateViewController : MCViewController<
  GameSceneMenuDelegate,
  MCAlertDelegate,
  GameSceneViewDelegate
> {
  @protected
    kBlockViewMoveFlag _moveFlag;
  
  @private
    int _theGateID;
    MCGameSceneView *_gameSceneView;
    MCGameSceneMenuView *_gmaeSceneMenuView;
    NSArray *_steps;
    
    MCAlertView *_currentAlertView;
    // 点击重置按钮之后弹出的dialog
    MCResetAlertView *_resetAlertView;
    // 过关之后的Dialog
    MCAlertPassLevelView *_passLevelAlertView;
    
    // 移动总数
    int _moveCount;
    
}

@property (nonatomic, assign) int theGateID;
@property (nonatomic, retain) MCGameSceneView *gameSceneView;
@property (nonatomic, retain) MCGameSceneMenuView *gameSceneMenuView;
@property (nonatomic, retain) NSArray *steps;
@property (nonatomic, retain) MCAlertView *currentAlertView;
@property (nonatomic, assign) int moveCount;

- (id)initWithGateID:(int)gateID;

// 刷新按钮，设置按钮是否可点击
- (void)refreshButtons;

- (void)resumeGame;
- (void)refreshSubViews;

@end
