function [err_val, std_val] = bathy_moments(result, varargin)

% Calculate the error between the matched pairs, of img1 and img2
% Either direct error or moment error can be calculated

defaults.direct_error = false;
args = propval(varargin,defaults);

n_max = 3;
m_max = 3;

if isempty(result.matches.x_img1)
    err_val = NaN;
    std_val = NaN;
    return;
end

[x_img1, x_img2] = shift_val(result.matches.x_img1, result.matches.x_img2);
[y_img1, y_img2] = shift_val(result.matches.y_img1, result.matches.y_img2);

if args.direct_error
    err_val = mean(    abs( x_img1 - x_img2) ...
                              +  abs( y_img1 - y_img2) ...
                  + abs( result.matches.z_img1 - result.matches.z_img2) );
    std_val = std(    abs( x_img1 - x_img2) ...
                              +  abs( y_img1 - y_img2) ...
                  + abs( result.matches.z_img1 - result.matches.z_img2) );
              
else
    
    mom_img1 = zeros(n_max+1, m_max+1);
    mom_img2 = zeros(n_max+1, m_max+1);
   
    for n=0:n_max
        for m=0:m_max
            mom_img1(n+1,m+1) = sum(x_img1.^m.*y_img1.^n.*abs(result.matches.z_img1));
            mom_img2(n+1,m+1) = sum(x_img2.^m.*y_img2.^n.*abs(result.matches.z_img2));
        end
    end
    
    err_val = mean2(abs(log(mom_img1)-log(mom_img2)));
    std_val = std2(abs(log(mom_img1)-log(mom_img2)));
end

fprintf('Error between img1 and img2 %d \n ', err_val);

function [x1, x2]= shift_val(x1, x2)

x1_ref  = min(x1) ;
x2_ref = min(x2);

x_ref = min(x1_ref, x2_ref);

x1 = x1 - x_ref;
x2 = x2 - x_ref;
