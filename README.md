# F.A.C.E
 
F.A.C.E (Facial Analysis and Classification Expert)

FACE is an Image Age Classifier for Information Security using computer vision and machine learning.
It todays world data is available within a hands reach and hence unnecessary influence to data is a big issue.
Our software scans the person's face and then identifies him/her as an adult or a minor and grants access to only adults.
We have used real time image processing and computer vision along with machine learning to achieve this purpose.

We have used the SVM (Support vector Machine) machine learning model to linearly classify a new data point in the X,Y plane 
where each axis is an attribute of that data point.

The attributes Extracted from our image dataset are:
1) A Product of ratios of certain distances on the face 
2) Wrinkle analysis using canny edge detection.

FeatureExtraction.m :

A matrix of all the datapoints in the training set was created using and the SVM model was applied on these matrix along 
with the output lable of each datapoint.


FinalGUI.m :

Responsible for taking a new image and correctly classifying it based on the previously trained SVM model.



