clear all, clc;
%final test for image segement
I = imread('newpear.jpg');
hsv = rgb2hsv(I);
H = hsv(:,:,1); %h
S = hsv(:,:,2); %S
V = hsv(:,:,3); %V

level = graythresh(S);
[m, n] = size(S);
for p=1 : m
    for q=1 : n
        if(S(p,q) > level & S(p, q) < 1)
            result(p,q) = 1;
        else
            result(p,q) = 0;
        end
    end
end
result = imfill(result, 'holes');
se = strel('disk',3);
closeResult = imclose(result,se);
%figure, imshow(result);
%figure, imshow(closeResult);

 rawdata= im2double(I);
 cutimg=rawdata.*closeResult;
 figure,imshow(cutimg);
