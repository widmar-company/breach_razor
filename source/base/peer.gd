extends Node

# Basic settings here 
const DEFAULT_PORT = 7000
var address = "localhost"
enum TYPES {CLIENT, SERVER}
var type

var clients = []

# Signals
signal spawn_new_player(id)

# Begin the mulitplayer.
func start_multiplayer(t: int):
	type = t
	if t == TYPES.CLIENT:
		bootstrap_client()
	if t == TYPES.SERVER:
		bootstrap_server()
	
func bootstrap_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(_client_recieved_new_client)
	
	print("Client running...")

func bootstrap_server():
	# First create our server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, 16)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(_server_recieved_new_client)
	
	print("Server running...")
	
	# Now set up the world
	Data.change_state(Data.STATES.WORLD)




# ANY CLIENT TO ANY CLIENT FUNCTIONS ARE HERE
func _client_recieved_new_client(id):
	print("We are a client and we just got a new client")



# SERVER TO CLIENT FUNCTIONS ARE HERE
@rpc("authority", "call_remote") 
func client_recieves_world(t):
	print("We are a client and we just recieved terrain")
	Data.terrain_verts = t
	Data.change_state(Data.STATES.WORLD)
	



# CLIENT TO SERVER ENET SIGNALS ARE HERE
func _server_recieved_new_client(id):
	print("We are a server and we just got a client, we are giving them terrain")
	client_recieves_world.rpc_id(id, Data.terrain_verts)
	clients.append(id)
