%
%Read SDFX header, reference: page 49 sdf 15300018 REV 5.0
%
% ECA Robotics
%

function sdfx_recordheader = SDFX_RECORD_HEADER( fileID )
sdfx_recordheader.recordID=fread(fileID,1,'uint32');
sdfx_recordheader.recordNumBytes=fread(fileID,1,'uint32');
sdfx_recordheader.headerVersion=fread(fileID,1,'uint32');
sdfx_recordheader.recordVersion=fread(fileID,1,'uint32');
sdfx_recordheader.reserved=fread(fileID,12,'uint32');
end

