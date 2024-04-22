% Extract curve data from an image

clear, clc, close all

%% Calibration between the image and the curve

im = imread('test.png'); % Load the image (replace with your target image)
im = rgb2gray(im); % Convert to grayscale
thresh = graythresh(im); % Calculate binarization threshold
im = im2bw(im, thresh); % Binarize image
set(0, 'defaultfigurecolor', 'w')
imshow(im); % Display image

[y, x] = find(im == 0); % Find coordinates of "black points" in the image
y = max(y) - y; % Convert screen coordinates to Cartesian coordinates (right-hand system)
y = fliplr(y); % Flip array left-to-right
plot(x, y, 'r.', 'Markersize', 2);

disp('Please click the two vertices of the actual coordinate frame in the Figure (top-left and bottom-right), i.e., points A and B.');
[Xx, Yy] = ginput(2); % Capture the vertices of the actual coordinate frame

min_x = input('Enter the minimum x value: '); % Input the minimum x-axis value
max_x = input('Enter the maximum x value: '); % Input the maximum x-axis value
min_y = input('Enter the minimum y value: '); % Input the minimum y-axis value
max_y = input('Enter the maximum y value: '); % Input the maximum y-axis value

x = (x - Xx(1)) * (max_x - min_x) / (Xx(2) - Xx(1)) + min_x;
y = (y - Yy(2)) * (min_y - max_y) / (Yy(1) - Yy(2)) + max_y;
plot(x, y, 'r.', 'Markersize', 2);
axis([min_x, max_x, min_y, max_y]); % Set axis range according to inputs
title('Scatter plot derived from original image');

%% Convert scatter plot to a usable curve

% Challenges and solutions
% (1) One x value may correspond to multiple y values --> Keep y values within one standard deviation from the mean
% (2) Interference at the beginning and end of the curve --> Remove the first and last 5% of the data
% (3) Interference at the top and bottom of the curve --> Remove the top and bottom 10% of the data

% Parameter presets
rate_x = 0.08; % Percentage of data to remove from the beginning and end of the x-axis
rate_y = 0.05; % Percentage of data to remove from the top and bottom of the y-axis

[x_uni, index_x_uni] = unique(x); % Identify unique x coordinates
x_uni(1:floor(length(x_uni) * rate_x)) = []; % Remove the first percentage of x coordinates
x_uni(floor(length(x_uni) * (1 - rate_x)):end) = []; % Remove the last percentage of x coordinates

for ii = 1:length(x_uni)
    if ii == length(x_uni)
        ytemp = y(index_x_uni(ii):end);
    else
        ytemp = y(index_x_uni(ii):index_x_uni(ii + 1) - 1);
    end
    % Remove outliers
    threshold1 = mean(ytemp) - std(ytemp);
    threshold2 = mean(ytemp) + std(ytemp);
    ytemp(ytemp < threshold1 | ytemp > threshold2) = [];
    % Remove points too close to the top or bottom
    thresholdy = (max_y - min_y) * rate_y;
    ytemp(ytemp > max_y - thresholdy | ytemp < min_y + thresholdy) = [];
    y_uni(ii) = mean(ytemp); % Calculate the average of the remaining y values
end

x_uni(isnan(y_uni)) = []; % Remove NAN values from x_uni
y_uni(isnan(y_uni)) = []; % Remove NAN values from y_uni

plot(x_uni, y_uni, 'r.'); % Plot processed curve
title('Processed curve from scan');
axis([min_x, max_x, min_y, max_y]); % Set axis range according to inputs

%% Data fitting (modify as necessary)

[p, s] = polyfit(x_uni, y_uni, 4); % Polynomial fitting (avoid high-degree polynomials to prevent Runge's phenomenon)
[y_fit, DELTA] = polyval(p, x_uni, s); % Calculate fitted values

hold on;
plot(x_uni, y_fit); % Plot fitted curve
title('Fitted curve');
axis([min_x, max_x, min_y, max_y]); % Set axis range according to inputs

%% Output data to Excel

delete('test.xlsx');
data = [x_uni y_fit];
data_cell = mat2cell(data, ones(size(data, 1), 1), ones(1, size(data, 2))); % Convert matrix to cell array
headers = {'Iteration', 'Distance'}; % Headers for the variables (x and y)
result = [headers; data_cell]; % Combine headers and data
S = xlswrite('test1.xls', result, 'Sheet1'); % Save data to Excel