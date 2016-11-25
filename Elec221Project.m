%% ELEC 221 Project
% Morten Kals, 52429140

% Cleanup frome earlier sessions
delete('ELEC221images/*.PNG');
clear; 
clf;

% Declare image directories
imageDirectory = 'ELEC221images/';
exportDirectory = 'reportImages/';

% Calculate which image is to be plotted
Y = 40;
X = mod(Y,30)+1;
fprintf('date: April %d, 2014\n', X);
printTime = '46.68';    % hardcoaded timestamp this time corresponds to

video = VideoReader('antartic_ice_melt.mp4');

startTime = 45 + 10/video.framerate; % Start reading frames at 45 seconds
endTime = 56 + 20/video.framerate;   % End reading frames at 56 seconds

video.CurrentTime = startTime;       % Start reading frames from start time

x = 1;
areaHistogram = 0; % Initialize and set first entry to zero

while (hasFrame(video) && (video.CurrentTime < endTime))
    
    frame = readFrame(video);   % extract frame
    gray = rgb2gray(frame);     % convert to gray-scale 
    binary = imbinarize(gray);  % apply to black and white
   
    binaryMasked = binary;
    binaryMasked(1:95,1:280) = 0;     % mask date-stamp
    
    % Apply average filter
    binaryFiltered = binaryMasked;    
    
%     for i = 1:5
        h = fspecial('average', 5);
        binaryFiltered = imfilter(binaryFiltered, h);
%     end
    
%     fft = fft2(h);
    
    % 6. Estimating change in ice extent
    area = sum(sum(binaryFiltered));
    if x == 1
        firstArea = area;
    else
        relativeArea = (area - firstArea)/firstArea * 100;
        areaHistogram = [areaHistogram, relativeArea];
    end
    
    
    
    
%     if (strcmp(sprintf('%2.2f', video.CurrentTime), printTime)) 
%         imwrite(gray,           sprintf('%sfigure1.PNG', exportDirectory));
%         imwrite(binary,         sprintf('%sfigure2.PNG', exportDirectory));
%         imwrite(binaryMasked,   sprintf('%sfigure3.PNG', exportDirectory));
%         imwrite(binaryFiltered, sprintf('%sfigure4.PNG', exportDirectory));
%         imwrite(frame, sprintf('%sfigure6.PNG', exportDirectory));
%         imwrite(frame, sprintf('%sfigure7.PNG', exportDirectory));
%         imwrite(frame, sprintf('%sfigure8.PNG', exportDirectory));
%     end
    
    % imwrite(frame, sprintf('%srgb%2.2f.PNG', imageDirectory, video.CurrentTime));
    % imwrite(gray, sprintf('%sgray%2.2f.PNG', imageDirectory, video.CurrentTime));
    % imwrite(binary, sprintf('%sbin%2.2f.PNG', imageDirectory, video.CurrentTime));
    % imwrite(binaryFiltered, sprintf('%sbinfil%2.2f.PNG', imageDirectory, video.CurrentTime));
    
    x = x+1;
end

%% Figure 5
figure;
[q, frames] = size(areaHistogram);
areaHistogram = [linspace(1,183,frames)', areaHistogram'];
plot(areaHistogram(:,1), areaHistogram(:,2));
title('Figure 5');
xlabel('day'); ylabel('relative ice extent, %')

% Save graph to disk
frame = getframe(1);
figure5 = frame2im(frame);
imwrite(figure5, sprintf('%sfigure5.PNG', exportDirectory));

%% Figure 6
hold on;
p = polyfit(areaHistogram(:,1), areaHistogram(:,2),2);
x1 = linspace(1,183);
plot(x1, polyval(p, x1));
legend(['values', 'polyfit']);

% Save to disk
frame = getframe(1);
figure6 = frame2im(frame);
imwrite(figure6, sprintf('%sfigure6.PNG', exportDirectory));

hold off;

%{
%% Question 0
fprintf('Number of frames: %d', video.duration*video.framerate);
fprintf('Frame rate:       %d', video.framerate);

%% Fig. 1 
filename = [imageDirectory 'rgb46.68.PNG'];    % generate filename for image
img = imread(filename); 
imwrite(img, [exportDirectory 'figure1.PNG']);  % export to report resources folder
figure; imshow(img);

%% Fig. 2
filename = [imageDirectory 'bin46.68.PNG'];
img = imread(filename);
imwrite(img, [exportDirectory 'figure2.PNG']);
figure; imshow(img);

%% Fig. 3
filename = [imageDirectory 'binfil46.68.PNG'];
img = imread(filename);
imwrite(img, [exportDirectory 'figure3.PNG']);
figure; imshow(img);


%}


