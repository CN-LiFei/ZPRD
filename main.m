% If you find the code and dataset useful in your research, please consider citing:
% °∂Underwater Image Enhancement with Zero-Point Symmetry Prior and Reciprocal Mapping°∑

close all;
clc;

% Input image
img = imread('image\test1.png');

% Color-balanced image
img_color = ZPSP(img);

% Result image
result = RM(img_color);

% –ßπ˚œ‘ æ
figure;
subplot(131);imshow(img);title('Input image');
subplot(132);imshow(img_color);title('Color-balanced image'); 
subplot(133);imshow(result);title('Result image'); 

% imwrite(img_dst, 'result\result1.png');



