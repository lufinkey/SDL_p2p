
#pragma once

#ifndef _SDL_P2P_gamekit_GAMEKIT_H
#define _SDL_P2P_gamekit_GAMEKIT_H

#include "SDL_p2p.h"

#ifdef __OBJC__
#import "SDL_p2p_gamekitdelegate.h"

struct P2P_Session
{
	SDL_p2p_gamekitdelegate* gk_delegate;
	P2P_EventHandler event_callback;
};
#endif

extern P2P_Session* P2P_gamekit_createSession();
extern void P2P_gamekit_destroySession(P2P_Session*session);

extern void P2P_gamekit_searchForPeers(P2P_Session*session, const char*sessionID);
extern void P2P_gamekit_searchForClients(P2P_Session*session, const char*sessionID);
extern void P2P_gamekit_searchForServer(P2P_Session*session, const char*sessionID);

extern void P2P_gamekit_setEventHandler(P2P_Session*session, P2P_EventHandler callback);

extern SDL_bool P2P_gamekit_isConnected(P2P_Session*session);
extern SDL_bool P2P_gamekit_isConnectedToPeer(P2P_Session*session, const char*peerID);

extern SDL_bool P2P_gamekit_acceptConnectionRequest(P2P_Session*session, const char*peerID);
extern void P2P_gamekit_denyConnectionRequest(P2P_Session*session, const char*peerID);

extern void P2P_gamekit_getSelfDisplayName(P2P_Session*session, char*dispName);
extern void P2P_gamekit_getPeerDisplayName(P2P_Session*session, const char*peerID, char*dispName);
extern void P2P_gamekit_getSelfID(P2P_Session*session, char*selfID);
extern void P2P_gamekit_getSessionID(P2P_Session*session, char*sessionID);

extern void P2P_gamekit_sendData(P2P_Session*session, void*data, unsigned int size, P2P_SendDataMode mode);
extern void P2P_gamekit_sendDataToPeers(P2P_Session*session, char**peers, unsigned int numPeers, void*data, unsigned int size, P2P_SendDataMode mode);

extern void P2P_gamekit_disconnectPeer(P2P_Session*session, const char*peerID);
extern void P2P_gamekit_endSession(P2P_Session*session);

#endif //_SDL_P2P_gamekit_GAMEKIT_H
