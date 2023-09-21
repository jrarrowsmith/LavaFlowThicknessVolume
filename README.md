# LavaFlowThicknessVolume
Matlab script to compute lava flow thickness and volume given flow outline and Digital Elevation Model. This was built as a simple scheme to take the outline of a lava flow, segment a DEM as flow and surroundings, interpolate the base from the surroundings, and then compute the thickness distribution by subtracting the interpolated base from the DEM and integrate the thickness distribution to compute a volume. 

The example data and video explanation are for a small lava flow (Pietre Cotta) on the western side of Vulcano La Fossa (Eolian Islands Sicily). But it should work for many cases.
