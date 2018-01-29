function isis_gyro = ISIS_GYRO(fileID)

% source: ECA Robotics

% isis_gyro.MagicNumber = fread(fileID,1,'uint16');		% Set to 0xFACE
% isis_gyro.HeaderType = fread(fileID,1);			% XTF_HEADER_SOURCETIME_GYRO
isis_gyro.Reserved = fread(fileID,7);           % Must be here!
isis_gyro.NumBytesThisRecord = fread(fileID,1,'uint32');    % Total byte count = 64
isis_gyro.Year = fread(fileID,1,'uint16');                  % Source time year
isis_gyro.Month = fread(fileID,1);				% Source time month
isis_gyro.Day = fread(fileID,1);				% Source time Day
isis_gyro.Hour = fread(fileID,1);				% Source time hour
isis_gyro.Minutes = fread(fileID,1);			% Source time minute
isis_gyro.Seconds = fread(fileID,1);			% Source time second
isis_gyro.MicroSeconds = fread(fileID,1,'uint32');		%(0 - 999999)
isis_gyro.SourceEpoch = fread(fileID,1,'uint32');		% Source Epoch Seconds since 1/1/1970
isis_gyro.TimeTag = fread(fileID,1,'uint32');			% System time reference in milliseconds
isis_gyro.Gyro = fread(fileID,1,'float');				% Raw heading
isis_gyro.TimeFlag = fread(fileID,1);		% time stamp validity: 
                                            %0 = only receive time valid
                                            %1 = only source time valid
                                            %3 = both valid
isis_gyro.Reserved1 = fread(fileID,26);		% Unused, set to 0.

end