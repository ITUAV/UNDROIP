%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%             XTF Reader Interface - Read XTF files and save as .mat file
%%%                 Input:    - Name of XTF file
%%%                     - Number of pings (predetermined)
%%%                     - Type of ping: Klein or EdgeTech
%%%                 Output:   A struct of Ping, including XTF Ping headers and data samples
%%%
%%%                 main code. Version for reading a single file
%%%
%%%         ECA Robotics march 2017
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Example  main_readXTFFiles('M3_L009')

function main_readXTFFiles(fileName)

%% parameters

PingType = 'Klein';
ext = '.xtf';

%% reading data


% data reading
Ping=readXTFFiles(fileName,PingType); % all data are in Ping

% real number of pings
nb_ping=length(Ping)/2;

%% sonar image
temp1=Ping(1).chan1Sample;
temp2=Ping(1).chan2Sample;
nb_sample=length(temp1)+length(temp2);

WF=zeros(nb_ping,nb_sample);
i=1;% initialisation for the image due to a step of 2
for iping=1:2:length(Ping) % pair lines (first corresponds to sonar data and second line to interferometric data that is why there is a step of 2)
    temp1=Ping(iping).chan1Sample;
    temp2=Ping(iping).chan2Sample; 
    WF(i,:)=[temp1' temp2'];
    i=i+1;    
end

figure
WF_mean=mean(mean(WF(:,300:3000)));
WF2=WF./WF_mean.*16;
image(WF2)
colormap gray

%% geographical positions
posXY=zeros(nb_ping,4);

i=1;
for iping=1:2:length(Ping)    
    temp1=Ping(iping).xtfping_header.SensorXcoordinate;
    temp2=Ping(iping).xtfping_header.SensorYcoordinate;
    temp3=Ping(iping).xtfping_header.SensorHeading;
    temp4=Ping(iping).xtfping_header.SensorPrimaryAltitude;
    
    posXY(i,:)=[temp1 temp2 temp3 temp4];
    i=i+1;    
end

