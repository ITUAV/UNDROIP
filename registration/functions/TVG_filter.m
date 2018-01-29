function WFtvg=TVG_filter(WF)

%
%   TVG correction
% 
% I. Leblond
% 
% ECA Robotics march 2017
%


temp=mean(WF); 
filter_tvg=repmat(temp,size(WF,1),1);
filter_tvg=medfilt2(filter_tvg,[5 5]); %  to blurr a little

filter_tvg(filter_tvg==0)=1; % to avoid zero dividing

WFtvg=WF./filter_tvg;
