%
% Remove value of bathy equal to -32768 defined as "Not a Number" (NaN) 
% Klein 3500 bathy processed data page (page version 3511, 153000018 REV 5.0 SDF )
%
% ECA Robotics
%

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
end

