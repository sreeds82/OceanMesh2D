addpath(genpath('utilities/'))
addpath(genpath('datasets/'))
addpath(genpath('m_map/')) 
%% STEP 1: set mesh extents and set parameters for mesh.
bbox = [-95.40 -94.4;  
         29.14  30.09];
min_el    = 60;  		% Minimum mesh resolution in meters.
max_el    = 1e3;        % Maximum mesh resolution in meters. 
%% STEP 2: specify geographical datasets and process the geographical data 
%% to be used later with other OceanMesh classes...
coastline = 'ECGC_3as_0m_LMSL';
demfile   = 'galveston_13_mhw_2007.nc'; 
gdat = geodata('shp',coastline,...
               'dem',demfile,...
               'bbox',bbox,...
               'h0',min_el);
load ECGC_Thalwegs.mat
%% STEP 3: create an edge function class
fh = edgefx('geodata',gdat,...
            'fs',3,...
            'ch',0.1,...
            'Channels',pts2,...
            'g',0.25,...
            'max_el',max_el); 
%% STEP 4: Pass your edgefx class object along with some meshing options and
% build the mesh...
mshopts = meshgen('ef',fh,'bou',gdat,'plot_on',1);
% now build the mesh with your options and the edge function.
mshopts = mshopts.build; 
%% STEP 5: Plot it and write a triangulation fort.14 compliant file to disk.
plot(mshopts.grd,'tri',0);
write(mshopts.grd,'HoustonShipChannel');
