%
%Read SDFX ship bathy processed settings record 3, reference: page 54 sdf 15300018 REV 5.0
%
% ECA Robotics
%

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
end







