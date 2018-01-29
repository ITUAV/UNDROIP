
function wL= spline_fit(fmat, in_axis, ping_idx, wL_prev, spline_tol)

fmat = log(fmat);       
wL = csaps(in_axis ,double(fmat), spline_tol ,  in_axis); % plot(ys); hold on; plot(fmat)    
wL = check_sanity(wL, ping_idx, wL_prev);
wL= exp(wL); %  2.^wL;  % probably, -ve values may appear at the ver far end, convering them to +ve poses no problem

end



function wL = check_sanity(wL, ping_idx, wL_prev)
if(min(wL)<0)    
    fprintf('ping id %d', ping_idx);
    fprintf('--------------------------------------------------- Overfitting problem -------------------------------------------------------------\n');
    fprintf('--------------   negative values due to over fitting, \n  -------------------\n');
    fprintf('-------------- the absolute value is always used, you have to check the results, \n  you may change (increase/decrease) the polynomial degree and try again if not satisfied with them     -------------------');   
    wL= abs(wL);
    return;
end

 if any(isnan(wL)); 
     fprintf('Due to matrix factorization singularities, Nan values appeared at %d, we shall use a previously fitted polynomial \n ', ping_idx); 
     xx = length(wL)-length(wL_prev);
     if xx>0
         wL_prev(end+1:end+xx)=wL_prev(end);
     elseif xx<0
         wL_prev(end+xx+1:end)=[];
     end    
         
     wL = log(wL_prev);
     return;     
 end
 % wL=wL; wL is OK

end

    