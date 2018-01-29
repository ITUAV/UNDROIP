function x = tst2(landmarks)

% jj=0;
% for i= -9:2:14
%     jj=jj+1;
%     subplot(4,3,jj), plot(landmarks.signal{127+i});
%     x= 2650 + i ; 
%     title(['Ping ' num2str(x)]);  
%     
% end


x = [];
for i=1:length(landmarks.peaks.significane)       
    x = [x landmarks.peaks.significane{i}];
end





% 
% 
% jj=0;
% for i= -9:2:14
%     jj=jj+1;
%     x= 2650 + i ; 
%     
%     subplot(4,3,jj), plot(landmarks.img(2777-x+1,200:end));
%     
%     title(['Ping ' num2str(x)]);  
%     
% end