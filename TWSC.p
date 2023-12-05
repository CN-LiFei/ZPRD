function [dst] = TWSC(img)

img = im2double(img);     % double类型
img_lab = rgb2lab(img);   % 转换为lab空间

L = im2double(img_lab(:,:,1));
a = img_lab(:,:,2);
b = img_lab(:,:,3);

% L 通道像素值归一化
L_max = max(max(L));
L_min = min(min(L));
L = (L - L_min) ./ (L_max - L_min);

% Retinex分解
win_size = 15;
Illumination = get_bright_channel(L, win_size);  %  照明成分

% 平滑照明图
img_haze_size = size(L);
img_haze_w = img_haze_size(2);
img_haze_h = img_haze_size(1);
kenlRatio = .01;  
krnlsz = floor(max([img_haze_w * kenlRatio, img_haze_h * kenlRatio]));
r = krnlsz * 4;
eps = 10^-6;
Illumination_GUIDE = guidedfilter(double(L), double(Illumination), r, eps);

% 反射率求解
Reflectance = L ./ Illumination_GUIDE;

% 照明图增强
Illumination_gamma = Illumination_dehazing(Illumination_GUIDE); % 照明层增强---去雾

% 反射率去雾
Reflectance_strech = Reflectance_dehazing(Reflectance);    %  反射率层增强---对比度拉伸

%  Retinex进行合并L
L_enhanced = Reflectance_strech .* Illumination_gamma;
L_max = max(max(L_enhanced));
L_min = min(min(L_enhanced));
L_enhanced = (L_enhanced - L_min) ./ (L_max - L_min);
L_enhanced = im2double(L_enhanced * 100.0);

% Lab转为RGB
Lab_Enhanced = cat(3, L_enhanced, a, b);
Enhanced_image = lab2rgb(Lab_Enhanced);

dst = uint8(Enhanced_image * 255.0);
end

