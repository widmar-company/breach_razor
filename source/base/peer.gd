extends Node

# Basic settings here 
const DEFAULT_PORT = 7000
var address = "localhost"
enum TYPES {CLIENT, SERVER}
var type

var clients = []

# Signals
signal begin_new_player(id)
signal begin_new_world()
signal bootstrap_done(id)

signal spawn_actor(a)
signal spawn_projectile(p)

signal delete_player(id)

# Begin the mulitplayer.
func start_multiplayer(t: int):
	type = t
	if t == TYPES.CLIENT:
		bootstrap_client()
	if t == TYPES.SERVER:
		bootstrap_server()
	#Add ourself to the list of ids

func bootstrap_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(_client_recieved_new_client)
	#peer.peer_disconnected.connect(_client_disconnected)
	bootstrap_finish()

	print("Client running...")

func bootstrap_server():
	# First create our server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, 16)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(_server_recieved_new_client)
	#peer.peer_disconnected.connect(_client_disconnected)
	bootstrap_finish()

	print("Server running...")
	
	begin_new_world.emit()

func bootstrap_finish():
	clients.append(multiplayer.get_unique_id())
	bootstrap_done.emit(multiplayer.get_unique_id())
	

#
# ANY CLIENT TO ANY CLIENT FUNCTIONS ARE HERE
#

func _client_recieved_new_client(id):
	print("We are client [", multiplayer.get_unique_id(), "], and we just got a new client with id: ", id)
	clients.push_back(id)
	

func _client_disconnected(id):
	clients.find(id)
	delete_player.emit(id)

func client_disconnect():
	multiplayer.multiplayer_peer = null
	

#
# SERVER TO CLIENT FUNCTIONS ARE HERE
#

# As a client, recieve verts for terrain construction
@rpc("authority", "call_remote") 
func client_recieves_world(t):
	print("We are a client and we just recieved terrain")
	Data.terrain_verts = t
	begin_new_world.emit() 

# As a client, recieve a new player and spawn them in.
@rpc("authority", "call_local")
func client_recieves_player(id):
	if id != multiplayer.get_unique_id():
		begin_new_player.emit(id)
	print("We are telling the world to spawn player: ", id)

@rpc("authority", "call_local")
func client_recieves_projectile(proj):
	spawn_projectile.emit(proj)
	
	

#
# CLIENT TO SERVER ENET SIGNALS ARE HERE
#
func _server_recieved_new_client(id):
	print("We are a server and we just got a client, we are giving them terrain")
	client_recieves_world.rpc_id(id, Data.terrain_verts)
	clients.append(id)
	print(clients)
	for c in clients:
		print("We are telling client [", c, "] to spawn in client [", id, "].")
		client_recieves_player.rpc_id(c, id)
		if c != id and c != 1:
			print("We are telling client ", id, " to spawn client ", c)
			client_recieves_player.rpc_id(id, c)


# CLIENT TO SERVER RPC FUNCTIONS ARE HERE

@rpc("any_peer", "call_local")
func server_recieved_projectile(proj):
	for c in clients:
		client_recieves_projectile.rpc_id(c, proj)
