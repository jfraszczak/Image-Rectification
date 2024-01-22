function [imgWithLines, imgWithCorners] = FeatureExtraction(img)

preprocessedImg = preprocess(img);
imwrite(preprocessedImg, 'output/processedImg.png');

cannyFilterImg = extractEdges(preprocessedImg);
imwrite(cannyFilterImg, 'output/cannyFilterImg.png');

lines = findLines(cannyFilterImg);
imgWithLines = drawLines(img, lines);
imwrite(imgWithLines, 'output/imgWithLines.png');

corners = findCorners(preprocessedImg);
imgWithCorners = drawCorners(img, corners);
imwrite(imgWithCorners, 'output/imgWithCorners.png');

end

function [preprocessedImg] = preprocess(img)
grayImg = rgb2gray(img);
gaussianFilterImg = imgaussfilt(grayImg,4);
preprocessedImg = gaussianFilterImg;

end

function [cannyFilterImg] = extractEdges(img)
cannyFilterImg = edge(img,'Canny');

se90 = strel('line',3,90);
se0 = strel('line',3,0);
dilatedImg = imdilate(cannyFilterImg,[se90 se0]);
cannyFilterImg = dilatedImg;

end

function [lines] = findLines(img)
[H,theta,rho] = hough(img);
P = houghpeaks(H,300,'threshold',ceil(0.1*max(H(:))));
lines = houghlines(img,theta,rho,P,'FillGap',5,'MinLength',100);

end

function [corners] = findCorners(img)
binaryImg = imbinarize(img);
corners = detectHarrisFeatures(binaryImg, 'FilterSize', 3);
corners = corners.selectStrongest(1000);
end

function [imgWithLines] = drawLines(img, lines)
figure, imshow(img), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','magenta');
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','black');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','black');
end

hold off
imgWithLines = getframe;
imgWithLines = imgWithLines.cdata;

end

function [imgWithCorners] = drawCorners(img, corners)
figure, imshow(img), hold on
plot(corners)
hold off
imgWithCorners = getframe;
imgWithCorners = imgWithCorners.cdata;
end