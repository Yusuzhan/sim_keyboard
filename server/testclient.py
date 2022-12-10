import socket

def client():
    host = '127.0.0.1' 
    port = 5000

    client_socket = socket.socket()
    client_socket.connect((host, port))

    message = input(' -> ') # take input

    while message.lower().strip() != 'bye':
        client_socket.send(message.encode())
        data = client_socket.recv(8).decode()

        print('Received from server: ' + data) # show in terminal

        message = input(" -> ") # again take the input

    client_socket.close()

client()