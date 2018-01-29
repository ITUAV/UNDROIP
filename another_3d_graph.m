function Another_3d_graph(x)
%Generate random data

%Create regular grid across data space
[X,Y] = meshgrid(linspace(min(x(:,1)'),max(x(:,1)'), 10), linspace(min(x(:,2)),max(x(:,2)), 10));

%create contour plot
contour(X,Y,griddata(x(:,1),x(:,1),x(:,3),X,Y))

%mark original data points
hold on;scatter(x,y,'o');hold off