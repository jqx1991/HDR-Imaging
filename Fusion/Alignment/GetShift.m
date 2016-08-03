function [shift_x, shift_y] = GetShift(Img1, Img2, maxShift)
%
% Determine how much to move the second exposure (Img2) in x and y to align
% it with the first exposure (Img1).
% The maximum number of pixels in the final offsets is determined by the
% maxShift.
%
threshold = 0.5;
tolerance = 0.015;
if maxShift > 0
    Img1_sml = imresize(Img1, 1/2, 'nearest');
    Img2_sml = imresize(Img2, 1/2, 'nearest');
    [shift_current_x, shift_current_y] = GetShift(Img1_sml, Img2_sml, maxShift-1);
    shift_current_x = shift_current_x * 2;
    shift_current_y = shift_current_y * 2;
else
    shift_current_x = 0;
    shift_current_y = 0;
end
TImg1 = Img2MTB(Img1, threshold);
TImg2 = Img2MTB(Img2, threshold);
EImg1 = Img2ExMap(Img1, threshold, tolerance);
EImg2 = Img2ExMap(Img2, threshold, tolerance);

minErr = size(Img1,1)*size(Img1,2);

for x = -1:1:1;
    for y = -1:1:1
        xc = shift_current_x + x;
        yc = shift_current_y + y;
        TImg2_shifted = imtranslate(TImg2, [xc,yc]);
        EImg2_shifted = imtranslate(EImg2, [xc,yc]);
        Diff = xor(TImg1, TImg2_shifted) & EImg1 & EImg2_shifted;
        err = sum(sum(Diff));
        if err < minErr
            shift_x = xc;
            shift_y = yc;
            minErr = err;
        end
    end
end
clear Img1 Img2
