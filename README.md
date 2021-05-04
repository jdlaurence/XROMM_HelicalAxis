# XROMM_HelicalAxis
 Scripts to calculate (in MATLAB) and visualize (in Maya) the instantaneous helical axis of rotation of a rigid body (bone).
 
[Go to instructions](https://github.com/jdlaurence/XROMM_HelicalAxis/blob/master/instructions.md)

What is the helical (screw) axis? Essentially it's another way to quantify the motion of one rigid body relative to another. Rather than breaking down the transformation into 6 degrees of freedom (3 rotations and 3 translations) as is common in XROMM analysis, the helical axis deconstructs a motion into a rotation about a single axis somewhere in 3D space, and a translation along that axis. This script allows you to visualize the instantaenous helical axis--the real time axis of rotation about which a rigid body is rotating. This can be useful in understanding and building intuition for complex motions.
 
Pipeline written by J.D. Laurence-Chasen. Axis calculation based on code by Christoph Reinschmidt. Inspired by code by Jose Iriarte-Diaz and pipeline by Kelsey Stilson.
 
References:   (1) Spoor and Veldpaus (1980) Rigid body motion calculated
                   from spatial co-ordinates of markers. 
                   J Biomech 13: 391-393
               (2) Berme, Cappozzo, and Meglan. Rigid body mechanics
                   as applied to human movement studies. In Berme and 
                   Cappozzo: Biomechanics of human movement.
