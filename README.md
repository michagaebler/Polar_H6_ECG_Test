# ECG Polar Test

## Introduction
We wanted to know if we can use the [Polar H6 heart rate sensor](https://www.polar.com/de/produkte/accessoires/H6) to reliably record and scientifically analyse ECG data for heart rate (HR) and HR variability (HRV) analysis. 

## Methods
We compared the data from the Polar H6 to a standard scientific 3-lead ECG. 

Details: 

- **Polar H6**: 1-lead ECG chest strap placed on sternum, recorded with [HRV Logger app](http://www.marcoaltini.com/blog/heart-rate-variability-logger-app-details) (Android, [LG L40 smartphone](http://www.lg.com/de/handy/lg-L40))
- **ECG**: 3-lead ECG [Brainproducts ExG BrainAmp](http://www.brainproducts.com/productdetails.php?id=7), recorded with [BrainVision Recorder](http://www.brainproducts.com/downloads.php?kid=2) (v1.20.0506) at 500 Hz. 
- **Electrode placement**: between right clavicle and sternum, on the left side between the two lower rips, and on the right lower abdomen.
- **Data**: two recordings at rest, acquired on July 21, 2015 (in github: *Teil1* = part 1, *Teil2* = part 2)
- **Subject**: healthy young male, age: 34, BMI ~21 kg/m^2
- **Analysis** (cf. [Matlab script](./ECGPolarTest.m)): 
  1. read in raw ECG data (*.eeg) 
  2. detect peaks using *findpeaks()* function
  3. cross-correlate resulting tachogram and tachogram from Polar H6 (to temporally align)
  4. plot

## Results 
![First recording](/Teil1_correlation_Polar_ECG.png?raw=true "Tachograms of Polar H6 and ECG")
![First recording](/Teil2_correlation_Polar_ECG.png?raw=true "Tachograms of Polar H6 and ECG")

## Discussion
The Polar H6 can reliably and precisely detect heartbeats - at least in a lean young subject at rest.

### References
[similar analyses by Marco Altini for the Polar H7](http://www.marcoaltini.com/blog/heart-rate-variability)
