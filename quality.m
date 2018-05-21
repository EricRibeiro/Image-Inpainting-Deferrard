% imname = 'boat';
imname = 'horses';
% imname = 'monk';
% imname = 'piramide';
% sgm = 'areas';
% sgm = 'dynamics';
sgm = 'volumes';

original = imread(['originals_', imname, '.png']);
inpainted = imread([imname, '_', sgm, '_inpainted_global.png']);
[peaksnr, snr] = psnr(inpainted, original);
disp('PSNR:');
disp(peaksnr);
disp('MSE:');
disp(immse(inpainted, original));