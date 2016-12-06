inbound = igtlConnect('127.0.0.1',18944);
server = tcpip('0.0.0.0', 55000, 'NetworkRole', 'Server');
transform = igtlReceiveTransform(inbound);
s = whos('transform');
set(server, 'OutputBufferSize', s.bytes);
fopen(server);
while 1
    transform = igtlReceiveTransform(inbound);
    fwrite(server, transform);
end
