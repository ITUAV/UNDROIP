function isis_navigation = ISIS_NAVIGATION(fileID)

% source: ECA Robotics

% isis_navigation.MagicNumber = fread(fileID,1,'uint16'); % Set to 0xFACE
% isis_navigation.HeaderType = fread(fileID,1);   % XTF_HEADER_SOURCETIME_NAVIGATION
isis_navigation.Reserved = fread(fileID,7);		% Must be here!
isis_navigation.NumBytesThisRecord = fread(fileID,1,'uint32'); % Total byte count = 64
isis_navigation.Year = fread(fileID,1,'uint16');	% Source time year
isis_navigation.Month = fread(fileID,1);            % Source time month
isis_navigation.Day = fread(fileID,1);				% Source time Day
isis_navigation.Hour = fread(fileID,1);				% Source time hour
isis_navigation.Minutes = fread(fileID,1);			% Source time minute
isis_navigation.Seconds = fread(fileID,1);			% Source time second
isis_navigation.MicroSeconds = fread(fileID,1,'uint32');	%(0 - 999999)
isis_navigation.SourceEpoch = fread(fileID,1,'uint32');		% Source Epoch Seconds since 1/1/1970
isis_navigation.TimeTag = fread(fileID,1,'uint32');			% System time reference in milliseconds
isis_navigation.RawYCoordinate = fread(fileID,1,'double');	% Raw position from POSMV or other time stamped nav source.
isis_navigation.RawXCoordinate = fread(fileID,1, 'double');	% Raw position from POSMV or other time stamped nav source.
isis_navigation.RawAltitude = fread(fileID,1, 'double');	% Altitude, can hold real-time kinemetics altitude.
isis_navigation.TimeFlag = fread(fileID,1);			% time stamp validity: 
                                                    %0 = only receive time valid
                                                    %1 = only source time valid
                                                    %3 = both valid
isis_navigation.Reserved1 = fread(fileID,6);

end