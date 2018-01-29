function x = optimized_bathy(img1, img2)

% Example
% optimized_bathy(M2L9, M2L10, 'x_min', .5, 'y_min', .5, 'z_min', 1.5)
% global img1;
% global img2;

m1=0.55;
m2=0.55;
options = optimset('fminsearch');

x0=[m1, m2];
x = fminsearch(@opt_func, x0); %, options);


function opt_val = opt_func(m)
global img1;
global img2;

disp(m);
no_of_matches = rawi_bathy_analysis (img1, img2,  'm1', m(1), 'm2', m(2),  'x_min', .5, 'y_min', .5, 'z_min', 1.5);
% no_of_matches= sin(m(1)*m(2));
opt_val = 1/(no_of_matches +1);

