# LavaFlowThicknessVolume
Matlab script to compute lava flow thickness and volume given flow outline and Digital Elevation Model. This was built as a simple scheme to take the outline of a lava flow, segment a DEM as flow and surroundings, interpolate the base from the surroundings, and then compute the thickness distribution by subtracting the interpolated base from the DEM and integrate the thickness distribution to compute a volume. 

The example data and video explanation are for a small lava flow (Pietre Cotta) on the western side of Vulcano La Fossa (Eolian Islands Sicily). But it should work for many cases.

A video explanation is here: <a href="https://drive.google.com/file/d/1Q5vFcIAWIAo-k2v3ZzRbAnu39yWJoNos/view?usp=sharing">Video</a>.

Note that this relies on working with the digital elevation data (either point cloud .las or .laz or a DEM converted to point cloud) in <a href="https://www.danielgm.net/cc/">CloudCompare</a>.
