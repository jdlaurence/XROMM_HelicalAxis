# Helical Axis of Rotation Workflow Instructions

## Step 1: Download scripts from scripts folder and add to working directories

This workflow requires a series of MATLAB scripts and one Maya (MEL) script. Download the scripts (or clone this repository), and ensure they are added to the respective programs' working directories.


## Step 2: Open, edit, and run MATLAB Script [CalculateHelicalAxes.m](/functions/CalculateHelicalAxes.m)

This is the master script that will walk you through the calculation and file save.
It will ask you to point to 'rbtReference' and 'rbtBone' files. These are the rigid body transformations (from XMALab), of a proximal (reference) and distal (bone) of your two bones of interest. There are other parameters you can adjust (timestep, etc).

The script will save two files in your working directory: HAdataRaw, and HAdataMaya.

HAdataRaw contains technical descriptive information about the axis, like the unit vector, rotation angle, and translation.

HADataMaya contains the data required to import and visualize the axis in Maya.


## Step 3: Import helical axis into Maya.

In the Maya MEL line, type "impHAdata;" and press enter/return

This should bring up a dialogue box that asks your for the file (HAdataforMaya.csv) and an axis name.

One you select your file and give it a name, the axis should be imported!
