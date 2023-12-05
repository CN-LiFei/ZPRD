function [img_color] = CCS(img)
%%  2023.10.18  颜色校正方案---零点对称性先验---将通道a,b的均值变为关于零点对称

img = im2double(img);   % double类型

img_lab = rgb2lab(img); % 转换为lab空间

L = im2double(img_lab(:,:,1));     % 亮度L空间
a = im2double(img_lab(:,:,2));     % 颜色a空间
b = im2double(img_lab(:,:,3));     % 颜色b空间

mean_a = mean2(a);    % a通道均值
mean_b = mean2(b);    % b通道均值

% a,b通道均值补偿，将均值归零
a_bu = a - mean_a;    
b_bu = b - mean_b;    

% 补偿后重新合并为Lab空间下的图像
Lab_bu = cat(3, L, a_bu, b_bu);

% 通道分解
L = im2double(Lab_bu(:,:,1));
a = im2double(Lab_bu(:,:,2));
b = im2double(Lab_bu(:,:,3));

[height, width, ~] = size(Lab_bu);  % 高，宽，通道数；

% a通道第二次补偿，实现负轴和正轴的均值数值相等
num_fu_a = 0;
num_fupixel_a = 0;
num_zheng_a = 0;
num_zhengpixel_a = 0;

% 计算a通道负值和正值的像素点总数，以及负值和正值的和总数。
for i = 1:height
    for j = 1:width
        if a(i,j) < 0
            num_fu_a = num_fu_a + 1;
            num_fupixel_a = num_fupixel_a + a(i,j);
        else
            num_zheng_a = num_zheng_a + 1;
            num_zhengpixel_a = num_zhengpixel_a + a(i,j);
        end
    end
end

% 负值的均值为：
if num_fu_a == 0
    mean_fu_a = 0;
else
    mean_fu_a = num_fupixel_a / num_fu_a;
end
% 正值的均值为：
if num_zheng_a == 0
    mean_zheng_a = 0;
else
    mean_zheng_a = num_zhengpixel_a / num_zheng_a;
end

% 求取均值的绝对值
abs_mean_fu_a = abs(mean_fu_a);
abs_mean_zheng_a = abs(mean_zheng_a);

% 计算K值
Ka = (abs_mean_fu_a + abs_mean_zheng_a) / 2;

%计算通道系数
if abs_mean_fu_a == 0
    Kfu_a = 1;
else
    Kfu_a = Ka / abs_mean_fu_a;
end

if abs_mean_zheng_a == 0
    Kzheng_a = 1;
else
    Kzheng_a = Ka / abs_mean_zheng_a;
end

%像素值处理
for i = 1:height
    for j = 1:width
        if a(i,j) < 0
            a(i,j) = a(i,j) * Kfu_a;
        else
            a(i,j) = a(i,j) * Kzheng_a;
        end
    end
end

% 计算b通道负值和正值的像素点总数，以及负值和正值的和总数。
num_fu_b = 0;
num_fupixel_b = 0;
num_zheng_b = 0;
num_zhengpixel_b = 0;

for i = 1:height
    for j = 1:width
        if b(i,j) < 0
            num_fu_b = num_fu_b + 1;
            num_fupixel_b = num_fupixel_b + b(i,j);
        else
            num_zheng_b = num_zheng_b + 1;
            num_zhengpixel_b = num_zhengpixel_b + b(i,j);
        end
    end
end

% 负值的均值为：
if num_fu_b == 0
    mean_fu_b = 0;
else
    mean_fu_b = num_fupixel_b / num_fu_b;
end
% 正值的均值为：
if num_zheng_b == 0
    mean_zheng_b = 0;
else
    mean_zheng_b = num_zhengpixel_b / num_zheng_b;
end

% 求取均值的绝对值
abs_mean_fu_b = abs(mean_fu_b);
abs_mean_zheng_b = abs(mean_zheng_b);

% 计算K值
Kb = (abs_mean_fu_b + abs_mean_zheng_b) / 2;

%计算通道系数
if abs_mean_fu_b == 0
    Kfu_b = 1;
else
    Kfu_b = Kb / abs_mean_fu_b;
end

if abs_mean_zheng_b == 0
    Kzheng_b = 1;
else
    Kzheng_b = Kb / abs_mean_zheng_b;
end

%像素值处理
for i = 1:height
    for j = 1:width
        if b(i,j) < 0
            b(i,j) = b(i,j) * Kfu_b;
        else
            b(i,j) = b(i,j) * Kzheng_b;
        end
    end
end

a = a * 1.5;
b = b * 1.5;

Lab_result = cat(3, L, a, b);

img_color = uint8(lab2rgb(Lab_result)*255.0); 
end

