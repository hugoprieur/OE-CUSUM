# O-E CUSUM GRAPH SAS Code

**A Risk-Adjusted Observed minus Expected CUmulative SUM (RA O-E CUSUM) Chart for Visualization and Monitoring of Surgical Outcomes**

This code is also available in the appendix of the original manuscript.

_v1.0, 11/10/2024_

---
Draws the O-E CUSUM graph of a given dataset of procedures into a png file.

**Inputs :**  
- CUSUM Parameters  
- Table of procedures including the following variables :  
  - Number of the procedure in the dataset      
  - Expected probability of event      
  - Observed event

**Output :**  
- png file of a O-E CUSUM graph

**Summary :**  
- Parameters  
  _CUSUM parameters for the detection of signals and output parameters, including path, name and size of the output file_  
- Sample data  
	_A table of simulated data is provided for testing the code._  
- O-E, CUSUM scores and signals  
	_Calculation of the observed minus expected values, CUSUM scores, and CUSUM signals of improvement or deterioration_   
- Annomac tables  
	_Creation of datasets for the different graphic elements that will be drawn by the annotate procedure_   
- Graph file output
