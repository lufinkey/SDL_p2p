
#include "SDL_p2p.h"

#import "SDL_syswm.h"

UIViewController*SDL_P2P_getViewController(SDL_Window*window)
{
	SDL_SysWMinfo systemWindowInfo;
    SDL_VERSION(&systemWindowInfo.version);
    if (!SDL_GetWindowWMInfo(window, &systemWindowInfo))
	{
        // consider doing some kind of error handling here
        return nil;
    }
    UIWindow*appWindow = systemWindowInfo.info.uikit.window;
    UIViewController*rootViewController = appWindow.rootViewController;
    return rootViewController;
}

void SDL_P2P_setEventHandler(SDL_P2P_EventHandler callback)
{
	//
}

void SDL_P2P_searchForPeersBluetooth(SDL_Window*parent, const char*sessionID)
{
	//
}

SDL_bool SDL_P2P_isConnected(SDL_Window*parent)
{
	return false;
}

SDL_bool SDL_P2P_isConnectedToPeer(SDL_Window*parent, const char*peerID)
{
	return false;
}

SDL_bool SDL_P2P_acceptConnectionRequest(SDL_Window*parent, const char*peerID)
{
	return false;
}

void SDL_P2P_denyConnectionRequest(SDL_Window*parent, const char*peerID)
{
	//
}

void SDL_P2P_getPeerDisplayName(SDL_Window*parent, const char*peerID, char*dispName)
{
	//
}

void SDL_P2P_getSelfDisplayName(SDL_Window*parent, char*dispName)
{
	//
}

void SDL_P2P_getSelfID(SDL_Window*parent, char*selfID)
{
	//
}

void SDL_P2P_getSessionID(SDL_Window*parent, char*sessionID)
{
	//
}

void SDL_P2P_sendData(SDL_Window*parent, void*data, unsigned int size, SDL_P2P_SendDataMode mode)
{
	//
}

void SDL_P2P_sendDataToPeers(SDL_Window*parent, char**peers, unsigned int numPeers, void*data, unsigned int size, SDL_P2P_SendDataMode mode)
{
	//
}

void SDL_P2P_disconnectPeer(SDL_Window*parent, const char*peerID)
{
	//
}

void SDL_P2P_endSession(SDL_Window*parent)
{
	//
}




