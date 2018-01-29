%% Read XTF ping channel header, reference: page 27 XTF_Format_X35
% source: ECA Robotics

function xtfpingchan_header = XTFPINGCHANHEADER(fileID)

%% Read variables
xtfpingchan_header.ChannelNumber = fread(fileID,1,'uint16');
xtfpingchan_header.DownsampleMethod = fread(fileID,1,'uint16');
xtfpingchan_header.SlantRange = fread(fileID,1,'float');
xtfpingchan_header.GroundRange = fread(fileID,1,'float');
xtfpingchan_header.TimeDelay = fread(fileID,1,'float');
xtfpingchan_header.TimeDuration = fread(fileID,1,'float');
xtfpingchan_header.SecondsPerPing = fread(fileID,1,'float');
xtfpingchan_header.ProcessingFlags = fread(fileID,1,'uint16');
xtfpingchan_header.Frequency = fread(fileID,1,'uint16');
xtfpingchan_header.InitialGainCode = fread(fileID,1,'uint16');
xtfpingchan_header.GainCode = fread(fileID,1,'uint16');
xtfpingchan_header.BandWidth = fread(fileID,1,'uint16');
xtfpingchan_header.ContactNumber = fread(fileID,1,'uint32');
xtfpingchan_header.ContactClassification = fread(fileID,1,'uint16');
xtfpingchan_header.ContactSubNumber = fread(fileID,1,'*char');
xtfpingchan_header.ContactType = fread(fileID,1,'*char');
xtfpingchan_header.NumSamples = fread(fileID,1,'uint32');
xtfpingchan_header.MillivoltScale = fread(fileID,1,'uint16');
xtfpingchan_header.ContactTimeOffTrack = fread(fileID,1,'float');
xtfpingchan_header.ContactCloseNumber = fread(fileID,1,'*char');
xtfpingchan_header.Reserved2 = fread(fileID,1,'*char');
xtfpingchan_header.FixedVSOP = fread(fileID,1,'float');
xtfpingchan_header.Weight = fread(fileID,1,'uint16');
xtfpingchan_header.ReservedSpace = fread(fileID,4);

end
