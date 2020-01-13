


clear;
clc;
close all;

I=imread('vegetables.jpg'); % reading the picture %
I2=rgb2gray(I); %dividing the picture into 3 matrices %
I1=im2double(I2);   % converting the data type to double %

fprintf('Size of original_image')  % printing the size of the image %
size(I2)  % prints the value %

figure('Name','original Picture');
imshow(I1);  
title("Original Picture") % naming the image %

sol = calc(I1,72);
figure('Name','Picture after 1/10th Compression')
clf
imshow(sol);
title('Picture after 1/10th Compression') % printing the image after 1/10th compression %

sol = calc(I1,144);
figure('Name','Picture after 1/5th Compression')
clf
imshow(sol);
title('Picture after 1/5th Compression') % printing the image after 1/5th compression %

sol = calc(I1,360);
figure('Name','Picture after 1/2th Compression')
clf
imshow(sol);
title('Picture after 1/2th Compression')   %   printing the image after 1/2th compression %

function decom_r=calc(image,factor)
    image=image'; % image transpose %
    mean_img = mean(image); % calculates mean for every column of image %
    image = image - mean_img; % creates standard deviation of image %
    [compressed_image, sorted_eigenvectors] = compressor(double(image'),factor); 
   % compressed image %

    decom_r = decompressor(compressed_image, sorted_eigenvectors);
  % restoring the new (restored) image from compressed image %
    decom_r=decom_r+mean_img; 
    decom_r=decom_r'; % add mean and transpose it to get the recovered image %
end


% this function removes less variants eigenvalues and calculates compressed image %
function [compressed_image, sorted_eigenvectors] = compressor(image,factor)
    covariance_matrix = (image')*image; % covariance of matrix %
    % Here we consider each column of the image as a vector in our dataset,
    % and hence this covariance matrix gives us the covariance among these vectors. %
    [V,D]=eig(covariance_matrix);  
    % v- eigen vectors as columns ,D-eigen values as diagonal elements %
    D_arr = sum(D);  % D_arry  is the array of eigenvalues %
    [sorted_eigenvalues, sorted_eigenvectors] = sort(D_arr, V);
    sorted_eigenvalues = sorted_eigenvalues/sum(sorted_eigenvalues);
    figure(5)
    plot(sorted_eigenvalues)
    title('Proportion of variance')
    % sorts eigen vectors w.r.t to eigenvalues in descending order %
    % Dataset varies majorly across the eigenvectors with large eigenvalues. 
    %So we remove less significant dimensions.%
    sorted_eigenvectors = sorted_eigenvectors(:, 1:factor);
    % removes some eigen vectors by a factor %
    compressed_image = (sorted_eigenvectors')*image'; 
    % constructs compressed_image %
    % Transforming the image into a new vector space defined by selected eigenvectors.%
    fprintf('Size of compressed_image')
    size(compressed_image)  % prints the size of compressed image %
end

function decompressed_image = decompressor(compressed_image, sorted_eigenvectors)
    decompressed_image = (sorted_eigenvectors)*compressed_image;  %restored image %
end


% sorts eigenvectors correspondce to eigen values %
function [eigenvalues, eigenvectors]=sort(eigenvalues, eigenvectors)
    for c=1:length(eigenvalues)
        for i=1:(length(eigenvalues)-1)
            if eigenvalues(i)<eigenvalues(i+1)
                temp=eigenvalues(i);
                eigenvalues(i)=eigenvalues(i+1);
                eigenvalues(i+1)=temp;
                temp1=eigenvectors(:,i);
                eigenvectors(:,i)=eigenvectors(:,i+1);
                eigenvectors(:,i+1)=temp1;
            end
        end
    end
end

