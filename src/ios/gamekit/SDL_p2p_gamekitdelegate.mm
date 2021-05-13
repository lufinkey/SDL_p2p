
#import "SDL_p2p_gamekitdelegate.h"
#import "SDL_p2p_gamekit.h"

@implementation SDL_p2p_gamekitdelegate

- (id)initWithSession:(P2P_Session*)session
{
	self = [self init];
    if (self == nil)
	{
        return nil;
    }
	
	p2pSession = session;
	
	peers = [[NSMutableArray alloc] init];
	
	sessionID = [[NSString alloc] initWithUTF8String:"com.yourcompany.SDL_p2p"];
	sessionMode = GKSessionModePeer;
	p2pconnected = NO;
	
	return self;
}

- (void)setSessionID:(NSString *)sessID
{
	sessionID = sessID;
}

- (NSString*)sessionID
{
	return sessionID;
}

- (NSString*)displayName
{
	return [gkSession displayName];
}

- (NSString*)displayNameForPeer:(NSString*)peerID
{
	return [gkSession displayNameForPeer:peerID];
}

- (NSString*)peerID
{
	return [gkSession peerID];
}

- (void)connectToPeers
{
	if(peerPicker==nil)
	{
		sessionMode = GKSessionModePeer;
		peerPicker = [[GKPeerPickerController alloc] init];
		peerPicker.delegate = self;
		peerPicker.connectionTypesMask = (GKPeerPickerConnectionType)(GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline);
		[peerPicker show];
	}
}

- (void)connectToClients
{
	if(peerPicker==nil && gkSession==nil)
	{
		sessionMode = GKSessionModeServer;
		peerPicker = [[GKPeerPickerController alloc] init];
		peerPicker.delegate = self;
		peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
		[peerPicker show];
	}
}

- (void)connectToServer
{
	if(peerPicker==nil && gkSession==nil)
	{
		sessionMode = GKSessionModeClient;
		peerPicker = [[GKPeerPickerController alloc] init];
		peerPicker.delegate = self;
		peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
		[peerPicker show];
	}
}

- (void)disconnectFromPeers
{
	if(p2pconnected)
	{
		[gkSession disconnectFromAllPeers];
		p2pconnected = NO;
		gkSession = nil;
	}
}

- (void)disconnectPeer:(NSString*)peerID
{
	if(p2pconnected)
	{
		[gkSession disconnectPeerFromAllPeers:peerID];
		if([[gkSession peersWithConnectionState:GKPeerStateConnected] count]==0
		   && [[gkSession peersWithConnectionState:GKPeerStateConnecting] count]==0)
		{
			p2pconnected = NO;
			[gkSession disconnectFromAllPeers];
			gkSession = nil;
		}
	}
}

- (BOOL)acceptConnectionFromPeer:(NSString*)peerID error:(NSError**)error
{
	return [gkSession acceptConnectionFromPeer:peerID error:error];
}

- (void)denyConnectionFromPeer:(NSString*)peerID
{
	[gkSession denyConnectionFromPeer:peerID];
}

- (void)dismissPicker
{
	if(peerPicker!=nil)
	{
		[peerPicker dismiss];
		peerPicker = nil;
	}
}

- (BOOL)isConnected
{
	return p2pconnected;
}

- (BOOL)isConnectedToPeer:(NSString*)peerID
{
	unsigned int i = 0;
	for(i=0; i<[peers count]; i++)
	{
		NSString*cmp = [peers objectAtIndex:i];
		if([cmp isEqualToString:peerID]==YES)
		{
			return YES;
		}
	}
	return NO;
}

- (void)sendData:(NSData*)data withDataMode:(GKSendDataMode)mode error:(NSError**)error
{
	[gkSession sendData:data toPeers:peers withDataMode:mode error:error];
}

- (void)sendData:(NSData*)data toPeers:(NSMutableArray*)peerIDs withDataMode:(GKSendDataMode)mode error:(NSError**)error
{
	[gkSession sendData:data toPeers:peerIDs withDataMode:mode error:error];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
	GKSession* session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:sessionMode];
	gkSession = session;
	session.delegate = self;
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    gkSession = session;
    session.delegate = self;
	
	[self dismissPicker];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void*)context
{
	void*dataRecieved = (void*)[data bytes];
	unsigned int length = [data length];
	
	NSString* peerDisplayName = [session displayNameForPeer:peer];
	
	P2P_Event event;
	event.type = P2P_RECIEVEDDATA;
	event.peer.peerID = (char*)[peer UTF8String];
	event.peer.peerDisplayName = (char*)[peerDisplayName UTF8String];
	event.data.data = dataRecieved;
	event.data.size = length;
	if(p2pSession->event_callback!=NULL)
	{
		p2pSession->event_callback(&event);
	}
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	p2pconnected = NO;
	
	P2P_Event event;
	event.type = P2P_PICKERDIDCANCEL;
	event.peer.peerID = "";
	event.peer.peerDisplayName = "";
	event.data.data = NULL;
	event.data.size = 0;
	if(p2pSession->event_callback!=NULL)
	{
		p2pSession->event_callback(&event);
	}
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSString* peerDisplayName = [session displayNameForPeer:peerID];
	
	P2P_Event event;
	event.type = P2P_PEERREQUESTEDCONNECTION;
	event.peer.peerID = (char*)[peerID UTF8String];
	event.peer.peerDisplayName = (char*)[peerDisplayName UTF8String];
	event.data.data = NULL;
	event.data.size = 0;
	if(p2pSession->event_callback!=NULL)
	{
		p2pSession->event_callback(&event);
	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	if(state == GKPeerStateConnected)
	{
		[peers addObject:peerID];
		
		NSString*peerDisplayName = [session displayNameForPeer:peerID];
		
		[session setDataReceiveHandler:self withContext:nil];
		p2pconnected = YES;
		
		P2P_Event event;
		event.type = P2P_PEERCONNECTED;
		event.peer.peerID = (char*)[peerID UTF8String];
		event.peer.peerDisplayName = (char*)[peerDisplayName UTF8String];
		event.data.data = NULL;
		event.data.size = 0;
		if(p2pSession->event_callback!=NULL)
		{
			p2pSession->event_callback(&event);
		}
	}
	else if(state == GKPeerStateDisconnected)
	{
		unsigned int i = 0;
		NSString*peerDisplayName = [session displayNameForPeer:peerID];
		for(i=0; i<[peers count]; i++)
		{
			NSString*cmp = [peers objectAtIndex:i];
			if([peerID isEqualToString:cmp]==YES)
			{
				[peers removeObjectAtIndex:i];
				i=[peers count];
			}
		}
		
		if([peers count] == 0)
		{
			p2pconnected = NO;
			[gkSession disconnectFromAllPeers];
			gkSession = nil;
		}
		
		P2P_Event event;
		event.type = P2P_PEERDISCONNECTED;
		event.peer.peerID = (char*)[peerID UTF8String];
		event.peer.peerDisplayName = (char*)[peerDisplayName UTF8String];
		event.data.data = NULL;
		event.data.size = 0;
		if(p2pSession->event_callback!=NULL)
		{
			p2pSession->event_callback(&event);
		}
	}
}

@end
