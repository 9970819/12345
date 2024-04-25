### Project Description
###### This MATLAB script is designed for optimizing driving routes based on various parameters including battery capacity, time windows, and demand at each node. The algorithm utilizes genetic operations such as selection, crossover, and mutation to find the most efficient route that minimizes the total cost and meets all operational constraints.

### Features
###### 1. Data Loading: Reads data from an Excel file specifying positions, demands, and time windows.
###### 2. Distance Matrix Calculation: Computes the distance between each pair of nodes.
###### 3. Genetic Algorithm: Optimizes routes using genetic operations like crossover and mutation adapted to the problem constraints.
###### 4. Fitness Evaluation: Assesses the suitability of each candidate solution based on route cost, time constraints, and other operational parameters.
###### 5. Visualization: Outputs the optimization process and the final route, both in the MATLAB console and as plots.

### Prerequisites
###### Before you run this script, make sure you have MATLAB installed on your machine with the following toolboxes:
###### 1. Optimization Toolbox
###### 2. Statistics and Machine Learning Toolbox
###### Additionally, the script requires an Excel file placed in the same directory as the script. This file should contain the necessary data structured in specific columns for positions, electricity supply requirements, and timing constraints.

### How to Run
###### 1. Open MATLAB.
###### 2. Navigate to the directory containing the script.
###### 3. Load the script in MATLAB editor by double-clicking on it or using the command ‘open ‘filename.m’’.
###### 4. Run the script by pressing the run button or using the command ‘run’.

### Output
###### The script will output:
###### 1. Generation logs showing the progress of the algorithm.
###### 2. A plot showing the optimization process over generations.
###### 3. The best route found and its associated cost.

### Customization
###### You can adjust various parameters in the script to fit specific scenarios:
###### 1. Maximum vehicle speed
###### 2. Maximum rechargeable capacity
###### 3. Cost factors for different operations.

### Additional Notes
###### Ensure that the Excel data is formatted correctly, with no missing values in critical columns. Incorrect data formats or missing entries might cause the script to fail or produce erroneous results.
