%% Read XTF ping header, reference: page 25 XTF_Format_X35
% source: ECA Robotics

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

end
