%% show the rank_r result
% the cache calculate form 'methodVSImage.m'
% plot the best one for rank_r
% clear; clc; close all;
format long;
filename = mfilename('fullpath');
[path, scriptname, ~] = fileparts(filename);
cd(path); 
lena_load = load("..\exp_cache\Tab_re4_mask1_2407220042.mat");
% lena_load = load("..\exp_cache\ImgRe_best_R1.mat");

%% save the rank-30 result
if 0
  img_show = lena_load.Tab_img{4}; % rank 30

  figure(1)
  imshow(img_show.ori_img, 'border','tight','initialmagnification','fit');

  figure(2)
  imshow(img_show.low_img, 'border','tight','initialmagnification','fit');

  figure(3)
  imshow(img_show.mask_img, 'border','tight','initialmagnification','fit');

  for i = 1:5
    figure(3+i)
    imshow(img_show.sol{i}, 'border','tight','initialmagnification','fit');
  end

  fig_name = 'SIST_gym_Rank30';
  imwrite(img_show.ori_img, ['../imgRe_',fig_name,'_Sol1_ori.png'])
  imwrite(img_show.low_img, ['../imgRe_',fig_name,'_Sol2_low.png'])
  imwrite(img_show.mask_img, ['../imgRe_',fig_name,'_Sol3_mask.png'])
  imwrite(img_show.sol{2}, ['../imgRe_',fig_name,'_Sol4_PIRNN.png'])
  imwrite(img_show.sol{3}, ['../imgRe_',fig_name,'_Sol5_AIRNN.png'])
  imwrite(img_show.sol{4}, ['../imgRe_',fig_name,'_Sol6_EIRNRI.png'])
  imwrite(img_show.sol{5}, ['../imgRe_',fig_name,'_Sol7_Scp.png'])
  imwrite(img_show.sol{5}, ['../imgRe_',fig_name,'_Sol8_FGSR.png'])
end
%% select a best one in different rank_list and display 
% plot lena_best_lambda_p for different rank_r choose a best rank_r
format bank
R_psnrTable = [];
% cache_load = load('..\exp_cache\ImgRe_best_lambda_LenaR15.mat');
% Tab_img = cache_load.Tab_img;

% best_lena = load('..\exp_cache\ImgRe_best_lena.mat')
% Tab_img = best_lena.Tab_img;

% best_R1 = load('..\exp_cache\ImgRe_best_R1.mat')
% Tab_img = best_R1.Tab_img;

Tab_img = lena_load.Tab_img;
for irank = 1 : 6 % rank_tb = [15 20 25 30 35 40]
  img_show = Tab_img{irank};

  figure(1)
  imshow(img_show.ori_img)

  figure(2)
  imshow(img_show.low_img)

  figure(3)
  imshow(img_show.mask_img)



  for i = 1:5
    tempR = 0;
    img_sol = img_show.sol{i};
    for k =1 :3
      tempR = tempR + rank(img_sol(:,:,k));
    end
    R_psnrTable(irank,2*i-1:2*i) = [vpa(psnr(img_sol,img_show.ori_img),6), floor(tempR/3)];

    figure(3+i)
    imshow(img_sol)
  end
end
%% save table
% for i = 1:6
%   img_show = Tab_img{i};
%   img_ori = img_show.ori_img;
%   img_low = img_show.low_img;
%   for j = 1:5
%     img_sol = img_show.sol{j};
% %     sPsnr = psnr(img_ori,img_sol)
%     R_psnr_Rank_Table(i,2*j-1) = vpa( psnr(img_ori,img_sol), 2);
%     tempR = 0;
%     for k =1 :3
%       tempR = tempR + rank(img_sol(:,:,k));
%     end
%     R_psnr_Rank_Table(i,2*j) = floor(tempR/3);
%   end
% end

%% with ch1 red
if 0
  for i = 1:5
    tempR = 0;
    img_sol = img_show.sol{i};
    for k =1 :3
      tempR = tempR + rank(img_sol(:,:,k));
    end
    [psnr(img_sol,img_show.ori_img),floor(tempR/3)];
    figure(i)
    %   imshow(img_show.sol{i}.*ch1)
    ich = 1;
    for j = 1:3
      if j ~= ich
        img_sol(:,:,j) = img_sol(:,:,j).*ch1;
      else
        img_sol(:,:,j) = img_sol(:,:,j).*ch1 + (1-ch1);
      end
    end
    imshow(img_sol)
    %   imshow(img_sol(:,:,1))
  end
end
%% mark a red box
if 0
  ch1 = img_sol(:,:,1);
  % ch1 = ones(size(img_sol(:,:,1)));
  bd = 1;
  l = 190;
  r = 250;
  s = 240;
  x = 290;

  ch1(s:x,l:l+bd) = 0;
  ch1(s:x,r:r+bd) = 0;
  ch1(s:s+bd,l:r) = 0;
  ch1(x:x+bd,l:r+bd) = 0;
  imshow(ch1)
  %
  line_M = zeros(size(img_sol(:,:,1)));
  line_M(270:270:280) = 0.5;
  imshow(line_M)
  %
  for i = 1:5
    tempR = 0;
    for k =1 :3
      tempR = tempR + rank(img_sol(:,:,k));
    end
    [psnr(img_sol,img_show.ori_img),floor(tempR/3)];
    figure(i)
    img_sol = img_show.sol{i};
    %   imshow(img_show.sol{i}.*ch1)

    ich = 1;
    for j = 1:3
      if j ~= ich
        img_sol(:,:,j) = img_sol(:,:,j).*ch1;
      else
        img_sol(:,:,j) = img_sol(:,:,j).*ch1 + (1-ch1);
      end
    end
    imshow(img_sol)
    %   imshow(img_sol(:,:,1))
  end
end
%% calculate the psnr and rank to make table
% R_psnr_Rank_Table = zeros(6,10);
R_psnr_Rank_Table = [];
format bank
for i = 1:6
  img_show = Tab_img{i};
  img_ori = img_show.ori_img;
  img_low = img_show.low_img;
  for j = 1:5
    img_sol = img_show.sol{j};
%     sPsnr = psnr(img_ori,img_sol)
    R_psnr_Rank_Table(i,2*j-1) = vpa( psnr(img_ori,img_sol), 2);
    tempR = 0;
    for k =1 :3
      tempR = tempR + rank(img_sol(:,:,k));
    end
    R_psnr_Rank_Table(i,2*j) = floor(tempR/3);
  end
end

