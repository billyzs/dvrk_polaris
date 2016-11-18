function [ normals ] = calculateNormal( points , numNeighbors)
%calculateNormal takes in a n*3 array of xyz location of points
% and calculate the normal estimate of each point
if nargin < 2 || numNeighbors < 2 || numNeighbors > size(points, 1)
    numNeighbors = 3;
end

normals = zeros(size(points));

for i=1:size(points, 1)
    currPoint = points(i,:);
    % extract the matrix besides currPoint
    diff = bsxfun(@minus, currPoint, points);
    diff(i,:) = [];
    
    n = nchoosek(numNeighbors, 2);
    normEstm = [0 0 0];
    for iter = nchoosek(1:numNeighbors, 2)'
        normEstm = normEstm + cross(diff(iter(1),:), diff(iter(2),:));
    end
    normals(i,:) = normEstm / n;
end
% normalize
normals = normr(normals);
%TODO define z axis accoridng to the way how ROS is set up
end

