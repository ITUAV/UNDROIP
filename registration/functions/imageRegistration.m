function im_rec=imageRegistration(im_test,ang,tx,ty)

% registration on rotation and translation
% I. Leblond
%
% ECA Robotics march 2017
%



im_rec=imrotate(im_test,ang,'crop');

im_rec=imtranslate(im_rec,[ty tx]); 