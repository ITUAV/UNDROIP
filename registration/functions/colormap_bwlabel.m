
function colormap_bwlabel(Label)

%
% colormap for label image
%
% I. Leblond
%
% ECA Robotics march 2017
%

nb_color=max(max(Label)); % nb area



color_lines=[0 0.447 0.741;...
    0.85 0.325 0.098;...
    0.929 0.694 0.125;...
    0.494 0.184 0.556;...    
    0.466 0.6740 0.188;...
    0.301 0.745 0.9330;...
    0.635 0.078 0.184]; 


nb_color_base=size(color_lines,1); % loop on 7 colors


nb_boucles=ceil(nb_color./nb_color_base); % nb of loops


color=repmat(color_lines,nb_boucles,1);

color=color(1:nb_color,:); %cut on necessary number of labels

color=[1 1 1; color]; % white for the background

colormap(color)


