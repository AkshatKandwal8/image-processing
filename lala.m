img = imread('/MATLAB Drive/Examples/flower.png');
figure; imshow(img); title('Original Image');

% Convert to grayscale
gray = rgb2gray(img);
figure; imshow(gray); title('Grayscale Image');

% Smooth
blurred = imgaussfilt(gray, 2);
figure; imshow(blurred); title('Smoothed Image');

% Binarize - threshold at 180 to isolate bright flower petals
bw = blurred > 161;  % Instead of 180  % Pixels brighter than 180 become white (flower)
figure; imshow(bw); title('Binary Image');

% Clean up
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 1000);  % Remove small noise
bw = imclose(bw, strel('disk', 10));  % Close gaps between petals
figure; imshow(bw); title('Cleaned Binary Image');

% Keep only the largest object (the flower)
cc = bwconncomp(bw);
numPixels = cellfun(@numel, cc.PixelIdxList);
[~, idx] = max(numPixels);
bw = false(size(bw));
bw(cc.PixelIdxList{idx}) = true;
figure; imshow(bw); title('Largest Object Only');

% Detect boundary
boundaries = bwboundaries(bw);
figure; imshow(img); hold on;
boundary = boundaries{1};
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
hold off; title('Detected Flower Boundary');

% Measure properties
stats = regionprops(bw, 'Area', 'Perimeter');
area = stats.Area;
perimeter = stats.Perimeter;

fprintf('Flower Area: %.2f pixels\n', area);
fprintf('Flower Perimeter: %.2f pixels\n', perimeter);