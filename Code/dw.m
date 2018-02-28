clear all;
%Select the fold that contains images
folder = uigetdir;

%Extract all image files' name
imgFileNames = ls(strcat(folder,'\*.jpg'));

%Process all jpg files in the folder
for idx= 1:length(imgFileNames)
    %Get a filename
    imgFileName = strcat(folder,'\',imgFileNames(idx,:));
    
    %Read a image
    img_raw1 = imread(imgFileName); 
    %R,G,B value
    img_raw = imresize(img_raw1, [256 256]);      
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    img_gray = rgb2gray(img_raw);
    img_gray = imbinarize(img_gray);
    [B,L]=bwboundaries(img_gray,'noholes');
    stats = regionprops(L,'Area','Centroid');
    boundary = B{1};

    % calculate perimeter 
    delta_sq = diff(boundary).^2;   
    perimeter = sum(sqrt(sum(delta_sq,2)));
    
    % get area  
    area = stats(1).Area;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     img_bina = logical(img_raw);
%     area = regionprops(img_bina, 'Area');
%     area = area.Area;
    [r,c,d]=size(img_raw);

    %get red
    red=img_raw;
    red(:,:,1)=img_raw(:,:,1);
    red(:,:,2)=zeros(r,c);
    red(:,:,3)=zeros(r,c);
    red=uint8(red);
    [countred, zr] = imhist(red, 32);

    %get green
    green=zeros(r,c);
    green(:,:,1)=zeros(r,c);
    green(:,:,2)=img_raw(:,:,2);
    green(:,:,3)=zeros(r,c);
    green=uint8(green);
    [countgreen, zg] = imhist(green, 32);


    %get blue
    blue=zeros(r,c);
    blue(:,:,1)=zeros(r,c);
    blue(:,:,2)=zeros(r,c);
    blue(:,:,3)=img_raw(:,:,3);
    blue=uint8(blue);
    [countblue, zb] = imhist(blue, 32);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %texture
    % gray value extraction
    gray = rgb2gray(img_raw);
    A=double(gray);
    [m,n]=size(A);                         
    B=A;
    C=zeros(m,n);                         
    for i=1:m-1
        for j=1:n-1
            B(i,j)=A(i+1,j+1);
            C(i,j)=abs(round(A(i,j)-B(i,j)));
        end
    end
    h=imhist(mat2gray(C))/(m*n);
    mean=0;con=0;ent=0;                    
    for i=1:256                                      
        mean=mean+(i*h(i))/256;
        con=con+i*i*h(i);
        if(h(i)>0)
            ent=ent-h(i)*log2(h(i));
        end
    end
    
    feature_vec = [countred'/area, countgreen'/area, countblue'/area, mean, con, ent];
    feature_matrix(:,idx) = [feature_vec, 1];    
end

%Write feature matrix to excel file
feature_matrix=feature_matrix';
%excelFile = strcat(folder,'\datasetCS.xlsx');
xlswrite('mydata.xlsx',feature_matrix);