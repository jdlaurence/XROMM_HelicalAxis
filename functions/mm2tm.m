function [out] = mm2tm(mm)
% Maya Transformation Matrix (1x16) to Transformation matrix (4x4)

% Input: either .csv of rigid body transform direct from XMALab (as a string) or a matrix as a double
% itself where rows are frames and each row is 1x16 maya format

% Out= 4x4xn transformation matrix where z dimension is n frames.
out = [];

if ischar(mm) % assume it's a filename
    
   data = csvread(mm,1,0);
    
elseif isnumeric(mm)
    if size(mm,2) == 4
        error('Data are already in tm format')
    else
    data = mm;
    end
else
    error('Data must be in .csv or matrix format')
end

for i = 1:size(data,1)
    
     
   out(1:3,1,i) = data(i,1:3);
   out(1:3,2,i) = data(i,5:7);
   out(1:3,3,i) = data(i,9:11);
   out(1:3,4,i) = data(i,13:15);
   if ~isnan(data(i,1))
       
   out(4,1:3,i) = 0;
   out(4,4,i) = 1;
   else
       
   out(4,1:3,i) = NaN;
   out(4,4,i) = NaN;
   end
end

end

