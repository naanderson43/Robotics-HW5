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

[Nrows,Ncols] = size(Image);

label = 1;
Equiv = zeros(1,2);

if Image(1,1) < zt
    Image(1,1) = label;
    label = label + 1;
else
    Image(1,1) = 0;
end

for c = 2:Ncols
    if Image(1,c) < zt
        if Image(1,c-1) ~= 0
            Image(1,c) = Image(1,c-1);
        else
            Image(1,c) = label;
            label = label +1;
        end
        
    else
        Image(1,c) = 0;
    end
end
    
for r = 2:Nrows
    if Image(r,1) < zt
        if Image(r-1,1) ~= 0
            Image(r,1) = Image(r-1,1);
        else
            Image(r,1) = label;
            label = label + 1;
        end
        
    else
        Image(r,1) = 0;
    end
    
    for c = 2:Ncols
        if Image(r,c) < zt
            if Image(r-1,c) ~= 0 && Image(r,c-1) == 0
                Image(r,c) = Image(r-1,c);
                
            elseif Image(r-1,c) == 0 && Image(r,c-1) ~= 0
                Image(r,c) = Image(r,c-1);
                
            elseif Image(r-1,c) ~= 0 && Image(r,c-1) ~= 0
                Image(r,c) = min(Image(r,c-1), Image(r-1,c));
                Equiv = [Equiv; max(Image(r,c-1), Image(r-1,c)), min(Image(r,c-1), Image(r-1,c))];
                
                [Erows, ~] = size(Equiv);
                for e = Erows-1:2
                    if Equiv(Erows,2) == Equiv(e,1)
                        Equiv(Erows,2) = Equiv(e,2);
                    end
                end         
                
            else
                Image(r,c) = label;
                label = label + 1;
            end
            
        else
            Image(r,c) = 0;
        end
    end
end

[Erows, ~] = size(Equiv);

for r = 1:Nrows
    for c = 1:Ncols
        if Image(r,c) ~= 0
            for e = 2:Erows
                if Image(r,c) == Equiv(e,1)
                    Image(r,c) = Equiv(e,2);
                end
            end
        end
    end
end

redImage = zeros(Nrows,Ncols);
greenImage = zeros(Nrows,Ncols);
blueImage = zeros(Nrows,Ncols);

N = uint16(max(Image(:)))+1;

for r = 1:Nrows
    for c = 1:Ncols
        if Image(r,c) < (N/3)
            redImage(r,c) = Image(r,c);
        end
    end
end

for r = 1:Nrows
    for c = 1:Ncols
        if Image(r,c) > (2*N/3)
            blueImage(r,c) = Image(r,c);
        end
    end
end

for r = 1:Nrows
    for c = 1:Ncols
        if Image(r,c) >= (N/3) && Image(r,c) <= (2*N/3)
            greenImage(r,c) = Image(r,c);
        end
    end
end

colorImage = cat(3, redImage, greenImage, blueImage);

figure(3); clf
imshow(colorImage)
