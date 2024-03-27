%% reset all
clear
clear all
%% 
[img, map] = imread('../tests/lena_256_256.jpg');
imshow(img, map)

R = img(:,:,1); 
G = img(:,:,2); 
B = img(:,:,3);

pixel = [R(22,50), G(22,50), B(22,50)]

ybcr = rgb2ycbcr(img);
imshow(ybcr)
pixels = zeros((size(R,1)*size(R,2)),3);
k= 1;
for i=1:size(R,1)
    for j=1:size(R,2)
        pixels(k,1)= R(i,j);   
        pixels(k,2)= G(i,j);
        pixels(k,3)= B(i,j);
        k=k+1;
    end
end
%% write pixel values to a txt file for testbench
fileID = fopen('rgb_values.txt','w');
for m=1:size(pixels)
    fprintf(fileID,'%X%X%X\n',pixels(m,1),pixels(m,2),pixels(m,3));
end
fclose(fileID);

%% Read output of the verilog module 
verilogPixels = zeros(size(pixels));
fd = fopen('output.txt','r');

verilogPixels = fscanf(fd,'%d',size(verilogPixels));
fclose(fd);

%% dec pxl to hex pxl
for k=1:size(verilogPixels,1)
    y=dec2hex(verilogPixels(k),1);
    Y=y(1:2);
    CB =y(3:4);
    CR=y(5:6);
end