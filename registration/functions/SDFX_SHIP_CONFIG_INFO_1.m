%
%Read SDFX ship configuration info 1, reference: page 51 sdf 15300018 REV 5.0
%
% ECA Robotics
%

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
end




