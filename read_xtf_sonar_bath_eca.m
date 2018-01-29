function [sss_data] = read_xtf_sonar_bath_eca(fname, dir_in, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  XTF Reader Interface - Read XTF file 
%
%
% Input-
% fname: Name of XTF file
% dir_in: path of the XTF file
% 
%
% Output-
% sss_data: A struct of Ping, including XTF Ping headers and data samples
% store_ping: set to true if you want keep the ping data after loading it
% to the image structure
% 
% 
%
% Author: ECA
% Modified by Mohammed Al-Rawi (University of Aveiro)
%
%
% License:
%=====================================================================
% This is part of the UNDROIP toolbox, released under
% the GPL. https://github.com/rawi707/UNDROIP/blob/master/LICENSE
% 
% The UNDROIP toolbox is available free and
% unsupported to those who might find it useful. We do not
% take any responsibility whatsoever for any problems that
% you have related to the use of the UNDROIP toolbox.
%
% ======================================================================
%%

defaults.store_ping= false; % toggle this to 1 if you want to store the whole ping data
defaults.use_double_format = true;
defaults.has_bathy_image = true;
defaults.flip_channel = true;  % we might need to add this later in the function
args = propval(varargin, defaults);

if args.use_double_format
    read_format= 'double';  % requires higher space than single
else
    read_format= 'single';  % using single might cause a few problems in some Matlab functions
end

PingType = 'Klein';
sss_data.PingType =  'Klein 3500 bathy processd data page version 3511(3.2.6 15300018 REV 5.0 SDF)';
ext = '.xtf';
fileName=[dir_in,'\',fname];

fprintf('Reading %s ...\n', fileName);
tic; % start counting time

% data reading
Ping=readXTFFiles(fileName,PingType); % all data are in Ping

if( args.has_bathy_image)
    % real number of pings, since the data contains side scan sonar data and bathemetry data
    step_iping = 2;
else    
    step_iping = 1;
end

nb_ping = length(Ping)/step_iping;

%% sonar image
temp1=Ping(1).chan1Sample;
temp2=Ping(1).chan2Sample;
sss_data.left = zeros(nb_ping,length(temp1), read_format );
sss_data.right =zeros(nb_ping,length(temp2), read_format );
  

i=1;% initialisation for the image due to a step of 2
for iping=1:step_iping:length(Ping) % pair lines (first corresponds to sonar data and second line to interferometric data that is why there is a step of 2)
    sss_data.left(i,:) = Ping(iping).chan1Sample;
    sss_data.right(i,:)= Ping(iping).chan2Sample;
    Ping(iping).chan1Sample=[];  % now, clearing this memory
    Ping(iping).chan2Sample=[];  % now, clearing this memory
    i=i+1;    
end

% This only runs if the XTF has a bathy image, the user in this case has to
% set has_bathy_image to true
if( args.has_bathy_image)
    
    %% bathy image
    nb_samples_port=numel(Ping(2).bathy_channels.bathyPortZ);
    sss_data.image_bathy_port=zeros(nb_ping,nb_samples_port, read_format);
    nb_samples_stbd=length(Ping(2).bathy_channels.bathyStbdZ);
    sss_data.image_bathy_stbd=zeros(nb_ping,nb_samples_stbd, read_format);
    
    % scale factors are only on first ping bathy but can reoccur as many times as desired
    i=1;% initialisation for the image due to a step of 2
    for iping=2:step_iping:length(Ping) % pair lines (first corresponds to sonar data and second line to interferometric-> data that is why there is a step of 2)
        bathyPort=Ping(iping).bathymetry.bathyPortZ/Ping(2).sdfxbathyprocessed_settings_record1.bathyScaleXyz;
        bathyStbd=Ping(iping).bathymetry.bathyStbdZ/Ping(2).sdfxbathyprocessed_settings_record1.bathyScaleXyz;
        sss_data.image_bathy_port(i,1:length(bathyPort))=bathyPort;
        sss_data.image_bathy_stbd(i,1:length(bathyStbd))=bathyStbd;
        Ping(iping).bathymetry.bathyPortZ = [];  % now, clearing this memory
        Ping(iping).bathymetry.bathyStbdZ = [];  % now, clearing this memory
        i=i+1;
    end
end


%% geographical positions and other info
sss_data.posXY=zeros(nb_ping, 5);
sss_data.posXY_info=['ShipXcoordinate(Longitude) ShipYcoordinate(Latitude) SensorHeading  SensorPrimaryAltitude ShipGyro'];
%  sss_data.res= zeros(nb_ping,1);
i=0;
for iping=1:step_iping:length(Ping)
    i=i+1;
    temp1=Ping(iping).xtfping_header.ShipXcoordinate;
    temp2=Ping(iping).xtfping_header.ShipYcoordinate;
    temp3=Ping(iping).xtfping_header.SensorHeading;
    temp4=Ping(iping).xtfping_header.SensorPrimaryAltitude;
    temp5=Ping(iping).xtfping_header.ShipGyro;    
    sss_data.posXY(i,:)=[temp1 temp2 temp3 temp4 temp5];
    
    % There is not a variable resolution, probably, but I am keeping this (remarked) statement for consistency, 
    % sss_data.res(i) = Ping(iping).xtfpingchan_header1.SlantRange/Ping(iping).xtfpingchan_header1.NumSamples;
        
end

sss_data.res(1) = Ping(1).xtfpingchan_header1.SlantRange/Ping(1).xtfpingchan_header1.NumSamples;
if(args.flip_channel)
    sss_data.left = fliplr(sss_data.left); % flipping the left channel to have data consistency in processing
    if(args.has_bathy_image)
        sss_data.image_bathy_port = fliplr(sss_data.image_bathy_port); % flipping the left channel to have data consistency in processing
    end
end

sss_data.nb_ping = nb_ping;
if args.store_ping
    sss_data.Ping= Ping; % storing the Ping, it has to be done now, altough we removed the stored values, e.g., left and right channels, since they are copied to left and right images
else
    sss_data.Ping=[]; % remove/comment this statement if you want to keep the Ping.
    sss_data.Ping_='deleted after capturing all the info, to save space';
end

fprintf('Time needed to read the image is %.2f second(s) \n', toc);


% klein 3500 bathy processd data page version 3511(3.2.6 15300018 REV 5.0 SDF)
function bathy_channels = BATHY_19_CHANNELS( fileID)
NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortIntensity= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortIntensity=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortAngle= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortAngle=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortQuality= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortQuality=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortX= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortX=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortY= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortY=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortZ= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortZ=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdIntensity= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdIntensity=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdAngle= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdAngle=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdQuality= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdQuality=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdX= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdX=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdY= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdY=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdZ= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdZ=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.rollVector= fread(fileID,NumSamples,'short');
else
    bathy_channels.rollVector=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.pitchVector= fread(fileID,NumSamples,'short');
else
    bathy_channels.pitchVector=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.heaveVector= fread(fileID,NumSamples,'short');
else
    bathy_channels.heaveVector=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortSNR= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyPortSNR=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyPortUncertainty= fread(fileID,NumSamples,'ushort');
else
    bathy_channels.bathyPortUncertainty=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdSNR= fread(fileID,NumSamples,'short');
else
    bathy_channels.bathyStbdSNR=[];
end

NumSamples=fread(fileID,1,'short');
if NumSamples>0
    bathy_channels.bathyStbdUncertainty= fread(fileID,NumSamples,'ushort');
else
    bathy_channels.bathyStbdUncertainty=[];
end




%Remove value of bathy equal to -32768 defined as "Not a Number" (NaN)
%Klein 3500 bathy processed data page (page version 3511, 153000018 REV 5.0 SDF )
function bathy_cleaned= clean_bathy( bathy_struct )

fields=fieldnames(bathy_struct);
structSize = numel(fields);

indPort=find(bathy_struct.bathyPortZ==-32768);% false value
indStbd=find(bathy_struct.bathyStbdZ==-32768);%false value

bathy_temp=bathy_struct;

for i=1:structSize
    vec=bathy_temp.(fields{i});
    if isempty(vec)==0
        vec2=vec;
        if numel(strfind(fields{i},'Port'))>0
            vec2(indPort)=[];
        else
            vec2(indStbd)=[];
        end                
        bathy_temp.(fields{i})=vec2;
    end
end

bathy_cleaned=bathy_temp;




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





function Ping=readXTFFiles(fileName,PingType)



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
    %     Ping(iPing).MagicNumber
    %     Ping(iPing).HeaderType
    
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
                
                
                size_MagicNumber=2;
                size_HeaderType=1;
                size_xtfping_header=253;
                size_xtf_ping_Chanheader1=64;
                size_float=4;
                
                offset_sonar=Ping(iPing).xtfping_header.NumBytesThisRecord-size_MagicNumber-size_HeaderType-size_xtfping_header-Ping(iPing).xtfping_header.NumChansToFollow*(size_float*Ping(iPing).xtfpingchan_header1.NumSamples+size_xtf_ping_Chanheader1);
                
                % commented by Rawi
                skip=fread(fileID, offset_sonar);   
                
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
            
        case 75
            % Read XTF Bath Header
            Ping(iPing).bath_header = XTFPINGHEADER(fileID);
            
            if (Ping(iPing).bath_header.NumChansToFollow>0)
                
                
                size_sdfx=Ping(iPing).bath_header.OptionalOffset;
                
                
                %% Read XTF Bath Channel Header
                if strcmp(PingType,'Klein') %klein 3500 version 3511 (3.2.6 from 15300018 REV 5.0 SDF)
                    
                    
                    
                    % extract the data from the 19 data arrays
                    
                    Ping(iPing).bathy_channels = BATHY_19_CHANNELS( fileID);
                    Ping(iPing).bathymetry = clean_bathy(Ping(iPing).bathy_channels);% clean the false value (-32768)
                    
                    % it gives the size in bytes of the 19 data arrays
                    size_short=2;
                    fields=fieldnames(Ping(iPing).bathy_channels);
                    size_bathy_19_channels=numel(fields)*size_short;
                    for i=1:numel(fields)
                        vec=Ping(iPing).bathy_channels.(fields{i});
                        size_bathy_19_channels=size_bathy_19_channels+length(vec)*size_short;
                    end
                    
                    if size_sdfx>0
                        % Extract the SDFX containing the scale factors and ship config info
                        t=0;
                        while t==0
                            Ping(iPing).sdfx_recordheader = SDFX_RECORD_HEADER( fileID );
                            switch Ping(iPing).sdfx_recordheader.recordID
                                case 1 % ship configuration info
                                    if Ping(iPing).sdfx_recordheader.recordVersion==1
                                        Ping(iPing).sdfxshipconfig_info1 = SDFX_SHIP_CONFIG_INFO_1( fileID );
                                    else
                                        Disp('Wrong version number')
                                    end
                                    
                                case 2 % bathy calibration record 1
                                    
                                case 3 % bathy engine settings record 1
                                    
                                case 4 % bathy processed settings record 1
                                    if Ping(iPing).sdfx_recordheader.recordVersion==1
                                        Ping(iPing).sdfxbathyprocessed_settings_record1 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_1( fileID );
                                        
                                    elseif Ping(iPing).sdfx_recordheader.recordVersion==2
                                        Ping(iPing).sdfxbathyprocessed_settings_record2 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_2( fileID );
                                        
                                    elseif Ping(iPing).sdfx_recordheader.recordVersion==3
                                        Ping(iPing).sdfxbathyprocessed_settings_record3 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_3( fileID );
                                    else
                                        Disp('Wrong version number')
                                    end
                                case 4008636142 % end data record 0xEEEEEEEE
                                    t=1;
                                otherwise
                                    display('Not recognized record header')
                                    
                            end
                            
                        end
                    end
                    
                    
                    
                    size_MagicNumber=2;
                    size_HeaderType=1;
                    size_xtfping_header=253;% size header = size_MagicNumber+size_HeaderType+size_xtfping_header = 2+1+253 = 256 bytes
                    
                    offset_bathy=Ping(iPing).bath_header.NumBytesThisRecord-size_MagicNumber-size_HeaderType-size_xtfping_header-size_bathy_19_channels-size_sdfx;
                    skip=fread(fileID,offset_bathy);
                    
                    
                    
                elseif strcmp(PingType,'EdgeTech')
                    Ping(iPing).chan1Sample = fread(fileID,36864);
                end
                
                
            end
            
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


%Read SDFX ship bathy processed settings records 1, reference: page 52 sdf 15300018 REV 5.0
function sdfxbathyprocessed_settings_record1 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_1( fileID )
sdfxbathyprocessed_settings_record1.bathyScaleAngle=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScaleQuality=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScaleXyz=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScaleRoll=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScalePitch=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScaleHeave=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyScaleSoundSpeedCorrection=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record1.bathyMotionType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record1.bathySoundSpeedType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record1.bathyProcessingOptimizations=fread(fileID,1,'uint32');



%Read SDFX ship bathy processed settings record 2, reference: page 53 sdf 15300018 REV 5.0
function sdfxbathyprocessed_settings_record2 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_2( fileID )
sdfxbathyprocessed_settings_record2.bathyScaleIntensity=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleAngle=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleQuality1=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleQuality2=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleUncertainty=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleXyz=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleRoll=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScalePitch=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleHeave=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyScaleSoundSpeedCorrection=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record2.bathyMotionType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record2.bathySoundSpeedType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record2.bathyProcessingOptimizations=fread(fileID,1,'uint32');



%Read SDFX ship bathy processed settings record 3, reference: page 54 sdf 15300018 REV 5.0
function sdfxbathyprocessed_settings_record3 = SDFX_BATHY_PROCESSED_SETTINGS_RECORD_3( fileID )
sdfxbathyprocessed_settings_record3.bathyScaleIntensity=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleAngle=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleQuality1=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleQuality2=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleUncertainty=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleSnr=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleXyz=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleRoll=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScalePitch=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleHeave=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.bathyScaleSoundSpeedCorrection=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.reserved1=fread(fileID,1,'float');
sdfxbathyprocessed_settings_record3.WindSpeedSel=fread(fileID,1,'int16');
sdfxbathyprocessed_settings_record3.GrainSizeSel=fread(fileID,1,'int16');
sdfxbathyprocessed_settings_record3.bathyMotionType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record3.bathySoundSpeedType=fread(fileID,1,'uint32');
sdfxbathyprocessed_settings_record3.bathyProcessingOptimizations=fread(fileID,1,'uint32');


%Read SDFX header, reference: page 49 sdf 15300018 REV 5.0
function sdfx_recordheader = SDFX_RECORD_HEADER( fileID )
sdfx_recordheader.recordID=fread(fileID,1,'uint32');
sdfx_recordheader.recordNumBytes=fread(fileID,1,'uint32');
sdfx_recordheader.headerVersion=fread(fileID,1,'uint32');
sdfx_recordheader.recordVersion=fread(fileID,1,'uint32');
sdfx_recordheader.reserved=fread(fileID,12,'uint32');




%Read SDFX ship configuration info 1, reference: page 51 sdf 15300018 REV 5.0
function sdfxshipconfig_info1 = SDFX_SHIP_CONFIG_INFO_1( fileID )
sdfxshipconfig_info1.ShipLength=fread(fileID,1,'float');
sdfxshipconfig_info1.ShipWidth=fread(fileID,1,'float');
sdfxshipconfig_info1.ShipHeight=fread(fileID,1,'float');
sdfxshipconfig_info1.DatumX=fread(fileID,1,'float');
sdfxshipconfig_info1.DatumY=fread(fileID,1,'float');
sdfxshipconfig_info1.DatumZ=fread(fileID,1,'float');
sdfxshipconfig_info1.ArrayX=fread(fileID,1,'float');
sdfxshipconfig_info1.ArrayY=fread(fileID,1,'float');
sdfxshipconfig_info1.ArrayZ=fread(fileID,1,'float');
sdfxshipconfig_info1.ArraySpacing=fread(fileID,1,'float');
sdfxshipconfig_info1.MotionX=fread(fileID,1,'float');
sdfxshipconfig_info1.MotionY=fread(fileID,1,'float');
sdfxshipconfig_info1.MotionZ=fread(fileID,1,'float');
sdfxshipconfig_info1.PositionX=fread(fileID,1,'float');
sdfxshipconfig_info1.PositionY=fread(fileID,1,'float');
sdfxshipconfig_info1.PositionZ=fread(fileID,1,'float');
sdfxshipconfig_info1.Draft=fread(fileID,1,'float');
sdfxshipconfig_info1.RollBiasPort=fread(fileID,1,'float');
sdfxshipconfig_info1.PitchBiasPort=fread(fileID,1,'float');
sdfxshipconfig_info1.HeadingBiasPort=fread(fileID,1,'float');
sdfxshipconfig_info1.RollBiasStbd=fread(fileID,1,'float');
sdfxshipconfig_info1.PitchBiasStbd=fread(fileID,1,'float');
sdfxshipconfig_info1.HeadingBiasStbd=fread(fileID,1,'float');



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



















