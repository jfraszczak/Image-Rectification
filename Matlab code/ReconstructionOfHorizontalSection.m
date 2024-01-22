function [H, rectifiedImg, imLinfty, ratio] = ReconstructionOfHorizontalSection(img, imgWithLines)

parallelLinesMatrix = inputParallelLines(img, imgWithLines);
[affineRectificationImg, Haffine, imLinfty] = performAffineRectification(img, parallelLinesMatrix);


orthogonalLinesConstraints = inputOrthogonalLines(affineRectificationImg);
[similarityRectificationImg, Hsimilarity] = performSimilarityRectification(affineRectificationImg, orthogonalLinesConstraints);

rectifiedImg = similarityRectificationImg;
H = Hsimilarity * Haffine;

ratio = determineFacadeRatio(rectifiedImg);

imwrite(affineRectificationImg, 'output/affineRectificationImg.png');
imwrite(rectifiedImg, 'output/rectifiedHorizontalImg.png');

end

function [ratio] = determineFacadeRatio(img)
figure;
imshow(img); hold on;

lengths = [0 0];
for i = 1:2
line = drawline('Color', 'magenta');
x1 = line.Position(1,1); y1 = line.Position(1,2); x2 = line.Position(2,1); y2 = line.Position(2,2);
lengths(i) = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

ratio = lengths(1) / lengths(2);

end

function [affineRectificationImg, Haffine, imLinfty] = performAffineRectification(img, parallelLinesMatrix)

imLinfty = fitline(parallelLinesMatrix);

Haffine = [eye(2),zeros(2,1); imLinfty(:)'];

tform = projective2d(Haffine');
affineRectificationImg = imwarp(img,tform);

end

function [similarityRectificationImg, Hsimilarity] = performSimilarityRectification(img, orthogonalLinesConstraints)

[~,~,v] = svd(orthogonalLinesConstraints);
s = v(:,end); 
S = [s(1),s(2); s(2),s(3)];
[U,D,V] = svd(S);
A = U*sqrt(D)*V';

Hsimilarity = eye(3);
Hsimilarity(1,1) = A(1,1);
Hsimilarity(1,2) = A(1,2);
Hsimilarity(2,1) = A(2,1);
Hsimilarity(2,2) = A(2,2);
Hsimilarity = inv(Hsimilarity);

tform = projective2d(Hsimilarity');
similarityRectificationImg = imwarp(img,tform);

imshow(similarityRectificationImg);

end


function [parallelLinesMatrix] = inputParallelLines(img, imgWithLines)

figure;
imshow(img); hold on
f = 3;
numSegmentsPerFamily = 3;
parallelLines =cell(f,1);
col = 'rgby';
for i = 1:f
    count = 1;
    parallelLines{i} = nan(numSegmentsPerFamily,3);
    while(count <=numSegmentsPerFamily)
        figure(gcf);
        title(['Draw ', num2str(numSegmentsPerFamily),' segments: step ',num2str(count) ]);
        segment1 = drawline('Color',col(i));
        parallelLines{i}(count, :) = segToLine(segment1.Position);
        count = count +1;
    end
end

parallelLinesMatrix = nan(2,f);
for i = 1:f
    A = parallelLines{i}(:,1:2);
    B = -parallelLines{i}(:,3);
    parallelLinesMatrix(:,i) = A\B;
end

hold off
imgWithParallelLinesHorizontal = getframe;
imgWithParallelLinesHorizontal = imgWithParallelLinesHorizontal.cdata;
imwrite(imgWithParallelLinesHorizontal, 'output/imgWithParallelLinesHorizontal.png');

end

function [orthogonalLinesConstraints] = inputOrthogonalLines(img)
figure;
imshow(img);
numConstraints = 3;
hold on
count = 1;
orthogonalLinesConstraints = zeros(numConstraints, 3);

while (count <= numConstraints)
    figure(gcf);
    title(['Draw ', num2str(numConstraints),' pairs of orthogonal segments: step ',num2str(count) ]);
    col = 'rgbcmykwrgbcmykw';
    segment1 = drawline('Color',col(count));
    segment2 = drawline('Color',col(count));

    l = segToLine(segment1.Position);
    m = segToLine(segment2.Position);

    orthogonalLinesConstraints(count,:) = [m(1) * l(1) m(2) * l(1) + m(1) * l(2) m(2) * l(2)];
    
    count = count+1;
end

hold off
imgWithOrthogonalLinesHorizontal = getframe;
imgWithOrthogonalLinesHorizontal = imgWithOrthogonalLinesHorizontal.cdata;
imwrite(imgWithOrthogonalLinesHorizontal, 'output/imgWithOrthogonalLinesHorizontal.png');

end