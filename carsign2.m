img = imread("截取的车牌1.jpg");
bw = imbinarize(img);
% 对二值图像进行形态学膨胀操作
se = strel('rectangle',[1,1]); 
bw_dilate = imdilate(bw, se);
chang= strel("rectangle",[50,5]);
% 执行开运算消除边缘和一些铆钉
op = imopen(bw, chang);
% 执行闭运算将消失的边缘和一些铆钉再次添加回来
cl = imclose(op, chang);
% 使用原始图像减去处理好的图像来去除所有铆钉和边框
fl = bw - cl;
figure(3)
imshow(fl);


% 使用连通性分析找到所有连通域
cc = bwconncomp(fl);
st = regionprops(cc,'Area');
a = [st.Area];
char_imgs = [];
char_size = [32, 50];
for i = 1:cc.NumObjects
    mask = false(size(bw));
    mask(cc.PixelIdxList{i}) = true;
 if a(i) > 200 && a(i) < 450 % 计算当前字符的边界框信息
        st = regionprops('table',mask,'BoundingBox');
        b = st.BoundingBox;
        width = b(3);
        height = b(4);
        % 调整字符的边界框大小
        if width > height
            height2 = char_size(1) * height / width;
            y2 = (char_size(2) - height2) / 2;
            b(2) = b(2) - y2;
            b(4) = height2;
        else
            width2 = char_size(2) * width / height;
            x2 = (char_size(1) - width2) / 2;
            b(1) = b(1) - x2;
            b(3) = width2;
        end
        char_img = imcrop(mask, b);
        char_img = imresize(char_img, char_size);
        char_imgs = cat(3, char_imgs, char_img);
       
 end
end
figure(4)
for i = 1:size(char_imgs,3)
    subplot(1,size(char_imgs,3),i);
    filename = ['char_',num2str(i),'.jpg'];
    imwrite(char_imgs(:,:,i), filename, 'jpg');
    imshow(char_imgs(:,:,i));
end
disp('车牌号码是：')
ch=imread("char_1.jpg");
ocrResults = ocr(ch, 'Language', 'ChineseSimplified');
disp(ocrResults.Text);
imgDir = '第一次作业';
for i = 2:7 
    imgPath = fullfile(imgDir, ['char_', num2str(i), '.jpg']); % 构造文件路径
    img= imread(imgPath);
    ocrResults = ocr(img, 'TextLayout', 'Block');
    disp([ocrResults.Text]);
end





