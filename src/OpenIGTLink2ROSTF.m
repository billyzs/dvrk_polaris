%% Parsing transformation received from OpenIGTLink as ROS transformation messages

igtlConnection = igtlConnect('127.0.0.1',18944);
startTime = -1;
receiveStartTime=tic();

while true
    transform = igtlReceiveTransform(igtlConnection);
    if ~isempty(transform.matrix)
         % Compute relative timestamp (from the start of the script)
        if startTime<0
            startTime=transform.timestamp;
            relativeTime=0;
        else
            relativeTime=transform.timestamp-startTime;
        end     
        % parse
        
    end
        
end
    