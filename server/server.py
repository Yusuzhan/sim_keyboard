import keyboard as kb
import time
import socket

# kb.press_and_release('w')

# packet size
SERVER_INPUT_PACKET_SIZE = 16

def server():
    # get the hostname
    host = socket.gethostname()
    host = '0.0.0.0'
    print(host)
    port = 5000

    server_socket = socket.socket()
    # look closely. The bind() function takes tupe as argument
    server_socket.bind((host, port))

    # configure how many client the server can listen simutaneosly
    server_socket.listen(10)

    conn, address = server_socket.accept() # accept new conneciton
    print("Connection from: " + str(address))

    while True:
        # receive data stream. it won't accept data packet greater than 1024 bytes
        key = conn.recv(SERVER_INPUT_PACKET_SIZE).decode()
        if key == 'quit':
            break
        print('pressing ' + key)
        # key stroke
        try:
            kb.press_and_release(key)
        except Exception as e:
            print(e)
            print('ERR pressing ' + key)
        data = 'test message'
        conn.send(data.encode()) # send data to the client
    print('closing server')
    conn.close()

server()
