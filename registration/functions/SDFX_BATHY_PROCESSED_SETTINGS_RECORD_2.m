%
%Read SDFX ship bathy processed settings record 2, reference: page 53 sdf 15300018 REV 5.0
%
% ECA Robotics
%

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
end







