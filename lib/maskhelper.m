function [r1, c1] = maskhelper(img)
%--------------------------------------------------------------------------
target1R = 0; target1G = 255; target1B = 0;
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
matches1 = R == target1R & G == target1G & B == target1B; 
[r1, c1] = find(matches1);

if size(r1) < 9 | size(c1) < 9
    target1R = 0; target1G = 1; target1B = 0;
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    matches1 = R == target1R & G == target1G & B == target1B; 
    [r1, c1] = find(matches1);
end

