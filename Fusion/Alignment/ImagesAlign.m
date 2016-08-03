function [AlignedImgsCell, Shift] = ImagesAlign(ImgsCell, referenceNum, maxShift)
%
% Align images with reference of ImgsCell{referenceNum}. The shift
% distances for every images are recoreded in Shift.
%
if ~iscell(ImgsCell)
    error('Images to be aligned should be stored in a cell dataType.');
end
if referenceNum > length(ImgsCell)
    error(['Can not find No.',num2str(referenceNum),' image in images cell.']);
end
AlignedImgsCell = cell(size(ImgsCell));
Shift = zeros(length(ImgsCell),2);
for i = 1:length(ImgsCell)
    if i ~= referenceNum
        [Shift(i,1), Shift(i,2)] = GetShift(ImgsCell{referenceNum}, ImgsCell{i}, maxShift);
        AlignedImgsCell{i} = imtranslate( ImgsCell{i}, [Shift(i,1),Shift(i,2)] );
    else
        AlignedImgsCell{i} = ImgsCell{referenceNum};
    end
end