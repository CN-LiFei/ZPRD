function [Illumination_enhanced] = Illumination_strech(Illumination_gamma)
% 照明图的值域为[0,1]
% 最小值滤波窗口大小为 15 = 7*2+1
window_size = 15;

%  亮通道
Illumination_bright = get_bright_channel(Illumination_gamma, window_size);

%  暗通道
Illumination_dark = get_dark_channel(Illumination_gamma, window_size);

%  t求解
t_T = (Illumination_bright - Illumination_dark) ./ (1 - Illumination_dark);

% % 导向滤波平滑t
% img_haze_size = size(Illumination_gamma);
% img_haze_w = img_haze_size(2);
% img_haze_h = img_haze_size(1);
% kenlRatio = .01;  
% krnlsz = floor(max([img_haze_w * kenlRatio, img_haze_h * kenlRatio]));
% r = krnlsz * 4;
% eps = 10^-6;
% t_T = guidedfilter(double(Illumination_gamma), double(t_T), r, eps);
% disp("guidedfilter");
% t_max = max(max(t_T));
% t_min = min(min(t_T));
% disp(t_max);
% disp(t_min);
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
t_T(t_T < mint) = mint;

%  增强后图像
Illumination_enhanced = (Illumination_gamma - Illumination_dark) ./ t_T + Illumination_dark;
end

