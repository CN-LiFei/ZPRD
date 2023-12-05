close all;
clc;

img = imread('C:\Users\LiFei\Desktop\test\color test\src\176.png');

% CCS
img_color = CCS(img);

% TWSC
img_dst = TWSC(img_color);

% –ßπ˚œ‘ æ
figure;
subplot(131);imshow(img);title('Raw Image');
subplot(132);imshow(img_color);title('Color Corrected Image'); 
subplot(133);imshow(img_dst);title('Enhanced Image'); 


