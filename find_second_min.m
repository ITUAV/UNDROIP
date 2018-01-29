function [second_min , val]= find_second_min(A, i)
% This functions finds the second minima in a smooth fit polynomial
% start searching from the ith index
%
%
% Input- 
% A: a vector of values
% i: the value to start searching for the second minima
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Sept 12, 2016
%
%
%
% License:
%=====================================================================
% This is part of the UNDROIP toolbox, released under
% the GPL. https://github.com/rawi707/UNDROIP/blob/master/LICENSE
% 
% The UNDROIP toolbox is available free and
% unsupported to those who might find it useful. We do not
% take any responsibility whatsoever for any problems that
% you have related to the use of the UNDROIP toolbox.
%
% ======================================================================
%%


while(1)
    if A(i+1)>A(i)
        i=i+1;
        continue;
    else break;
    end    
end

while(1)
    if A(i+1)<A(i)
        i=i+1;
        continue;
    else break;
    end    
end

second_min=i;
val = A(second_min);