function [dst] = TWSC(img)

img = im2double(img);     % double����
img_lab = rgb2lab(img);   % ת��Ϊlab�ռ�

L = im2double(img_lab(:,:,1));
a = img_lab(:,:,2);
b = img_lab(:,:,3);

% L ͨ������ֵ��һ��
L_max = max(max(L));
L_min = min(min(L));
L = (L - L_min) ./ (L_max - L_min);

% Retinex�ֽ�
win_size = 15;
Illumination = get_bright_channel(L, win_size);  %  �����ɷ�

% ƽ������ͼ
img_haze_size = size(L);
img_haze_w = img_haze_size(2);
img_haze_h = img_haze_size(1);
kenlRatio = .01;  
krnlsz = floor(max([img_haze_w * kenlRatio, img_haze_h * kenlRatio]));
r = krnlsz * 4;
eps = 10^-6;
Illumination_GUIDE = guidedfilter(double(L), double(Illumination), r, eps);

% ���������
Reflectance = L ./ Illumination_GUIDE;

% ����ͼ��ǿ
Illumination_gamma = Illumination_dehazing(Illumination_GUIDE); % ��������ǿ---ȥ��

% ������ȥ��
Reflectance_strech = Reflectance_dehazing(Reflectance);    %  �����ʲ���ǿ---�Աȶ�����

%  Retinex���кϲ�L
L_enhanced = Reflectance_strech .* Illumination_gamma;
L_max = max(max(L_enhanced));
L_min = min(min(L_enhanced));
L_enhanced = (L_enhanced - L_min) ./ (L_max - L_min);
L_enhanced = im2double(L_enhanced * 100.0);

% LabתΪRGB
Lab_Enhanced = cat(3, L_enhanced, a, b);
Enhanced_image = lab2rgb(Lab_Enhanced);

dst = uint8(Enhanced_image * 255.0);
end

