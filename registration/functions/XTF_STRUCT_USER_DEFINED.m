function xtf_struct_userdefined = XTF_STRUCT_USER_DEFINED(fileID)

% source: ECA Robotics

xtf_struct_userdefined.SubChannelNumber = fread(fileID,1);             % Unused
xtf_struct_userdefined.NumChansToFollow = fread(fileID,1,'uint16');     % Unused
xtf_struct_userdefined.Reserved = fread(fileID,2,'uint16');             % Unused
xtf_struct_userdefined.NumBytesThisRecord = fread(fileID,1,'uint32');  % Total byte count for this update (256)

% Date and time of the data
xtf_struct_userdefined.Year = fread(fileID,1,'uint16');
xtf_struct_userdefined.Month = fread(fileID,1);
xtf_struct_userdefined.Day = fread(fileID,1);
xtf_struct_userdefined.Hour = fread(fileID,1);
xtf_struct_userdefined.Minute = fread(fileID,1);
xtf_struct_userdefined.Second = fread(fileID,1);
xtf_struct_userdefined.ReservedBytes = fread(fileID,39);   % Unused


% Skip
% struct_UserDefined = xtf_struct_userdefined;
NbBytesOfStruct = 61;
skip = xtf_struct_userdefined.NumBytesThisRecord-NbBytesOfStruct-2-1;   % sizeof(MagicNumber) = 2
                                                                        % sizeof(HeaderType) = 1

% User datakind
if (skip>0)
    xtf_struct_userdefined.DataKind = fread(fileID,1,'int',skip);  % enum _XTF_USER_DEFINED_DATA_KIND
else
    xtf_struct_userdefined.DataKind = fread(fileID,1,'int');
end
end