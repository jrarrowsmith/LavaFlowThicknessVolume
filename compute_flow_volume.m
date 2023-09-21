%Script to process and compute volume for lava flow
%JRA July 24, 2020
clc
%needs two separated point clouds:
% a fringing portion of the ground surface to project under the lava flow
% the flow itself

%the ascii files look like
% UTM easting     UTM northing      elevation  intensity  classification
% 496254.42187500 4251360.62109375 74.26000214 26.000000 2.000000
% 496255.27343750 4251361.30078125 74.01000214 53.000000 2.000000

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%load the data
lavaflowdata=load('lavaflow.txt');
surroundingdata=load('surrounding.txt');
grid_resolution = 10; %resolution of the pixels for the interpolation
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

e_flow=lavaflowdata(:,1);
n_flow=lavaflowdata(:,2);
z_flow=lavaflowdata(:,3);

figure(1)
clf
subplot(2,2,1)
plot(e_flow,n_flow, 'r.')
hold on
k=boundary(e_flow,n_flow);
plot(e_flow(k),n_flow(k),'k-')

e_surround=surroundingdata(:,1);
n_surround=surroundingdata(:,2);
z_surround=surroundingdata(:,3);

plot(e_surround,n_surround, 'b.')
axis equal
xlabel('UTM easting (m)')
ylabel('UTM northing (m)')

%use surrounding to set the ranges
emax = max(e_surround);
emin = min(e_surround);
nmin = min(n_surround);
nmax = max(n_surround);

%grid on which to estimate the elevations
[xq,yq] = meshgrid(emin:grid_resolution:emax, nmin:grid_resolution:nmax);
plot(xq,yq,'k+')

%grid the surroudings
z_surrounding = griddata(e_surround,n_surround,z_surround,xq,yq);

subplot(2,2,2)
surfl(xq,yq,z_surrounding)
shading interp
colormap gray
lighting gouraud
material shiny
hold on
plot3(e_surround,n_surround, z_surround, 'b.')
axis equal
xlabel('UTM easting (m)')
ylabel('UTM northing (m)')
zlabel('elevation (m)')

%grid the flow
z_flow_interp = griddata(e_flow,n_flow,z_flow,xq,yq);

mesh(xq,yq,z_flow_interp, 'FaceAlpha','0.1')
hold on
plot3(e_flow,n_flow,z_flow, 'r.')
axis equal
xlabel('UTM easting (m)')
ylabel('UTM northing (m)')
zlabel('elevation (m)')

%flow thickness:
flowthickness = z_flow_interp-z_surrounding;
subplot(2,2,3)
imagesc(emin:grid_resolution:emax,nmin:grid_resolution:nmax,flowthickness>0)
hold on
plot(e_surround,n_surround, 'k.')
axis equal
xlabel('UTM easting (m)')
ylabel('UTM northing (m)')
subplot(2,2,4)
imagesc(emin:grid_resolution:emax,nmin:grid_resolution:nmax,flowthickness)
hold on
axis equal
xlabel('UTM easting (m)')
ylabel('UTM northing (m)')
colorbar
colormap summer

tf=flowthickness>0;
volume_of_each_column = flowthickness(tf).*grid_resolution.*grid_resolution;
volume_of_flow=cumsum(volume_of_each_column);
min_thick=min(min(flowthickness(tf)));
max_thick=max(max(flowthickness(tf)));
mean_thick=mean(flowthickness(tf),'all');
total_volume=volume_of_flow(length(volume_of_flow));

fprintf('min thickness %.1f m, mean thickness %.1f m, max thickness %.1f m, total volume = %.0f cubic m or %.1e cubic km\n', ...
    min_thick, mean_thick, max_thick, total_volume, total_volume./10^9)
flow_area = polyarea(e_flow(k),n_flow(k));
fprintf('flow area %.1f sq m so volume check area * mean thickness = %.0f cubic m\n', ...
    flow_area, flow_area.*mean_thick)
s=sprintf('min thickness %.1f m, mean thickness %.1f m, max thickness %.1f m, total volume = %.0f cubic m or %.1e cubic km\n flow area %.1f sq m so volume check area * mean thickness = %.0f cubic m', ...
    min_thick, mean_thick, max_thick, total_volume, total_volume./10^9,  flow_area, flow_area.*mean_thick);

subplot(2,2,1)
title(s)

print -dpng 'lava_flow_analysis.png'


