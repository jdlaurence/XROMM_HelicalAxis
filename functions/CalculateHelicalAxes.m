%% Helical Axis Calculation for Maya
%
% This script uses several functions to calcuate a helical axis based on
% XROMM Rigid body transformation data, and formats it for import into maya
% using the impHAdata MEL script.
%
% The output file HAdataMaya has 7 columns, the first 6 are xyz points of
% the endpoints of the helical axis, and the 7th is the normalized rotation
% magnitude (used to scale the axis maya).
%
% The output file HAdataRaw is the actual helical axis data (in CT-space),
% following the format:
%    HAdataRaw(frame,1:3) = unitvec; %unit vector with direction of HA
%    HAdataRaw(frame,4:6) = point; %point on HA
%    HAdataRaw(frame,7) = phi; %rotation angle 
%    HAdataRaw(frame,8) = t; %translation
%
%
% Pipline written by J.D. Laurence-Chasen
% last revised 2020/06/07
% 
%% User Input %%

% set working directorty
cd('C:\Users\jdlc7\Desktop\HAdemo\Opossum');

% Data files: XMAlab transformation matricies
rbtRef = csvread('20200108_Evt26_RigidBody001_Cranium_Filtered_30Hz.csv',1,0); % RBT of reference bone/coordinate system (probably cranium)
% Note- use rbtRef = 'world'; if you have no reference rigid body
rbtBone = csvread('20200108_Evt26_RigidBody003_Left_Hemimandible_Filtered_30Hz.csv',1,0); % RBT of bone of interest

timestep = 8; % Number of frames between which to calculate the derivative transformation
% (larger timestep means HA will have less noise)

threshold = 1.5; % minimum rotation value allowed (below won't be drawn in maya), this should be small for small timesteps

HAlen = 10; % length of helical axis line- currently this DOESN'T effect maya drawing, just the endpoint calculation

axisCentroid = [7.712 -9.039 13.971]; % CT-space point (xyz position) with anatomical significance (i.e. between the condyles for a mandible)
% The HA endpoint calculation will use this to figure out where to
% visualize the segment of the HA such that it intersects with the bone


%% Calculation %%

[HAdataMaya, HAdataRaw] = calcHAforMaya(rbtRef,rbtBone,timestep,threshold,HAlen,axisCentroid);
% master calculation function- open it see details
%
% But the most important note is that the HA calculation occurs in CT
% space, then the axis is transformed back into cube space for animation.
% So bear that in mind when interpreting HAdataRaw, which is in CT space.
%% File save %%

csvwrite('HAdataForMaya_left.csv',HAdataMaya);
%csvwrite('HAdataRaw.csv',HAdataRaw);
