# Introduction to project
This project is completed for the degree of MEng in Aeronautical with Spacecraft Engineering at Imperial College London. The accuracy and frequency content of the TLE set for LAGEOS-1 is investigated.

This project analyses the accuracy and frequency content of the TLE set for LAGEOS-1 to shed more light on the accuracy and frequency content of the entire TLE catalogue.  In the first part, the TLE error when compared to POE data is computed for position, velocity and orbital elements. In the second part, a numerical propagator know n as THALASSA is used to generate high-fidelity data and the spectrum is compared to that of TLE. 


# User guide: Preparing

PART 1 - Error Analysis

  1. Download TLE data from the space-track.org website by executing the “ST_TLE_Retriever.py” script. This requires an account (which is simple to create) and the login details must be included in the “ST_config.ini” file. Input the appropriate cat ID, dates etc, and ensure the output is saved into a text file (.txt) to the “..input/TLE” folder 
    2. Input the correct path to the TLE data in the “read_TLE_v1.m” MATLAB function
    3. Download POE data from the HORIZONS web interface at “https://ssd.jpl.nasa.gov/horizons.cgi” and save as “.txt” file in the “..input/POE” folder.  Ensure that the prefixes and other texts are removed manually, leaving the POE data starting with an epoch in the first line
    4. Input the correct path to the POE data in the “POE_LAGEOS_v1.py” script
    5. Input the correct path to the data output in the “TLEvsPOE.m” script in lines 179, 180 and 248
    6. Input the correct path to the data input to be plotted in the “plot_TLEvsPOE.m” script


PART 2 - Frequency Content Analysis

   7. Download TLE for the frequency analysis in the same way as in Step 1
   8.  In the “read_TLE_v2.m” MATLAB function, input the correct path to the TLE file (line 17), and to 
        the output “object.txt” file which captures initial conditions obtained from the TLE to be    
        used by THALASSA for propagation (line 74)
    9. Adjust the THALASSA propagation interval and time-step in the “input.txt” file in   
        “thalassa-master” folder.  Also input the correct path to the “..input/thalassa” folder for the 
        THALASSA outputs to be saved in
   10. Input the correct path to the THALASSA data in the “read_thalassa.m” script (line 7)
   11. Input the correct path to the data output in the “TLEvsTHALASSA.m” script in lines 164, 165 
           and 215
  12. Input the correct path to the data input to be plotted in the “plot_TLEvsTHALASSA.m” script
  13. Input the correct path to the data input to be analysed and plotted in the “freq_analysis.m” 
           script


# User guide: Executing
PART 1 - Error Analysis

1. Execute the "TLEvsPOE.m" script in MATLAB, followed by the "plot_TLEvsPOE.m" script to output the plots of errors

PART 2 - Frequency Content Analysis

1. Execute the "read_TLE_v2.m" MATLAB function to output the "object.txt" file 
2. Run THALASSA with the correct "object.txt" file in the terminal
3. Execute the "TLEvsTHALASSA.m" MATLAB script in MATLAB, followed by the "plot_TLEvsTHALASSA.m" to see the error plots
4. Execute the "freq_analysis.m" script to produce the TLE and THALASSA spectrum plots

# Credits
Thanks to Amato et al., 2019 for allowing me to use THALASSA 
Thanks to Vallado et al., 2006 for making the complete SGP4 model public
