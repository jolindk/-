clear;
p=imread("car1.jpg");
subplot(2,3,1);
imshow(p);
title('原图');
j=imadjust(p,stretchlim(p));%图像增强，调整对比度
p1=rgb2gray(j);%灰化图像
subplot(2,3,2)
imshow(p1);
title('经过灰化后的图像');
bw = imbinarize(p1); 
[e1,s1]= edge(bw,'sobel',0.03,'both');%边缘检测，二值化
subplot(2,3,3)
imshow(e1);
title('经过边缘检测后的图像');
se1=[1;1;1];
I3=imerode(e1,se1);%腐蚀后
subplot(2,3,4),
imshow(I3);
title('经过腐蚀后的图像');
se2=strel('rectangle',[25,25]);
I4=imclose(I3,se2);%平滑图像
subplot(2,3,5),
imshow(I4);
title('经过闭合的图像');
I5=bwareaopen(I4,2000);%删除小对象
subplot(2,3,6),
imshow(I5);
title('经过删除小颗粒的图像');
stats = regionprops(I5,'all');
areas = [stats.Area];
[idx,bbox] = max(areas);
cropped_image = imcrop(p1,stats(bbox).BoundingBox);
figure(2),
imshow(cropped_image);
title('定位到的车牌');
imwrite(cropped_image,'截取的车牌1.jpg');



