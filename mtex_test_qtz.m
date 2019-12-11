%%
clear variables

%% Import EBSD Data

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-3m1', [4.9 4.9 5.5], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Quartz-new', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

% path to files (change the path accordingly)
path = 'C:\Users\marco\Documents\GitHub\perimeter_example\';
fname = [path 'dataset_qtz_ss1.ctf'];
fname2 = [path 'dataset_qtz_ss2.ctf'];
ebsd = EBSD.load(fname, CS, 'interface', 'ctf', 'convertEuler2SpatialReferenceFrame');
ebsd2 = EBSD.load(fname2, CS, 'interface', 'ctf', 'convertEuler2SpatialReferenceFrame');

%% Generate grain boundaries
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd, 'angle', 5*degree, 'boundary', 'tight');
[grains2, ebsd2.grainId, ebsd2.mis2mean] = calcGrains(ebsd2, 'angle', 5*degree, 'boundary', 'tight');

%% Apply Laplacian smoothing
grains_s1 = smooth(grains, 1);
grains_s2 = smooth(grains, 2);
grains_s3 = smooth(grains, 3);
grains_s6 = smooth(grains, 6);

grains2_s1 = smooth(grains2, 1);
grains2_s2 = smooth(grains2, 2);
grains2_s3 = smooth(grains2, 3);
grains2_s6 = smooth(grains2, 6);

%% Remove border grains
face_id = grains.boundary.hasPhaseId(0);
grain_ids = grains.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains = grains(~ismember(grains.id, grain_ids));

face_id = grains2.boundary.hasPhaseId(0);
grain_ids = grains2.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains2 = grains2(~ismember(grains2.id, grain_ids));

face_id = grains_s1.boundary.hasPhaseId(0);
grain_ids = grains_s1.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains_s1 = grains_s1(~ismember(grains_s1.id, grain_ids));

face_id = grains2_s1.boundary.hasPhaseId(0);
grain_ids = grains2_s1.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains2_s1 = grains2_s1(~ismember(grains2_s1.id, grain_ids));

face_id = grains_s2.boundary.hasPhaseId(0);
grain_ids = grains_s2.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains_s2 = grains_s2(~ismember(grains_s2.id, grain_ids));

face_id = grains2_s2.boundary.hasPhaseId(0);
grain_ids = grains2_s2.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains2_s2 = grains2_s2(~ismember(grains2_s2.id, grain_ids));

face_id = grains_s3.boundary.hasPhaseId(0);
grain_ids = grains_s3.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains_s3 = grains_s3(~ismember(grains_s3.id, grain_ids));

face_id = grains2_s3.boundary.hasPhaseId(0);
grain_ids = grains2_s3.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains2_s3 = grains2_s3(~ismember(grains2_s3.id, grain_ids));

face_id = grains_s6.boundary.hasPhaseId(0);
grain_ids = grains_s6.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains_s6 = grains_s6(~ismember(grains_s6.id, grain_ids));

face_id = grains2_s6.boundary.hasPhaseId(0);
grain_ids = grains2_s6.boundary(face_id).grainId;
grain_ids(grain_ids == 0) = [];
grains2_s6 = grains2_s6(~ismember(grains2_s6.id, grain_ids));

%% Plot IPF map with boundaries

% Set IPF colors respect to extension direction (xvector)
oM = ipfHSVKey(ebsd('Quartz-new'));
oM.inversePoleFigureDirection = xvector;
IPF_x = oM.orientation2color(ebsd('Quartz-new').orientations);
oM2 = ipfHSVKey(ebsd2('Quartz-new'));
oM2.inversePoleFigureDirection = xvector;
IPF_x2 = oM2.orientation2color(ebsd2('Quartz-new').orientations);

% plot IPF map
mtexFig = newMtexFigure('nrows', 2, 'ncols', 4, 'figSize', 'large');

plot(ebsd('Quartz-new'), IPF_x);
hold on
plot(grains.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd('Quartz-new'), IPF_x);
hold on
plot(grains_s1.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd('Quartz-new'), IPF_x);
hold on
plot(grains_s3.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd('Quartz-new'), IPF_x);
hold on
plot(grains_s6.boundary, 'linewidth', 5.0, 'lineColor', 'white')
hold off
nextAxis
plot(ebsd2('Quartz-new'), IPF_x2);
hold on
plot(grains2.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd2('Quartz-new'), IPF_x2);
hold on
plot(grains2_s1.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd2('Quartz-new'), IPF_x2);
hold on
plot(grains2_s3.boundary, 'linewidth', 5.0, 'lineColor', 'white')
nextAxis
plot(ebsd2('Quartz-new'), IPF_x2);
hold on
plot(grains2_s6.boundary, 'linewidth', 5.0, 'lineColor', 'white')
hold off

%% Estimate perimeters (step size 1)
grains.perimeter
grains_s1.perimeter
grains_s2.perimeter
grains_s3.perimeter
grains_s6.perimeter

%% Estimate perimeters (step size 2)
grains2.perimeter
grains2_s1.perimeter
grains2_s2.perimeter
grains2_s3.perimeter
grains2_s6.perimeter

%% Compare perimeter and boundary size in a smoothed boundary
grains_s1.perimeter
grains_s1.boundarySize

%% Estimate areas (step size 1)
grains.area
grains_s1.area
grains_s2.area
grains_s3.area
grains_s6.area

%% Estimate areas (step size 2)
grains2.area
grains2_s1.area
grains2_s2.area
grains2_s3.area
grains2_s6.area
