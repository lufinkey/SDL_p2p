
#include "SDL_p2p.h"

#if defined(__APPLE__)
	#include <TargetConditionals.h>
	#if defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR)
		#define P2P_PLATFORM_IOS
		#include "ios/gamekit/SDL_p2p_gamekit.h"
	#endif
#endif

P2P_Session* P2P_createSession()
{
#ifdef P2P_PLATFORM_IOS
	return P2P_gamekit_createSession();
#endif
}

void P2P_destroySession(P2P_Session* session)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_destroySession(session);
#endif
}

void P2P_searchForPeers(P2P_Session*session, const char*sessionID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_searchForPeers(session, sessionID);
#endif
}

void P2P_searchForClients(P2P_Session*session, const char*sessionID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_searchForClients(session, sessionID);
#endif
}

void P2P_searchForServer(P2P_Session*session, const char*sessionID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_searchForServer(session, sessionID);
#endif
}

void P2P_setEventHandler(P2P_Session*session, P2P_EventHandler callback)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_setEventHandler(session, callback);
#endif
}

SDL_bool P2P_isConnected(P2P_Session*session)
{
#ifdef P2P_PLATFORM_IOS
	return P2P_gamekit_isConnected(session);
#else
	return SDL_FALSE;
#endif
}

SDL_bool P2P_isConnectedToPeer(P2P_Session*session, const char*peerID)
{
#ifdef P2P_PLATFORM_IOS
	return P2P_gamekit_isConnectedToPeer(session, peerID);
#else
	return SDL_FALSE;
#endif
}

SDL_bool P2P_acceptConnectionRequest(P2P_Session*session, const char*peerID)
{
#ifdef P2P_PLATFORM_IOS
	return P2P_gamekit_acceptConnectionRequest(session, peerID);
#else
	return SDL_FALSE;
#endif
}

void P2P_denyConnectionRequest(P2P_Session*session, const char*peerID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_denyConnectionRequest(session, peerID);
#endif
}

void P2P_getPeerDisplayName(P2P_Session*session, const char*peerID, char*dispName)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_getPeerDisplayName(session, peerID, dispName);
#endif
}

void P2P_getSelfDisplayName(P2P_Session*session, char*dispName)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_getSelfDisplayName(session, dispName);
#endif
}

void P2P_getSelfID(P2P_Session*session, char*selfID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_getSelfID(session, selfID);
#endif
}

void P2P_getSessionID(P2P_Session*session, char*sessionID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_getSessionID(session, sessionID);
#endif
}

void P2P_sendData(P2P_Session*session, void*data, unsigned int size, P2P_SendDataMode mode)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_sendData(session, data, size, mode);
#endif
}

void P2P_sendDataToPeers(P2P_Session*session, char**peers, unsigned int numPeers, void*data, unsigned int size, P2P_SendDataMode mode)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_sendDataToPeers(session, peers, numPeers, data, size, mode);
#endif
}

void P2P_disconnectPeer(P2P_Session*session, const char*peerID)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_disconnectPeer(session, peerID);
#endif
}

void P2P_endSession(P2P_Session*session)
{
#ifdef P2P_PLATFORM_IOS
	P2P_gamekit_endSession(session);
#endif
}




