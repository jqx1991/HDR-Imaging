function ExclusionMap = Img2ExMap(ColorImg, percentileThreshold, noiseTorerance)
%
% Convert RGB color image to exclusion map image.
% The pixel values between [percentileThreshold-noiseTorerance, percentileThreshold+noiseTorerance]
% would also be set to zero to prevent threshold noise.
% See page 128 of HDRI book.
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
if ~exist('noiseTorerance','var')
    noiseTorerance = 0;
elseif (percentileThreshold-noiseTorerance<=0) || (percentileThreshold+noiseTorerance>=1)
    error('The noise torerance is too large.');
end
if depth == 3
    YImg = ColorImg(:,:,1)*54/256 + ColorImg(:,:,2)*183/256 + ColorImg(:,:,3)*19/256;
elseif depth == 1
    YImg = ColorImg;
else
    error('The dimension of input image was unavailable.');
end
threshold = prctile(YImg(:), 100*percentileThreshold);
ExclusionMap = ones(height, width);
ExclusionMap((YImg>threshold-noiseTorerance) & (YImg<threshold+noiseTorerance)) = 0;
