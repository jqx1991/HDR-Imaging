function BinaryImg = Img2MTB(ColorImg, percentileThreshold)
%
% Convert RGB color image to binary bitmap image.
%
[height, width, depth] = size(ColorImg);
if ~isfloat(ColorImg)
    ColorImg = double(ColorImg)/255;
end
if ~exist('percentileThreshold','var')
    percentileThreshold = 0.5;
elseif (percentileThreshold<0) || (percentileThreshold>1)
    error('The percentile threshold should within 0 and 1.')
end
if depth == 3
    YImg = ColorImg(:,:,1)*54/256 + ColorImg(:,:,2)*183/256 + ColorImg(:,:,3)*19/256;
elseif depth == 1
    YImg = ColorImg;
else
    error('The dimension of input image was unavailable.');
end
threshold = prctile(YImg(:), 100*percentileThreshold);
BinaryImg = zeros(height, width);
BinaryImg(YImg>threshold) = 1;