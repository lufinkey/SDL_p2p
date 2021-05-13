
#pragma once

#import <GameKit/GameKit.h>
#import "SDL_p2p.h"

@interface SDL_p2p_gamekitdelegate : NSObject <GKSessionDelegate, GKPeerPickerControllerDelegate>
{
	@private
	P2P_Session* p2pSession;
	NSString* sessionID;
	GKSession *gkSession;
	GKSessionMode sessionMode;
	GKPeerPickerController *peerPicker;
	NSMutableArray *peers;
	BOOL p2pconnected;
}

- (id)initWithSession:(P2P_Session*)session;

- (void)setSessionID:(NSString*)sessID;
- (NSString*)sessionID;

- (NSString*)displayName;
- (NSString*)displayNameForPeer:(NSString*)peerID;

- (NSString*)peerID;

- (void)connectToPeers;
- (void)connectToClients;
- (void)connectToServer;
- (void)disconnectFromPeers;
- (void)disconnectPeer:(NSString*)peerID;

- (BOOL)acceptConnectionFromPeer:(NSString*)peerID error:(NSError**)error;
- (void)denyConnectionFromPeer:(NSString*)peerID;

- (void)dismissPicker;

- (void)sendData:(NSData*)data withDataMode:(GKSendDataMode)mode error:(NSError**)error;
- (void)sendData:(NSData*)data toPeers:(NSMutableArray*)peerIDs withDataMode:(GKSendDataMode)mode error:(NSError**)error;
- (BOOL)isConnected;
- (BOOL)isConnectedToPeer:(NSString*)peerID;

@end
