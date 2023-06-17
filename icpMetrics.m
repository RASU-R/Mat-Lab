clc;
close all;

ref = imread('images/13.tif'); %origial img
%ref=im2gray(ref); % for color images
%{
B=imnoise(ref,'gaussian',0.01); %noisy img
B=imnoise(ref,'salt & pepper',0.1);

A=wiener2(B,[5 5]); %filtered image
A=medfilt3(B);

filter=fspecial('gaussian',7,1.5);%filterSize=7 sigma=1.5;
A=imfilter(B,filter);

%B=imnoise(ref,'speckle');
%A=medfilt2(B);
%}

B=imnoise(ref,'salt & pepper',0.1);
A=medfilt2(B);

%figure,imshow(ref), title('Original Image');
%figure,imshow(B), title('Noisy Image');
%figure,imshow(A), title('Filtered Image');

ref=double(ref);
A=double(A);

%function call
[psnr,mse]=PeakSignaltoNoiseRatio(ref,A);
rmse=RootMeanSquareError(ref,A);
mae=MeanAbsoluteError(ref,A);
ssim=StructuralSimiliarityIndex(ref,A);
nae=NormalizedAbsoluteError(ref,A);
ncc=NormalizedCrossCorrelation(ref,A);
sc=StructuralContent(ref,A);
s=multissim(ref,A);

fprintf("mae is %f\n",mae);
fprintf("mse is %f\n",mse);
fprintf("rmse is %f\n",rmse);
fprintf("psnr is %f\n",psnr);
fprintf("ssim is %f\n",s);
fprintf("nae is %f\n",nae);
fprintf("ncc is %f\n",ncc);
fprintf("sc is %f\n",sc);

%psnr,mse function
function [PSNR,MSE] = PeakSignaltoNoiseRatio(origImg, distImg)
    [M ,N] = size(origImg);
    error = origImg - distImg;
    MSE = sum(sum(error .* error)) / (M * N);
    PSNR = 10*log(255*255/MSE) / log(10);
end

function RMSE=RootMeanSquareError(origImg, distImg)
    [M ,N] = size(origImg);
    error = origImg - distImg;
    MSE = sum(sum(error .* error)) / (M * N);
    RMSE=sqrt(MSE);
end

function MAE = MeanAbsoluteError(origImg, distImg)
    [M,N]=size(origImg);
    error = abs(origImg - distImg);
    MAE = sum(sum(error))/ (M * N);  
end

function SSIM=StructuralSimiliarityIndex(origImg, distImg)
    mean_dist=mean(mean(distImg));
    mean_ori=mean(mean(origImg));
    correlationCoef=corrcoef(origImg,distImg);

    std_dist=std(std(distImg));
    std_ori=std(std(origImg));

    sq_m=(mean_dist^2)+(mean_ori^2);
    sq_s=(std_dist^2)+(std_ori^2);
    SSIM=((2*mean_dist*mean_ori)*(2*correlationCoef))/(sq_m * sq_s);
   % o=size(SSI);
   % SSIM=sum(SSI)/o;
   % SSIM=
end

function NAE = NormalizedAbsoluteError(origImg, distImg)
    error = origImg - distImg;
    NAE = sum(sum(abs(error))) / sum(sum(origImg));
end

function NK = NormalizedCrossCorrelation(origImg, distImg)
    NK = sum(sum(origImg .* distImg)) / sum(sum(origImg .* origImg));
end

function SC = StructuralContent(origImg, distImg)
    SC = sum(sum(origImg .* origImg)) / sum(sum(distImg .* distImg));
end

