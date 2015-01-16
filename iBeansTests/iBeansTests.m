//
//  iBeansTests.m
//  iBeansTests
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Container.h"
#import  "Player.h"
#import "Game.h"
#import "GameViewController.h"

@interface iBeansTests : XCTestCase

@end

@implementation iBeansTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testContainer {
    Bowl *bowl=[[Bowl alloc] initWithPosition:3];
    Tray  *tray=[[Tray alloc] initWithPosition:7];
    
    XCTAssertNotNil(bowl, "container succesfully initialized");
    XCTAssertEqual([bowl position], 3, "position correctly initialized");
    XCTAssertEqual([bowl numOfSeeds], 3, "seeds initialized to 3");
    XCTAssertNotEqual([tray numOfSeeds], 3, "tray seeds initialized not to 3");
    XCTAssertEqual([tray numOfSeeds], 0, "tray seeds initialized to 0");
    
    [bowl addSeeds:5];
    XCTAssertEqual([bowl numOfSeeds], 8, "seeds correctly added");
    
    [bowl increment];
    [tray increment];
    XCTAssertEqual([bowl numOfSeeds], 9, "seeds incremented correctly");
    XCTAssertEqual([tray numOfSeeds], 1, "seeds incremented correctly");
    
    [bowl empty];
    XCTAssertFalse([bowl numOfSeeds], "bowl emptied correctly");
}


- (void) testPlayer {
    Player *player=[[Player alloc] initWithPlayerNumber:0];
    
    //check initialization
    XCTAssertNotNil(player, "player initialized");
    XCTAssertNotNil(player.containers[6],"containers correctly initialize within player");
    XCTAssert([player.containers[6] isKindOfClass:([Tray class])], "tray correctly added to player's containers");
    XCTAssert([player.containers[5] isKindOfClass:([Bowl class])], "bowls added to player's containers");
    XCTAssert([player.containers[0] isKindOfClass:([Bowl class])], "bowls added to player's containers");
    
    //check getTrayCount function
    XCTAssertEqual([player getTrayCount], 0, "tray is empty");
    
    
    //check opponent
    XCTAssertNil([player opponent], "opponent not instanciated yet");
    Player *player2=[[Player alloc] initWithPlayerNumber:1];
    player.opponent=player2;
    XCTAssertNotNil([player opponent], "opponent instanciated correctly");
    
    
    NSArray *initialContainer= [NSArray alloc];
    initialContainer=player.containers;
    NSArray *initialContainer2= [NSArray alloc];
    initialContainer2=player2.containers;
    
    
    //check move function
    int last=[player move:6];
    XCTAssert(last==-1, "returned exception, move not executed");
    XCTAssert(player2.containers==initialContainer2, "move not executed confirmed");
    
    last=[player move:5];
    XCTAssert(last==8, "move executed correctly");
    XCTAssert([player.containers[5] numOfSeeds]==0, "move executed correctly");
    XCTAssert([player getTrayCount]==1, "move executed correctly");
    XCTAssert([player2.containers[1] numOfSeeds]==4, "move executed correctly");
    
    //check capture seeds
    [player captureSeeds:last];
    XCTAssert([player2.containers[1] numOfSeeds]==4, "capture seeds not performed on opponents bowl");
    
    //verify move exceptions
    last=[player move:6];
    XCTAssert(last==-1, "returned exception, move not executed, Class of type Tray");
    XCTAssert([player getTrayCount]==1, "returned exception, move not executed, Class of type Tray");
    
    last=[player move:2];
    [player captureSeeds:last];
    XCTAssert([player2.containers[0] numOfSeeds]==0, "capture seeds performed correctly");
    XCTAssert([player getTrayCount]==6, "capture seeds performed correctly");
    
    //check player controller
    int flag=[player playerController:4];
    XCTAssert(flag, "if true, then change round, should be true");
    flag=[player playerController:5];
    XCTAssertFalse(flag, "if false, don t change round, should be false");
    
}

- (void) testPlayer2 {
    Human *player=[[Human alloc] initWithPlayerNumber:0];
    Computer *player2=[[Computer alloc] initWithPlayerNumber:1];
    player.opponent=player2;
    
    //check human controller
    int flag=[player humanController:5];
    XCTAssert(flag, "if true, then change round, should be true");
    
    //Show state
    printf("\nplayer1\n");
    [player printPlayerState];
    printf("\nplayer2\n");
    [player2 printPlayerState];
    
    flag=[player humanController:4];
    XCTAssertFalse(flag, "if false, don t change round, should be false");
    
    
    //Check bowl function
    XCTAssertFalse([player checkBowl], "bowls are non empty");
    
    //Show state
    printf("\nplayer1\n");
    [player printPlayerState];
    printf("\nplayer2\n");
    [player2 printPlayerState];
    
    [player2 setAiLevel:0.5];
    [player2 aiController];
    
    //Simulate end game
    int collect=0;
    for (int i=0; i<6; i++)
    {
        collect= collect+[player.containers[i] empty];
    };
    [player.containers[6] addSeeds:collect];
    
    //Show state
    printf("\nplayer1\n");
    [player printPlayerState];
    printf("\nplayer2\n");
    [player2 printPlayerState];
    
    
    //Check bowl function
    XCTAssert([player checkBowl], "bowls are empty. Game is over");
    XCTAssert([player getTrayCount]==17, "seeds collected in total should be 17");
    //call final move
    [player computeEndMove];
    XCTAssert([player2 checkBowl], "bowls of player 2 should be empty");
    XCTAssert([player2 getTrayCount]==19, "seeds in tray of player 2 should be equal to 19");
    
    
    //Show state
    printf("\nplayer1\n");
    [player printPlayerState];
    printf("\nplayer2\n");
    [player2 printPlayerState];
    

}

- (void) testGame {
    Game *game=[[Game alloc] initGameWithMode:1];
    XCTAssert([game.players[0] isKindOfClass:([Human class])], "one human players");
    XCTAssert([game.players[1] isKindOfClass:([Computer class])], "computer player");
    
    game=[game initGameWithMode:2];
    XCTAssert([game.players[0] isKindOfClass:([Computer class])], "computer player is fine");
    XCTAssert([game.players[1] isKindOfClass:([Computer class])], "computer player");
    
    game=[game initGameWithMode:0];
    XCTAssert([game.players[0] isKindOfClass:([Human class])], "one human players");
    XCTAssert([game.players[1] isKindOfClass:([Human class])], "other human player");
    
    XCTAssertNil([game winner], "winner not set");
    
    [game setRound:1];
    [game changeRound:true];
    XCTAssert([game round]==0, "round correctly changed");
    
    [game setRound:5];
    [game changeRound:true];
    XCTAssert([game round]==0, "round exception correctly handled");
    
    
    //simulate game controller and full game
    int flag;
    
    int sequence[11]= {4,1,11,8,2,10,5,10,4,8,6};
    
    for (int i=0; i<11; i++) {
        flag=[game.players[game.round] humanController: sequence[i]%7];
        if (flag!=-1){
            [game gameController:(flag)];
        };
    };
    XCTAssertNotNil([game winner], "Winner detected! Game correctly simulated! Functions correctly called! Testing terminated");
    
    int  state[14]={1,1,2,3,4,5,6,7,6,5,4,3,2,1};
    int arSize=sizeof(state)/sizeof(int);
    
    flag=[game setGameSituation:state andSize:arSize];
    XCTAssert(flag, "operation correctly executed");
    
    
    int state2[5]={0,0,0,0,0};
    arSize=sizeof(state2)/sizeof(int);
    flag=[game setGameSituation:state2 andSize:arSize];
    XCTAssertFalse(flag, "operation correctly rejected");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testGameViewController {
    GameViewController * game=[[GameViewController alloc] init];
    [game saveStatsWinner:@"io" withLoser:@"tu" andScore:@"24" andDate:[NSDate new]];
    
}

@end
