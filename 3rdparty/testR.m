client = tcpip('130.215.206.154', 55000, 'NetworkRole', 'Client');
set(client,'InputBufferSize',10240);
set(client,'Timeout',30);
fopen(client);
rawData = fread(client,100,'double');
rawD
ata
