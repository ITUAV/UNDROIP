function [x_ref, y_ref]= min_ref(x1, x2)

x1_ref  = min(x1(1:end,1)') ;
y1_ref  = min(x1(1:end,2)');

x2_ref  = min(x2(1:end,1)') ;
y2_ref  = min(x2(1:end,2)');


x_ref = min(x1_ref, x2_ref)+1;
y_ref = min(y1_ref, y2_ref)+1;


