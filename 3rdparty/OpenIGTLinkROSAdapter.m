classdef OpenIGTLinkROSAdapter < handle
    properties
        igtlConnection % client for receiving igtl messages
        rosPublisher % for publishing ros messages
        rosSubscriber % for receiving ros messages
        topicName % the tool being tracked by this adapter
    end
    methods
        
        function obj = OpenIGTLinkROSAdapter(igtl_server_ip, igtl_port, ros_master_uri, topic_name)
            obj.topicName = topic_name;
            obj.igtlConnection = igtlConnect(igtl_server_ip, igtl_port);
            rosinit(ros_master_uri);
            obj.rosPublisher = rospublisher(obj.topicName, 'geometry_msgs/TransformStamped');
            obj.rosSubscriber= [];
            return;
        end
        
        function delete(obj) % destructor
            rosshutdown;
            if ~isempty(obj.igtlConnection)
                igtlDisconnect(obj.igtlConnection)
            end
            clear obj.rosPublisher;
            clear obj.rosSubscriber;
        end
        
        function igtlTransform = getIGTLTransform(this)
            igtlTransform = igtlReceiveTransform(this.igtlConnection);
        end
        
        function [header, child] = parseHeader(this, igtlTF)
            %TODO
            % igtlTF.name is in the form of Tool1ToRef, Tool2ToRef, ...
            % defined in the XML files;
            % need to establish Tool1 = what frame ID is the left arm, 
            % what frame ID is the right arm, etc
            name = igtlTF.name;
            header = 'name'; % replace with actual name of origin in ros
            child = 'Tool1';

        end
        
        function sendROSMsg(this)
            try
                igtlTF = this.getIGTLTransform();
                if ~isempty(igtlTF.matrix)
                    % parse
                    [header, child] = this.parseHeader(igtlTF);
                    tfStampedMSG = rosmessage(this.rosPublisher);
                    tfStampedMSG.transform.translation = igtlTF.matrix(1:3,4);
                    tfStampedMSG.transform.rotation = rotm2quat(igtlTF.matrix(1:3,1:3));
                    tfStampedMSG.child_frame_id = child;
                    tfStampedMSG.header.frame_id = header;
                    send(this.rosPublisher, tfStampedMSG);
                else
                    msgID = 'OPenIGTLinkROSAdapter::sendROSMsg:';
                    msg = ['No Transform received from ', igtlTF.name];
                    noTransform = MException(msgID, msg);
                    throw(noTransform);
                end
            catch ME
                warning(ME.msgtext);
            end
        end
    end
end
