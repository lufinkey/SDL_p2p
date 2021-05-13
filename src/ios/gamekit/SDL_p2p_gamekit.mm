
#import "SDL_p2p_gamekit.h"

P2P_Session* P2P_gamekit_createSession()
{
	P2P_Session* p2pSession = (P2P_Session*)malloc(sizeof(P2P_Session));
	p2pSession->event_callback = NULL;
	p2pSession->gk_delegate = [[SDL_p2p_gamekitdelegate alloc] initWithSession:p2pSession];
	return p2pSession;
}

void P2P_gamekit_destroySession(P2P_Session*session)
{
	if([session->gk_delegate isConnected])
	{
		[session->gk_delegate disconnectFromPeers];
	}
	
	free(session);
}

void P2P_gamekit_searchForPeers(P2P_Session*session, const char*sessionID)
{
	NSString* sessionIDStr = [[NSString alloc] initWithUTF8String:sessionID];
	[session->gk_delegate setSessionID:sessionIDStr];
	[session->gk_delegate connectToPeers];
}

void P2P_gamekit_searchForClients(P2P_Session*session, const char*sessionID)
{
	NSString* sessionIDStr = [[NSString alloc] initWithUTF8String:sessionID];
	[session->gk_delegate setSessionID:sessionIDStr];
	[session->gk_delegate connectToClients];
}

void P2P_gamekit_searchForServer(P2P_Session*session, const char*sessionID)
{
	NSString* sessionIDStr = [[NSString alloc] initWithUTF8String:sessionID];
	[session->gk_delegate setSessionID:sessionIDStr];
	[session->gk_delegate connectToServer];
}

void P2P_gamekit_setEventHandler(P2P_Session*session, P2P_EventHandler callback)
{
	session->event_callback = callback;
}

SDL_bool P2P_gamekit_isConnected(P2P_Session*session)
{
	if([session->gk_delegate isConnected])
	{
		return SDL_TRUE;
	}
	return SDL_FALSE;
}

SDL_bool P2P_gamekit_isConnectedToPeer(P2P_Session*session, const char*peerID)
{
	NSString* peerIDStr = [[NSString alloc] initWithUTF8String:peerID];
	if([session->gk_delegate isConnectedToPeer:peerIDStr])
	{
		return SDL_TRUE;
	}
	return SDL_FALSE;
}

SDL_bool P2P_gamekit_acceptConnectionRequest(P2P_Session*session, const char*peerID)
{
	NSString* peerIDStr = [[NSString alloc] initWithUTF8String:peerID];
	//TODO add error handler in here
	if([session->gk_delegate acceptConnectionFromPeer:peerIDStr error:nil])
	{
		return SDL_TRUE;
	}
	return SDL_FALSE;
}

void P2P_gamekit_denyConnectionRequest(P2P_Session*session, const char*peerID)
{
	NSString* peerIDStr = [[NSString alloc] initWithUTF8String:peerID];
	[session->gk_delegate denyConnectionFromPeer:peerIDStr];
}

void P2P_gamekit_getSelfDisplayName(P2P_Session*session, char*dispName)
{
	strcpy(dispName, [[session->gk_delegate displayName] UTF8String]);
}

void P2P_gamekit_getPeerDisplayName(P2P_Session*session, const char*peerID, char*dispName)
{
	NSString* peerIDStr = [[NSString alloc] initWithUTF8String:peerID];
	strcpy(dispName, [[session->gk_delegate displayNameForPeer:peerIDStr] UTF8String]);
}

void P2P_gamekit_getSelfID(P2P_Session*session, char*selfID)
{
	strcpy(selfID, [[session->gk_delegate peerID] UTF8String]);
}

void P2P_gamekit_getSessionID(P2P_Session*session, char*sessionID)
{
	strcpy(sessionID, [[session->gk_delegate sessionID] UTF8String]);
}

void P2P_gamekit_sendData(P2P_Session*session, void*data, unsigned int size, P2P_SendDataMode mode)
{
	//TODO add error handling
	if(mode==P2P_SENDDATA_RELIABLE)
	{
		[session->gk_delegate sendData:[NSData dataWithBytes:data length:size] withDataMode:GKSendDataReliable error:nil];
	}
	else if(mode==P2P_SENDDATA_UNRELIABLE)
	{
		[session->gk_delegate sendData:[NSData dataWithBytes:data length:size] withDataMode:GKSendDataUnreliable error:nil];
	}
}

void P2P_gamekit_sendDataToPeers(P2P_Session*session, char**peers, unsigned int numPeers, void*data, unsigned int size, P2P_SendDataMode mode)
{
	//TODO add error handling
	NSMutableArray*peerArray = [[NSMutableArray alloc] init];
	for(unsigned int i=0; i<numPeers; i++)
	{
		[peerArray addObject:[NSString stringWithUTF8String:peers[i]]];
	}
	if(mode == P2P_SENDDATA_RELIABLE)
	{
		[session->gk_delegate sendData:[NSData dataWithBytes:data length:size] toPeers:peerArray withDataMode:GKSendDataReliable error:nil];
	}
	else if(mode == P2P_SENDDATA_UNRELIABLE)
	{
		[session->gk_delegate sendData:[NSData dataWithBytes:data length:size] toPeers:peerArray withDataMode:GKSendDataUnreliable error:nil];
	}
}

void P2P_gamekit_disconnectPeer(P2P_Session*session, const char*peerID)
{
	NSString* peerIDStr = [[NSString alloc] initWithUTF8String:peerID];
	[session->gk_delegate disconnectPeer:peerIDStr];
}

void P2P_gamekit_endSession(P2P_Session*session)
{
	[session->gk_delegate disconnectFromPeers];
}




