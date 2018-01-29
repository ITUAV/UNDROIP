%
%Read SDFX ship bathy processed settings records 1, reference: page 52 sdf 15300018 REV 5.0
%
% ECA Robotics
%

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
end







