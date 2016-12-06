%% assume ROS is already connected
igtlConnection = igtlConnect('127.0.0.1',18944);

% Test options
numberOfTransformsToReceive=400;
displayReceivedTransforms=1;

% Initialize variables for statistics computation and data display
startTime=-1;
receiveStartTime=tic();

% ROS
adnan_pc = 'http://130.215.206.207:11311';
this_pc = '130.215.218.187';
setenv('ROS_MASTER_URI', adnan_pc);
setenv('ROS_IP', this_pc);
rosinit
rosPublisher = rospublisher('polaris', 'geometry_msgs/TransformStamped'); 
pause(2);


while true  

    % Get a transform
    transform = igtlReceiveTransform(igtlConnection);
    rosTime = rostime('now');
    % Display the received transform
    if ~isempty(transform.matrix)
        % Compute relative timestamp (from the start of the script)
        if startTime<0
            startTime=transform.timestamp;
            relativeTime=0;
        else
            relativeTime=transform.timestamp-startTime;
        end        
        % Print name, transform, matrix
        % send tf as ros message
        % rosPublisher = rospublisher('polaris', 'geometry_msgs/TransformStamped');
        
        tfStampedMSG = rosmessage(rosPublisher);
       
        % tfStampedMSG.Transform.Translation = rosmessage('geometry_msgs/Vector3');
        tfStampedMSG.Transform.Translation.X = transform.matrix(1,4);
        tfStampedMSG.Transform.Translation.Y = transform.matrix(2,4);
        tfStampedMSG.Transform.Translation.Z = transform.matrix(3,4);
        
        r = rotm2quat(transform.matrix(1:3,1:3));
        tfStampedMSG.Transform.Rotation.X = r(1);
        tfStampedMSG.Transform.Rotation.Y = r(2);
        tfStampedMSG.Transform.Rotation.Z = r(3);
        tfStampedMSG.Transform.Rotation.W = r(4);
        
        tfStampedMSG.ChildFrameId = '/Tool0'; % what should this be? 
        % No one is really sure, Adnan suggested looking at other ROS
        % packages
        tfStampedMSG.Header = rosmessage('std_msgs/Header');
        tfStampedMSG.Header.FrameId = '/Ref'; % what should this be?
        tfStampedMSG.Header.Stamp = rosTime;
        rosPublisher.send(tfStampedMSG);
        if displayReceivedTransforms
          disp(['------------ ',transform.name,' (',num2str(relativeTime),') ------------']);
          disp(transform.matrix);
        end
    else
        % No transforms are received, probably timeout
        disp('No transforms are available');
    end    
end

% Display some statistics
elapsedTime=toc(receiveStartTime);
disp(['Received ',num2str(numberOfTransformsToReceive),' transforms in ',num2str(elapsedTime),' sec: ',num2str(numberOfTransformsToReceive/elapsedTime),' transforms/sec']);
disp(['Timestamp span: ',num2str(relativeTime)]);

% Disconnect from the OpenIGTLink server
igtlDisconnect(igtlConnection);
