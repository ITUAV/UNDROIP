function imgS=segment_shadow_s(WF,thresS,sizeMinS,sizeMaxS,Area_minS,Ex_min,ratio_max,Hwater,hmin,d_obj_min)


%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% segmentation of shadows on starboard
%%%
%%% I. Leblond
%%%
%%% ECA Robotics march 2017
%%%
%%%%%%%%%%%%%%%%%%%%%%

ind=find(WF<=thresS); % segmentation
BW=zeros(size(WF));
BW(ind)=1;

L=bwlabel(BW); % labellisation

% extraction of characteristics of shadows

stats=regionprops(L,'BoundingBox'); % recherche des tailles des boîtes englobantes

sizeS=[stats.BoundingBox];
sizeS=reshape(sizeS,4,length(sizeS)/4); 
sizeS=sizeS'; 

size_ping=sizeS(:,4); % number of pings for each shadow
j_landmk=ceil(sizeS(:,1)); %position of landmarks across track (beginning of bounding box for starboard)


if length(Hwater)>1
   % if estimation ping by ping of water column
    i_landmk=ceil(sizeS(:,2)+sizeS(:,4)./2); % ping number of landmarks
    Hwater_old=Hwater;
    Hwater=Hwater_old(i_landmk);
end


ds_min=((hmin./Hwater).*j_landmk)./(1-hmin./Hwater); % minimal length of shadow acording to grazing angle
d0=((hmin./Hwater).*d_obj_min)./(1-hmin./Hwater); % reference size

stats=regionprops(L,'Area');
Area=[stats.Area]';

Area_corr=Area./ds_min.*d0;

stats=regionprops(L,'FilledArea');
FA=[stats.FilledArea]';
ratio=FA./Area;

stats=regionprops(L,'Extent');
Ex=[stats.Extent]';

% selection of shadows with good characteristics

ind=find(size_ping>=sizeMinS & size_ping<=sizeMaxS & Area_corr>=Area_minS & Ex>=Ex_min); 


% image of shadows

imgS=zeros(size(L)); 

for ii=1:length(ind)
    
    iii=find(L==ind(ii));
    imgS(iii)=1;

end






