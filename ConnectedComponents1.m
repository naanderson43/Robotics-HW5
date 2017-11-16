function cc = ConnectedComponents( binary_img )
% Using the same image, label the connected components using the two-pass
% algorithm from section 11.4.  Call your file  ConnectedComponents.m with
% function call
% cc = ConnectedComponents( binary_img ), where binary_img is a binary image
% and cc is a matrix the size of binary_img with 0 assigned to background
% pixels and integers to different connected components.
% Uses the algorithm in "Robot Modeling and Control" by Spong, Hutchinson,
% and Vidyasagar
%
% Aaron T Becker, 03-21-2016, atbecker@uh.edu
% http://www.labbookpages.co.uk/software/imgProc/otsuThreshold.html
%
%  Items to complete are marked with "TODO:"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin <1  % if user doesn't specify an image, load one from memory
    binary_img = imread('Duplos.png');
end

zt = AutoThreshold(binary_img);
if numel(size(binary_img))>2
    Image = rgb2gray(binary_img);
else
    Image = binary_img;
end

Image = Image > zt; 
[Nrow, Ncol] = size(Image); 
tempImage = zeros(Nrow, Ncol); 

for r = 2:Nrow-1
    for c = 2:Ncol-1
        if Image(r,c) > 0 
            tempImage(r,c) = 1; 
        end
    end
end

%clean up the noise
for r = 2:Nrow-1
    for c = 3:Ncol-1
        if Image(r,c) == 0
            if Image(r-1,c)==1 || Image(r+1,c) ==1 || Image(r,c+1) == 1 || Image(r,c-1) == 1
                tempImage(r,c) = 1;
            end
        end
    end
end
Image = tempImage; 

% 1 is white
% 0 is black 


figure(3); 
imshow(Image)
end