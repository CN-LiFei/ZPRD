function [Reflectance_enhanced] = Reflectance_dehazing(Reflectance_strech)
% 反射率的值域为[0,1]
% 最小值滤波窗口大小为 15 = 7*2+1
window_size = 7;

%  亮通道
Reflectance_bright = get_bright_channel(Reflectance_strech, window_size);

%  暗通道
Reflectance_dark = get_dark_channel(Reflectance_strech, window_size);

%  t求解
t_R = double(1 - Reflectance_dark ./ Reflectance_bright);

% 导向滤波平滑t
% img_haze_size = size(Reflectance_strech);
% img_haze_w = img_haze_size(2);
% img_haze_h = img_haze_size(1);
% kenlRatio = .01;  
% krnlsz = floor(max([img_haze_w * kenlRatio, img_haze_h * kenlRatio]));
% r = krnlsz * 4;
% eps = 10^-6;
% t_R = guidedfilter(double(Reflectance_strech), double(t_R), r, eps);

% t_T = double(t_T * 255);
% t_T = (t_T - t_min) ./ (t_max - t_min);
% t_T = double(t_T * 255);
% T_max = max(max(Illumination_gamma));
% T_min = min(min(Illumination_gamma));
% Illumination_gamma = (Illumination_gamma - T_min) ./ (T_max - T_min);
% t_max = max(max(t_T));
% t_min = min(min(t_T));
% t_T = (t_T - t_min) ./ (t_max - t_min);
% t_T = guidedfilter(double(Illumination_gamma), double(t_T), r, eps);
% disp(t_T(20,20));

% 根据新的透射图，得到去雾图
mint = 0.5;
t_R(t_R < mint) = mint;

%  增强后图像
R_J = (Reflectance_strech - Reflectance_bright) ./ t_R + Reflectance_bright;
Reflectance_enhanced = R_J;

end