function [g, logE] = GetCamResponse(Z, Exposures, Weight, lambda)
%
% Estimate camere response from several pixel values of several exposures.
% Z is a matrix containing pixel values, each row of which corresponds to
% one position of images,each column of which corresponds to one exposure.
% See Paul E.~Debevec, Jitendra Malik, Recovering High Dynamic Range
% Radiance Maps from Photographs.
%
precise = length(Weight);
[pixelNum, expNum] = size(Z);
if pixelNum*expNum < precise
    error('Too few pixel values to estimate camera response function.');
end
if isfloat(Z) && max(Z(:))<=1
    Z = round((precise-1)*Z);
end
if size(Weight,1) == 1 % Weight must be a column vector
    Weight = Weight';
end
if size(Exposures,2) == 1 % Exposures must be a row vector
    Exposures = Exposures';
end
Exposures = repmat(Exposures, pixelNum, 1);

A_upper = zeros(pixelNum*expNum, precise+pixelNum);
iRow = 1;
for iExp = 1:expNum
    for iPix = 1:pixelNum
        A_upper(iRow, Z(iPix,iExp)+1) =  Weight(Z(iPix,iExp)+1);
        A_upper(iRow, precise+iPix) = -Weight(Z(iPix,iExp)+1);
        iRow = iRow + 1;
    end
end
b_upper = Weight(Z(:)+1) .* Exposures(:);

A_lower = zeros(precise-2, precise+pixelNum);
for i = 1:precise-2
    A_lower(i,i:i+2) = Weight(i+1)*[-1, 2, -1];
end
b_lower = zeros(precise-2,1);

A = [A_upper; lambda*A_lower; zeros(1,precise+pixelNum)];
A(end,128) = 1; % constrain that the middle pixel value (128) corresponds to the unit energy
b = [b_upper; b_lower; 0];
x = linsolve(A,b);
g = x(1:precise);
logE = x(precise+1:end);
Energy = Exposures+repmat(logE,1,expNum); % logarithm of the product of the exposure time and irradiance

figure;hold on
scatter(Z(:),Energy(:));
plot(0:precise-1,g);
xlabel('Pixel Value','Interpreter','LaTeX');
ylabel('$\log(E\cdot\Delta{}t)$','Interpreter','LaTeX');
xlim([0 255]);
