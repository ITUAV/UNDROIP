function [eca_data] = read_xtf_sonar_eca(fileName, PingType, padding)

% 
% eca_data.padding = padding;
% eca_data.PingType = PingType;
% eca_data.file_name =fileName;


% PingType = 'EdgeTech';

%  Example:
eca_data.padding = 16;
eca_data.PingType = 'Klein';
%  eca_data.file_name = '20150706_081412_081412_L005.xtf';
% eca_data.file_name = '20150706_080707_081050_L003.xtf';
 eca_data.file_name = fileName;

% read file 
Ping = readXTFFiles(eca_data.file_name, eca_data.PingType, eca_data.padding); % all data are in Ping

%% sonar image
eca_data.nb_ping=length(Ping);
temp1=Ping(1).chan1Sample;
temp2=Ping(1).chan2Sample;
eca_data.nb_sample=length(temp1)+length(temp2);
eca_data.WF=zeros(eca_data.nb_ping, eca_data.nb_sample, 'single');

% storing the chanel signal into eca_data.WF, and erasing it from Ping
% variable
for iping=1: eca_data.nb_ping    
    temp1=Ping(iping).chan1Sample;     
    temp2=Ping(iping).chan2Sample;    
    eca_data.WF(iping,:)=[temp1' temp2'];    
    Ping(iping).chan1Sample=[];
    Ping(iping).chan2Sample=[];
end

eca_data.ping = Ping; % contins all info except the sonar signal, which is stored in eca_data.WF

%% geographical positions
eca_data.posXY=zeros(eca_data.nb_ping,3);

for iping=1: eca_data.nb_ping    
    temp1=Ping(iping).xtfping_header.ShipXcoordinate;
    temp2=Ping(iping).xtfping_header.ShipYcoordinate;
    temp3=Ping(iping).xtfping_header.ShipGyro;    
    eca_data.posXY(iping,:)=[temp1 temp2 temp3];  
    
end

res_val = 0.05;  % dear isabelle, please give the correct resolution value
x = [-Ping(1).xtfpingchan_header1.NumSamples*res_val  Ping(1).xtfpingchan_header2.NumSamples*res_val];
y = [0  eca_data.nb_ping];
colormap(copper)
% mm = log(double( max(max(eca_data.WF))));
% imagesc(x,y, uint8(round( 255*log(double(eca_data.WF))/mm)));


function Ping = readXTFFiles(fileName, PingType, padding)



fileID = fopen(fileName);

%% XTF File header.
%  Total of 1024 bytes.

FileFormat                      = fread(fileID,1);
SystemType                      = fread(fileID,1);
RecordingProgramName            = fread(fileID,[1 8],'*char');
RecordingProgramVersion         = fread(fileID,[1 8],'*char');
SonarName                       = fread(fileID,[1 16],'*char');
SonarType                       = fread(fileID,1,'uint16');  
NoteString                      = fread(fileID,[1 64],'*char');
ThisFileName                    = fread(fileID,[1 64],'*char');
NavUnits                        = fread(fileID,1,'uint16');
NumberOfSonarChannels           = fread(fileID,1,'uint16');
NumberOfBathymetryChannels      = fread(fileID,1,'uint16');
NumberOfForwardLookArrays       = fread(fileID,1,'uint16');
NumberOfEchoStrengthChannels    = fread(fileID,1,'uint16');
NumberOfInterferometriyChannels = fread(fileID,1,'*char');
Reserved1                       = fread(fileID,1,'*char');
Reserved2                       = fread(fileID,1,'uint16');
ReferencePointHeight            = fread(fileID,1,'float');

%% Navigation System Parameters
SystemSerialNumber      = fread(fileID,1,'uint16');
ProjectionType          = fread(fileID,[10]);
SpheriodType            = fread(fileID,[10]);
NavigationLatency       = fread(fileID,1,'long');
OriginX                 = fread(fileID,1,'float'); % inversion OriginY et OriginX
OriginY                 = fread(fileID,1,'float');
NavOffsetY              = fread(fileID,1,'float');
NavOffsetX              = fread(fileID,1,'float');
NavOffsetZ              = fread(fileID,1,'float');
NavOffsetYaw            = fread(fileID,1,'float');
MRUOffsetY              = fread(fileID,1,'float');
MRUOffsetX              = fread(fileID,1,'float');
MRUOffsetZ              = fread(fileID,1,'float');
MRUOffsetYaw            = fread(fileID,1,'float');
MRUOffsetPitch          = fread(fileID,1,'float');
MRUOffsetRoll           = fread(fileID,1,'float');

%% Channel information CHANINFO

for iChannel=1:6
    ChanInfo(iChannel).TypeOfChannel        = fread(fileID,1);
    ChanInfo(iChannel).SubChannelNumber     = fread(fileID,1);
    ChanInfo(iChannel).CorrectionFlags      = fread(fileID,1,'uint16');
    ChanInfo(iChannel).UniPolar             = fread(fileID,1,'uint16');
    ChanInfo(iChannel).BytesPerSample       = fread(fileID,1,'uint16');
    ChanInfo(iChannel).Reserved             = fread(fileID,1,'uint32');
    ChanInfo(iChannel).ChannelName          = fread(fileID,[1 16],'*char');
    ChanInfo(iChannel).VoltScale            = fread(fileID,1,'float');
    ChanInfo(iChannel).Frequency            = fread(fileID,1,'float');
    ChanInfo(iChannel).HorizBeamAngle       = fread(fileID,1,'float');
    ChanInfo(iChannel).TiltAngle            = fread(fileID,1,'float');
    ChanInfo(iChannel).BeamWidth            = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetX              = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetY              = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetZ              = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetYaw            = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetPitch          = fread(fileID,1,'float');
    ChanInfo(iChannel).OffsetRoll           = fread(fileID,1,'float');
    ChanInfo(iChannel).BeamsPerArray        = fread(fileID,1,'uint16');
    ChanInfo(iChannel).Latency              = fread(fileID,1,'float');
    ChanInfo(iChannel).ReservedArea2        = fread(fileID,[1 50],'*char');
end

%% Ping Klein (or EdgeTech4600)
iPing = 0;
while (1)
% for iPing = 1:nbPing
    iPing=iPing+1;
    
    Ping(iPing).MagicNumber = fread(fileID,1,'uint16');
    if (feof(fileID))
        break
    end
    if (Ping(iPing).MagicNumber ~= 64206)
        display(['Wrong Magic Number at Ping ' num2str(iPing)])
    end
    
    Ping(iPing).HeaderType = fread(fileID,1);
    
    switch Ping(iPing).HeaderType
        case 0
            %% Read XTF Ping Header
            Ping(iPing).xtfping_header = XTFPINGHEADER(fileID);
            if (Ping(iPing).xtfping_header.NumChansToFollow>0)
                %% Read XTF Ping Channel Header
                Ping(iPing).xtfpingchan_header1 = XTFPINGCHANHEADER(fileID);
                if strcmp(PingType,'Klein')
                    Ping(iPing).chan1Sample = fread(fileID,[Ping(iPing).xtfpingchan_header1.NumSamples 1],'float');
                elseif strcmp(PingType,'EdgeTech')
                    Ping(iPing).chan1Sample = fread(fileID,[Ping(iPing).xtfpingchan_header1.NumSamples 1],'uint16');
                end
            end
            if (Ping(iPing).xtfping_header.NumChansToFollow>1)
                
                Ping(iPing).xtfpingchan_header2 = XTFPINGCHANHEADER(fileID);
                if strcmp(PingType,'Klein')
                    Ping(iPing).chan2Sample = fread(fileID,[Ping(iPing).xtfpingchan_header2.NumSamples 1],'float');
                elseif strcmp(PingType,'EdgeTech')
                    Ping(iPing).chan2Sample = fread(fileID,[Ping(iPing).xtfpingchan_header1.NumSamples 1],'uint16');
                end
            end
            if (Ping(iPing).xtfping_header.NumChansToFollow>2)
            
                Ping(iPing).xtfpingchan_header3 = XTFPINGCHANHEADER(fileID);
                Ping(iPing).chan3Sample = fread(fileID,[Ping(iPing).xtfpingchan_header3.NumSamples 1],'float');
            end
            if (Ping(iPing).xtfping_header.NumChansToFollow>3)
            
                Ping(iPing).xtfpingchan_header4 = XTFPINGCHANHEADER(fileID);
                Ping(iPing).chan4Sample = fread(fileID,[Ping(iPing).xtfpingchan_header4.NumSamples 1],'float');
            end
            
            if strcmp(PingType,'Klein')
                skip=fread(fileID,padding);  % padding pas elegant KLEIN
            end
            % Caution: no padding pas elegant for EDGETECH
        case 3
            %% Read XTF Attitude data packet
            Ping(iPing).attitudedata = XTFATTITUDEDATA(fileID);
        case 42
            Ping(iPing).isis_navigation = ISIS_NAVIGATION(fileID);
            
        case 73
            %% Read XTF EdgeTech data packet
            Ping(iPing).xtfping_header = XTFPINGHEADER(fileID);
            Ping(iPing).xtfping_ET4600 = XTFPINGBATHY_ET4600(fileID);
            
        case 84
            Ping(iPing).isis_gyro = ISIS_GYRO(fileID);
            
        case 200 
            %% XTF_HEADER_USERDEFINED
            Ping(iPing).xtf_struct_userdefined = XTF_STRUCT_USER_DEFINED(fileID);

        otherwise
            display('Not recognized HeaderType')
    end
    
end
nbPing = size(Ping,2)-1;
Ping = Ping(1:nbPing);
fclose(fileID);


function isis_gyro = ISIS_GYRO(fileID)

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


function isis_navigation = ISIS_NAVIGATION(fileID)

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


function xtf_struct_userdefined = XTF_STRUCT_USER_DEFINED(fileID)

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


%% Read attitude data packet, reference: page 17 XTF_Format_X35

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

%% Read XTF ping channel header, reference: page 27 XTF_Format_X35

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


%% Read XTF ping header, reference: page 25 XTF_Format_X35

function xtfping_header = XTFPINGHEADER(fileID)

%% Read variables

xtfping_header.SubChannelNumber = fread(fileID,1);
xtfping_header.NumChansToFollow = fread(fileID,1,'uint16');
xtfping_header.Reserved1 = fread(fileID,2,'uint16');
xtfping_header.NumBytesThisRecord = fread(fileID,1,'uint32');
xtfping_header.Year = fread(fileID,1,'uint16');
xtfping_header.Month= fread(fileID,1);
xtfping_header.Day= fread(fileID,1);
xtfping_header.Hour= fread(fileID,1);
xtfping_header.Minute= fread(fileID,1);
xtfping_header.Second= fread(fileID,1);
xtfping_header.HSeconds= fread(fileID,1);
xtfping_header.JulianDay = fread(fileID,1,'uint16');
xtfping_header.EventNumber = fread(fileID,1,'long');
xtfping_header.PingNumber = fread(fileID,1,'uint32');
xtfping_header.SoundVelocity = fread(fileID,1,'float');
xtfping_header.OceanTide = fread(fileID,1,'float');
xtfping_header.Reserved2 = fread(fileID,1,'uint32');
xtfping_header.ConductivityFreq = fread(fileID,1,'float');
xtfping_header.TemperatureFreq = fread(fileID,1,'float');
xtfping_header.PressureFreq = fread(fileID,1,'float');
xtfping_header.PressureTemp = fread(fileID,1,'float');
xtfping_header.Conductivity = fread(fileID,1,'float');
xtfping_header.WaterTemperature = fread(fileID,1,'float');
xtfping_header.Pressure = fread(fileID,1,'float');
xtfping_header.ComputedSoundVelocity = fread(fileID,1,'float');
xtfping_header.MagX = fread(fileID,1,'float');
xtfping_header.MagY = fread(fileID,1,'float');
xtfping_header.MagZ = fread(fileID,1,'float');
xtfping_header.AuxVal1 = fread(fileID,1,'float');
xtfping_header.AuxVal2 = fread(fileID,1,'float');
xtfping_header.AuxVal3 = fread(fileID,1,'float');
xtfping_header.AuxVal4 = fread(fileID,1,'float');
xtfping_header.AuxVal5 = fread(fileID,1,'float');
xtfping_header.AuxVal6 = fread(fileID,1,'float');
xtfping_header.SpeedLog = fread(fileID,1,'float');
xtfping_header.Turbidity = fread(fileID,1,'float');
xtfping_header.ShipSpeed = fread(fileID,1,'float');
xtfping_header.ShipGyro = fread(fileID,1,'float');
xtfping_header.ShipYcoordinate = fread(fileID,1,'double');
xtfping_header.ShipXcoordinate = fread(fileID,1,'double');
xtfping_header.ShipAltitude = fread(fileID,1,'uint16');
xtfping_header.ShipDepth = fread(fileID,1,'uint16');
xtfping_header.FixTimeHour= fread(fileID,1);
xtfping_header.FixTimeMinute= fread(fileID,1);
xtfping_header.FixTimeSecond= fread(fileID,1);
xtfping_header.FixTimeHsecond= fread(fileID,1);
xtfping_header.SensorSpeed = fread(fileID,1,'float');
xtfping_header.KP = fread(fileID,1,'float');
xtfping_header.SensorYcoordinate = fread(fileID,1,'double');
xtfping_header.SensorXcoordinate = fread(fileID,1,'double');
xtfping_header.SonarStatus = fread(fileID,1,'uint16');
xtfping_header.RangeToFish = fread(fileID,1,'uint16');
xtfping_header.BearingToFish = fread(fileID,1,'uint16');
xtfping_header.CableOut = fread(fileID,1,'uint16');
xtfping_header.Layback = fread(fileID,1,'float');
xtfping_header.CableTension = fread(fileID,1,'float');
xtfping_header.SensorDepth = fread(fileID,1,'float');
xtfping_header.SensorPrimaryAltitude = fread(fileID,1,'float');
xtfping_header.SensorAuxAltitude = fread(fileID,1,'float');
xtfping_header.SensorPitch = fread(fileID,1,'float');
xtfping_header.SensorRoll = fread(fileID,1,'float');
xtfping_header.SensorHeading = fread(fileID,1,'float');
xtfping_header.Heave = fread(fileID,1,'float');
xtfping_header.Yaw = fread(fileID,1,'float');
xtfping_header.AttitudeTimeTag = fread(fileID,1,'uint32');
xtfping_header.DOT = fread(fileID,1,'float');
xtfping_header.NavFixMilliseconds = fread(fileID,1,'uint32');
xtfping_header.ComputerClockHour = fread(fileID,1,'*char');
xtfping_header.ComputerClockMinute = fread(fileID,1,'*char');
xtfping_header.ComputerClockSecond = fread(fileID,1,'*char');
xtfping_header.ComputerClockHsec = fread(fileID,1,'*char');
xtfping_header.FishPositionDeltaX = fread(fileID,1,'short');
xtfping_header.FishPositionDeltaY = fread(fileID,1,'short');
xtfping_header.FishPositionErrorCode = fread(fileID,1,'*char');
xtfping_header.OptionalOffset = fread(fileID,1,'uint');
xtfping_header.CableOutHundredths = fread(fileID,1,'*char');
xtfping_header.ReservedSpace2= fread(fileID,5);
xtfping_header.CheckSum= fread(fileID,1);



