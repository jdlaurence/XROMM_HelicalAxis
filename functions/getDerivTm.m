function derivTm = getDerivTm(rbtRef,rbtBone,timestep)
% GET DERIVATIVE TRANSFORMATION MATRIX This function takes a
% transformation matrix, and an optional reference matrix (either file path
% or matrix) from XMALab and calculates the derivative transformation at the
% given time step. The output, reltm, is the input to the screw_original.m
% script.

% input: rbtRef = reference bone rbt (e.g. cranium) IF NO REFERENCE put
% 'world' or ''
%        rbtBone = bone of interest rbt
%        timestep = number of frames between derivative calculations
% output: relativeTm = derivative transformation matrix

% Written by J.D. Laurence-Chasen 2020/06/05

%% Transform bone into reference coordinate system if present

% i.e. subtract reference transformation matrix from bone via matrix
% multiplication

if isnumeric(rbtRef)
    if size(rbtRef,2) == 16 & size(rbtRef) == size(rbtBone)
    newtm = NaN(4,4,length(rbtRef));
    for i = 1:length(rbtRef)
        if ~isnan(rbtRef(i,1)) & ~isnan(rbtBone(i,1))
        newtm(:,:,i) = inv(reshape(rbtRef(i,:),[4 4]))*reshape(rbtBone(i,:),[4 4]);    
        end
    end
    else
        error('Matricies must have same dimensions')
    end
else % use world space as reference i.e. don't transform
    newtm = [];
    for i = 1:size(rbtBone,1)
        newtm = reshape(rbtBone(i,:),[4 4]);
    end
end
%% Calculate derivative

% check timestep value
if timestep < 1 
    error('Time step must be positive')
elseif rem(timestep,timestep) ~= 0
    error('Time step must be an integer')
end

% Which frames have data?
frames = find(~isnan(squeeze(newtm(1,1,:))));
timestep_offset = floor(timestep/2); % center the HA data between the timesteps
newframes = frames + timestep_offset;

% calculate transform
derivTm = NaN(size(newtm));
for frame = 1:length(frames)-timestep

    currentTm = newtm(:,:,frames(frame));
    nextTm = newtm(:,:,frames(frame+timestep));

    derivTm(:,:,newframes(frame)) = inv(currentTm)*nextTm;
    
end

end

