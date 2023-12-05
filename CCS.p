function [img_color] = CCS(img)
%%  2023.10.18  ��ɫУ������---���Գ�������---��ͨ��a,b�ľ�ֵ��Ϊ�������Գ�

img = im2double(img);   % double����

img_lab = rgb2lab(img); % ת��Ϊlab�ռ�

L = im2double(img_lab(:,:,1));     % ����L�ռ�
a = im2double(img_lab(:,:,2));     % ��ɫa�ռ�
b = im2double(img_lab(:,:,3));     % ��ɫb�ռ�

mean_a = mean2(a);    % aͨ����ֵ
mean_b = mean2(b);    % bͨ����ֵ

% a,bͨ����ֵ����������ֵ����
a_bu = a - mean_a;    
b_bu = b - mean_b;    

% ���������ºϲ�ΪLab�ռ��µ�ͼ��
Lab_bu = cat(3, L, a_bu, b_bu);

% ͨ���ֽ�
L = im2double(Lab_bu(:,:,1));
a = im2double(Lab_bu(:,:,2));
b = im2double(Lab_bu(:,:,3));

[height, width, ~] = size(Lab_bu);  % �ߣ���ͨ������

% aͨ���ڶ��β�����ʵ�ָ��������ľ�ֵ��ֵ���
num_fu_a = 0;
num_fupixel_a = 0;
num_zheng_a = 0;
num_zhengpixel_a = 0;

% ����aͨ����ֵ����ֵ�����ص��������Լ���ֵ����ֵ�ĺ�������
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

% ��ֵ�ľ�ֵΪ��
if num_fu_a == 0
    mean_fu_a = 0;
else
    mean_fu_a = num_fupixel_a / num_fu_a;
end
% ��ֵ�ľ�ֵΪ��
if num_zheng_a == 0
    mean_zheng_a = 0;
else
    mean_zheng_a = num_zhengpixel_a / num_zheng_a;
end

% ��ȡ��ֵ�ľ���ֵ
abs_mean_fu_a = abs(mean_fu_a);
abs_mean_zheng_a = abs(mean_zheng_a);

% ����Kֵ
Ka = (abs_mean_fu_a + abs_mean_zheng_a) / 2;

%����ͨ��ϵ��
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

%����ֵ����
for i = 1:height
    for j = 1:width
        if a(i,j) < 0
            a(i,j) = a(i,j) * Kfu_a;
        else
            a(i,j) = a(i,j) * Kzheng_a;
        end
    end
end

% ����bͨ����ֵ����ֵ�����ص��������Լ���ֵ����ֵ�ĺ�������
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

% ��ֵ�ľ�ֵΪ��
if num_fu_b == 0
    mean_fu_b = 0;
else
    mean_fu_b = num_fupixel_b / num_fu_b;
end
% ��ֵ�ľ�ֵΪ��
if num_zheng_b == 0
    mean_zheng_b = 0;
else
    mean_zheng_b = num_zhengpixel_b / num_zheng_b;
end

% ��ȡ��ֵ�ľ���ֵ
abs_mean_fu_b = abs(mean_fu_b);
abs_mean_zheng_b = abs(mean_zheng_b);

% ����Kֵ
Kb = (abs_mean_fu_b + abs_mean_zheng_b) / 2;

%����ͨ��ϵ��
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

%����ֵ����
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

