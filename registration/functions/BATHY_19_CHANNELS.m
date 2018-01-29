%
% klein 3500 bathy processd data page version 3511(3.2.6 15300018 REV 5.0 SDF)
%
% ECA Robotics
%

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

end

