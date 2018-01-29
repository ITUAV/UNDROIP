function [Ping,xtfFileHeader,NavSystemParameters,ChanInfo]=readXTFFiles(fileName,PingType)

%%%%%%%%%%%%%
%
% read xtf data
%
% ECA Robotics
%
%%%%%%%%%%%%%

fileID = fopen(fileName);

%% XTF File header.
%  Total of 1024 bytes.

xtfFileHeader.FileFormat                      = fread(fileID,1);
xtfFileHeader.SystemType                      = fread(fileID,1);
xtfFileHeader.RecordingProgramName            = fread(fileID,[1 8],'*char');
xtfFileHeader.RecordingProgramVersion         = fread(fileID,[1 8],'*char');
xtfFileHeader.SonarName                       = fread(fileID,[1 16],'*char');
xtfFileHeader.SonarType                       = fread(fileID,1,'uint16');  
xtfFileHeader.NoteString                      = fread(fileID,[1 64],'*char');
xtfFileHeader.ThisFileName                    = fread(fileID,[1 64],'*char');
xtfFileHeader.NavUnits                        = fread(fileID,1,'uint16');
xtfFileHeader.NumberOfSonarChannels           = fread(fileID,1,'uint16');
xtfFileHeader.NumberOfBathymetryChannels      = fread(fileID,1,'uint16');
xtfFileHeader.NumberOfForwardLookArrays       = fread(fileID,1,'uint16');
xtfFileHeader.NumberOfEchoStrengthChannels    = fread(fileID,1,'uint16');
xtfFileHeader.NumberOfInterferometriyChannels = fread(fileID,1,'*char');
xtfFileHeader.Reserved1                       = fread(fileID,1,'*char');
xtfFileHeader.Reserved2                       = fread(fileID,1,'uint16');
xtfFileHeader.ReferencePointHeight            = fread(fileID,1,'float');

%% Navigation System Parameters
NavSystemParameters.SystemSerialNumber      = fread(fileID,1,'uint16');
NavSystemParameters.ProjectionType          = fread(fileID,[10]);
NavSystemParameters.SpheriodType            = fread(fileID,[10]);
NavSystemParameters.NavigationLatency       = fread(fileID,1,'long');
NavSystemParameters.OriginX                 = fread(fileID,1,'float'); % inversion OriginY et OriginX
NavSystemParameters.OriginY                 = fread(fileID,1,'float');
NavSystemParameters.NavOffsetY              = fread(fileID,1,'float');
NavSystemParameters.NavOffsetX              = fread(fileID,1,'float');
NavSystemParameters.NavOffsetZ              = fread(fileID,1,'float');
NavSystemParameters.NavOffsetYaw            = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetY              = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetX              = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetZ              = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetYaw            = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetPitch          = fread(fileID,1,'float');
NavSystemParameters.MRUOffsetRoll           = fread(fileID,1,'float');

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


%% Ping Klein 
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
                
                size_MagicNumber=2;
                size_HeaderType=1;
                size_xtfping_header=253;
                size_xtf_ping_Chanheader1=64;
                size_float=4;
                
                padding_sonar=Ping(iPing).xtfping_header.NumBytesThisRecord-size_MagicNumber-size_HeaderType-size_xtfping_header-Ping(iPing).xtfping_header.NumChansToFollow*(size_float*Ping(iPing).xtfpingchan_header1.NumSamples+size_xtf_ping_Chanheader1);
                
                
                skip=fread(fileID,padding_sonar);  
                
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
                                         disp('ok')
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

                        padding_bathy=Ping(iPing).bath_header.NumBytesThisRecord-size_MagicNumber-size_HeaderType-size_xtfping_header-size_bathy_19_channels-size_sdfx;
                        skip=fread(fileID,padding_bathy); 
               
                    
               
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
