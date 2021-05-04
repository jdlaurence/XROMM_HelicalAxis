function [HAdataMaya, HAdataRaw,axisCentroid_cube] = calcHAforMaya(rbtRef,rbtBone,timestep,threshold,HAlen,axisCentroid)
%CALCULATE HELICAL AXIS FOR MAYA This function takes XMALab rigid body
%transformation files and calculates a helical axis, ready to be imported
%in to Autodesk maya for visualization.

% Written by J.D. Laurence-Chasen, modified from Pepe Iriarte-Diaz and
% Kelsey Stilson's original scripts
% last updated 2020/06/07

% Input:
% - rbtRef = rigid body transformation in maya format, as double. if there's no reference object, set it to 'world'
% - rbtBone = rbt (maya format) from XMAlab of bone you want to calculate the helical axis for
% - timestep = distance (in frames) between consecutive HA calculations
% - threhold = rotation magnitude below which the HA won't be drawn in maya
% - HAlen = length of HA. Not used in maya currently, but will affect the position of the endpoints
% - axisCentroid = CT-space XYZ position of the bone/region of interest. This ensures the HA is drawn close to your actual models

% Output
% -HAdataMaya = data formatted for input via impHAdata MEL script
%    Columns--> 1:3 = endpoint1 xyz; 4-6 = endpoint2 xyz; 7 = normalized rotation magnitude
% -HAdataRaw = output from screw_original, i.e. the helical axis data, following the
% format:
%    HAdataRaw(frame,1:3) = unitvec; %unit vector with direction of helical axis
%    HAdataRaw(frame,4:6) = point; %point on helical axis
%    HAdataRaw(frame,7) = phi; %rotation angle
%    HAdataRaw(frame,8) = t; %translation
%
%% Calculate derivative transformation
% this will transform the bone into the reference coordinate system and
% calculate the derivative of its motion

derivTm = getDerivTm(rbtRef,rbtBone,timestep);


%% Calculate helical axis
nframes = size(derivTm,3);
HAdata = NaN(nframes,8); % initialize output array w/ NaNs
I = 3; % intersect where the plane is 0, x=1, y=2, z=3

for frame = 1:nframes
   
    if ~isnan(derivTm(1,1,frame))
    
    
    [unitvec,point,phi,t] = screw_original(derivTm(:,:,frame),I); % calculate helical axis 
    
    % populate output array
    HAdata(frame,1:3) = unitvec; %unit vector with direction of helical axis
    HAdata(frame,4:6) = point; %point on helical axis
    HAdata(frame,7) = phi; %rotation angle
    HAdata(frame,8) = t; %translation
    
    end
    
end

%% Format for maya (calculate endpoints)

frames = find(~isnan(HAdata(:,1))); % which frames have data?

pos = HAdata(frames,4:6) ; % HA origin point
dir = HAdata(frames,1:3) ; % Unit vector

% Scale size of arrow to be magnitude of rotation

% get the indices of the values where rotation is higher than the rotation
% threshold
belowThreshold = HAdata(:,7) < threshold ;

% calculate the position of the end points of the HA
newpos = [];
for i = 1:length(frames)
    % find point on HA that minimizes distance to axisCentroid, this will be
    % the mid-point of the HA as it's drawn in maya
    lhs = axisCentroid - pos(i,:);
    dotP = dot(lhs, dir(i,:));
    center = pos(i,:) + dir(i,:) * dotP;
    newpos(i,:) = center;
end

% this gives you two points on the HA, equally spread from the just
% calculated centroid
pos1 = newpos + dir.*repmat(HAlen/2,1,3) ;
pos2 = newpos - dir.*repmat(HAlen/2,1,3) ;


% put back into trial time
temppos1 = NaN(length(HAdata),3);
temppos2 = NaN(length(HAdata),3);
scale = NaN(length(HAdata),1);
temppos1(frames,:) = pos1;
temppos2(frames,:) = pos2;
scale(frames) = HAdata(frames,7)./max(HAdata(frames,7)); % normalized scale

% IMPORTANT apply original RBT to bring back points into cube space
pos1 = applyTm(temppos1,rbtBone);
pos2 = applyTm(temppos2,rbtBone);
HAendpoints = [pos1 pos2 scale];
axisCentroid_cube = applyTm(newpos,rbtBone);
% remove below threshold points
HAendpoints(belowThreshold,1:6) = nan;
HAendpoints(belowThreshold,7) = 0.5;


% create final array
HAdataMaya = HAendpoints;
HAdataRaw = HAdata;

disp('Helical axis successfully calculated')
end

