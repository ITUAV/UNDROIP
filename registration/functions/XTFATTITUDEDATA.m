%% Read attitude data packet, reference: page 17 XTF_Format_X35
% source: ECA Robotics

function xtfattitude_data = XTFATTITUDEDATA(fileID)

% xtfattitude_data.MagicNumber = fread(fileID,1,'uint16');
% xtfattitude_data.HeaderType = fread(fileID,1);
xtfattitude_data.SubChannelNumber = fread(fileID,1);
xtfattitude_data.NumChansToFollow= fread(fileID,1,'uint16');
xtfattitude_data.Reserved1 = fread(fileID,2,'uint16');
xtfattitude_data.NumBytesThisRecord = fread(fileID,1,'uint32');
xtfattitude_data.Reserved2 = fread(fileID,2 ,'uint32');
xtfattitude_data.EpochMicroseconds = fread(fileID,1,'uint32');
xtfattitude_data.SourceEpoch = fread(fileID,1,'uint32');
xtfattitude_data.Pitch = fread(fileID,1,'float');
xtfattitude_data.Roll = fread(fileID,1,'float');
xtfattitude_data.Heave = fread(fileID,1,'float');
xtfattitude_data.Yaw = fread(fileID,1,'float');
xtfattitude_data.TimeTag = fread(fileID,1,'uint32');
xtfattitude_data.Heading = fread(fileID,1,'float');
xtfattitude_data.Year = fread(fileID,1,'uint16');
xtfattitude_data.Month = fread(fileID,1);
xtfattitude_data.Day = fread(fileID,1);
xtfattitude_data.Hour = fread(fileID,1);
xtfattitude_data.Minutes = fread(fileID,1);
xtfattitude_data.Seconds = fread(fileID,1);
xtfattitude_data.Miliseconds = fread(fileID,1,'uint16');
xtfattitude_data.xtfattitude_data.Reserved3 = fread(fileID,1);

end
