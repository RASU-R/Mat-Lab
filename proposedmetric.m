clc;
close all;

ref = imread('C:\Users\SANJAISIVA\Desktop\ICP\USED IMAGES FOR PROGRAM\mandril_gray.tif'); 
%imwrite(ref,'C:\Users\SANJAISIVA\Desktop\ICP\mandril.jpg')

%origial 
% img%ref=im2gray(ref); % for color images
%{
B=imnoise(ref,'gaussian',0.01); %noisy img
B=imnoise(ref,'salt & pepper',0.1);
A=wiener2(B,[5 5]); %filtered image
A=medfilt3(B);
filter=fspecial('gaussian',7,1.5);%filterSize=7 sigma=1.5;
A=imfilter(B,filter);
%}

B=imnoise(ref,'gaussian',0.5);
A=wiener2(B,[5 5]);
%imwrite(A,'C:\Users\SANJAISIVA\Desktop\ICP\0.9.jpg')
%imwrite(A,'C:\Users\SANJAISIVA\Desktop\ICP\11FILTER.jpg')

%figure,imshow(ref), title('Original Image');
%figure,imshow(B), title('Noisy Image');
%figure,imshow(A), title('Filtered Image');
x=0;y=0;
ref=double(ref);
A=double(A);
[m,n]=size(A);
O_F=abs(ref-A);


[one1,one]=find_metric_1x1(O_F);  %1x1
[two1,two]=find_metric_2x2(O_F);  %2x2
[four1,four]=find_metric_4x4(O_F);  %4x4

fprintf("metric 1x1 value is:%0.4f %0.4f\n",one1,one);
fprintf("metric 2x2 value is:%0.4f %0.4f\n",two1,two);
fprintf("metric 4x4 value is:%0.4f %0.4f\n",four1,four);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [metric_0or1_1x1,metric_ori_1x1]=find_metric_1x1(O_F)
    Epi=mean(mean(O_F));
[m,n]=size(O_F);
for i=1:m
    for j=1:n
        if(O_F(i,j)>=Epi)
            new_O_F(i,j)=O_F(i,j);
            new1_O_F(i,j)=1;

        else
             new_O_F(i,j)=0;
              new1_O_F(i,j)=0;

        end     
    end
end    


metric_ori_1x1=mean(mean(new_O_F));
metric_0or1_1x1=mean(mean(new1_O_F));


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [metric_0or1_2x2,metric_ori_2x2]=find_metric_2x2(O_F)
[m,n]=size(O_F);
%%%episilon
x=0;
for i=1:2:m
    x=x+1;
    y=0;
    for j=1:2:n
        y=y+1;
        sum=0;
        for k =i:i+1
            for l=j:j+1
               sum=sum+O_F(i,j);
            end   

        end    
        E(x,y)=sum/4;

    end    
end 

x=0;
for i=1:m
    y=0;
    if(mod(i,2)~=0)
        x=x+1;
    end 
    for j=1:n
        if(mod(j,2)~=0)
            y=y+1;
        end 
        
        if(O_F(i,j)>=E(x,y))
           
            new_O_F(i,j)=O_F(i,j);  %1st method
           new1_O_F(i,j)=1;           %2nd method
        else
            %fprintf("x,y,i,j is %d %d %d %d\n",x,y,i,j);
            new_O_F(i,j)=0;
             new1_O_F(i,j)=0;
        end

        
         
              
    end    
end    

metric_ori_2x2=mean(mean(new_O_F)); 
metric_0or1_2x2=mean(mean(new1_O_F));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [metric_0or1_4x4,metric_ori_4x4]=find_metric_4x4(O_F)
[m,n]=size(O_F);
x=0;
for i=1:4:m
    x=x+1;
    y=0;
    for j=1:4:n
        y=y+1;
        sum=0;
        for k =i:i+3
            for l=j:j+3
               sum=sum+O_F(i,j);
            end   
        end    
        E(x,y)=sum/16;
    end    
end 

x=0;
for i=1:m
    y=0;
    if(mod(i,4)==1)
        x=x+1;
    end 
    for j=1:n
        if(mod(j,4)==1)
            y=y+1;
        end 
        
        if(O_F(i,j)>=E(x,y))
           % fprintf("x,y,i,j is %d %d %d %d\n",x,y,i,j);
            new_O_F(i,j)=O_F(i,j);  %1st method
            new1_O_F(i,j)=1;           %2nd method
        else
            %fprintf("x,y,i,j is %d %d %d %d\n",x,y,i,j);
            new_O_F(i,j)=0;
            new_O_F(i,j)=0;
        end           
    end    
end    
 
metric_0or1_4x4=mean(mean(new1_O_F));
metric_ori_4x4=mean(mean(new_O_F));


end