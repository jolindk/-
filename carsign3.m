clear;
for i = 1:size(char_imgs,3)
file_name = ['char_',num2str(i),'.jpg'];
p(i)=imread(file_name,"jpg");
ocrResults = ocr(p(i), 'TextLayout', 'Block');
disp([ocrResults.Text]);
end
