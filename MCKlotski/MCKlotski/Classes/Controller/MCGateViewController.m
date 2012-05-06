//
//  MCGateViewController.m
//  MCKlotski
//
//  Created by gtts on 5/4/12.
//  Copyright (c) 2012 TJUT-SCCE-SIPC. All rights reserved.
//

#import "MCGateViewController.h"
#import "MCConfig.h"
#import "GGFoundation.h"
#import "MCGate.h"
#import "MCBlock.h"
#import "MCBlockView.h"
#import "MCUtil.h"
#import "MCDataManager.h"


@interface MCGateViewController (Privates)

- (void)createSubViews;
- (void)removeSubViews;
- (void)createBlockViews;

- (void)clearBoxView;

- (void)showBlockViews;
- (void)showStar:(MCGate *)gate;

@end

@implementation MCGateViewController
@synthesize theGateID = _theGateID;
@synthesize blockViews = _blockViews;
@synthesize theGate = _theGate;
@synthesize starView = _starView;

#pragma mark - init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%@ : %@", NSStringFromSelector(_cmd), self);
    }
    return self;
}

- (id)initWithGateID:(int)gateID
{
    self = [super init];
    if (self) {
        NSLog(@"%@ : %@", NSStringFromSelector(_cmd), self);
        self.theGateID = gateID;
        _moveFlag = kBlockViewMoveNormal;
    }
    return self;
}

- (void)dealloc
{
    MCRelease(_blockViews);
    MCRelease(_theGate);
    MCRelease(_starView);
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createSubViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self removeSubViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - get & set
- (void)setBlockViews:(NSArray *)blockViews
{
    [_blockViews autorelease];
    _blockViews = [blockViews retain];
    [MCDataManager sharedMCDataManager].blockViews = _blockViews;
    [self showBlockViews];
}

- (void)setTheGate:(MCGate *)theGate
{
    [_theGate autorelease];
    _theGate = [theGate retain];
    [self showStar:_theGate];
    [self createBlockViews];
}

#pragma mark - Priate method

- (void)createSubViews
{
    //    self.gameSceneView = [[[MCGameSceneView alloc] initWithFrame:CGRectMake(0, 0, 320, 390)] autorelease];
    //    MCGate *gate =  [[MCGate alloc] init];
    //    gate.passMin = 1;
    //    gate.passMoveCount = 1;
    //    gate.layout = [NSArray arrayWithObjects:@"4",@"2",@"0",@"3",@"0",@"1",@"3",@"0",@"2",@"3",@"2",@"2",@"3",@"0",@"3",@"1",@"2",@"3",@"1",@"3",@"3",@"1",@"0",@"4",@"1",@"1",@"4",@"1",@"2",@"4",@"1",@"3",@"4", nil];
    //    self.gameSceneView.theGate = gate;
    //    [gate release];
    //    
    //    [self.view addSubview:self.gameSceneView];
    //    
    //    self.gameSceneMenuView = [[[MCGameSceneMenuView alloc] init] autorelease];
    //    [self.view addSubview:self.gameSceneMenuView];
    
    // 添加游戏场景背景
    UIImage *gateFrameImage = [UIImage imageNamed:@"gateFrame.png"];
    UIImageView *gateFrameBgView = 
    [[[UIImageView alloc] initWithFrame:
      CGRectMake(0, 0,  gateFrameImage.size.width, gateFrameImage.size.height)] autorelease];
    gateFrameBgView.backgroundColor = [UIColor clearColor];
    gateFrameBgView.image = gateFrameImage;
    [self.view addSubview:gateFrameBgView];
    
    _theBoxView = [[UIView alloc] initWithFrame:
                   CGRectMake((self.view.frame.size.width - kBoxWidth) / 2, 90, kBoxWidth, kBoxHeight)];
    _theBoxView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_theBoxView];
    
    UIButton *back = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"back1.png"];
    back.frame = CGRectMake(10, 450, backImage.size.width, backImage.size.height);
    [back setBackgroundImage:backImage forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [back release]; 
}

- (void)removeSubViews
{
}

- (void)backAction:(id)sender
{
    [super ButtonAction:sender];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearBoxView
{
    [MCUtil clearAllSubViewsWith:_theBoxView];
}

- (void)showBlockViews
{
    [self clearBoxView];
    for (MCBlockView *blockView in self.blockViews) {
        [_theBoxView addSubview:blockView];
    }
}

- (void)showStar:(MCGate *)gate
{
    [_starView removeFromSuperview];
    self.starView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 70, 51, 51)];
    if (_theGate.passMoveCount != 0) {
        if (_theGate.passMoveCount > _theGate.passMin || _theGate.passMoveCount == -1) {
            _starView.image = [UIImage imageNamed:@"star1.png"];
        }else {
            _starView.image = [UIImage imageNamed:@"star2.png"];
        }
    }else {
        // 还没有开始移动，即第一次移动
        _starView.image = [UIImage imageNamed:@"star3.png"];
    }
    [self.view addSubview:_starView];
}

- (void)createBlockViews
{
    int layoutCount = self.theGate.layout.count;
    if (0 == layoutCount || 0 != layoutCount % 3) {
        NSLog(@"Invaluable layout!");
        return;
    }
    
    NSMutableArray *tempBlockViews = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0 ; i < layoutCount; i += 3) {
        kBlockType blockType = [[self.theGate.layout objectAtIndex:i] intValue];
        int positionX = [[self.theGate.layout objectAtIndex:(i + 1)] intValue];
        int positionY = [[self.theGate.layout objectAtIndex:(i + 2)] intValue];
        MCBlock *block = [[MCBlock alloc] init];
        block.blockID = i / 3;
        block.blockType = blockType;
        block.positionX = positionX;
        block.positionY = positionY;
        MCBlockView *tempBlockView = [[MCBlockView alloc] initWithBlock:block];
        [tempBlockViews addObject:tempBlockView];
        [block release];
        [tempBlockView release];
    }
    self.blockViews = [NSArray arrayWithArray:tempBlockViews];
}


@end
